import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/enums.dart';

part 'trip.g.dart';

@collection
class Trip {
  Id id = Isar.autoIncrement;

  late int alarmId;
  late String destinationName;
  late double destLatitude;
  late double destLongitude;

  late DateTime startedAt;
  DateTime? endedAt;

  double? totalDistanceMeters;
  int? durationSeconds;
  double? maxSpeedKmh;
  double? avgSpeedKmh;

  @enumerated
  late TripOutcome outcome;

  String? routePolyline;
}
