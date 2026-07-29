import 'package:nomad_alarm/models/enums.dart';

class MapService {
  const MapService();

  static const double defaultZoom = 14;
  static const double minZoom = 3;
  static const double maxZoom = 19;

  static const String standardTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const String satelliteTileUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  static const String darkTileUrl =
      'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}.png';

  static const String terrainTileUrl =
      'https://tile.opentopomap.org/{z}/{x}/{y}.png';

  /// OpenStreetMap raster tiles (standard layer).
  static const String tileUrlTemplate = standardTileUrl;

  static String tileUrlForLayer(MapLayerType layer) {
    return switch (layer) {
      MapLayerType.standard => standardTileUrl,
      MapLayerType.satellite => satelliteTileUrl,
      MapLayerType.dark => darkTileUrl,
      MapLayerType.terrain => terrainTileUrl,
    };
  }

  String get tileUrl => tileUrlTemplate;
}
