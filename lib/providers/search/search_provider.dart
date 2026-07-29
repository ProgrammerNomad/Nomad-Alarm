import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/search_result.dart';

abstract class SearchProvider {
  SearchProviderType get type;

  Future<List<SearchResult>> search(String query);

  Future<SearchResult?> reverseGeocode(double latitude, double longitude);

  void dispose() {}
}
