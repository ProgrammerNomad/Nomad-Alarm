import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/location_service.dart';

class AlarmService {
  AlarmService({
    required AlarmRepository alarmRepository,
    required LocationService locationService,
  })  : _alarmRepository = alarmRepository,
        _locationService = locationService;

  final AlarmRepository _alarmRepository;
  final LocationService _locationService;

  _AlarmSession? _session;

  int? get activeAlarmId => _session?.alarmId;

  Stream<AlarmRuntimeState> watchActiveAlarm(int alarmId) {
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
  }

  Future<void> pauseAlarm(int alarmId) async {
    _ensureSession(alarmId);
    await _session!.subscription?.cancel();
    _session!.subscription = null;

    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }
    alarm.status = AlarmStatus.paused;
    await _alarmRepository.update(alarm);

    _emitState(
      _session!.lastState!.copyWith(status: AlarmStatus.paused),
    );
  }

  Future<void> resumeAlarm(int alarmId) async {
    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }
    alarm.status = AlarmStatus.active;
    await _alarmRepository.update(alarm);
    await _startSession(alarm);
  }

  Future<void> cancelAlarm(int alarmId) async {
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

    _session?.snoozeTimer?.cancel();

    if (snooze) {
      alarm.status = AlarmStatus.active;
      alarm.triggeredAt = null;
      await _alarmRepository.update(alarm);

      _session?.snoozeSuppressedUntil = DateTime.now().add(
        Duration(minutes: AlarmConstants.snoozeDurationMin),
      );

      if (_session?.alarmId == alarmId) {
        _emitState(
          _session!.lastState!.copyWith(status: AlarmStatus.active),
        );
      }
      return;
    }

    alarm.status = AlarmStatus.completed;
    alarm.completedAt = DateTime.now();
    alarm.updatedAt = DateTime.now();
    await _alarmRepository.update(alarm);

    if (_session?.alarmId == alarmId) {
      await _disposeSession();
    }
  }

  /// Evaluates trigger conditions for a position update. Exposed for unit tests.
  AlarmRuntimeState evaluate(Alarm alarm, Position position) {
    final distance = haversineMeters(
      position.latitude,
      position.longitude,
      alarm.destLatitude,
      alarm.destLongitude,
    );

    final speedKmh =
        position.speed >= 0 ? (position.speed * 3.6).toDouble() : 0.0;
    final now = position.timestamp;

    final session = _session;
    if (session != null && session.alarmId == alarm.id) {
      session.updatePassedDetection(distance);
    }

    final isGpsLost = session?.isGpsLost(now) ?? false;
    final hasPassed = session?.hasPassedDestination ?? false;

    var status = alarm.status;
    final snoozeActive = session?.snoozeSuppressedUntil != null &&
        now.isBefore(session!.snoozeSuppressedUntil!);

    if (!snoozeActive &&
        status == AlarmStatus.active &&
        distance <= alarm.triggerDistanceMeters) {
      status = AlarmStatus.triggered;
    }

    return AlarmRuntimeState(
      alarmId: alarm.id,
      destinationName: alarm.name,
      address: alarm.address,
      destLatitude: alarm.destLatitude,
      destLongitude: alarm.destLongitude,
      distanceMeters: distance,
      speedKmh: speedKmh,
      accuracyMeters: position.accuracy,
      lastFixAt: now,
      isGpsLost: isGpsLost,
      hasPassedDestination: hasPassed,
      status: status,
    );
  }

  Future<void> _startSession(Alarm alarm) async {
    await _disposeSession();

    final controller = StreamController<AlarmRuntimeState>.broadcast();
    _session = _AlarmSession(
      alarmId: alarm.id,
      controller: controller,
    );

    try {
      final position = await _locationService.getCurrentPositionSafe();
      if (position != null) {
        await _onPosition(alarm, position);
      }
    } catch (_) {
      // Initial fix optional; stream will follow.
    }

    _session!.subscription = _locationService
        .watchPosition(
          accuracy: LocationAccuracy.high,
          distanceFilterMeters: AlarmConstants.gpsDistanceFilterBalancedM,
        )
        .listen(
      (position) async {
        final current = await _alarmRepository.getById(alarm.id);
        if (current == null ||
            current.status == AlarmStatus.cancelled ||
            current.status == AlarmStatus.completed) {
          return;
        }
        if (current.status == AlarmStatus.paused) {
          return;
        }
        await _onPosition(current, position);
      },
      onError: (_) {},
    );
  }

  Future<void> _onPosition(Alarm alarm, Position position) async {
    final distance = haversineMeters(
      position.latitude,
      position.longitude,
      alarm.destLatitude,
      alarm.destLongitude,
    );

    final useAggressive = distance <=
        alarm.triggerDistanceMeters * AlarmConstants.approachZoneMultiplier;

    if (useAggressive && _session != null) {
      // Restart stream with aggressive filter when entering approach zone.
      // For Phase 3, evaluation uses incoming positions as-is.
    }

    final state = evaluate(alarm, position);
    _session?.recordFix(position.timestamp);
    _emitState(state);

    if (state.status == AlarmStatus.triggered &&
        alarm.status != AlarmStatus.triggered) {
      alarm.status = AlarmStatus.triggered;
      alarm.triggeredAt = DateTime.now();
      await _alarmRepository.update(alarm);
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
    await _session?.subscription?.cancel();
    await _session?.controller.close();
    _session = null;
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
  StreamSubscription<Position>? subscription;
  Timer? snoozeTimer;
  DateTime? snoozeSuppressedUntil;
  AlarmRuntimeState? lastState;
  DateTime? lastFixAt;
  final List<double> _distanceSamples = [];
  bool _wasApproaching = false;

  void recordFix(DateTime fixAt) {
    lastFixAt = fixAt;
  }

  bool isGpsLost(DateTime now) {
    if (lastFixAt == null) {
      return false;
    }
    return now.difference(lastFixAt!).inSeconds >
        AlarmConstants.gpsLostThresholdSec;
  }

  void updatePassedDetection(double distance) {
    if (_distanceSamples.isEmpty) {
      _distanceSamples.add(distance);
      return;
    }

    final previous = _distanceSamples.last;
    if (distance < previous) {
      _wasApproaching = true;
    }

    _distanceSamples.add(distance);
    if (_distanceSamples.length > AlarmConstants.passedDestinationSamples) {
      _distanceSamples.removeAt(0);
    }
  }

  bool get hasPassedDestination {
    if (!_wasApproaching ||
        _distanceSamples.length < AlarmConstants.passedDestinationSamples) {
      return false;
    }
    for (var i = 1; i < _distanceSamples.length; i++) {
      if (_distanceSamples[i] <= _distanceSamples[i - 1]) {
        return false;
      }
    }
    return true;
  }
}
