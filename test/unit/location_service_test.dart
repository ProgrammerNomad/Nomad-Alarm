import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/services/location_platform.dart';
import 'package:nomad_alarm/services/location_service.dart';
import 'package:nomad_alarm/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MockLocationPlatform extends Mock implements LocationPlatform {}

class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late MockLocationPlatform platform;
  late MockPermissionService permissionService;
  late LocationService service;

  setUpAll(() {
    registerFallbackValue(const LocationSettings());
  });

  setUp(() {
    platform = MockLocationPlatform();
    permissionService = MockPermissionService();
    service = LocationService(
      permissionService: permissionService,
      platform: platform,
    );
    when(() => platform.getLastKnownPosition()).thenAnswer((_) async => null);
  });

  test('getCurrentPosition returns position when permitted', () async {
    final position = Position(
      latitude: 51.5,
      longitude: -0.12,
      timestamp: DateTime.utc(2024, 1, 1),
      accuracy: 10,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

    when(() => permissionService.isGranted(Permission.locationWhenInUse))
        .thenAnswer((_) async => true);
    when(() => platform.isLocationServiceEnabled()).thenAnswer((_) async => true);
    when(() => platform.getCurrentPosition(locationSettings: any(named: 'locationSettings')))
        .thenAnswer((_) async => position);

    final result = await service.getCurrentPosition();
    expect(result.latitude, 51.5);
    expect(result.longitude, -0.12);
  });

  test('getCurrentPosition throws when permission denied', () async {
    when(() => permissionService.isGranted(Permission.locationWhenInUse))
        .thenAnswer((_) async => false);

    expect(
      () => service.getCurrentPosition(),
      throwsA(isA<PermissionException>()),
    );
  });

  test('getCurrentPosition throws when location disabled', () async {
    when(() => permissionService.isGranted(Permission.locationWhenInUse))
        .thenAnswer((_) async => true);
    when(() => platform.isLocationServiceEnabled()).thenAnswer((_) async => false);

    expect(
      () => service.getCurrentPosition(),
      throwsA(isA<LocationException>()),
    );
  });
}
