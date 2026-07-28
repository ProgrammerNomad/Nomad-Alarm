import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/models/trip.dart';
import 'package:nomad_alarm/repositories/history_repository.dart';
import 'package:nomad_alarm/repositories/trip_repository.dart';
import 'package:nomad_alarm/services/isar_service.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(ref.watch(isarProvider));
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepositoryImpl(ref.watch(isarProvider));
});

final historyEntriesProvider = StreamProvider<List<HistoryEntry>>((ref) async* {
  await ref.watch(isarServiceProvider.future);
  yield* ref.watch(historyRepositoryProvider).watchAll();
});

final historyEntriesByTypeProvider =
    StreamProvider.family<List<HistoryEntry>, HistoryFilter>((ref, filter) async* {
  await ref.watch(isarServiceProvider.future);
  final repo = ref.watch(historyRepositoryProvider);
  if (filter == HistoryFilter.all) {
    yield* repo.watchAll();
  } else {
    yield* repo.watchAll(type: filter.historyType);
  }
});

enum HistoryFilter {
  all,
  completed,
  missed,
}

extension on HistoryFilter {
  HistoryType? get historyType {
    switch (this) {
      case HistoryFilter.all:
        return null;
      case HistoryFilter.completed:
        return HistoryType.completed;
      case HistoryFilter.missed:
        return HistoryType.missed;
    }
  }
}

final tripsProvider = StreamProvider<List<Trip>>((ref) async* {
  await ref.watch(isarServiceProvider.future);
  yield* ref.watch(tripRepositoryProvider).watchAll();
});
