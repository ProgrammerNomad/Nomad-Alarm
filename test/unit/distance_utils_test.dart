import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';

void main() {
  test('haversineMeters returns zero for same point', () {
    const lat = 51.5074;
    const lon = -0.1278;
    expect(haversineMeters(lat, lon, lat, lon), closeTo(0, 0.1));
  });

  test('haversineMeters computes known distance', () {
    // Roughly 1 km north at London latitude
    const lat1 = 51.5074;
    const lon = -0.1278;
    const lat2 = 51.5164;
    final distance = haversineMeters(lat1, lon, lat2, lon);
    expect(distance, inInclusiveRange(900, 1100));
  });

  test('formatDistance shows meters below 1 km', () {
    expect(formatDistance(450), '450 m');
  });

  test('formatDistance shows km at or above 1 km', () {
    expect(formatDistance(1500), '1.5 km');
  });

  test('estimateEtaMinutes returns null when stationary', () {
    expect(estimateEtaMinutes(1000, 3), isNull);
    expect(estimateEtaMinutes(1000, 0), isNull);
  });

  test('estimateEtaMinutes computes from speed and distance', () {
    // 60 km/h = 16.67 m/s → 1000m ≈ 1 min
    final eta = estimateEtaMinutes(1000, 60);
    expect(eta, closeTo(1, 0.1));
  });

  test('formatEta shows dash when unknown', () {
    expect(formatEta(null), '-');
  });

  test('formatEta shows minutes', () {
    expect(formatEta(12), '~12 min');
    expect(formatEta(0.5), '< 1 min');
  });
}
