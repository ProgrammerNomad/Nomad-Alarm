import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/repositories/search_repository.dart';
import 'package:nomad_alarm/services/search_service.dart';

class FakeSearchService extends SearchService {
  FakeSearchService(this._results);

  final List<SearchResult> _results;

  @override
  Future<List<SearchResult>> search(String query) async {
    return _results.where((r) => r.name.contains(query)).toList();
  }
}

void main() {
  late Isar isar;
  late Directory tempDir;
  late SearchRepository repository;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('nomad_alarm_search_test');
    isar = await Isar.open(
      [RecentSearchSchema],
      directory: tempDir.path,
      name: 'search_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    repository = SearchRepositoryImpl(
      searchService: FakeSearchService([
        const SearchResult(
          name: 'London',
          latitude: 51.5074,
          longitude: -0.1278,
          address: 'London, UK',
        ),
      ]),
      isar: isar,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('search returns filtered results', () async {
    final results = await repository.search('London');
    expect(results, hasLength(1));
    expect(results.first.name, 'London');
  });

  test('saveRecent persists and returns in getRecent', () async {
    const result = SearchResult(
      name: 'London',
      latitude: 51.5074,
      longitude: -0.1278,
      address: 'London, UK',
    );
    await repository.saveRecent('London', result);

    final recent = await repository.getRecent();
    expect(recent, hasLength(1));
    expect(recent.first.resultName, 'London');
    expect(recent.first.query, 'London');
  });
}
