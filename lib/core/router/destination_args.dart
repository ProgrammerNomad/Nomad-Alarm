import 'package:nomad_alarm/models/search_result.dart';

/// Destination passed between Search/Map and Alarm Config.
class DestinationArgs {
  const DestinationArgs({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeId,
  });

  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final String? placeId;

  SearchResult toSearchResult() {
    return SearchResult(
      name: name,
      latitude: latitude,
      longitude: longitude,
      address: address,
      placeId: placeId,
    );
  }

  factory DestinationArgs.fromSearchResult(SearchResult result) {
    return DestinationArgs(
      name: result.name,
      latitude: result.latitude,
      longitude: result.longitude,
      address: result.address,
      placeId: result.placeId,
    );
  }
}
