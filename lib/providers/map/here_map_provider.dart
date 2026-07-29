import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/map/map_provider.dart';
import 'package:nomad_alarm/services/map_service.dart';

class HereMapProvider implements MapProvider {
  HereMapProvider({required this.apiKey});

  static const _attribution = '© HERE';
  static const _tileUrl =
      'https://maps.hereapi.com/v3/base/mc/{z}/{x}/{y}/png?apiKey={apiKey}';

  final String apiKey;

  @override
  MapProviderType get type => MapProviderType.here;

  @override
  MapDisplayMode get displayMode => MapDisplayMode.flutterMap;

  @override
  MapTileConfig? get tileConfig => MapTileConfig(
        urlTemplate: _tileUrl,
        attribution: _attribution,
        minZoom: MapService.minZoom,
        maxZoom: MapService.maxZoom,
        defaultZoom: MapService.defaultZoom,
        additionalOptions: {'apiKey': apiKey},
        tileProviderKey: 'here',
      );

  @override
  String get attribution => _attribution;
}
