import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/search_result.dart';

abstract class FavoriteRepository {
  Future<List<Favorite>> getAll();
  Future<List<Favorite>> getTop({int limit = 10});
  Stream<List<Favorite>> watchAll();
  Future<Favorite> save({
    required String name,
    required double latitude,
    required double longitude,
    String? address,
    FavoriteCategory category = FavoriteCategory.custom,
  });
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
  Stream<List<Favorite>> watchAll() {
    return _isar.favorites.where().sortBySortOrder().watch(fireImmediately: true);
  }

  @override
  Future<Favorite> save({
    required String name,
    required double latitude,
    required double longitude,
    String? address,
    FavoriteCategory category = FavoriteCategory.custom,
  }) async {
    final favorite = Favorite()
      ..name = name
      ..latitude = latitude
      ..longitude = longitude
      ..address = address
      ..category = category
      ..createdAt = DateTime.now()
      ..sortOrder = DateTime.now().millisecondsSinceEpoch;

    await _isar.writeTxn(() async {
      await _isar.favorites.put(favorite);
    });
    return favorite;
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.favorites.delete(id);
    });
  }

  Future<Favorite> saveFromSearchResult(SearchResult result) {
    return save(
      name: result.name,
      latitude: result.latitude,
      longitude: result.longitude,
      address: result.address,
    );
  }
}
