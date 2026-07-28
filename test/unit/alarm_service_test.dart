import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/alarm_service.dart';
import 'package:nomad_alarm/services/location_service.dart';

class MockAlarmRepository extends Mock implements AlarmRepository {}

class MockLocationService extends Mock implements LocationService {}

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
  late MockLocationService locationService;
  late AlarmService service;

  setUpAll(() {
    registerFallbackValue(_alarm());
    registerFallbackValue(LocationAccuracy.high);
  });

  setUp(() {
    repository = MockAlarmRepository();
    locationService = MockLocationService();
    service = AlarmService(
      alarmRepository: repository,
      locationService: locationService,
    );

    when(() => locationService.getCurrentPositionSafe()).thenAnswer(
      (_) async => _position(lat: 51.52, lon: -0.1278),
    );
    when(
      () => locationService.watchPosition(
        accuracy: any(named: 'accuracy'),
        distanceFilterMeters: any(named: 'distanceFilterMeters'),
      ),
    ).thenAnswer((_) => const Stream.empty());
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

  test('pauseAlarm updates status to paused', () async {
    final alarm = _alarm();
    when(() => repository.getById(1)).thenAnswer((_) async => alarm);
    when(() => repository.update(any())).thenAnswer((_) async {});

    await service.startAlarm(1);
    await service.pauseAlarm(1);

    expect(alarm.status, AlarmStatus.paused);
  });

  test('cancelAlarm updates status to cancelled', () async {
    final alarm = _alarm();
    when(() => repository.getById(1)).thenAnswer((_) async => alarm);
    when(() => repository.update(any())).thenAnswer((_) async {});

    await service.startAlarm(1);
    await service.cancelAlarm(1);

    expect(alarm.status, AlarmStatus.cancelled);
  });
}
