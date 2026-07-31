import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nomad_alarm/features/history/history_list_item.dart';

import 'package:nomad_alarm/models/enums.dart';

import 'package:nomad_alarm/models/history_entry.dart';

import 'package:nomad_alarm/models/trip.dart';

import 'package:nomad_alarm/providers/alarm_providers.dart';

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

  final historyType = filter.historyType;

  if (historyType == null) {

    yield* repo.watchAll();

  } else {

    yield* repo.watchAll(type: historyType);

  }

});



enum HistoryFilter {

  all,

  active,

  saved,

  completed,

  missed,

  dismissed,

  snoozed,

}



extension HistoryFilterQuery on HistoryFilter {

  static HistoryFilter? fromQueryParameter(String? value) {

    return switch (value) {

      'active' => HistoryFilter.active,

      'saved' => HistoryFilter.saved,

      'completed' => HistoryFilter.completed,

      'missed' => HistoryFilter.missed,

      'dismissed' || 'cancelled' => HistoryFilter.dismissed,

      'snoozed' => HistoryFilter.snoozed,

      'all' => HistoryFilter.all,

      _ => null,

    };

  }



  HistoryType? get historyType {

    switch (this) {

      case HistoryFilter.all:

      case HistoryFilter.active:

      case HistoryFilter.saved:

        return null;

      case HistoryFilter.completed:

        return HistoryType.completed;

      case HistoryFilter.missed:

        return HistoryType.missed;

      case HistoryFilter.dismissed:

        return HistoryType.dismissed;

      case HistoryFilter.snoozed:

        return HistoryType.snoozed;

    }

  }



  bool get includesActiveAlarms =>

      this == HistoryFilter.all || this == HistoryFilter.active;



  bool get includesDraftAlarms =>

      this == HistoryFilter.all || this == HistoryFilter.saved;

}



final unifiedHistoryProvider =

    Provider.family<AsyncValue<List<HistoryListItem>>, HistoryFilter>((ref, filter) {

  if (filter == HistoryFilter.active) {

    return ref.watch(activeAlarmsProvider).when(

          data: (alarms) => AsyncValue.data(

            sortActiveAlarms(alarms).map(ActiveHistoryItem.new).toList(),

          ),

          loading: () => const AsyncValue.loading(),

          error: (error, stackTrace) => AsyncValue.error(error, stackTrace),

        );

  }



  if (filter == HistoryFilter.saved) {

    return ref.watch(draftAlarmsProvider).when(

          data: (drafts) => AsyncValue.data(

            sortDraftAlarms(drafts).map(DraftHistoryItem.new).toList(),

          ),

          loading: () => const AsyncValue.loading(),

          error: (error, stackTrace) => AsyncValue.error(error, stackTrace),

        );

  }



  if (filter.includesActiveAlarms || filter.includesDraftAlarms) {

    final activeAsync = ref.watch(activeAlarmsProvider);

    final draftAsync = ref.watch(draftAlarmsProvider);

    final pastAsync = ref.watch(historyEntriesProvider);



    if (activeAsync.isLoading || draftAsync.isLoading || pastAsync.isLoading) {

      return const AsyncValue.loading();

    }

    if (activeAsync.hasError) {

      return AsyncValue.error(

        activeAsync.error!,

        activeAsync.stackTrace ?? StackTrace.empty,

      );

    }

    if (draftAsync.hasError) {

      return AsyncValue.error(

        draftAsync.error!,

        draftAsync.stackTrace ?? StackTrace.empty,

      );

    }

    if (pastAsync.hasError) {

      return AsyncValue.error(

        pastAsync.error!,

        pastAsync.stackTrace ?? StackTrace.empty,

      );

    }



    return AsyncValue.data(

      mergeUnifiedHistory(

        activeAlarms: activeAsync.value ?? [],

        draftAlarms: draftAsync.value ?? [],

        pastEntries: pastAsync.value ?? [],

      ),

    );

  }



  return ref.watch(historyEntriesByTypeProvider(filter)).when(

        data: (entries) =>

            AsyncValue.data(entries.map(PastHistoryItem.new).toList()),

        loading: () => const AsyncValue.loading(),

        error: (error, stackTrace) => AsyncValue.error(error, stackTrace),

      );

});



final tripsProvider = StreamProvider<List<Trip>>((ref) async* {

  await ref.watch(isarServiceProvider.future);

  yield* ref.watch(tripRepositoryProvider).watchAll();

});


