import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/alarm_evaluator.dart';
import 'package:nomad_alarm/core/utils/deep_link_parser.dart';
import 'package:nomad_alarm/models/alarm_monitor_config.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:geolocator/geolocator.dart';

Position _pos({required double lat, required double lon, double speed = 0}) {
  return Position(
    latitude: lat,
    longitude: lon,
    timestamp: DateTime.utc(2024, 6, 1, 12),
    accuracy: 10,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: speed,
    speedAccuracy: 0,
  );
}

void main() {
  test('geofence triggers inside radius', () {
    final evaluator = AlarmEvaluator();
    final config = const AlarmMonitorConfig(
      alarmId: 1,
      name: 'Test',
      destLatitude: 51.5074,
      destLongitude: -0.1278,
      triggerDistanceMeters: 500,
      alarmType: AlarmType.geofence,
      radiusMeters: 1000,
    );
    final state = evaluator.evaluate(
      config: config,
      position: _pos(lat: 51.5074, lon: -0.1278),
      currentStatus: AlarmStatus.active,
    );
    expect(state.status, AlarmStatus.triggered);
  });

  test('parses plus code pattern', () {
    final result = DeepLinkParser.parse('9C3W+Q8 London');
    expect(result, isNotNull);
    expect(result!.name, contains('London'));
  });
}
