import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/eta_predictor.dart';
import 'package:nomad_alarm/core/utils/polyline_utils.dart';
import 'package:nomad_alarm/core/utils/travel_mode_utils.dart';
import 'package:nomad_alarm/models/enums.dart';

void main() {
  group('TravelModeUtils', () {
    test('maps walking to OSRM foot profile', () {
      expect(TravelModeUtils.osrmProfile(TravelMode.walking), 'foot');
    });
  });

  group('PolylineUtils', () {
    test('parses semicolon-separated points', () {
      final points = PolylineUtils.parse('51.5,-0.1;51.51,-0.11');
      expect(points, hasLength(2));
      expect(points.first.latitude, 51.5);
    });
  });

  group('EtaPredictor', () {
    test('blends route and speed ETA when AI flag logic enabled via predictor', () {
      final predictor = EtaPredictor();
      for (var i = 0; i < 5; i++) {
        predictor.recordSpeed(60);
      }
      final eta = predictor.predict(
        distanceMeters: 6000,
        currentSpeedKmh: 60,
        routeEtaMinutes: 10,
      );
      expect(eta, isNotNull);
      expect(eta!, greaterThan(0));
    });
  });
}
