import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/router/app_router.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/services/alarm_service.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';
import 'package:nomad_alarm/services/notification_service.dart';
import 'package:nomad_alarm/services/speech_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final speechServiceProvider = Provider<SpeechService>((ref) {
  return SpeechService();
});

final alarmServiceProvider = Provider<AlarmService>((ref) {
  final router = ref.watch(routerProvider);
  final settings = ref.watch(appSettingsProvider).valueOrNull;

  final service = AlarmService(
    alarmRepository: ref.watch(alarmRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
    speechService: ref.watch(speechServiceProvider),
    languageCode: settings?.languageCode ?? 'en',
    onNavigateToAlarm: (alarmId, {isRing = false}) {
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

final backgroundInitProvider = FutureProvider<void>((ref) async {
  await BackgroundAlarmService.ensureConfigured();
});
