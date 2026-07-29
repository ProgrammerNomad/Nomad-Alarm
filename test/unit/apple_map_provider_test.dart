import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/providers/map/apple_map_provider.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/map/map_provider.dart';

void main() {
  test('AppleMapProvider uses apple native display', () {
    const provider = AppleMapProvider();
    expect(provider.type, MapProviderType.apple);
    expect(provider.displayMode, MapDisplayMode.appleNative);
    expect(provider.tileConfig, isNull);
    expect(provider.attribution, isNotEmpty);
  });
}
