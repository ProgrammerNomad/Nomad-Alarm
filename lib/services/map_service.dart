class MapService {
  const MapService();

  /// OpenStreetMap raster tiles (standard layer).
  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const double defaultZoom = 14;
  static const double minZoom = 3;
  static const double maxZoom = 19;

  String get tileUrl => tileUrlTemplate;
}
