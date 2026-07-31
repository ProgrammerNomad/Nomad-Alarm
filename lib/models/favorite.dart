import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/enums.dart';

part 'favorite.g.dart';

@collection
class Favorite {
  Id id = Isar.autoIncrement;

  late String name;

  @enumerated
  late FavoriteCategory category;

  late double latitude;
  late double longitude;
  String? address;
  String? icon;
  int? linkedTripId;
  String? routePolyline;
  String? providerPlaceId;

  late bool isFavorite = true;
  @enumerated
  SmartAlarmMode smartAlarmMode = SmartAlarmMode.off;
  late double triggerDistanceMeters = 500;

  int autoStartedCount = 0;
  DateTime? lastUsedAt;
  DateTime? lastAutoCreatedAt;
  DateTime? lastDismissedAt;

  int priority = 0;
  double predictionAccuracy = 0.5;
  int falsePredictionCount = 0;

  late DateTime createdAt;
  int sortOrder = 0;

  static Favorite createDefaults({
    required String name,
    required double latitude,
    required double longitude,
    FavoriteCategory category = FavoriteCategory.custom,
    String? address,
  }) {
    return Favorite()
      ..name = name
      ..latitude = latitude
      ..longitude = longitude
      ..address = address
      ..category = category
      ..isFavorite = true
      ..smartAlarmMode = SmartAlarmMode.off
      ..triggerDistanceMeters = 500
      ..autoStartedCount = 0
      ..priority = 0
      ..predictionAccuracy = 0.5
      ..falsePredictionCount = 0
      ..createdAt = DateTime.now()
      ..sortOrder = DateTime.now().millisecondsSinceEpoch;
  }
}
