import 'package:isar/isar.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/trip.dart';

class TripStats {
  const TripStats({
    this.totalDistanceMeters,
    this.maxSpeedKmh,
    this.avgSpeedKmh,
  });

  final double? totalDistanceMeters;
  final double? maxSpeedKmh;
  final double? avgSpeedKmh;
}

abstract class TripRepository {
  Future<Trip> startTrip(Alarm alarm);
  Future<Trip> endTrip(int tripId, TripOutcome outcome, {TripStats? stats});
  Future<void> updateStats(int tripId, TripStats stats);
  Future<List<Trip>> getAll({int? limit, int? offset});
  Future<Trip?> getById(int id);
  Future<Trip?> getActiveTrip();
  Stream<List<Trip>> watchAll();
}

class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Future<Trip> startTrip(Alarm alarm) async {
    final active = await getActiveTrip();
    if (active != null) {
      await endTrip(active.id, TripOutcome.cancelled);
    }

    final trip = Trip()
      ..alarmId = alarm.id
      ..destinationName = alarm.name
      ..destLatitude = alarm.destLatitude
      ..destLongitude = alarm.destLongitude
      ..startedAt = alarm.startedAt ?? DateTime.now()
      ..outcome = TripOutcome.completed;

    try {
      await _isar.writeTxn(() async {
        await _isar.trips.put(trip);
      });
    } catch (e) {
      throw StorageException(
        'Unable to start trip.',
        debugMessage: e.toString(),
      );
    }
    return trip;
  }

  @override
  Future<Trip> endTrip(int tripId, TripOutcome outcome, {TripStats? stats}) async {
    final trip = await getById(tripId);
    if (trip == null) {
      throw StorageException('Trip not found.');
    }
    if (trip.endedAt != null) {
      return trip;
    }

    final endedAt = DateTime.now();
    trip
      ..endedAt = endedAt
      ..outcome = outcome
      ..durationSeconds = endedAt.difference(trip.startedAt).inSeconds;

    if (stats != null) {
      _applyStats(trip, stats);
    }

    await _isar.writeTxn(() async {
      await _isar.trips.put(trip);
    });
    return trip;
  }

  @override
  Future<void> updateStats(int tripId, TripStats stats) async {
    final trip = await getById(tripId);
    if (trip == null || trip.endedAt != null) {
      return;
    }
    _applyStats(trip, stats);
    await _isar.writeTxn(() async {
      await _isar.trips.put(trip);
    });
  }

  void _applyStats(Trip trip, TripStats stats) {
    if (stats.totalDistanceMeters != null) {
      trip.totalDistanceMeters = stats.totalDistanceMeters;
    }
    if (stats.maxSpeedKmh != null) {
      trip.maxSpeedKmh = stats.maxSpeedKmh;
    }
    if (stats.avgSpeedKmh != null) {
      trip.avgSpeedKmh = stats.avgSpeedKmh;
    }
  }

  @override
  Future<List<Trip>> getAll({int? limit, int? offset}) async {
    final all = await _isar.trips.where().findAll()
      ..sort((a, b) {
        final byStart = b.startedAt.compareTo(a.startedAt);
        if (byStart != 0) {
          return byStart;
        }
        return b.id.compareTo(a.id);
      });
    if (offset == null && limit == null) {
      return all;
    }
    final start = offset ?? 0;
    if (start >= all.length) {
      return [];
    }
    final end = limit == null ? all.length : (start + limit).clamp(0, all.length);
    return all.sublist(start, end);
  }

  @override
  Future<Trip?> getById(int id) => _isar.trips.get(id);

  @override
  Future<Trip?> getActiveTrip() async {
    return _isar.trips
        .filter()
        .endedAtIsNull()
        .sortByStartedAtDesc()
        .findFirst();
  }

  @override
  Stream<List<Trip>> watchAll() {
    return _isar.trips.where().watch(fireImmediately: true).map(
      (trips) => trips
        ..sort((a, b) {
          final byStart = b.startedAt.compareTo(a.startedAt);
          if (byStart != 0) {
            return byStart;
          }
          return b.id.compareTo(a.id);
        }),
    );
  }
}
