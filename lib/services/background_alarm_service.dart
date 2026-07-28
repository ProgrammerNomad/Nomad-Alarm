import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/utils/alarm_evaluator.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm_monitor_config.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';

/// Background GPS monitoring via Android foreground service.
class BackgroundAlarmService {
  BackgroundAlarmService._();

  static bool _configured = false;

  static Future<void> ensureConfigured() async {
    if (_configured) {
      return;
    }
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundServiceOnStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'tracking',
        initialNotificationTitle: 'Nomad Alarm',
        initialNotificationContent: 'Starting location tracking…',
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(),
    );
    _configured = true;
  }

  static Future<void> startMonitoring(AlarmMonitorConfig config) async {
    await ensureConfigured();
    final service = FlutterBackgroundService();
    if (!await service.isRunning()) {
      await service.startService();
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
    FlutterBackgroundService().invoke('resume', config.toJson());
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
  StreamSubscription<Position>? subscription;
  var paused = false;

  Future<void> stopAll() async {
    await subscription?.cancel();
    subscription = null;
    config = null;
    evaluator.tracker.reset();
    service.invoke('stopped');
    service.stopSelf();
  }

  Future<void> handlePosition(Position position) async {
    final activeConfig = config;
    if (activeConfig == null || paused) {
      return;
    }

    final state = evaluator.evaluate(
      config: activeConfig,
      position: position,
      currentStatus: currentStatus,
      snoozeSuppressedUntil: snoozeSuppressedUntil,
    );

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: activeConfig.name,
        content: '${formatDistance(state.distanceMeters)} to destination',
      );
    }

    service.invoke('state', state.toJson());

    if (state.status == AlarmStatus.triggered &&
        currentStatus != AlarmStatus.triggered) {
      currentStatus = AlarmStatus.triggered;
      service.invoke('triggered', {'alarmId': activeConfig.alarmId});
    }
  }

  service.on('start').listen((event) async {
    if (event == null) {
      return;
    }
    config = AlarmMonitorConfig.fromJson(Map<String, dynamic>.from(event));
    currentStatus = AlarmStatus.active;
    paused = false;
    snoozeSuppressedUntil = null;
    evaluator.tracker.reset();

    await subscription?.cancel();
    subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: AlarmConstants.gpsDistanceFilterBalancedM,
      ),
    ).listen(handlePosition);
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
  });

  service.on('snooze').listen((_) {
    currentStatus = AlarmStatus.active;
    snoozeSuppressedUntil = DateTime.now().add(
      Duration(minutes: AlarmConstants.snoozeDurationMin),
    );
  });

  service.on('stop').listen((_) async {
    await stopAll();
  });
}
