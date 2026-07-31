import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/history/history_list_item.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/history_entry.dart';

void main() {
  test('mergeUnifiedHistory lists active before past entries', () {
    final active = Alarm()
      ..id = 1
      ..name = 'Active'
      ..destLatitude = 1
      ..destLongitude = 2
      ..status = AlarmStatus.active
      ..startedAt = DateTime(2026, 1, 20);
    final past = HistoryEntry()
      ..id = 10
      ..destinationName = 'Past'
      ..destLatitude = 3
      ..destLongitude = 4
      ..type = HistoryType.completed
      ..occurredAt = DateTime(2026, 1, 10);

    final merged = mergeUnifiedHistory(
      activeAlarms: [active],
      draftAlarms: const [],
      pastEntries: [past],
    );

    expect(merged, hasLength(2));
    expect(merged.first, isA<ActiveHistoryItem>());
    expect((merged.first as ActiveHistoryItem).alarm.name, 'Active');
    expect(merged.last, isA<PastHistoryItem>());
  });
}
