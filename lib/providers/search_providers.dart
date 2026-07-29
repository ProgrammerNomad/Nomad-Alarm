import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/repositories/search_repository.dart';
import 'package:nomad_alarm/services/isar_service.dart';
final searchRepositoryProvider = FutureProvider<SearchRepository>((ref) async {
  final isar = ref.watch(isarProvider);
  final searchProvider = await ref.watch(searchProviderProvider.future);
  return SearchRepositoryImpl(
    searchProvider: searchProvider,
    isar: isar,
  );
});

final recentSearchesProvider = StreamProvider<List<RecentSearch>>((ref) async* {
  final isarService = await ref.watch(isarServiceProvider.future);
  final searchProvider = await ref.watch(searchProviderProvider.future);
  final repository = SearchRepositoryImpl(
    searchProvider: searchProvider,
    isar: isarService.isar,
  );
  yield* repository.watchRecent(limit: 10);
});

class SearchController extends AsyncNotifier<List<SearchResult>> {
  Timer? _debounce;
  String _lastQuery = '';

  @override
  Future<List<SearchResult>> build() async {
    ref.onDispose(() => _debounce?.cancel());
    await ref.watch(isarServiceProvider.future);
    await ref.watch(searchRepositoryProvider.future);
    await ref.watch(searchProviderProvider.future);
    return [];
  }

  SearchRepository get _repo {
    return ref.read(searchRepositoryProvider).requireValue;
  }

  void search(String query) {
    _debounce?.cancel();
    _lastQuery = query;
    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() => _repo.search(query));
    });
  }

  Future<void> selectResult(SearchResult result) async {
    await _repo.saveRecent(_lastQuery, result);
  }

  SearchResult recentToResult(RecentSearch recent) {
    return SearchResult(
      name: recent.resultName,
      latitude: recent.latitude,
      longitude: recent.longitude,
      address: recent.address,
    );
  }
}

final searchControllerProvider =
    AsyncNotifierProvider<SearchController, List<SearchResult>>(
  SearchController.new,
);
