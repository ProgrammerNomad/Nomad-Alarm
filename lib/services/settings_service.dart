import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nomad_alarm/core/utils/settings_provider_utils.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';

class SettingsService {
  SettingsService(this._isar);

  final Isar _isar;

  Future<AppSettings> getSettings() async {
    final existing = await _isar.appSettings.get(0);
    if (existing != null) {
      ensureProviderSettingsDefaults(existing);
      return existing;
    }
    final defaults = AppSettings.defaults();
    await _isar.writeTxn(() async {
      await _isar.appSettings.put(defaults);
    });
    return defaults;
  }

  Stream<AppSettings> watchSettings() async* {
    yield await getSettings();
    await for (final _ in _isar.appSettings.watchLazy(fireImmediately: false)) {
      yield await getSettings();
    }
  }

  Future<void> updateSettings(AppSettings settings) async {
    try {
      settings.id = 0;
      await _isar.writeTxn(() async {
        await _isar.appSettings.put(settings);
      });
    } catch (e) {
      throw StorageException(
        'Unable to save settings',
        debugMessage: e.toString(),
      );
    }
  }

  ThemeMode toFlutterThemeMode(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  AppThemeMode fromFlutterThemeMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => AppThemeMode.light,
      ThemeMode.dark => AppThemeMode.dark,
      ThemeMode.system => AppThemeMode.system,
    };
  }
}
