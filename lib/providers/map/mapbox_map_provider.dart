import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/map/map_provider.dart';
import 'package:nomad_alarm/services/map_service.dart';

class MapboxMapProvider implements MapProvider {
  MapboxMapProvider({
    required this.accessToken,
    this.layer = MapLayerType.standard,
  });

  static const _attribution = '© Mapbox © OpenStreetMap';

  final String accessToken;
  final MapLayerType layer;

  String get _stylePath => switch (layer) {
        MapLayerType.satellite => 'mapbox/satellite-v9',
        MapLayerType.dark => 'mapbox/dark-v11',
        MapLayerType.terrain => 'mapbox/outdoors-v12',
        MapLayerType.standard => 'mapbox/streets-v12',
      };

  @override
  MapProviderType get type => MapProviderType.mapbox;

  @override
  MapDisplayMode get displayMode => MapDisplayMode.flutterMap;

  @override
  MapTileConfig? get tileConfig => MapTileConfig(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/$_stylePath/tiles/{z}/{x}/{y}?access_token={access_token}',
        attribution: _attribution,
        minZoom: MapService.minZoom,
        maxZoom: MapService.maxZoom,
        defaultZoom: MapService.defaultZoom,
        additionalOptions: {'access_token': accessToken},
        tileProviderKey: 'mapbox',
      );

  @override
  String get attribution => _attribution;
}
