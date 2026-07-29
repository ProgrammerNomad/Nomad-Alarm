import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/recent_search.dart';import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/search/search_provider.dart';

abstract class SearchRepository {
  Future<List<SearchResult>> search(String query);
  Future<SearchResult?> reverseGeocode(double latitude, double longitude);
  Future<List<RecentSearch>> getRecent({int limit = 10});
  Stream<List<RecentSearch>> watchRecent({int limit = 10});
  Future<void> saveRecent(String query, SearchResult result);
}

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({
    required SearchProvider searchProvider,
    required Isar isar,
  })  : _searchProvider = searchProvider,
        _isar = isar;

  final SearchProvider _searchProvider;
  final Isar _isar;

  @override
  Future<List<SearchResult>> search(String query) async {
    try {
      return await _searchProvider.search(query);
    } catch (_) {
      return _offlineFallback(query);
    }
  }

  Future<List<SearchResult>> _offlineFallback(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return [];
    }
    final results = <SearchResult>[];
    final seen = <String>{};

    final recent = await getRecent(limit: 50);
    for (final entry in recent) {
      if (entry.query.toLowerCase().contains(normalized) ||
          entry.resultName.toLowerCase().contains(normalized)) {
        final key = '${entry.latitude},${entry.longitude}';
        if (seen.add(key)) {
          results.add(
            SearchResult(
              name: entry.resultName,
              latitude: entry.latitude,
              longitude: entry.longitude,
              address: entry.address,
            ),
          );
        }
      }
    }

    final favorites = await _isar.favorites.where().findAll();
    for (final fav in favorites) {
      if (fav.name.toLowerCase().contains(normalized) ||
          (fav.address?.toLowerCase().contains(normalized) ?? false)) {
        final key = '${fav.latitude},${fav.longitude}';
        if (seen.add(key)) {
          results.add(
            SearchResult(
              name: fav.name,
              latitude: fav.latitude,
              longitude: fav.longitude,
              address: fav.address,
            ),
          );
        }
      }
    }
    return results;
  }

  @override
  Future<SearchResult?> reverseGeocode(double latitude, double longitude) async {
    try {
      return await _searchProvider.reverseGeocode(latitude, longitude);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<RecentSearch>> getRecent({int limit = 10}) async {
    return _isar.recentSearchs
        .where()
        .sortBySearchedAtDesc()
        .limit(limit)
        .findAll();
  }

  @override
  Stream<List<RecentSearch>> watchRecent({int limit = 10}) {
    return _isar.recentSearchs
        .where()
        .sortBySearchedAtDesc()
        .limit(limit)
        .watch(fireImmediately: true);
  }

  @override
  Future<void> saveRecent(String query, SearchResult result) async {
    final entry = RecentSearch()
      ..query = query.isEmpty ? result.name : query
      ..resultName = result.name
      ..latitude = result.latitude
      ..longitude = result.longitude
      ..address = result.address
      ..searchedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.recentSearchs.put(entry);
    });

    final all = await _isar.recentSearchs.where().sortBySearchedAtDesc().findAll();
    if (all.length > 50) {
      final toDelete = all.skip(50).map((e) => e.id).toList();
      await _isar.writeTxn(() async {
        await _isar.recentSearchs.deleteAll(toDelete);
      });
    }
  }
}
