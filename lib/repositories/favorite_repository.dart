import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/models/trip.dart';

abstract class FavoriteRepository {
  Future<List<Favorite>> getAll();
  Future<List<Favorite>> getTop({int limit = 10});
  Future<Favorite?> getById(int id);
  Stream<List<Favorite>> watchAll();
  Stream<List<Favorite>> watchSmartEnabled();
  Future<Favorite> save(Favorite favorite);
  Future<Favorite> saveNew({
    required String name,
    required double latitude,
    required double longitude,
    String? address,
    FavoriteCategory category = FavoriteCategory.custom,
    SmartAlarmMode smartAlarmMode = SmartAlarmMode.off,
    double triggerDistanceMeters = 500,
    String? providerPlaceId,
    int? linkedTripId,
    String? routePolyline,
  });
  Future<Favorite> saveFromTrip(Trip trip);
  Future<void> update(Favorite favorite);
  Future<void> markAutoCreated(int id);
  Future<void> recordStopDismissed(int id);
  Future<void> recordSmartAlarmCompleted(int id);
  Future<void> delete(int id);
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Future<List<Favorite>> getAll() async {
    return _isar.favorites.where().sortBySortOrder().findAll();
  }

  @override
  Future<List<Favorite>> getTop({int limit = 10}) async {
    return _isar.favorites.where().sortBySortOrder().limit(limit).findAll();
  }

  @override
  Future<Favorite?> getById(int id) => _isar.favorites.get(id);

  @override
  Stream<List<Favorite>> watchAll() {
    return _isar.favorites.where().sortBySortOrder().watch(fireImmediately: true);
  }

  @override
  Stream<List<Favorite>> watchSmartEnabled() {
    return watchAll().map(
      (list) => list
          .where((f) => f.smartAlarmMode != SmartAlarmMode.off)
          .toList(),
    );
  }

  @override
  Future<Favorite> save(Favorite favorite) async {
    await _isar.writeTxn(() async {
      await _isar.favorites.put(favorite);
    });
    return favorite;
  }

  @override
  Future<Favorite> saveNew({
    required String name,
    required double latitude,
    required double longitude,
    String? address,
    FavoriteCategory category = FavoriteCategory.custom,
    SmartAlarmMode smartAlarmMode = SmartAlarmMode.off,
    double triggerDistanceMeters = 500,
    String? providerPlaceId,
    int? linkedTripId,
    String? routePolyline,
  }) async {
    final favorite = Favorite.createDefaults(
      name: name,
      latitude: latitude,
      longitude: longitude,
      address: address,
      category: category,
    )
      ..smartAlarmMode = smartAlarmMode
      ..triggerDistanceMeters = triggerDistanceMeters
      ..providerPlaceId = providerPlaceId
      ..linkedTripId = linkedTripId
      ..routePolyline = routePolyline;

    return save(favorite);
  }

  @override
  Future<Favorite> saveFromTrip(Trip trip) async {
    return saveNew(
      name: trip.destinationName,
      latitude: trip.destLatitude,
      longitude: trip.destLongitude,
      category: FavoriteCategory.trip,
      linkedTripId: trip.id,
      routePolyline: trip.routePolyline,
    );
  }

  @override
  Future<void> update(Favorite favorite) async {
    await save(favorite);
  }

  @override
  Future<void> markAutoCreated(int id) async {
    final favorite = await getById(id);
    if (favorite == null) {
      return;
    }
    favorite
      ..lastAutoCreatedAt = DateTime.now()
      ..autoStartedCount = favorite.autoStartedCount + 1
      ..lastUsedAt = DateTime.now();
    await update(favorite);
  }

  @override
  Future<void> recordStopDismissed(int id) async {
    final favorite = await getById(id);
    if (favorite == null) {
      return;
    }
    favorite
      ..falsePredictionCount = favorite.falsePredictionCount + 1
      ..lastDismissedAt = DateTime.now()
      ..predictionAccuracy = (favorite.predictionAccuracy * 0.85).clamp(0.0, 1.0);
    await update(favorite);
  }

  @override
  Future<void> recordSmartAlarmCompleted(int id) async {
    final favorite = await getById(id);
    if (favorite == null) {
      return;
    }
    favorite
      ..lastUsedAt = DateTime.now()
      ..predictionAccuracy = (favorite.predictionAccuracy * 0.7 + 0.3).clamp(0.0, 1.0);
    await update(favorite);
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.favorites.delete(id);
    });
  }

  Future<Favorite> saveFromSearchResult(SearchResult result) {
    return saveNew(
      name: result.name,
      latitude: result.latitude,
      longitude: result.longitude,
      address: result.address,
      providerPlaceId: result.placeId,
    );
  }
}
