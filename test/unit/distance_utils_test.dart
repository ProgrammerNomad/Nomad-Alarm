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
}
