import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/multi_alarm_notification_formatter.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';

AlarmRuntimeState _state({
  required int id,
  required String name,
  required double distance,
  double? eta,
  AlarmStatus status = AlarmStatus.active,
}) {
  return AlarmRuntimeState(
    alarmId: id,
    destinationName: name,
    distanceMeters: distance,
    speedKmh: 30,
    accuracyMeters: 10,
    lastFixAt: DateTime.utc(2024, 6, 1, 12),
    isGpsLost: false,
    hasPassedDestination: false,
    status: status,
    etaMinutes: eta,
  );
}

void main() {
  test('formats single alarm notification', () {
    final content = formatMultiAlarmNotification([
      _state(id: 1, name: 'Noida', distance: 7600, eta: 12),
    ]);

    expect(content.title, 'Nomad Alarm');
    expect(content.content, contains('Noida'));
    expect(content.content, contains('7.6 km'));
  });

  test('formats multi-alarm notification with nearest label', () {
    final content = formatMultiAlarmNotification([
      _state(id: 1, name: 'Noida', distance: 7600, eta: 12),
      _state(id: 2, name: 'Delhi Airport', distance: 18000, eta: 24),
    ]);

    expect(content.content, contains('2 active alarms'));
    expect(content.content, contains('Nearest'));
    expect(content.content, contains('Noida'));
  });

  test('nearestActiveAlarmState picks closest active alarm', () {
    final nearest = nearestActiveAlarmState([
      _state(id: 1, name: 'Far', distance: 10000),
      _state(id: 2, name: 'Near', distance: 1000),
      _state(id: 3, name: 'Paused', distance: 100, status: AlarmStatus.paused),
    ]);

    expect(nearest?.alarmId, 2);
  });
}
