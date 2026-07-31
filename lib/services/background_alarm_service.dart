import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/constants/battery_profile_config.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/l10n/notification_l10n.dart';
import 'package:nomad_alarm/core/utils/alarm_evaluator.dart';
import 'package:nomad_alarm/core/utils/multi_alarm_notification_formatter.dart';
import 'package:nomad_alarm/models/alarm_monitor_config.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/route/osrm_route_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Background GPS monitoring via Android foreground service.
class BackgroundAlarmService {
  BackgroundAlarmService._();

  static bool _configured = false;
  static String _languageCode = 'en';

  static Future<void> ensureConfigured({String languageCode = 'en'}) async {
    if (_configured && _languageCode == languageCode) {
      return;
    }
    _languageCode = languageCode;
    final strings = await NotificationL10n.load(languageCode);

    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundServiceOnStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'tracking',
        initialNotificationTitle: strings.fgsStartingTitle,
        initialNotificationContent: strings.fgsStartingContent,
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: backgroundServiceOnStart,
      ),
    );
    _configured = true;
  }

  static Future<void> updateLanguageCode(String languageCode) async {
    if (languageCode == _languageCode) {
      return;
    }
    _configured = false;
    final running = await isRunning();
    if (!running) {
      await ensureConfigured(languageCode: languageCode);
    }
  }

  static Future<bool> hasLocationPermissionForForegroundService() async {
    return Permission.locationWhenInUse.isGranted;
  }

  static Future<void> _ensureServiceRunning() async {
    if (!await hasLocationPermissionForForegroundService()) {
      throw const PermissionException(
        'Location permission is required to track your alarm.',
      );
    }

    await ensureConfigured(languageCode: _languageCode);
    final service = FlutterBackgroundService();
    if (!await service.isRunning()) {
      try {
        await service.startService();
      } catch (error) {
        throw PermissionException(
          'Could not start background tracking. Check location permissions.',
          debugMessage: error.toString(),
        );
      }
    }
  }

  static Future<void> addAlarmMonitoring(AlarmMonitorConfig config) async {
    await _ensureServiceRunning();
    FlutterBackgroundService().invoke('addAlarm', config.toJson());
  }

  static Future<void> removeAlarmMonitoring(int alarmId) async {
    FlutterBackgroundService().invoke('removeAlarm', {'alarmId': alarmId});
  }

  static Future<void> stopMonitoring() async {
    final service = FlutterBackgroundService();
    service.invoke('stop');
    service.invoke('stopService');
  }

  static Future<void> pauseAlarmMonitoring(int alarmId) async {
    FlutterBackgroundService().invoke('pauseAlarm', {'alarmId': alarmId});
  }

  static Future<void> resumeAlarmMonitoring(AlarmMonitorConfig config) async {
    if (!await hasLocationPermissionForForegroundService()) {
      throw const PermissionException(
        'Location permission is required to resume tracking.',
      );
    }
    await _ensureServiceRunning();
    FlutterBackgroundService().invoke('resumeAlarm', config.toJson());
  }

  /// Legacy entry point - adds one alarm without stopping others.
  static Future<void> startMonitoring(AlarmMonitorConfig config) async {
    await addAlarmMonitoring(config);
  }

  static Future<void> pauseMonitoring() async {
    FlutterBackgroundService().invoke('pauseAll');
  }

  static Future<void> resumeMonitoring(AlarmMonitorConfig config) async {
    await resumeAlarmMonitoring(config);
  }

  static Future<bool> isRunning() async {
    return FlutterBackgroundService().isRunning();
  }

  static void listenEvents({
    required void Function(AlarmRuntimeState state) onState,
    required void Function(int alarmId) onTriggered,
    void Function()? onStopped,
  }) {
    final service = FlutterBackgroundService();
    service.on('state').listen((event) {
      if (event == null) {
        return;
      }
      onState(AlarmRuntimeState.fromJson(Map<String, dynamic>.from(event)));
    });
    service.on('triggered').listen((event) {
      if (event == null) {
        return;
      }
      final alarmId = event['alarmId'] as int?;
      if (alarmId != null) {
        onTriggered(alarmId);
      }
    });
    service.on('stopped').listen((_) => onStopped?.call());
  }
}

class _MonitorEntry {
  _MonitorEntry(this.config);

  AlarmMonitorConfig config;
  AlarmStatus currentStatus = AlarmStatus.active;
  DateTime? snoozeSuppressedUntil;
  final AlarmEvaluator evaluator = AlarmEvaluator();
  DateTime? lastRouteFetchAt;
  double? cachedRouteEtaMinutes;
  bool paused = false;
  bool passedHandled = false;
  AlarmRuntimeState? lastState;
}

/// Snapshot map values before async iteration to avoid concurrent modification.
List<T> snapshotMonitorValues<T>(Map<dynamic, T> monitors) =>
    monitors.values.toList();

@pragma('vm:entry-point')
Future<void> backgroundServiceOnStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final monitors = <int, _MonitorEntry>{};
  final routeProvider = OsrmRouteProvider();
  StreamSubscription<Position>? subscription;
  LocationSettings? activeSettings;
  Future<void> Function(Position position)? onPosition;
  var processingPosition = false;

  Future<void> stopAll() async {
    await subscription?.cancel();
    subscription = null;
    monitors.clear();
    activeSettings = null;
    routeProvider.dispose();
    service.invoke('stopped');
    service.stopSelf();
  }

  Future<void> startGpsStream(double nearestDistanceMeters) async {
    var profile = BatteryProfile.balanced;
    var triggerDistance = AlarmConstants.defaultTriggerDistanceM;
    for (final entry in snapshotMonitorValues(monitors)) {
      if (entry.paused) {
        continue;
      }
      if (entry.config.batteryProfile == BatteryProfile.aggressive) {
        profile = BatteryProfile.aggressive;
      }
      if (entry.config.triggerDistanceMeters < triggerDistance) {
        triggerDistance = entry.config.triggerDistanceMeters;
      }
    }

    final profileConfig = BatteryProfileConfig.effectiveFor(
      selectedProfile: profile,
      distanceMeters: nearestDistanceMeters,
      triggerDistanceMeters: triggerDistance,
    );
    final settings = profileConfig.toLocationSettings();
    if (activeSettings != null &&
        activeSettings!.accuracy == settings.accuracy &&
        activeSettings!.distanceFilter == settings.distanceFilter) {
      return;
    }
    activeSettings = settings;
    await subscription?.cancel();
    subscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen((position) => onPosition!(position));
  }

  Future<double?> resolveRouteEta(_MonitorEntry entry, Position position) async {
    final cfg = entry.config;
    final now = DateTime.now();
    if (entry.lastRouteFetchAt != null &&
        now.difference(entry.lastRouteFetchAt!).inSeconds <
            AlarmConstants.routeEtaRefreshSec &&
        entry.cachedRouteEtaMinutes != null) {
      return entry.cachedRouteEtaMinutes;
    }
    try {
      final result = await routeProvider.route(
        from: LatLng(position.latitude, position.longitude),
        to: LatLng(cfg.destLatitude, cfg.destLongitude),
        travelMode: cfg.travelMode,
      );
      entry.lastRouteFetchAt = now;
      entry.cachedRouteEtaMinutes = result?.durationMinutes;
      return entry.cachedRouteEtaMinutes;
    } catch (_) {
      return null;
    }
  }

  void updateForegroundNotification(List<AlarmRuntimeState> states) {
    if (service is! AndroidServiceInstance) {
      return;
    }
    final formatted = formatMultiAlarmNotification(states);
    service.setForegroundNotificationInfo(
      title: formatted.title,
      content: formatted.content,
    );
  }

  onPosition = (Position position) async {
    if (processingPosition || monitors.isEmpty) {
      return;
    }
    processingPosition = true;
    try {
      final emitted = <AlarmRuntimeState>[];
      var nearestDistance = double.infinity;

      for (final entry in snapshotMonitorValues(monitors)) {
        if (entry.paused) {
          if (entry.lastState != null) {
            emitted.add(entry.lastState!);
          }
          continue;
        }

        final routeEta = await resolveRouteEta(entry, position);
        final state = entry.evaluator.evaluate(
          config: entry.config,
          position: position,
          currentStatus: entry.currentStatus,
          snoozeSuppressedUntil: entry.snoozeSuppressedUntil,
          routeEtaMinutes: routeEta,
        );

        entry.lastState = state;
        emitted.add(state);
        if (state.distanceMeters < nearestDistance) {
          nearestDistance = state.distanceMeters;
        }

        service.invoke('state', state.toJson());

        if (state.status == AlarmStatus.triggered &&
            entry.currentStatus != AlarmStatus.triggered) {
          entry.currentStatus = AlarmStatus.triggered;
          service.invoke('triggered', {'alarmId': entry.config.alarmId});
        }

        if (state.hasPassedDestination && !entry.passedHandled) {
          entry.passedHandled = true;
        }
      }

      if (nearestDistance.isFinite) {
        await startGpsStream(nearestDistance);
      }
      updateForegroundNotification(emitted);
    } finally {
      processingPosition = false;
    }
  };

  void addMonitor(AlarmMonitorConfig config) {
    monitors[config.alarmId] = _MonitorEntry(config);
    if (subscription == null) {
      unawaited(startGpsStream(double.infinity));
    }
  }

  service.on('addAlarm').listen((event) async {
    if (event == null) {
      return;
    }
    final config = AlarmMonitorConfig.fromJson(Map<String, dynamic>.from(event));
    addMonitor(config);
  });

  service.on('start').listen((event) async {
    if (event == null) {
      return;
    }
    final config = AlarmMonitorConfig.fromJson(Map<String, dynamic>.from(event));
    addMonitor(config);
  });

  service.on('removeAlarm').listen((event) async {
    final alarmId = event?['alarmId'] as int?;
    if (alarmId == null) {
      return;
    }
    monitors.remove(alarmId);
    if (monitors.isEmpty) {
      await stopAll();
    }
  });

  service.on('pauseAlarm').listen((event) {
    final alarmId = event?['alarmId'] as int?;
    if (alarmId == null) {
      return;
    }
    monitors[alarmId]?.paused = true;
    monitors[alarmId]?.currentStatus = AlarmStatus.paused;
  });

  service.on('pauseAll').listen((_) {
    for (final entry in snapshotMonitorValues(monitors)) {
      entry.paused = true;
      entry.currentStatus = AlarmStatus.paused;
    }
  });

  service.on('resumeAlarm').listen((event) async {
    if (event == null) {
      return;
    }
    final config = AlarmMonitorConfig.fromJson(Map<String, dynamic>.from(event));
    final entry = monitors[config.alarmId];
    if (entry != null) {
      entry.config = config;
      entry.paused = false;
      entry.currentStatus = AlarmStatus.active;
    } else {
      addMonitor(config);
    }
  });

  service.on('snooze').listen((event) {
    final alarmId = event?['alarmId'] as int?;
    if (alarmId != null) {
      final entry = monitors[alarmId];
      if (entry != null) {
        entry.currentStatus = AlarmStatus.active;
        entry.snoozeSuppressedUntil = DateTime.now().add(
          const Duration(minutes: AlarmConstants.snoozeDurationMin),
        );
        return;
      }
    }
    for (final entry in snapshotMonitorValues(monitors)) {
      entry.currentStatus = AlarmStatus.active;
      entry.snoozeSuppressedUntil = DateTime.now().add(
        const Duration(minutes: AlarmConstants.snoozeDurationMin),
      );
    }
  });

  service.on('stop').listen((_) async {
    await stopAll();
  });
}
