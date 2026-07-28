import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/enums.dart';

part 'history_entry.g.dart';

@collection
class HistoryEntry {
  Id id = Isar.autoIncrement;

  int? alarmId;
  int? tripId;

  late String destinationName;
  late double destLatitude;
  late double destLongitude;

  @enumerated
  late HistoryType type;

  late DateTime occurredAt;
  double? triggerDistanceMeters;
  int? snoozeCount;
  String? notes;
}
