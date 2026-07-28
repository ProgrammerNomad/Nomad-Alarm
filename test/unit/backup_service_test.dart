import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/services/backup_service.dart';

Alarm _sampleAlarm({AlarmStatus status = AlarmStatus.draft}) {
  final now = DateTime.utc(2024, 6, 1);
  return Alarm()
    ..name = 'Central Station'
    ..destLatitude = 51.5
    ..destLongitude = -0.1
    ..address = 'London'
    ..type = AlarmType.distance
    ..triggerDistanceMeters = 500
    ..travelMode = TravelMode.train
    ..repeat = false
    ..voiceEnabled = true
    ..vibrationEnabled = true
    ..flashlightEnabled = false
    ..status = status
    ..createdAt = now
    ..updatedAt = now;
}

void main() {
  late Isar isar;
  late BackupService service;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('nomad_alarm_backup_test');
    isar = await Isar.open(
      [
        AlarmSchema,
        FavoriteSchema,
        HistoryEntrySchema,
        AppSettingsSchema,
      ],
      directory: tempDir.path,
      name: 'backup_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    service = BackupService(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('export_import_roundtrip preserves mergeable data', () async {
    await isar.writeTxn(() async {
      await isar.alarms.put(_sampleAlarm());
      await isar.alarms.put(_sampleAlarm(status: AlarmStatus.active));
      await isar.favorites.put(
        Favorite()
          ..name = 'Home'
          ..category = FavoriteCategory.home
          ..latitude = 51.5
          ..longitude = -0.1
          ..createdAt = DateTime.utc(2024, 1, 1),
      );
      await isar.historyEntrys.put(
        HistoryEntry()
          ..destinationName = 'Central Station'
          ..destLatitude = 51.5
          ..destLongitude = -0.1
          ..type = HistoryType.completed
          ..occurredAt = DateTime.utc(2024, 2, 1),
      );
      await isar.appSettings.put(AppSettings.defaults()..useMetric = false);
    });

    final exported = await service.exportToJson();
    final map = jsonDecode(exported) as Map<String, dynamic>;

    expect(map['version'], backupSchemaVersion);
    expect(map['alarms'], hasLength(1));
    expect(map['favorites'], hasLength(1));
    expect(map['history'], hasLength(1));

    await isar.writeTxn(() async {
      await isar.alarms.clear();
      await isar.favorites.clear();
      await isar.historyEntrys.clear();
    });

    final result = await service.importFromJson(exported);
    expect(result.alarmsImported, 1);
    expect(result.favoritesImported, 1);
    expect(result.historyImported, 1);
    expect(result.settingsImported, isTrue);

    final alarms = await isar.alarms.where().findAll();
    expect(alarms, hasLength(1));
    expect(alarms.first.status, AlarmStatus.draft);
    expect(alarms.first.name, 'Central Station');

    final settings = await isar.appSettings.get(0);
    expect(settings?.useMetric, isFalse);
  });

  test('reject_invalid_version throws StorageException', () async {
    const invalid = '{"version": 99, "alarms": []}';

    expect(
      () => service.importFromJson(invalid),
      throwsA(isA<StorageException>()),
    );
  });
}
