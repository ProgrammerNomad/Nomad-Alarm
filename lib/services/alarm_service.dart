import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/utils/alarm_evaluator.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/alarm_monitor_config.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/repositories/history_repository.dart';
import 'package:nomad_alarm/repositories/trip_repository.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';
import 'package:nomad_alarm/services/battery_monitor_service.dart';
import 'package:nomad_alarm/services/flashlight_service.dart';
import 'package:nomad_alarm/services/notification_service.dart';
import 'package:nomad_alarm/services/speech_service.dart';

typedef AlarmTriggerHandler = void Function(int alarmId, {bool isRing});

class _TripStatsTracker {
  double totalDistanceMeters = 0;
  double maxSpeedKmh = 0;
  final List<double> _speedSamples = [];
  double? _lastLat;
  double? _lastLon;

  void recordPosition(double lat, double lon, double speedKmh) {
    if (_lastLat != null && _lastLon != null) {
      totalDistanceMeters += haversineMeters(_lastLat!, _lastLon!, lat, lon);
    }
    _lastLat = lat;
    _lastLon = lon;
    if (speedKmh > 0) {
      _speedSamples.add(speedKmh);
      if (speedKmh > maxSpeedKmh) {
        maxSpeedKmh = speedKmh;
      }
    }
  }

  TripStats toStats() {
    final avg = _speedSamples.isEmpty
        ? null
        : _speedSamples.reduce((a, b) => a + b) / _speedSamples.length;
    return TripStats(
      totalDistanceMeters:
          totalDistanceMeters > 0 ? totalDistanceMeters : null,
      maxSpeedKmh: maxSpeedKmh > 0 ? maxSpeedKmh : null,
      avgSpeedKmh: avg,
    );
  }

  void reset() {
    totalDistanceMeters = 0;
    maxSpeedKmh = 0;
    _speedSamples.clear();
    _lastLat = null;
    _lastLon = null;
  }
}

class AlarmService {
  AlarmService({
    required AlarmRepository alarmRepository,
    required TripRepository tripRepository,
    required HistoryRepository historyRepository,
    required NotificationService notificationService,
    required SpeechService speechService,
    required FlashlightService flashlightService,
    required BatteryMonitorService batteryMonitorService,
    this.batteryProfile = BatteryProfile.balanced,
    this.onNavigateToAlarm,
    this.languageCode = 'en',
  })  : _alarmRepository = alarmRepository,
        _tripRepository = tripRepository,
        _historyRepository = historyRepository,
        _notificationService = notificationService,
        _speechService = speechService,
        _flashlightService = flashlightService,
        _batteryMonitorService = batteryMonitorService,
        _evaluator = AlarmEvaluator();

  final AlarmRepository _alarmRepository;
  final TripRepository _tripRepository;
  final HistoryRepository _historyRepository;
  final NotificationService _notificationService;
  final SpeechService _speechService;
  final FlashlightService _flashlightService;
  final BatteryMonitorService _batteryMonitorService;
  final AlarmEvaluator _evaluator;
  final AlarmTriggerHandler? onNavigateToAlarm;
  final String languageCode;
  final BatteryProfile batteryProfile;

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

    final trip = await _tripRepository.startTrip(alarm);

    await _startSession(alarm, tripId: trip.id);
    await BackgroundAlarmService.startMonitoring(_monitorConfig(alarm));
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

    if (_session?.alarmId == alarmId) {
      await _startSession(alarm, tripId: _session!.tripId);
    } else {
      final activeTrip = await _tripRepository.getActiveTrip();
      await _startSession(alarm, tripId: activeTrip?.id);
    }

    await BackgroundAlarmService.resumeMonitoring(_monitorConfig(alarm));
  }

  Future<void> cancelAlarm(int alarmId) async {
    await BackgroundAlarmService.stopMonitoring();
    await _notificationService.cancelAll();
    await _flashlightService.stop();

    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      if (_session?.alarmId == alarmId) {
        await _disposeSession();
      }
      return;
    }

    await _finalizeAlarm(
      alarm,
      alarmStatus: AlarmStatus.cancelled,
      tripOutcome: TripOutcome.cancelled,
      historyType: HistoryType.dismissed,
      historyNotes: 'Cancelled by user',
    );

    if (_session?.alarmId == alarmId) {
      await _disposeSession();
    }
  }

  Future<void> dismissAlarm(int alarmId, {bool snooze = false}) async {
    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }

    await _notificationService.cancelAlarmNotification();

    if (snooze) {
      _session?.snoozeCount += 1;
      alarm.status = AlarmStatus.active;
      alarm.triggeredAt = null;
      await _alarmRepository.update(alarm);
      await _speechService.stop();
      await _flashlightService.stop();
      FlutterBackgroundService().invoke('snooze');

      await _historyRepository.log(
        alarm: alarm,
        type: HistoryType.snoozed,
        tripId: _session?.tripId,
        snoozeCount: _session?.snoozeCount,
      );

      if (_session?.alarmId == alarmId && _session!.lastState != null) {
        _emitState(_session!.lastState!.copyWith(status: AlarmStatus.active));
      }
      return;
    }

    await _finalizeAlarm(
      alarm,
      alarmStatus: AlarmStatus.completed,
      tripOutcome: TripOutcome.completed,
      historyType: HistoryType.completed,
    );

    await _speechService.stop();
    await _flashlightService.stop();
    await BackgroundAlarmService.stopMonitoring();

    if (_session?.alarmId == alarmId) {
      await _disposeSession();
    }
  }

  AlarmRuntimeState evaluate(Alarm alarm, Position position) {
    _session?.tripTracker.recordPosition(
      position.latitude,
      position.longitude,
      position.speed >= 0 ? position.speed * 3.6 : 0,
    );

    return _evaluator.evaluate(
      config: _monitorConfig(alarm),
      position: position,
      currentStatus: alarm.status,
      snoozeSuppressedUntil: _session?.snoozeSuppressedUntil,
    );
  }

  AlarmMonitorConfig _monitorConfig(Alarm alarm) {
    return AlarmMonitorConfig.fromAlarm(
      alarm,
      batteryProfile: batteryProfile,
    );
  }

  Future<void> _startSession(Alarm alarm, {int? tripId}) async {
    final preserveTripId = tripId ?? _session?.tripId;
    await _disposeSession();

    final controller = StreamController<AlarmRuntimeState>.broadcast();
    _session = _AlarmSession(
      alarmId: alarm.id,
      controller: controller,
      tripId: preserveTripId,
    );
    _evaluator.tracker.reset();
  }

  Future<void> _handleBackgroundState(AlarmRuntimeState state) async {
    if (_session == null || _session!.alarmId != state.alarmId) {
      final controller = StreamController<AlarmRuntimeState>.broadcast();
      final activeTrip = await _tripRepository.getActiveTrip();
      _session = _AlarmSession(
        alarmId: state.alarmId,
        controller: controller,
        tripId: activeTrip?.id,
      );
    }

    if (state.latitude != null && state.longitude != null) {
      _session!.tripTracker.recordPosition(
        state.latitude!,
        state.longitude!,
        state.speedKmh,
      );
    }

    final enriched = await _enrichWithBattery(state);
    _emitState(enriched);

    final tripId = _session?.tripId;
    if (tripId != null) {
      await _tripRepository.updateStats(tripId, _session!.tripTracker.toStats());
    }

    if (enriched.status != AlarmStatus.paused) {
      await _notificationService.updateTrackingNotification(enriched);
    }

    if (enriched.isGpsLost) {
      await _notificationService.showGpsLostAlert(enriched.alarmId);
    }

    if (enriched.isLowBattery && !(_session?.lowBatteryNotified ?? false)) {
      _session?.lowBatteryNotified = true;
      await _notificationService.showLowBatteryAlert(enriched.alarmId);
    }

    if (enriched.status == AlarmStatus.triggered) {
      final alarm = await _alarmRepository.getById(enriched.alarmId);
      if (alarm != null && alarm.status != AlarmStatus.triggered) {
        alarm.status = AlarmStatus.triggered;
        alarm.triggeredAt = DateTime.now();
        await _alarmRepository.update(alarm);
      }
    }

    if (enriched.hasPassedDestination && !(_session?.passedHandled ?? true)) {
      _session?.passedHandled = true;
      final alarm = await _alarmRepository.getById(state.alarmId);
      if (alarm != null &&
          alarm.status != AlarmStatus.completed &&
          alarm.status != AlarmStatus.missed &&
          alarm.status != AlarmStatus.cancelled) {
        await _handleMissed(alarm, reason: 'Destination passed');
      }
    }
  }

  Future<void> _handleMissed(Alarm alarm, {required String reason}) async {
    await BackgroundAlarmService.stopMonitoring();
    await _notificationService.cancelAll();
    await _flashlightService.stop();

    await _finalizeAlarm(
      alarm,
      alarmStatus: AlarmStatus.missed,
      tripOutcome: TripOutcome.passed,
      historyType: HistoryType.missed,
      historyNotes: reason,
    );

    if (_session?.alarmId == alarm.id) {
      await _disposeSession();
    }
  }

  Future<void> _finalizeAlarm(
    Alarm alarm, {
    required AlarmStatus alarmStatus,
    required TripOutcome tripOutcome,
    required HistoryType historyType,
    String? historyNotes,
  }) async {
    alarm.status = alarmStatus;
    alarm.updatedAt = DateTime.now();
    if (alarmStatus == AlarmStatus.completed) {
      alarm.completedAt = DateTime.now();
    }
    await _alarmRepository.update(alarm);

    final tripId = _session?.tripId;
    if (tripId != null) {
      await _tripRepository.endTrip(
        tripId,
        tripOutcome,
        stats: _session?.tripTracker.toStats(),
      );
    }

    await _historyRepository.log(
      alarm: alarm,
      type: historyType,
      tripId: tripId,
      snoozeCount: _session?.snoozeCount,
      notes: historyNotes,
    );
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

    if (alarm.flashlightEnabled) {
      await _flashlightService.startStrobe();
    }

    onNavigateToAlarm?.call(alarmId, isRing: true);
  }

  Future<AlarmRuntimeState> _enrichWithBattery(AlarmRuntimeState state) async {
    final now = DateTime.now();
    if (_session?.lastBatteryCheck != null &&
        now.difference(_session!.lastBatteryCheck!).inSeconds <
            AlarmConstants.lowBatteryCheckIntervalSec) {
      return state;
    }
    _session?.lastBatteryCheck = now;
    final low = await _batteryMonitorService.isLowBattery(
      AlarmConstants.lowBatteryThresholdPercent,
    );
    if (low == state.isLowBattery) {
      return state;
    }
    return state.copyWith(isLowBattery: low);
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
    this.tripId,
  });

  final int alarmId;
  final StreamController<AlarmRuntimeState> controller;
  final int? tripId;
  final _TripStatsTracker tripTracker = _TripStatsTracker();
  Timer? snoozeTimer;
  DateTime? snoozeSuppressedUntil;
  AlarmRuntimeState? lastState;
  int snoozeCount = 0;
  bool passedHandled = false;
  bool lowBatteryNotified = false;
  DateTime? lastBatteryCheck;
}
