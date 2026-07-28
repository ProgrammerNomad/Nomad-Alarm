import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/services/search_service.dart';

abstract class SearchRepository {
  Future<List<SearchResult>> search(String query);
  Future<SearchResult?> reverseGeocode(double latitude, double longitude);
  Future<List<RecentSearch>> getRecent({int limit = 10});
  Stream<List<RecentSearch>> watchRecent({int limit = 10});
  Future<void> saveRecent(String query, SearchResult result);
}

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({
    required SearchService searchService,
    required Isar isar,
  })  : _searchService = searchService,
        _isar = isar;

  final SearchService _searchService;
  final Isar _isar;

  @override
  Future<List<SearchResult>> search(String query) =>
      _searchService.search(query);

  @override
  Future<SearchResult?> reverseGeocode(double latitude, double longitude) =>
      _searchService.reverseGeocode(latitude, longitude);

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
