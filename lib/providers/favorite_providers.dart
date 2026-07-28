import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/repositories/favorite_repository.dart';
import 'package:nomad_alarm/services/isar_service.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return FavoriteRepositoryImpl(isar);
});

final favoritesProvider = StreamProvider<List<Favorite>>((ref) async* {
  final isarService = await ref.watch(isarServiceProvider.future);
  yield* FavoriteRepositoryImpl(isarService.isar).watchAll();
});
