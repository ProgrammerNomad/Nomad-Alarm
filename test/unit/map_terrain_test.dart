import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/services/map_service.dart';
import 'package:nomad_alarm/models/enums.dart';

void main() {
  test('terrain layer returns opentopomap url', () {
    final url = MapService.tileUrlForLayer(MapLayerType.terrain);
    expect(url, contains('opentopomap'));
  });
}
