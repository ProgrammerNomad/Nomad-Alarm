import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/repositories/history_repository.dart';

Alarm _alarm() {
  return Alarm()
    ..id = 1
    ..name = 'Central Station'
    ..destLatitude = 51.5
    ..destLongitude = -0.1
    ..type = AlarmType.distance
    ..triggerDistanceMeters = 500
    ..travelMode = TravelMode.train
    ..repeat = false
    ..voiceEnabled = true
    ..vibrationEnabled = true
    ..flashlightEnabled = false
    ..status = AlarmStatus.completed
    ..createdAt = DateTime.utc(2024, 1, 1)
    ..updatedAt = DateTime.utc(2024, 1, 1);
}

void main() {
  late Isar isar;
  late HistoryRepository repository;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('nomad_alarm_history_test');
    isar = await Isar.open(
      [HistoryEntrySchema],
      directory: tempDir.path,
      name: 'history_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    repository = HistoryRepositoryImpl(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('logs and retrieves history entries', () async {
    final entry = await repository.log(
      alarm: _alarm(),
      type: HistoryType.completed,
      tripId: 10,
    );

    expect(entry.id, greaterThan(0));
    expect(entry.destinationName, 'Central Station');
    expect(entry.tripId, 10);

    final all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.first.type, HistoryType.completed);
  });

  test('filters history by type', () async {
    await repository.log(alarm: _alarm(), type: HistoryType.completed);
    await repository.log(
      alarm: _alarm()..name = 'Airport',
      type: HistoryType.missed,
      notes: 'Passed stop',
    );

    final completed = await repository.getAll(type: HistoryType.completed);
    final missed = await repository.getAll(type: HistoryType.missed);

    expect(completed, hasLength(1));
    expect(missed, hasLength(1));
    expect(missed.first.notes, 'Passed stop');
  });

  test('deletes a history entry', () async {
    final entry = await repository.log(
      alarm: _alarm(),
      type: HistoryType.dismissed,
      notes: 'Cancelled by user',
    );

    await repository.delete(entry.id);

    expect(await repository.getAll(), isEmpty);
  });
}
