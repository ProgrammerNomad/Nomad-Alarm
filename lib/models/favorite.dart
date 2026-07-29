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

  late DateTime createdAt;
  int sortOrder = 0;
}
