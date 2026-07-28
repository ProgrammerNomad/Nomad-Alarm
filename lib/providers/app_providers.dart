import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/repositories/stub_repositories.dart';
import 'package:nomad_alarm/services/isar_service.dart';
import 'package:nomad_alarm/services/permission_service.dart';
import 'package:nomad_alarm/services/settings_service.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final isarService = ref.watch(isarServiceProvider).requireValue;
  return SettingsService(isarService.isar);
});

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepositoryImpl();
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepositoryImpl();
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl();
});

final bootstrapProvider = FutureProvider<bool>((ref) async {
  await ref.watch(isarServiceProvider.future);
  final isarService = ref.read(isarServiceProvider).requireValue;
  await SettingsService(isarService.isar).getSettings();
  return true;
});
