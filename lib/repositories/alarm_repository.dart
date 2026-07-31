import 'package:isar/isar.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/search_result.dart';

class AlarmDraft {
  const AlarmDraft({
    required this.name,
    required this.destLatitude,
    required this.destLongitude,
    this.address,
    this.placeId,
    this.triggerDistanceMeters = 500,
    this.travelMode = TravelMode.autoDetect,
    this.type = AlarmType.distance,
    this.speedThresholdKmh,
    this.voiceEnabled = true,
    this.vibrationEnabled = true,
    this.flashlightEnabled = false,
    this.ringtoneUri,
    this.notes,
    this.sourcePlaceId,
    this.createdBy = AlarmCreatedBy.manual,
  });

  final String name;
  final double destLatitude;
  final double destLongitude;
  final String? address;
  final String? placeId;
  final double triggerDistanceMeters;
  final TravelMode travelMode;
  final AlarmType type;
  final double? speedThresholdKmh;
  final bool voiceEnabled;
  final bool vibrationEnabled;
  final bool flashlightEnabled;
  final String? ringtoneUri;
  final String? notes;
  final int? sourcePlaceId;
  final AlarmCreatedBy createdBy;

  factory AlarmDraft.fromSearchResult(
    SearchResult result, {
    double triggerDistanceMeters = 500,
    bool voiceEnabled = true,
    bool vibrationEnabled = true,
    bool flashlightEnabled = false,
  }) {
    return AlarmDraft(
      name: result.name,
      destLatitude: result.latitude,
      destLongitude: result.longitude,
      address: result.address,
      placeId: result.placeId,
      triggerDistanceMeters: triggerDistanceMeters,
      voiceEnabled: voiceEnabled,
      vibrationEnabled: vibrationEnabled,
      flashlightEnabled: flashlightEnabled,
    );
  }
}

abstract class AlarmRepository {
  Future<Alarm> create(AlarmDraft draft);
  Future<Alarm?> getById(int id);
  Future<List<Alarm>> getAll();
  Future<List<Alarm>> getActive();
  Future<List<Alarm>> getRunning();
  Future<List<Alarm>> getDrafts();
  Future<void> update(Alarm alarm);
  Future<void> delete(int id);
}

class AlarmRepositoryImpl implements AlarmRepository {
  AlarmRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Future<Alarm> create(AlarmDraft draft) async {
    final now = DateTime.now();
    final alarm = Alarm()
      ..name = draft.name
      ..destLatitude = draft.destLatitude
      ..destLongitude = draft.destLongitude
      ..address = draft.address
      ..placeId = draft.placeId
      ..type = draft.type
      ..triggerDistanceMeters = draft.triggerDistanceMeters
      ..speedThresholdKmh = draft.speedThresholdKmh
      ..travelMode = draft.travelMode
      ..repeat = false
      ..voiceEnabled = draft.voiceEnabled
      ..vibrationEnabled = draft.vibrationEnabled
      ..flashlightEnabled = draft.flashlightEnabled
      ..ringtoneUri = draft.ringtoneUri
      ..status = AlarmStatus.draft
      ..sourcePlaceId = draft.sourcePlaceId
      ..createdBy = draft.createdBy
      ..createdAt = now
      ..updatedAt = now;

    await _isar.writeTxn(() async {
      await _isar.alarms.put(alarm);
    });
    return alarm;
  }

  @override
  Future<Alarm?> getById(int id) => _isar.alarms.get(id);

  @override
  Future<List<Alarm>> getAll() async {
    return _isar.alarms.where().sortByCreatedAtDesc().findAll();
  }

  @override
  Future<List<Alarm>> getActive() async {
    return _isar.alarms
        .filter()
        .statusEqualTo(AlarmStatus.active)
        .findAll();
  }

  @override
  Future<List<Alarm>> getRunning() async {
    final all = await getAll();
    return all
        .where(
          (a) =>
              a.status == AlarmStatus.active ||
              a.status == AlarmStatus.paused ||
              a.status == AlarmStatus.triggered,
        )
        .toList();
  }

  @override
  Future<List<Alarm>> getDrafts() async {
    final all = await getAll();
    return all.where((a) => a.status == AlarmStatus.draft).toList();
  }

  @override
  Future<void> update(Alarm alarm) async {
    try {
      alarm.updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.alarms.put(alarm);
      });
    } catch (e) {
      throw StorageException(
        'Unable to save alarm.',
        debugMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.alarms.delete(id);
    });
  }
}
