import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';

/// In-memory repo that mirrors create → draft, start → active behavior.
class _TrackingAlarmRepository implements AlarmRepository {
  Alarm? _alarm;

  final List<AlarmStatus> getRunningStatuses = [];

  @override
  Future<Alarm> create(AlarmDraft draft) async {
    _alarm = Alarm()
      ..id = 1
      ..name = draft.name
      ..destLatitude = draft.destLatitude
      ..destLongitude = draft.destLongitude
      ..type = draft.type
      ..triggerDistanceMeters = draft.triggerDistanceMeters
      ..travelMode = draft.travelMode
      ..repeat = false
      ..voiceEnabled = draft.voiceEnabled
      ..vibrationEnabled = draft.vibrationEnabled
      ..flashlightEnabled = draft.flashlightEnabled
      ..status = AlarmStatus.draft
      ..createdAt = DateTime.utc(2024, 1, 1)
      ..updatedAt = DateTime.utc(2024, 1, 1);
    return _alarm!;
  }

  @override
  Future<List<Alarm>> getRunning() async {
    getRunningStatuses.add(_alarm!.status);
    return _alarm!.status == AlarmStatus.active ||
            _alarm!.status == AlarmStatus.paused ||
            _alarm!.status == AlarmStatus.triggered
        ? [_alarm!]
        : [];
  }

  Future<void> startAlarm(int id) async {
    _alarm!
      ..status = AlarmStatus.active
      ..startedAt = DateTime.utc(2024, 1, 1);
  }

  @override
  Future<Alarm?> getById(int id) async => _alarm;

  @override
  Future<List<Alarm>> getAll() async => _alarm == null ? [] : [_alarm!];

  @override
  Future<List<Alarm>> getActive() async => [];

  @override
  Future<List<Alarm>> getDrafts() async {
    if (_alarm == null || _alarm!.status != AlarmStatus.draft) {
      return [];
    }
    return [_alarm!];
  }

  @override
  Future<void> update(Alarm alarm) async {
    _alarm = alarm;
  }

  @override
  Future<void> delete(int id) async {
    _alarm = null;
  }
}

AlarmDraft _sampleDraft() {
  return AlarmDraft.fromSearchResult(
    const SearchResult(
      name: 'Test Stop',
      latitude: 51.5074,
      longitude: -0.1278,
    ),
  );
}

void main() {
  test('broken order refetches running alarms while still draft', () async {
    final repo = _TrackingAlarmRepository();

    final alarm = await repo.create(_sampleDraft());
    final runningBeforeStart = await repo.getRunning();

    await repo.startAlarm(alarm.id);

    expect(runningBeforeStart, isEmpty);
    expect(repo.getRunningStatuses, [AlarmStatus.draft]);
  });

  test('fixed order refetches running alarms only after startAlarm', () async {
    final repo = _TrackingAlarmRepository();

    final alarm = await repo.create(_sampleDraft());
    await repo.startAlarm(alarm.id);
    final runningAfterStart = await repo.getRunning();

    expect(runningAfterStart, hasLength(1));
    expect(runningAfterStart.first.status, AlarmStatus.active);
    expect(repo.getRunningStatuses, [AlarmStatus.active]);
  });
}
