import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/repositories/settings_repository.dart';
import 'package:nomad_alarm/services/isar_service.dart';
import 'package:nomad_alarm/services/settings_service.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final isarService = ref.watch(isarServiceProvider).requireValue;
  return SettingsRepositoryImpl(SettingsService(isarService.isar));
});

final appSettingsProvider = StreamProvider<AppSettings>((ref) async* {
  final isarService = await ref.watch(isarServiceProvider.future);
  yield* SettingsRepositoryImpl(SettingsService(isarService.isar)).watchSettings();
});

class SettingsController extends AsyncNotifier<AppSettings> {
  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  @override
  Future<AppSettings> build() async {
    return _repo.getSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.updateSettings(settings);
      return _repo.getSettings();
    });
  }

  Future<void> completeWelcome() async {
    final current = await future;
    await saveSettings(
      current
        ..hasCompletedWelcome = true,
    );
  }

  Future<void> completePermissions() async {
    final current = await future;
    await saveSettings(
      current
        ..hasCompletedPermissions = true,
    );
  }
}

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);
