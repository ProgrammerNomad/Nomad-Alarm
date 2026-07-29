import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/providers/route/route_provider.dart';
import 'package:latlong2/latlong.dart';

void main() {
  test('storablePolyline prefers encoded polyline', () {
    const result = RouteResult(
      distanceMeters: 100,
      durationSeconds: 60,
      encodedPolyline: 'abc123',
      points: [LatLng(1, 2)],
    );
    expect(result.storablePolyline, 'abc123');
  });

  test('storablePolyline serializes points when no encoding', () {
    const result = RouteResult(
      distanceMeters: 100,
      durationSeconds: 60,
      points: [LatLng(51.5, -0.1), LatLng(51.51, -0.11)],
    );
    expect(result.storablePolyline, '51.5,-0.1;51.51,-0.11');
  });
}
