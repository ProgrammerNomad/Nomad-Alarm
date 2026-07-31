import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/router/app_router.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/providers/map_service_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/services/alarm_service.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';
import 'package:nomad_alarm/services/battery_monitor_service.dart';
import 'package:nomad_alarm/services/flashlight_service.dart';
import 'package:nomad_alarm/services/notification_service.dart';
import 'package:nomad_alarm/services/speech_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final speechServiceProvider = Provider<SpeechService>((ref) {
  return SpeechService();
});

final flashlightServiceProvider = Provider<FlashlightService>((ref) {
  final service = FlashlightService();
  ref.onDispose(service.stop);
  return service;
});

final batteryMonitorServiceProvider = Provider<BatteryMonitorService>((ref) {
  return BatteryMonitorService();
});

final alarmServiceProvider = Provider<AlarmService>((ref) {
  final router = ref.watch(routerProvider);
  final settings = ref.watch(appSettingsProvider).valueOrNull;

  final service = AlarmService(
    alarmRepository: ref.watch(alarmRepositoryProvider),
    tripRepository: ref.watch(tripRepositoryProvider),
    historyRepository: ref.watch(historyRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
    speechService: ref.watch(speechServiceProvider),
    flashlightService: ref.watch(flashlightServiceProvider),
    batteryMonitorService: ref.watch(batteryMonitorServiceProvider),
    batteryProfile: settings?.batteryProfile ?? BatteryProfile.balanced,
    languageCode: settings?.languageCode ?? 'en',
    lockScreenInfoEnabled: settings?.lockScreenInfoEnabled ?? true,
    routeService: ref.watch(settingsControllerProvider).maybeWhen(
          data: (_) => ref.watch(routeServiceProvider),
          orElse: () => null,
        ),
    onNavigateToAlarm: (alarmId, {isRing = false}) {
      if (alarmId < 0) {
        router.go('/alarms');
        return;
      }
      if (isRing) {
        router.go('/alarm/ring/$alarmId');
      } else {
        router.go('/alarm/active/$alarmId');
      }
    },
  );
  service.bindBackgroundEvents();
  ref.onDispose(service.dispose);
  return service;
});

final activeAlarmStateProvider =
    StreamProvider.family<AlarmRuntimeState, int>((ref, alarmId) {
  final alarmService = ref.watch(alarmServiceProvider);
  return alarmService.watchActiveAlarm(alarmId);
});

final monitoringAlarmIdProvider = Provider<int?>((ref) {
  return ref.watch(alarmServiceProvider).activeAlarmId;
});

final monitoredAlarmIdsProvider = Provider<Set<int>>((ref) {
  return ref.watch(alarmServiceProvider).monitoredAlarmIds;
});

final backgroundInitProvider = FutureProvider<void>((ref) async {
  await BackgroundAlarmService.ensureConfigured();
});

final backgroundServiceRunningProvider = FutureProvider<bool>((ref) async {
  return BackgroundAlarmService.isRunning();
});
