import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/settings_repository.dart';

class _DelayedSettingsRepository implements SettingsRepository {
  _DelayedSettingsRepository(this._settings);

  AppSettings _settings;
  Completer<void>? updateGate;

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Stream<AppSettings> watchSettings() async* {
    yield _settings;
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    final gate = updateGate;
    if (gate != null) {
      await gate.future;
    }
    _settings = settings;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saveSettings never enters AsyncLoading when data is already loaded',
      () async {
    final settings = AppSettings.defaults();
    final repo = _DelayedSettingsRepository(settings);
    repo.updateGate = Completer<void>();

    final container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(settingsControllerProvider.future);

    final notifier = container.read(settingsControllerProvider.notifier);
    final updated = AppSettings.defaults()..defaultVoiceEnabled = false;

    final saveFuture = notifier.saveSettings(updated);
    await Future<void>.delayed(Duration.zero);

    final duringSave = container.read(settingsControllerProvider);
    expect(duringSave.isLoading, isFalse);
    expect(duringSave.hasValue, isTrue);
    expect(duringSave.value!.defaultVoiceEnabled, isFalse);

    repo.updateGate!.complete();
    await saveFuture.catchError((_) {});

    final afterSave = container.read(settingsControllerProvider);
    expect(afterSave.isLoading, isFalse);
  });

  test('saveSettings reverts to previous value when persist fails', () async {
    final settings = AppSettings.defaults();
    final repo = _FailingSettingsRepository(settings);

    final container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(settingsControllerProvider.future);

    final notifier = container.read(settingsControllerProvider.notifier);
    final updated = AppSettings.defaults()..themeMode = AppThemeMode.dark;

    await notifier.saveSettings(updated);

    final state = container.read(settingsControllerProvider);
    expect(state.isLoading, isFalse);
    expect(state.hasValue, isTrue);
    expect(state.value!.themeMode, AppThemeMode.system);
  });

  test('saveSettings persists lastBackupAt', () async {
    final settings = AppSettings.defaults();
    final repo = _DelayedSettingsRepository(settings);

    final container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(settingsControllerProvider.future);

    final notifier = container.read(settingsControllerProvider.notifier);
    final at = DateTime.utc(2026, 7, 31, 14, 14);
    await notifier.saveSettings(settings..lastBackupAt = at);

    expect((await repo.getSettings()).lastBackupAt, at);
  });
}

class _FailingSettingsRepository implements SettingsRepository {
  _FailingSettingsRepository(this._settings);

  final AppSettings _settings;

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Stream<AppSettings> watchSettings() async* {
    yield _settings;
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    throw Exception('persist failed');
  }
}
