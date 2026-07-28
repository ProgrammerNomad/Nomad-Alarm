import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test('distance and ETA helpers smoke test', () {
    final distance = haversineMeters(51.5074, -0.1278, 51.52, -0.1278);
    expect(distance, greaterThan(0));

    final eta = estimateEtaMinutes(1000, 60);
    expect(eta, isNotNull);
    expect(formatEta(eta), contains('min'));
  });
}
