import 'package:geolocator/geolocator.dart';

abstract class LocationPlatform {
  Future<Position> getCurrentPosition({
    LocationSettings locationSettings = const LocationSettings(),
  });

  Future<Position?> getLastKnownPosition();

  Stream<Position> getPositionStream({
    LocationSettings locationSettings = const LocationSettings(),
  });

  Future<bool> isLocationServiceEnabled();

  Stream<ServiceStatus> get serviceStatusStream;
}

class GeolocatorPlatformImpl implements LocationPlatform {
  @override
  Future<Position> getCurrentPosition({
    LocationSettings locationSettings = const LocationSettings(),
  }) {
    return Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }

  @override
  Future<Position?> getLastKnownPosition() {
    return Geolocator.getLastKnownPosition();
  }

  @override
  Stream<Position> getPositionStream({
    LocationSettings locationSettings = const LocationSettings(),
  }) {
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Stream<ServiceStatus> get serviceStatusStream {
    return Geolocator.getServiceStatusStream();
  }
}
