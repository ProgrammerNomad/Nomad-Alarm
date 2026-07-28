import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/models/log_entry.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/models/trip.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  IsarService(this._isar);

  final Isar _isar;

  Isar get isar => _isar;

  static Future<IsarService> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        AlarmSchema,
        TripSchema,
        FavoriteSchema,
        HistoryEntrySchema,
        AppSettingsSchema,
        RecentSearchSchema,
        LogEntrySchema,
      ],
      directory: dir.path,
      name: 'nomad_alarm',
    );
    return IsarService(isar);
  }

  Future<void> close() async {
    await _isar.close();
  }
}

final isarServiceProvider = FutureProvider<IsarService>((ref) async {
  final service = await IsarService.open();
  ref.onDispose(() => service.close());
  return service;
});

final isarProvider = Provider<Isar>((ref) {
  final service = ref.watch(isarServiceProvider).requireValue;
  return service.isar;
});
