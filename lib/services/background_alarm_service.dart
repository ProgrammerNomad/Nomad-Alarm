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
import 'package:nomad_alarm/core/utils/distance_utils.dart';
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

  static Future<void> startMonitoring(AlarmMonitorConfig config) async {
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
    service.invoke('start', config.toJson());
  }

  static Future<void> stopMonitoring() async {
    final service = FlutterBackgroundService();
    service.invoke('stop');
    service.invoke('stopService');
  }

  static Future<void> pauseMonitoring() async {
    FlutterBackgroundService().invoke('pause');
  }

  static Future<void> resumeMonitoring(AlarmMonitorConfig config) async {
    if (!await hasLocationPermissionForForegroundService()) {
      throw const PermissionException(
        'Location permission is required to resume tracking.',
      );
    }
    FlutterBackgroundService().invoke('resume', config.toJson());
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

@pragma('vm:entry-point')
Future<void> backgroundServiceOnStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  AlarmMonitorConfig? config;
  var currentStatus = AlarmStatus.active;
  DateTime? snoozeSuppressedUntil;
  final evaluator = AlarmEvaluator();
  final routeProvider = OsrmRouteProvider();
  DateTime? lastRouteFetchAt;
  double? cachedRouteEtaMinutes;
  StreamSubscription<Position>? subscription;
  var paused = false;
  var lastDistanceMeters = double.infinity;
  LocationSettings? activeSettings;
  Future<void> Function(Position position)? onPosition;

  Future<void> stopAll() async {
    await subscription?.cancel();
    subscription = null;
    config = null;
    activeSettings = null;
    evaluator.reset();
    routeProvider.dispose();
    lastRouteFetchAt = null;
    cachedRouteEtaMinutes = null;
    service.invoke('stopped');
    service.stopSelf();
  }

  Future<void> startGpsStream(AlarmMonitorConfig cfg, double distance) async {
    final profileConfig = BatteryProfileConfig.effectiveFor(
      selectedProfile: cfg.batteryProfile,
      distanceMeters: distance,
      triggerDistanceMeters: cfg.triggerDistanceMeters,
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

  Future<double?> resolveRouteEta(
    AlarmMonitorConfig cfg,
    Position position,
  ) async {
    final now = DateTime.now();
    if (lastRouteFetchAt != null &&
        now.difference(lastRouteFetchAt!).inSeconds <
            AlarmConstants.routeEtaRefreshSec &&
        cachedRouteEtaMinutes != null) {
      return cachedRouteEtaMinutes;
    }
    try {
      final result = await routeProvider.route(
        from: LatLng(position.latitude, position.longitude),
        to: LatLng(cfg.destLatitude, cfg.destLongitude),
        travelMode: cfg.travelMode,
      );
      lastRouteFetchAt = now;
      cachedRouteEtaMinutes = result?.durationMinutes;
      return cachedRouteEtaMinutes;
    } catch (_) {
      return null;
    }
  }

  onPosition = (Position position) async {
    final activeConfig = config;
    if (activeConfig == null || paused) {
      return;
    }

    final routeEta = await resolveRouteEta(activeConfig, position);

    final state = evaluator.evaluate(
      config: activeConfig,
      position: position,
      currentStatus: currentStatus,
      snoozeSuppressedUntil: snoozeSuppressedUntil,
      routeEtaMinutes: routeEta,
    );

    lastDistanceMeters = state.distanceMeters;
    await startGpsStream(activeConfig, state.distanceMeters);

    if (service is AndroidServiceInstance) {
      final eta = formatEta(state.etaMinutes);
      final distance = formatDistance(state.distanceMeters);
      final content = state.etaMinutes != null
          ? '$distance · $eta'
          : '$distance to destination';
      service.setForegroundNotificationInfo(
        title: activeConfig.name,
        content: content,
      );
    }

    service.invoke('state', state.toJson());

    if (state.status == AlarmStatus.triggered &&
        currentStatus != AlarmStatus.triggered) {
      currentStatus = AlarmStatus.triggered;
      service.invoke('triggered', {'alarmId': activeConfig.alarmId});
    }
  };

  service.on('start').listen((event) async {
    if (event == null) {
      return;
    }
    config = AlarmMonitorConfig.fromJson(Map<String, dynamic>.from(event));
    currentStatus = AlarmStatus.active;
    paused = false;
    snoozeSuppressedUntil = null;
    lastDistanceMeters = double.infinity;
    evaluator.reset();
    lastRouteFetchAt = null;
    cachedRouteEtaMinutes = null;

    await startGpsStream(config!, lastDistanceMeters);
  });

  service.on('pause').listen((_) {
    paused = true;
    currentStatus = AlarmStatus.paused;
  });

  service.on('resume').listen((event) async {
    if (event != null) {
      config = AlarmMonitorConfig.fromJson(Map<String, dynamic>.from(event));
    }
    paused = false;
    currentStatus = AlarmStatus.active;
    if (config != null) {
      await startGpsStream(config!, lastDistanceMeters);
    }
  });

  service.on('snooze').listen((_) {
    currentStatus = AlarmStatus.active;
    snoozeSuppressedUntil = DateTime.now().add(
      const Duration(minutes: AlarmConstants.snoozeDurationMin),
    );
  });

  service.on('stop').listen((_) async {
    await stopAll();
  });
}
