import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/utils/alarm_evaluator.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/alarm_monitor_config.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';
import 'package:nomad_alarm/services/notification_service.dart';
import 'package:nomad_alarm/services/speech_service.dart';

typedef AlarmTriggerHandler = void Function(int alarmId, {bool isRing});

class AlarmService {
  AlarmService({
    required AlarmRepository alarmRepository,
    required NotificationService notificationService,
    required SpeechService speechService,
    this.onNavigateToAlarm,
    this.languageCode = 'en',
  })  : _alarmRepository = alarmRepository,
        _notificationService = notificationService,
        _speechService = speechService,
        _evaluator = AlarmEvaluator();

  final AlarmRepository _alarmRepository;
  final NotificationService _notificationService;
  final SpeechService _speechService;
  final AlarmEvaluator _evaluator;
  final AlarmTriggerHandler? onNavigateToAlarm;
  final String languageCode;

  _AlarmSession? _session;
  var _eventsBound = false;

  int? get activeAlarmId => _session?.alarmId;

  void bindBackgroundEvents() {
    if (_eventsBound) {
      return;
    }
    _eventsBound = true;

    BackgroundAlarmService.listenEvents(
      onState: _handleBackgroundState,
      onTriggered: _handleTriggered,
      onStopped: () async {
        if (_session != null) {
          await _disposeSession();
        }
      },
    );

    _notificationService.onNotificationTap = _handleNotificationTap;
    _notificationService.onNotificationAction = _handleNotificationAction;
  }

  Stream<AlarmRuntimeState> watchActiveAlarm(int alarmId) {
    bindBackgroundEvents();
    if (_session?.alarmId == alarmId) {
      return _session!.controller.stream;
    }
    return Stream.fromFuture(_buildStaticState(alarmId));
  }

  Future<AlarmRuntimeState?> getRuntimeState(int alarmId) async {
    if (_session?.alarmId == alarmId && _session!.lastState != null) {
      return _session!.lastState;
    }
    try {
      return await _buildStaticState(alarmId);
    } catch (_) {
      return null;
    }
  }

  Future<void> startAlarm(int alarmId) async {
    bindBackgroundEvents();

    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      throw const AlarmException('Alarm not found.');
    }

    if (_session != null && _session!.alarmId != alarmId) {
      await cancelAlarm(_session!.alarmId);
    }

    alarm.status = AlarmStatus.active;
    alarm.startedAt = DateTime.now();
    alarm.updatedAt = DateTime.now();
    await _alarmRepository.update(alarm);

    await _startSession(alarm);
    await BackgroundAlarmService.startMonitoring(
      AlarmMonitorConfig.fromAlarm(alarm),
    );
    await _notificationService.showTrackingNotification(
      AlarmRuntimeState(
        alarmId: alarm.id,
        destinationName: alarm.name,
        address: alarm.address,
        destLatitude: alarm.destLatitude,
        destLongitude: alarm.destLongitude,
        distanceMeters: 0,
        speedKmh: 0,
        accuracyMeters: 0,
        lastFixAt: DateTime.now(),
        isGpsLost: false,
        hasPassedDestination: false,
        status: AlarmStatus.active,
      ),
    );
  }

  Future<void> pauseAlarm(int alarmId) async {
    _ensureSession(alarmId);

    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }
    alarm.status = AlarmStatus.paused;
    await _alarmRepository.update(alarm);

    await BackgroundAlarmService.pauseMonitoring();

    if (_session?.lastState != null) {
      _emitState(_session!.lastState!.copyWith(status: AlarmStatus.paused));
    }
  }

  Future<void> resumeAlarm(int alarmId) async {
    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }
    alarm.status = AlarmStatus.active;
    await _alarmRepository.update(alarm);
    await _startSession(alarm);
    await BackgroundAlarmService.resumeMonitoring(
      AlarmMonitorConfig.fromAlarm(alarm),
    );
  }

  Future<void> cancelAlarm(int alarmId) async {
    await BackgroundAlarmService.stopMonitoring();
    await _notificationService.cancelAll();

    if (_session?.alarmId == alarmId) {
      await _disposeSession();
    }

    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }
    alarm.status = AlarmStatus.cancelled;
    alarm.updatedAt = DateTime.now();
    await _alarmRepository.update(alarm);
  }

  Future<void> dismissAlarm(int alarmId, {bool snooze = false}) async {
    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }

    await _notificationService.cancelAlarmNotification();

    if (snooze) {
      alarm.status = AlarmStatus.active;
      alarm.triggeredAt = null;
      await _alarmRepository.update(alarm);
      await _speechService.stop();
      FlutterBackgroundService().invoke('snooze');

      if (_session?.alarmId == alarmId && _session!.lastState != null) {
        _emitState(_session!.lastState!.copyWith(status: AlarmStatus.active));
      }
      return;
    }

    alarm.status = AlarmStatus.completed;
    alarm.completedAt = DateTime.now();
    alarm.updatedAt = DateTime.now();
    await _alarmRepository.update(alarm);

    await _speechService.stop();
    await BackgroundAlarmService.stopMonitoring();

    if (_session?.alarmId == alarmId) {
      await _disposeSession();
    }
  }

  AlarmRuntimeState evaluate(Alarm alarm, Position position) {
    return _evaluator.evaluate(
      config: AlarmMonitorConfig.fromAlarm(alarm),
      position: position,
      currentStatus: alarm.status,
      snoozeSuppressedUntil: _session?.snoozeSuppressedUntil,
    );
  }

  Future<void> _startSession(Alarm alarm) async {
    await _disposeSession();

    final controller = StreamController<AlarmRuntimeState>.broadcast();
    _session = _AlarmSession(
      alarmId: alarm.id,
      controller: controller,
    );
    _evaluator.tracker.reset();
  }

  Future<void> _handleBackgroundState(AlarmRuntimeState state) async {
    if (_session == null || _session!.alarmId != state.alarmId) {
      final controller = StreamController<AlarmRuntimeState>.broadcast();
      _session = _AlarmSession(
        alarmId: state.alarmId,
        controller: controller,
      );
    }

    _emitState(state);

    if (state.status != AlarmStatus.paused) {
      await _notificationService.updateTrackingNotification(state);
    }

    if (state.isGpsLost) {
      await _notificationService.showGpsLostAlert(state.alarmId);
    }

    if (state.status == AlarmStatus.triggered) {
      final alarm = await _alarmRepository.getById(state.alarmId);
      if (alarm != null && alarm.status != AlarmStatus.triggered) {
        alarm.status = AlarmStatus.triggered;
        alarm.triggeredAt = DateTime.now();
        await _alarmRepository.update(alarm);
      }
    }
  }

  Future<void> _handleTriggered(int alarmId) async {
    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }

    await _notificationService.showAlarmRingNotification(
      alarmId,
      alarm.name,
    );

    if (alarm.voiceEnabled) {
      final state = _session?.lastState;
      await _speechService.speakApproaching(
        destinationName: alarm.name,
        distanceMeters: state?.distanceMeters ?? alarm.triggerDistanceMeters,
        languageCode: languageCode,
      );
    }

    onNavigateToAlarm?.call(alarmId, isRing: true);
  }

  void _handleNotificationTap(String? payload) {
    if (payload == null) {
      return;
    }
    if (payload.startsWith('ring:')) {
      final id = int.tryParse(payload.split(':').last);
      if (id != null) {
        onNavigateToAlarm?.call(id, isRing: true);
      }
    } else if (payload.startsWith('active:')) {
      final id = int.tryParse(payload.split(':').last);
      if (id != null) {
        onNavigateToAlarm?.call(id, isRing: false);
      }
    }
  }

  Future<void> _handleNotificationAction(String action, int alarmId) async {
    if (action == 'pause') {
      await pauseAlarm(alarmId);
    } else if (action == 'cancel') {
      await cancelAlarm(alarmId);
    }
  }

  void _emitState(AlarmRuntimeState state) {
    _session?.lastState = state;
    if (!(_session?.controller.isClosed ?? true)) {
      _session!.controller.add(state);
    }
  }

  Future<AlarmRuntimeState> _buildStaticState(int alarmId) async {
    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      throw const AlarmException('Alarm not found.');
    }
    return AlarmRuntimeState(
      alarmId: alarm.id,
      destinationName: alarm.name,
      address: alarm.address,
      destLatitude: alarm.destLatitude,
      destLongitude: alarm.destLongitude,
      distanceMeters: 0,
      speedKmh: 0,
      accuracyMeters: 0,
      lastFixAt: DateTime.now(),
      isGpsLost: false,
      hasPassedDestination: false,
      status: alarm.status,
    );
  }

  void _ensureSession(int alarmId) {
    if (_session?.alarmId != alarmId) {
      throw AlarmException('No active monitoring for alarm $alarmId.');
    }
  }

  Future<void> _disposeSession() async {
    _session?.snoozeTimer?.cancel();
    await _session?.controller.close();
    _session = null;
    _evaluator.tracker.reset();
  }

  Future<void> dispose() async {
    await _disposeSession();
  }
}

class _AlarmSession {
  _AlarmSession({
    required this.alarmId,
    required this.controller,
  });

  final int alarmId;
  final StreamController<AlarmRuntimeState> controller;
  Timer? snoozeTimer;
  DateTime? snoozeSuppressedUntil;
  AlarmRuntimeState? lastState;
}
