import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/history_entry.dart';

sealed class HistoryListItem {
  const HistoryListItem();
}

class ActiveHistoryItem extends HistoryListItem {
  const ActiveHistoryItem(this.alarm);

  final Alarm alarm;
}

class DraftHistoryItem extends HistoryListItem {
  const DraftHistoryItem(this.alarm);

  final Alarm alarm;
}

class PastHistoryItem extends HistoryListItem {
  const PastHistoryItem(this.entry);

  final HistoryEntry entry;
}

List<Alarm> sortActiveAlarms(
  List<Alarm> alarms, {
  double Function(Alarm alarm)? distanceFor,
}) {
  final sorted = [...alarms];
  sorted.sort((a, b) {
    final statusOrder =
        _statusSortOrder(a.status).compareTo(_statusSortOrder(b.status));
    if (statusOrder != 0) {
      return statusOrder;
    }
    if (distanceFor != null) {
      return distanceFor(a).compareTo(distanceFor(b));
    }
    final aStarted = a.startedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bStarted = b.startedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bStarted.compareTo(aStarted);
  });
  return sorted;
}

List<Alarm> sortDraftAlarms(List<Alarm> alarms) {
  final sorted = [...alarms];
  sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return sorted;
}

int _statusSortOrder(AlarmStatus status) {
  return switch (status) {
    AlarmStatus.active => 0,
    AlarmStatus.triggered => 1,
    AlarmStatus.paused => 2,
    _ => 3,
  };
}

List<HistoryListItem> mergeUnifiedHistory({
  required List<Alarm> activeAlarms,
  required List<Alarm> draftAlarms,
  required List<HistoryEntry> pastEntries,
  double Function(Alarm alarm)? distanceFor,
}) {
  final sortedActive = sortActiveAlarms(activeAlarms, distanceFor: distanceFor);
  final sortedDrafts = sortDraftAlarms(draftAlarms);
  return [
    ...sortedActive.map(ActiveHistoryItem.new),
    ...sortedDrafts.map(DraftHistoryItem.new),
    ...pastEntries.map(PastHistoryItem.new),
  ];
}
