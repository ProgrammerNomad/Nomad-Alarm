import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/services/map_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test('map layer urls resolve for all layers', () {
    for (final layer in MapLayerType.values) {
      final url = MapService.tileUrlForLayer(layer);
      expect(url, isNotEmpty);
    }
  });
}
