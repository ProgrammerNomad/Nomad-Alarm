import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/map/map_provider.dart';
import 'package:nomad_alarm/services/map_service.dart';

class OsmMapProvider implements MapProvider {
  const OsmMapProvider({this.layer = MapLayerType.standard});

  final MapLayerType layer;

  static const _attribution = '© OpenStreetMap contributors';

  @override
  MapProviderType get type => MapProviderType.osm;

  @override
  MapDisplayMode get displayMode => MapDisplayMode.flutterMap;

  @override
  MapTileConfig? get tileConfig => MapTileConfig(
        urlTemplate: MapService.tileUrlForLayer(layer),
        attribution: _attribution,
        minZoom: MapService.minZoom,
        maxZoom: MapService.maxZoom,
        defaultZoom: MapService.defaultZoom,
      );

  @override
  String get attribution => _attribution;
}
