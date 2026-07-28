import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/trip.dart';
import 'package:nomad_alarm/repositories/trip_repository.dart';

Alarm _alarm({int id = 1}) {
  return Alarm()
    ..id = id
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
    ..status = AlarmStatus.active
    ..startedAt = DateTime.utc(2024, 6, 1, 8)
    ..createdAt = DateTime.utc(2024, 1, 1)
    ..updatedAt = DateTime.utc(2024, 1, 1);
}

void main() {
  late Isar isar;
  late TripRepository repository;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('nomad_alarm_trip_test');
    isar = await Isar.open(
      [TripSchema],
      directory: tempDir.path,
      name: 'trip_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    repository = TripRepositoryImpl(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('starts and ends a trip with stats', () async {
    final trip = await repository.startTrip(_alarm());
    expect(trip.alarmId, 1);
    expect(trip.endedAt, isNull);

    final active = await repository.getActiveTrip();
    expect(active?.id, trip.id);

    final ended = await repository.endTrip(
      trip.id,
      TripOutcome.completed,
      stats: const TripStats(
        totalDistanceMeters: 4200,
        maxSpeedKmh: 80,
        avgSpeedKmh: 45,
      ),
    );

    expect(ended.outcome, TripOutcome.completed);
    expect(ended.durationSeconds, isNotNull);
    expect(ended.totalDistanceMeters, 4200);
    expect(ended.maxSpeedKmh, 80);
    expect(await repository.getActiveTrip(), isNull);
  });

  test('closes previous active trip when starting a new one', () async {
    final first = await repository.startTrip(_alarm());
    final second = await repository.startTrip(_alarm(id: 2));

    final firstTrip = await repository.getById(first.id);
    expect(firstTrip?.endedAt, isNotNull);
    expect(firstTrip?.outcome, TripOutcome.cancelled);
    expect(second.alarmId, 2);
  });

  test('lists trips sorted by start date desc', () async {
    final first = await repository.startTrip(_alarm());
    await repository.endTrip(first.id, TripOutcome.completed);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final second = await repository.startTrip(_alarm(id: 2));
    await repository.endTrip(second.id, TripOutcome.completed);

    final trips = await repository.getAll();
    expect(trips, hasLength(2));
    expect(trips.first.id, second.id);
  });
}
