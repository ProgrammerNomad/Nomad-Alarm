import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/utils/alarm_evaluator.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/core/utils/multi_alarm_notification_formatter.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/alarm_monitor_config.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/repositories/history_repository.dart';
import 'package:nomad_alarm/repositories/trip_repository.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';
import 'package:nomad_alarm/services/battery_monitor_service.dart';
import 'package:nomad_alarm/services/boot_prefs_sync.dart';
import 'package:nomad_alarm/services/flashlight_service.dart';
import 'package:nomad_alarm/services/notification_service.dart';
import 'package:nomad_alarm/services/ringtone_service.dart';
import 'package:nomad_alarm/services/route_service.dart';
import 'package:nomad_alarm/services/speech_service.dart';
import 'package:nomad_alarm/services/widget_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
    RouteService? routeService,
    String languageCode = 'en',
    bool lockScreenInfoEnabled = true,
  })  : _alarmRepository = alarmRepository,
        _tripRepository = tripRepository,
        _historyRepository = historyRepository,
        _notificationService = notificationService,
        _speechService = speechService,
        _flashlightService = flashlightService,
        _batteryMonitorService = batteryMonitorService,
        _routeService = routeService,
        _evaluator = AlarmEvaluator(),
        _languageCode = languageCode {
    _notificationService.setLockScreenInfoEnabled(lockScreenInfoEnabled);
  }

  final AlarmRepository _alarmRepository;
  final TripRepository _tripRepository;
  final HistoryRepository _historyRepository;
  final NotificationService _notificationService;
  final SpeechService _speechService;
  final FlashlightService _flashlightService;
  final BatteryMonitorService _batteryMonitorService;
  final RouteService? _routeService;
  final RingtoneService _ringtoneService = RingtoneService();
  final AlarmEvaluator _evaluator;
  final AlarmTriggerHandler? onNavigateToAlarm;
  String _languageCode;
  final BatteryProfile batteryProfile;

  static const _routeRefreshInterval = Duration(seconds: 60);

  String get languageCode => _languageCode;

  final Map<int, _AlarmSession> _sessions = {};
  var _eventsBound = false;

  Set<int> get monitoredAlarmIds => _sessions.keys.toSet();

  int? get activeAlarmId {
    if (_sessions.isEmpty) {
      return null;
    }
    for (final session in _sessions.values) {
      if (session.lastState?.status == AlarmStatus.active) {
        return session.alarmId;
      }
    }
    return _sessions.keys.first;
  }

  void updateLockScreenInfoEnabled(bool enabled) {
    _notificationService.setLockScreenInfoEnabled(enabled);
  }

  Future<void> updateLanguageCode(String code) async {
    if (_languageCode == code) {
      return;
    }
    _languageCode = code;
    await BackgroundAlarmService.updateLanguageCode(code);
    await _syncWidgetFromSessions();
  }

  /// Resumes GPS monitoring for all active alarms in the database.
  Future<void> resumeMonitoringForRunningAlarms() async {
    if (!await BackgroundAlarmService.hasLocationPermissionForForegroundService()) {
      return;
    }
    bindBackgroundEvents();
    final running = await _alarmRepository.getRunning();
    for (final alarm in running) {
      if (alarm.status != AlarmStatus.active) {
        continue;
      }
      if (_sessions.containsKey(alarm.id)) {
        continue;
      }
      try {
        await startAlarm(alarm.id, createTrip: false);
      } catch (_) {
        // Skip alarms that cannot be resumed.
      }
    }
  }

  Future<void> suspendActiveAlarmsIfLocationDenied() async {
    if (await Permission.locationWhenInUse.isGranted) {
      return;
    }
    final running = await _alarmRepository.getRunning();
    for (final alarm in running) {
      if (alarm.status == AlarmStatus.active) {
        alarm.status = AlarmStatus.paused;
        alarm.updatedAt = DateTime.now();
        await _alarmRepository.update(alarm);
      }
    }
    if (await BackgroundAlarmService.isRunning()) {
      await BackgroundAlarmService.stopMonitoring();
    }
    await _disposeAllSessions();
  }

  void bindBackgroundEvents() {
    if (_eventsBound) {
      return;
    }
    _eventsBound = true;

    BackgroundAlarmService.listenEvents(
      onState: _handleBackgroundState,
      onTriggered: _handleTriggered,
      onStopped: () async {
        if (_sessions.isNotEmpty) {
          await _disposeAllSessions();
        }
      },
    );

    _notificationService.onNotificationTap = _handleNotificationTap;
    _notificationService.onNotificationAction = _handleNotificationAction;
  }

  Stream<AlarmRuntimeState> watchActiveAlarm(int alarmId) {
    bindBackgroundEvents();
    final session = _sessions[alarmId];
    if (session != null) {
      return session.controller.stream;
    }
    return Stream.fromFuture(_buildStaticState(alarmId));
  }

  Future<AlarmRuntimeState?> getRuntimeState(int alarmId) async {
    final session = _sessions[alarmId];
    if (session?.lastState != null) {
      return session!.lastState;
    }
    try {
      return await _buildStaticState(alarmId);
    } catch (_) {
      return null;
    }
  }

  Future<void> startAlarm(int alarmId, {bool createTrip = true}) async {
    bindBackgroundEvents();

    if (!await BackgroundAlarmService.hasLocationPermissionForForegroundService()) {
      throw const PermissionException(
        'Location permission is required to start an alarm.',
      );
    }

    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      throw const AlarmException('Alarm not found.');
    }

    alarm.status = AlarmStatus.active;
    alarm.startedAt ??= DateTime.now();
    alarm.updatedAt = DateTime.now();
    await _alarmRepository.update(alarm);

    int? tripId = _sessions[alarmId]?.tripId;
    if (createTrip || tripId == null) {
      final trip = await _tripRepository.startTrip(alarm);
      tripId = trip.id;
    }

    await _ensureSession(alarm, tripId: tripId);
    await BootPrefsSync.addActiveAlarmId(alarm.id);
    await BackgroundAlarmService.addAlarmMonitoring(_monitorConfig(alarm));

    _emitState(
      alarmId,
      _sessions[alarmId]!.lastState ??
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
    await _syncWidgetFromSessions();
  }

  Future<void> pauseAlarm(int alarmId) async {
    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }
    alarm.status = AlarmStatus.paused;
    await _alarmRepository.update(alarm);

    await BackgroundAlarmService.pauseAlarmMonitoring(alarmId);

    final session = _sessions[alarmId];
    if (session?.lastState != null) {
      _emitState(alarmId, session!.lastState!.copyWith(status: AlarmStatus.paused));
    }
    await _syncWidgetFromSessions();
  }

  Future<void> resumeAlarm(int alarmId) async {
    if (!await BackgroundAlarmService.hasLocationPermissionForForegroundService()) {
      throw const PermissionException(
        'Location permission is required to resume an alarm.',
      );
    }

    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }
    alarm.status = AlarmStatus.active;
    await _alarmRepository.update(alarm);

    final existing = _sessions[alarmId];
    if (existing != null) {
      await _ensureSession(alarm, tripId: existing.tripId);
    } else {
      final trip = await _tripRepository.getActiveTripForAlarm(alarm.id);
      await _ensureSession(alarm, tripId: trip?.id);
      await BootPrefsSync.addActiveAlarmId(alarm.id);
    }

    await BackgroundAlarmService.resumeAlarmMonitoring(_monitorConfig(alarm));
    await _syncWidgetFromSessions();
  }

  Future<void> cancelAlarm(int alarmId) async {
    await BackgroundAlarmService.removeAlarmMonitoring(alarmId);

    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      await _disposeSession(alarmId);
      await _maybeStopBackgroundWhenEmpty();
      return;
    }

    await _finalizeAlarm(
      alarm,
      session: _sessions[alarmId],
      alarmStatus: AlarmStatus.cancelled,
      tripOutcome: TripOutcome.cancelled,
      historyType: HistoryType.dismissed,
      historyNotes: 'Cancelled by user',
    );

    await _disposeSession(alarmId);
    await BootPrefsSync.removeActiveAlarmId(alarmId);
    await _maybeStopBackgroundWhenEmpty();
    await _syncWidgetFromSessions();
  }

  Future<void> dismissAlarm(int alarmId, {bool snooze = false}) async {
    final alarm = await _alarmRepository.getById(alarmId);
    if (alarm == null) {
      return;
    }

    await _notificationService.cancelAlarmNotification();

    if (snooze) {
      final session = _sessions[alarmId];
      session?.snoozeCount += 1;
      alarm.status = AlarmStatus.active;
      alarm.triggeredAt = null;
      await _alarmRepository.update(alarm);
      await _speechService.stop();
      await _flashlightService.stop();
      FlutterBackgroundService().invoke('snooze', {'alarmId': alarmId});

      await _historyRepository.log(
        alarm: alarm,
        type: HistoryType.snoozed,
        tripId: session?.tripId,
        snoozeCount: session?.snoozeCount,
      );

      if (session?.lastState != null) {
        _emitState(alarmId, session!.lastState!.copyWith(status: AlarmStatus.active));
      }
      await _syncWidgetFromSessions();
      return;
    }

    await BackgroundAlarmService.removeAlarmMonitoring(alarmId);

    await _finalizeAlarm(
      alarm,
      session: _sessions[alarmId],
      alarmStatus: AlarmStatus.completed,
      tripOutcome: TripOutcome.completed,
      historyType: HistoryType.completed,
    );

    await _speechService.stop();
    await _flashlightService.stop();

    await _disposeSession(alarmId);
    await BootPrefsSync.removeActiveAlarmId(alarmId);
    await _maybeStopBackgroundWhenEmpty();
    await _syncWidgetFromSessions();
  }

  AlarmRuntimeState evaluate(Alarm alarm, Position position) {
    _sessions[alarm.id]?.tripTracker.recordPosition(
      position.latitude,
      position.longitude,
      position.speed >= 0 ? position.speed * 3.6 : 0,
    );

    return _evaluator.evaluate(
      config: _monitorConfig(alarm),
      position: position,
      currentStatus: alarm.status,
      snoozeSuppressedUntil: _sessions[alarm.id]?.snoozeSuppressedUntil,
    );
  }

  AlarmMonitorConfig _monitorConfig(Alarm alarm) {
    return AlarmMonitorConfig.fromAlarm(
      alarm,
      batteryProfile: batteryProfile,
    );
  }

  Future<void> _ensureSession(Alarm alarm, {int? tripId}) async {
    final existing = _sessions[alarm.id];
    if (existing != null) {
      existing.tripId = tripId ?? existing.tripId;
      existing.travelMode = alarm.travelMode;
      return;
    }

    final controller = StreamController<AlarmRuntimeState>.broadcast();
    _sessions[alarm.id] = _AlarmSession(
      alarmId: alarm.id,
      controller: controller,
      tripId: tripId,
      travelMode: alarm.travelMode,
    );
  }

  Future<void> _handleBackgroundState(AlarmRuntimeState state) async {
    final alarmId = state.alarmId;
    var session = _sessions[alarmId];
    if (session == null) {
      final trip = await _tripRepository.getActiveTripForAlarm(alarmId);
      final controller = StreamController<AlarmRuntimeState>.broadcast();
      session = _AlarmSession(
        alarmId: alarmId,
        controller: controller,
        tripId: trip?.id,
      );
      _sessions[alarmId] = session;
    }

    if (state.latitude != null && state.longitude != null) {
      session.tripTracker.recordPosition(
        state.latitude!,
        state.longitude!,
        state.speedKmh,
      );
    }

    final enriched = await _enrichWithRouteEta(session, await _enrichWithBattery(session, state));
    _emitState(alarmId, enriched);

    final tripId = session.tripId;
    if (tripId != null) {
      await _tripRepository.updateStats(tripId, session.tripTracker.toStats());
    }

    final alarm = await _alarmRepository.getById(enriched.alarmId);
    if (enriched.isGpsLost) {
      await _notificationService.showGpsLostAlert(enriched.alarmId);
    }

    if (enriched.isLowBattery && !session.lowBatteryNotified) {
      session.lowBatteryNotified = true;
      await _notificationService.showLowBatteryAlert(enriched.alarmId);
    }

    if (enriched.isInternetLost && !session.internetLostNotified) {
      session.internetLostNotified = true;
      await _notificationService.showInternetLostAlert(enriched.alarmId);
    }

    if (enriched.status == AlarmStatus.triggered && alarm != null &&
        alarm.status != AlarmStatus.triggered) {
      alarm.status = AlarmStatus.triggered;
      alarm.triggeredAt = DateTime.now();
      await _alarmRepository.update(alarm);
    }

    if (enriched.hasPassedDestination && !session.passedHandled) {
      session.passedHandled = true;
      if (alarm != null &&
          alarm.status != AlarmStatus.completed &&
          alarm.status != AlarmStatus.missed &&
          alarm.status != AlarmStatus.cancelled) {
        await _handleMissed(alarm, reason: 'Destination passed');
      }
    }

    await _syncWidgetFromSessions();
  }

  Future<void> _handleMissed(Alarm alarm, {required String reason}) async {
    await BackgroundAlarmService.removeAlarmMonitoring(alarm.id);
    await _flashlightService.stop();

    await _finalizeAlarm(
      alarm,
      session: _sessions[alarm.id],
      alarmStatus: AlarmStatus.missed,
      tripOutcome: TripOutcome.passed,
      historyType: HistoryType.missed,
      historyNotes: reason,
    );

    await _disposeSession(alarm.id);
    await BootPrefsSync.removeActiveAlarmId(alarm.id);
    await _maybeStopBackgroundWhenEmpty();
    await _syncWidgetFromSessions();
  }

  Future<void> _finalizeAlarm(
    Alarm alarm, {
    required _AlarmSession? session,
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

    final tripId = session?.tripId;
    if (tripId != null) {
      await _tripRepository.endTrip(
        tripId,
        tripOutcome,
        stats: session?.tripTracker.toStats(),
      );
    }

    await _historyRepository.log(
      alarm: alarm,
      type: historyType,
      tripId: tripId,
      snoozeCount: session?.snoozeCount,
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
      final state = _sessions[alarmId]?.lastState;
      await _speechService.speakApproaching(
        destinationName: alarm.name,
        distanceMeters: state?.distanceMeters ?? alarm.triggerDistanceMeters,
        languageCode: _languageCode,
      );
    }

    if (alarm.flashlightEnabled) {
      await _flashlightService.startStrobe();
    }

    await _ringtoneService.play(alarm.ringtoneUri);

    onNavigateToAlarm?.call(alarmId, isRing: true);
  }

  Future<AlarmRuntimeState> _enrichWithRouteEta(
    _AlarmSession session,
    AlarmRuntimeState state,
  ) async {
    final routeService = _routeService;
    if (routeService == null ||
        state.latitude == null ||
        state.longitude == null ||
        state.destLatitude == null ||
        state.destLongitude == null) {
      return state;
    }

    final now = DateTime.now();
    if (session.lastRouteFetchAt != null &&
        now.difference(session.lastRouteFetchAt!) < _routeRefreshInterval &&
        session.cachedRouteEtaMinutes != null) {
      return state.copyWith(etaMinutes: session.cachedRouteEtaMinutes);
    }

    try {
      final result = await routeService.route(
        from: LatLng(state.latitude!, state.longitude!),
        to: LatLng(state.destLatitude!, state.destLongitude!),
        travelMode: session.travelMode,
      );
      session.lastRouteFetchAt = now;
      session.cachedRouteEtaMinutes = result?.durationMinutes;

      final polyline = result?.storablePolyline;
      final tripId = session.tripId;
      if (polyline != null && tripId != null && !session.routePolylineStored) {
        await _tripRepository.updateRoutePolyline(tripId, polyline);
        session.routePolylineStored = true;
      }

      if (session.cachedRouteEtaMinutes != null) {
        _evaluator.smartDetection.recordRouteSuccess();
        return state.copyWith(etaMinutes: session.cachedRouteEtaMinutes);
      }
      _evaluator.smartDetection.recordRouteSuccess();
    } catch (_) {
      _evaluator.smartDetection.recordRouteFailure(now);
    }
    return state;
  }

  Future<AlarmRuntimeState> _enrichWithBattery(
    _AlarmSession session,
    AlarmRuntimeState state,
  ) async {
    final now = DateTime.now();
    if (session.lastBatteryCheck != null &&
        now.difference(session.lastBatteryCheck!).inSeconds <
            AlarmConstants.lowBatteryCheckIntervalSec) {
      return state;
    }
    session.lastBatteryCheck = now;
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
      onNavigateToAlarm?.call(-1, isRing: false);
      return;
    }
    if (payload.startsWith('ring:')) {
      final id = int.tryParse(payload.split(':').last);
      if (id != null) {
        onNavigateToAlarm?.call(id, isRing: true);
      }
      return;
    }
    if (payload.startsWith('active:')) {
      final id = int.tryParse(payload.split(':').last);
      if (id != null) {
        onNavigateToAlarm?.call(id, isRing: false);
      }
      return;
    }
    if (payload == 'home') {
      onNavigateToAlarm?.call(-1, isRing: false);
    }
  }

  Future<void> _handleNotificationAction(String action, int alarmId) async {
    if (action == 'pause') {
      await pauseAlarm(alarmId);
    } else if (action == 'cancel') {
      await cancelAlarm(alarmId);
    }
  }

  void _emitState(int alarmId, AlarmRuntimeState state) {
    final session = _sessions[alarmId];
    if (session == null) {
      return;
    }
    session.lastState = state;
    if (!session.controller.isClosed) {
      session.controller.add(state);
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

  Future<void> _maybeStopBackgroundWhenEmpty() async {
    if (_sessions.isEmpty) {
      await BackgroundAlarmService.stopMonitoring();
      await _notificationService.cancelTrackingNotification();
    }
  }

  Future<void> _syncWidgetFromSessions() async {
    final states = _sessions.values
        .map((session) => session.lastState)
        .whereType<AlarmRuntimeState>()
        .toList();
    final nearest = nearestActiveAlarmState(states);
    if (nearest == null) {
      await WidgetService.clear(languageCode: _languageCode);
      return;
    }

    final alarm = await _alarmRepository.getById(nearest.alarmId);
    final activeCount = states
        .where((state) => state.status == AlarmStatus.active)
        .length;
    await WidgetService.updateActiveAlarm(
      active: true,
      destination: nearest.destinationName,
      distanceMeters: nearest.distanceMeters,
      etaMinutes: nearest.etaMinutes,
      alarmId: nearest.alarmId,
      triggerDistanceMeters: alarm?.triggerDistanceMeters,
      speedKmh: nearest.speedKmh,
      languageCode: _languageCode,
      activeAlarmCount: activeCount,
    );
  }

  Future<void> _disposeSession(int alarmId) async {
    final session = _sessions.remove(alarmId);
    if (session == null) {
      return;
    }
    session.snoozeTimer?.cancel();
    await session.controller.close();
  }

  Future<void> _disposeAllSessions() async {
    final ids = _sessions.keys.toList();
    for (final id in ids) {
      await _disposeSession(id);
    }
    _evaluator.reset();
    await BootPrefsSync.setActiveAlarmIds(const []);
    await WidgetService.clear(languageCode: _languageCode);
  }

  Future<void> dispose() async {
    await _ringtoneService.stop();
    _ringtoneService.dispose();
    await _disposeAllSessions();
  }
}

class _AlarmSession {
  _AlarmSession({
    required this.alarmId,
    required this.controller,
    this.tripId,
    this.travelMode = TravelMode.autoDetect,
  });

  final int alarmId;
  final StreamController<AlarmRuntimeState> controller;
  int? tripId;
  TravelMode travelMode;
  final _TripStatsTracker tripTracker = _TripStatsTracker();
  Timer? snoozeTimer;
  DateTime? snoozeSuppressedUntil;
  AlarmRuntimeState? lastState;
  int snoozeCount = 0;
  bool passedHandled = false;
  bool lowBatteryNotified = false;
  bool internetLostNotified = false;
  bool routePolylineStored = false;
  DateTime? lastBatteryCheck;
  DateTime? lastRouteFetchAt;
  double? cachedRouteEtaMinutes;
}
