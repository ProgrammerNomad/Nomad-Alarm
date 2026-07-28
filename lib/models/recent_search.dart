import 'package:isar/isar.dart';

part 'recent_search.g.dart';

@collection
class RecentSearch {
  Id id = Isar.autoIncrement;

  late String query;
  late String resultName;
  late double latitude;
  late double longitude;
  String? address;

  late DateTime searchedAt;
}
