import 'package:isar/isar.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/history_entry.dart';

abstract class HistoryRepository {
  Future<HistoryEntry> log({
    required Alarm alarm,
    required HistoryType type,
    int? tripId,
    int? snoozeCount,
    String? notes,
  });

  Future<List<HistoryEntry>> getAll({HistoryType? type});
  Stream<List<HistoryEntry>> watchAll({HistoryType? type});
  Future<void> delete(int id);
  Future<void> deleteAll();
}

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Future<HistoryEntry> log({
    required Alarm alarm,
    required HistoryType type,
    int? tripId,
    int? snoozeCount,
    String? notes,
  }) async {
    final entry = HistoryEntry()
      ..alarmId = alarm.id
      ..tripId = tripId
      ..destinationName = alarm.name
      ..destLatitude = alarm.destLatitude
      ..destLongitude = alarm.destLongitude
      ..type = type
      ..occurredAt = DateTime.now()
      ..triggerDistanceMeters = alarm.triggerDistanceMeters
      ..snoozeCount = snoozeCount
      ..notes = notes
      ..sourcePlaceId = alarm.sourcePlaceId
      ..createdBy = alarm.createdBy;

    try {
      await _isar.writeTxn(() async {
        await _isar.historyEntrys.put(entry);
      });
    } catch (e) {
      throw StorageException(
        'Unable to save history entry.',
        debugMessage: e.toString(),
      );
    }
    return entry;
  }

  @override
  Future<List<HistoryEntry>> getAll({HistoryType? type}) async {
    if (type == null) {
      return _isar.historyEntrys.where().sortByOccurredAtDesc().findAll();
    }
    return _isar.historyEntrys
        .filter()
        .typeEqualTo(type)
        .sortByOccurredAtDesc()
        .findAll();
  }

  @override
  Stream<List<HistoryEntry>> watchAll({HistoryType? type}) {
    if (type == null) {
      return _isar.historyEntrys
          .where()
          .sortByOccurredAtDesc()
          .watch(fireImmediately: true);
    }
    return _isar.historyEntrys
        .filter()
        .typeEqualTo(type)
        .sortByOccurredAtDesc()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.historyEntrys.delete(id);
    });
  }

  @override
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.historyEntrys.clear();
    });
  }
}
