import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/constants/battery_profile_config.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/services/location_platform.dart';
import 'package:nomad_alarm/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart' hide ServiceStatus;

class LocationService {
  LocationService({
    required PermissionService permissionService,
    LocationPlatform? platform,
  })  : _permissionService = permissionService,
        _platform = platform ?? GeolocatorPlatformImpl();

  static const _locationTimeout = Duration(seconds: 8);

  final PermissionService _permissionService;
  final LocationPlatform _platform;

  Future<bool> hasLocationPermission() {
    return _permissionService.isGranted(Permission.locationWhenInUse);
  }

  Future<void> _ensurePermission() async {
    final granted = await hasLocationPermission();
    if (!granted) {
      throw const PermissionException(
        'Location permission is required to show your position.',
      );
    }
  }

  Future<Position?> getCurrentPositionSafe({
    BatteryProfile profile = BatteryProfile.balanced,
  }) async {
    final accuracy = BatteryProfileConfig.forProfile(profile).accuracy;
    try {
      return await getCurrentPosition(accuracy: accuracy);
    } on PermissionException {
      return _platform.getLastKnownPosition();
    } on LocationException {
      return _platform.getLastKnownPosition();
    } catch (_) {
      return _platform.getLastKnownPosition();
    }
  }

  Future<Position> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    await _ensurePermission();
    final enabled = await _platform.isLocationServiceEnabled();
    if (!enabled) {
      final lastKnown = await _platform.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }
      throw const LocationException(
        'Location services are turned off. Enable GPS to continue.',
      );
    }
    try {
      return await _platform.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: _locationTimeout,
        ),
      );
    } catch (e) {
      final lastKnown = await _platform.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }
      throw LocationException(
        'Unable to get current location.',
        debugMessage: e.toString(),
      );
    }
  }

  Stream<Position> watchPosition({
    BatteryProfile profile = BatteryProfile.balanced,
  }) async* {
    await _ensurePermission();
    final enabled = await _platform.isLocationServiceEnabled();
    if (!enabled) {
      throw const LocationException(
        'Location services are turned off. Enable GPS to continue.',
      );
    }
    final cfg = BatteryProfileConfig.forProfile(profile);
    yield* _platform.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: cfg.accuracy,
        distanceFilter: cfg.distanceFilterMeters,
        timeLimit: _locationTimeout,
      ),
    );
  }

  Future<bool> isLocationEnabled() => _platform.isLocationServiceEnabled();

  Stream<ServiceStatus> get serviceStatusStream =>
      _platform.serviceStatusStream;
}
