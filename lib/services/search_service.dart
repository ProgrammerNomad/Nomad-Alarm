import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/search/nominatim_search_provider.dart';
import 'package:nomad_alarm/providers/search/search_provider.dart';

/// Legacy wrapper - prefer [SearchProvider] via [ProviderFactory].
class SearchService implements SearchProvider {
  SearchService({NominatimSearchProvider? provider})
      : _provider = provider ?? NominatimSearchProvider();

  final NominatimSearchProvider _provider;

  @override
  SearchProviderType get type => _provider.type;

  @override
  Future<List<SearchResult>> search(String query) => _provider.search(query);

  @override
  Future<SearchResult?> reverseGeocode(double latitude, double longitude) =>
      _provider.reverseGeocode(latitude, longitude);

  @override
  void dispose() => _provider.dispose();
}
