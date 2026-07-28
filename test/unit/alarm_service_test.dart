import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/repositories/history_repository.dart';
import 'package:nomad_alarm/repositories/trip_repository.dart';
import 'package:nomad_alarm/services/alarm_service.dart';
import 'package:nomad_alarm/services/battery_monitor_service.dart';
import 'package:nomad_alarm/services/flashlight_service.dart';
import 'package:nomad_alarm/services/notification_service.dart';
import 'package:nomad_alarm/services/speech_service.dart';

class MockAlarmRepository extends Mock implements AlarmRepository {}

class MockTripRepository extends Mock implements TripRepository {}

class MockHistoryRepository extends Mock implements HistoryRepository {}

class MockNotificationService extends Mock implements NotificationService {}

class MockSpeechService extends Mock implements SpeechService {}

Position _position({
  required double lat,
  required double lon,
  double speed = 10,
}) {
  return Position(
    latitude: lat,
    longitude: lon,
    timestamp: DateTime.utc(2024, 6, 1, 12),
    accuracy: 15,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: speed,
    speedAccuracy: 0,
  );
}

Alarm _alarm({
  double destLat = 51.5074,
  double destLon = -0.1278,
  double trigger = 500,
}) {
  return Alarm()
    ..id = 1
    ..name = 'Test Stop'
    ..destLatitude = destLat
    ..destLongitude = destLon
    ..type = AlarmType.distance
    ..triggerDistanceMeters = trigger
    ..travelMode = TravelMode.train
    ..repeat = false
    ..voiceEnabled = true
    ..vibrationEnabled = true
    ..flashlightEnabled = false
    ..status = AlarmStatus.active
    ..createdAt = DateTime.utc(2024, 1, 1)
    ..updatedAt = DateTime.utc(2024, 1, 1);
}

void main() {
  late MockAlarmRepository repository;
  late MockTripRepository tripRepository;
  late MockHistoryRepository historyRepository;
  late MockNotificationService notificationService;
  late MockSpeechService speechService;
  late AlarmService service;

  setUpAll(() {
    registerFallbackValue(_alarm());
    registerFallbackValue(
      AlarmRuntimeState(
        alarmId: 1,
        destinationName: 'Test',
        distanceMeters: 0,
        speedKmh: 0,
        accuracyMeters: 0,
        lastFixAt: DateTime.utc(2024, 1, 1),
        isGpsLost: false,
        hasPassedDestination: false,
        status: AlarmStatus.active,
      ),
    );
  });

  setUp(() {
    repository = MockAlarmRepository();
    tripRepository = MockTripRepository();
    historyRepository = MockHistoryRepository();
    notificationService = MockNotificationService();
    speechService = MockSpeechService();
    service = AlarmService(
      alarmRepository: repository,
      tripRepository: tripRepository,
      historyRepository: historyRepository,
      notificationService: notificationService,
      speechService: speechService,
      flashlightService: FlashlightService(),
      batteryMonitorService: BatteryMonitorService(),
    );

    when(() => notificationService.cancelAll()).thenAnswer((_) async {});
    when(() => notificationService.cancelAlarmNotification())
        .thenAnswer((_) async {});
    when(() => notificationService.showTrackingNotification(any()))
        .thenAnswer((_) async {});
    when(() => notificationService.updateTrackingNotification(any()))
        .thenAnswer((_) async {});
    when(() => speechService.stop()).thenAnswer((_) async {});
  });

  test('evaluate triggers when within threshold', () {
    final alarm = _alarm(trigger: 500);
    final state = service.evaluate(
      alarm,
      _position(lat: 51.5074, lon: -0.1278),
    );
    expect(state.status, AlarmStatus.triggered);
    expect(state.distanceMeters, lessThan(500));
  });

  test('evaluate stays active when outside threshold', () {
    final alarm = _alarm(trigger: 500);
    final state = service.evaluate(
      alarm,
      _position(lat: 51.52, lon: -0.1278),
    );
    expect(state.status, AlarmStatus.active);
    expect(state.distanceMeters, greaterThan(500));
  });

  test('evaluate includes eta when moving', () {
    final alarm = _alarm(trigger: 5000);
    final state = service.evaluate(
      alarm,
      _position(lat: 51.52, lon: -0.1278, speed: 20),
    );
    expect(state.etaMinutes, isNotNull);
    expect(state.etaMinutes!, greaterThan(0));
  });
}
