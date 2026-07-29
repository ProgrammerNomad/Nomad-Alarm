import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/map/map_provider.dart';

class AppleMapProvider implements MapProvider {
  const AppleMapProvider();

  static const _attribution = '© Apple';

  @override
  MapProviderType get type => MapProviderType.apple;

  @override
  MapDisplayMode get displayMode => MapDisplayMode.appleNative;

  @override
  MapTileConfig? get tileConfig => null;

  @override
  String get attribution => _attribution;
}
