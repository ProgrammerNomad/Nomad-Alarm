import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/repositories/backup_repository.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';
import 'package:nomad_alarm/services/backup_service.dart';
import 'package:nomad_alarm/services/boot_prefs_sync.dart';
import 'package:nomad_alarm/services/cloud_backup_service.dart';
import 'package:nomad_alarm/services/deep_link_service.dart';
import 'package:nomad_alarm/services/import_intent_service.dart';
import 'package:nomad_alarm/services/isar_service.dart';
import 'package:nomad_alarm/services/offline_tile_service.dart';
import 'package:nomad_alarm/services/permission_service.dart';
import 'package:nomad_alarm/services/settings_service.dart';
import 'package:nomad_alarm/services/widget_service.dart';

export 'package:nomad_alarm/providers/map_service_providers.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final isarService = ref.watch(isarServiceProvider).requireValue;
  return SettingsService(isarService.isar);
});

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final isarService = ref.watch(isarServiceProvider).requireValue;
  return BackupRepositoryImpl(isarService);
});

final cloudBackupServiceProvider = Provider<CloudBackupService>((ref) {
  final isarService = ref.watch(isarServiceProvider).requireValue;
  return CloudBackupService(BackupService(isarService.isar));
});

final bootstrapProvider = FutureProvider<bool>((ref) async {
  await ref.watch(isarServiceProvider.future);
  final isarService = ref.read(isarServiceProvider).requireValue;
  final settings = await SettingsService(isarService.isar).getSettings();

  await ref
      .read(notificationServiceProvider)
      .initialize(languageCode: settings.languageCode);
  await BackgroundAlarmService.ensureConfigured(
    languageCode: settings.languageCode,
  );
  await BootPrefsSync.initialize();
  await BootPrefsSync.syncResumeAfterBoot(settings.resumeAlarmAfterBoot);
  ref.read(alarmServiceProvider);

  return true;
});

/// Non-critical init deferred until after splash (widgets, tiles, offline maps).
final deferredInitProvider = FutureProvider<void>((ref) async {
  await ref.watch(bootstrapProvider.future);
  await WidgetService.initialize();
  await TileService.initialize();
  await DeepLinkService.initialize();
  await ImportIntentService.initialize();
  await OfflineTileService.initialize();
});
