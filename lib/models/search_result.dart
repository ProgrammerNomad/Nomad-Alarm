class SearchResult {
  const SearchResult({
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

  String get displayAddress => address ?? name;
}
