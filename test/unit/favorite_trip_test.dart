import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/trip.dart';
import 'package:nomad_alarm/repositories/favorite_repository.dart';

void main() {
  late Isar isar;
  late FavoriteRepository repository;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('nomad_alarm_favorite_trip');
    isar = await Isar.open(
      [FavoriteSchema, TripSchema],
      directory: tempDir.path,
    );
    repository = FavoriteRepositoryImpl(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('saveFromTrip persists trip metadata', () async {
    final trip = Trip()
      ..alarmId = 1
      ..destinationName = 'Central Station'
      ..destLatitude = 28.6139
      ..destLongitude = 77.2090
      ..startedAt = DateTime.now()
      ..outcome = TripOutcome.completed
      ..routePolyline = 'encoded_polyline';

    await isar.writeTxn(() async {
      await isar.trips.put(trip);
    });

    final favorite = await repository.saveFromTrip(trip);

    expect(favorite.category, FavoriteCategory.trip);
    expect(favorite.name, 'Central Station');
    expect(favorite.latitude, closeTo(28.6139, 0.0001));
    expect(favorite.longitude, closeTo(77.2090, 0.0001));
    expect(favorite.linkedTripId, trip.id);
    expect(favorite.routePolyline, 'encoded_polyline');

    final loaded = await repository.getAll();
    expect(loaded, hasLength(1));
    expect(loaded.first.id, favorite.id);
  });
}
