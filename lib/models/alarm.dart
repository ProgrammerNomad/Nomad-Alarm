import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/enums.dart';

part 'alarm.g.dart';

@collection
class Alarm {
  Id id = Isar.autoIncrement;

  late String name;
  late double destLatitude;
  late double destLongitude;
  String? address;
  String? placeId;

  @enumerated
  late AlarmType type;
  late double triggerDistanceMeters;
  double? radiusMeters;
  double? speedThresholdKmh;

  @enumerated
  late TravelMode travelMode;
  late bool repeat;
  DateTime? scheduledAt;
  late bool voiceEnabled;
  String? voiceMessage;
  late bool vibrationEnabled;
  late bool flashlightEnabled;
  String? ringtoneUri;

  @enumerated
  late AlarmStatus status;
  DateTime? startedAt;
  DateTime? triggeredAt;
  DateTime? completedAt;

  late DateTime createdAt;
  late DateTime updatedAt;

  int? sourcePlaceId;

  @enumerated
  AlarmCreatedBy createdBy = AlarmCreatedBy.manual;
}
