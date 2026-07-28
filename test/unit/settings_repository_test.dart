import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/repositories/settings_repository.dart';
import 'package:nomad_alarm/services/settings_service.dart';

void main() {
  late Isar isar;
  late SettingsRepository repository;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('nomad_alarm_test');
    isar = await Isar.open(
      [AppSettingsSchema],
      directory: tempDir.path,
      name: 'settings_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    repository = SettingsRepositoryImpl(SettingsService(isar));
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('seeds default settings on first read', () async {
    final settings = await repository.getSettings();
    expect(settings.id, 0);
    expect(settings.themeMode, AppThemeMode.system);
    expect(settings.useMetric, isTrue);
    expect(settings.hasCompletedWelcome, isFalse);
  });

  test('persists settings updates', () async {
    final settings = await repository.getSettings();
    settings.themeMode = AppThemeMode.dark;
    settings.useMetric = false;
    settings.languageCode = 'hi';
    await repository.updateSettings(settings);

    final loaded = await repository.getSettings();
    expect(loaded.themeMode, AppThemeMode.dark);
    expect(loaded.useMetric, isFalse);
    expect(loaded.languageCode, 'hi');
  });
}
