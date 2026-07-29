import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/map/map_provider.dart';

class GoogleMapProvider implements MapProvider {
  const GoogleMapProvider();

  static const _attribution = '© Google';

  @override
  MapProviderType get type => MapProviderType.google;

  @override
  MapDisplayMode get displayMode => MapDisplayMode.googleNative;

  @override
  MapTileConfig? get tileConfig => null;

  @override
  String get attribution => _attribution;
}
