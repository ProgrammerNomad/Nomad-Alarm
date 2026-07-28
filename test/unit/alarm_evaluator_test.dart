// Unit tests for AlarmEvaluator (Phase 4).
//
// Manual device verification checklist:
// 1. Save & Start alarm → persistent tracking notification shows distance
// 2. Lock screen / home button → GPS continues 10+ min, notification updates
// 3. Enter trigger zone → full-screen ring + TTS (if voice enabled)
// 4. Pause/Cancel from notification action buttons works
// 5. Dismiss ring → alarm completed, notifications cleared

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/utils/alarm_evaluator.dart';
import 'package:nomad_alarm/models/alarm_monitor_config.dart';
import 'package:nomad_alarm/models/enums.dart';

Position _position({
  required double lat,
  required double lon,
  double speed = 10,
  DateTime? timestamp,
}) {
  return Position(
    latitude: lat,
    longitude: lon,
    timestamp: timestamp ?? DateTime.utc(2024, 6, 1, 12),
    accuracy: 15,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: speed,
    speedAccuracy: 0,
  );
}

AlarmMonitorConfig _config({
  double destLat = 51.5074,
  double destLon = -0.1278,
  double trigger = 500,
}) {
  return AlarmMonitorConfig(
    alarmId: 1,
    name: 'Test Stop',
    destLatitude: destLat,
    destLongitude: destLon,
    triggerDistanceMeters: trigger,
  );
}

void main() {
  late AlarmEvaluator evaluator;

  setUp(() {
    evaluator = AlarmEvaluator();
  });

  test('triggers when within threshold', () {
    final state = evaluator.evaluate(
      config: _config(trigger: 500),
      position: _position(lat: 51.5074, lon: -0.1278),
      currentStatus: AlarmStatus.active,
    );
    expect(state.status, AlarmStatus.triggered);
    expect(state.distanceMeters, lessThan(500));
  });

  test('stays active when outside threshold', () {
    final state = evaluator.evaluate(
      config: _config(trigger: 500),
      position: _position(lat: 51.52, lon: -0.1278),
      currentStatus: AlarmStatus.active,
    );
    expect(state.status, AlarmStatus.active);
    expect(state.distanceMeters, greaterThan(500));
  });

  test('does not trigger during snooze suppression', () {
    final now = DateTime.utc(2024, 6, 1, 12);
    final state = evaluator.evaluate(
      config: _config(trigger: 5000),
      position: _position(lat: 51.5074, lon: -0.1278, timestamp: now),
      currentStatus: AlarmStatus.active,
      snoozeSuppressedUntil: now.add(const Duration(minutes: 2)),
    );
    expect(state.status, AlarmStatus.active);
  });

  test('detects passed destination after consecutive increases', () {
    final config = _config(trigger: 50);
    final base = DateTime.utc(2024, 6, 1, 12);

    evaluator.evaluate(
      config: config,
      position: _position(lat: 51.5074, lon: -0.1278, timestamp: base),
      currentStatus: AlarmStatus.active,
    );
    evaluator.evaluate(
      config: config,
      position: _position(lat: 51.506, lon: -0.1278, timestamp: base.add(const Duration(seconds: 5))),
      currentStatus: AlarmStatus.active,
    );
    for (var i = 2; i <= 5; i++) {
      evaluator.evaluate(
        config: config,
        position: _position(
          lat: 51.506 + (i * 0.001),
          lon: -0.1278,
          timestamp: base.add(Duration(seconds: i * 5)),
        ),
        currentStatus: AlarmStatus.active,
      );
    }

    expect(evaluator.tracker.hasPassedDestination, isTrue);
  });

  test('reports GPS lost after threshold without fixes', () {
    final config = _config();
    final base = DateTime.utc(2024, 6, 1, 12);

    evaluator.evaluate(
      config: config,
      position: _position(lat: 51.52, lon: -0.1278, timestamp: base),
      currentStatus: AlarmStatus.active,
    );

    final stale = evaluator.evaluate(
      config: config,
      position: _position(
        lat: 51.52,
        lon: -0.1278,
        timestamp: base.add(const Duration(seconds: 120)),
      ),
      currentStatus: AlarmStatus.active,
    );

    expect(stale.isGpsLost, isTrue);
  });
}
