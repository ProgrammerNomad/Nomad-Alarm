import 'package:nomad_alarm/models/enums.dart';

enum MapDisplayMode { flutterMap, googleNative, appleNative }

class MapTileConfig {
  const MapTileConfig({
    required this.urlTemplate,
    required this.attribution,
    this.minZoom = 3,
    this.maxZoom = 19,
    this.defaultZoom = 14,
    this.additionalOptions = const {},
    this.tileProviderKey,
  });

  static const double defaultMinZoom = 3;
  static const double defaultMaxZoom = 19;
  static const double defaultDefaultZoom = 14;

  final String urlTemplate;
  final String attribution;
  final double minZoom;
  final double maxZoom;
  final double defaultZoom;
  final Map<String, String> additionalOptions;
  final String? tileProviderKey;
}

abstract class MapProvider {
  MapProviderType get type;
  MapDisplayMode get displayMode;
  MapTileConfig? get tileConfig;
  String get attribution;
}
