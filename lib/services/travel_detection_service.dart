import 'dart:async';

import 'package:geolocator/geolocator.dart';

enum TravelActivity { still, onFoot, inVehicle, unknown }

class TravelSnapshot {
  const TravelSnapshot({
    required this.activity,
    required this.position,
    required this.distanceTraveledMeters,
    required this.isMoving,
  });

  final TravelActivity activity;
  final Position? position;
  final double distanceTraveledMeters;
  final bool isMoving;

  bool get isStill => activity == TravelActivity.still;
}

/// Lightweight travel detection using significant movement - no continuous
/// high-rate GPS while the user is still.
class TravelDetectionService {
  TravelDetectionService();

  StreamSubscription<Position>? _subscription;
  Position? _lastPosition;
  Position? _travelStartPosition;
  TravelActivity _activity = TravelActivity.still;
  final _controller = StreamController<TravelSnapshot>.broadcast();

  Stream<TravelSnapshot> get snapshots => _controller.stream;

  TravelActivity get activity => _activity;

  Future<void> start() async {
    if (_subscription != null) {
      return;
    }
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 100,
      ),
    ).listen(_onPosition, onError: (_) {});
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _lastPosition = null;
    _travelStartPosition = null;
    _activity = TravelActivity.still;
  }

  void _onPosition(Position position) {
    final previous = _lastPosition;
    _lastPosition = position;

    if (previous == null) {
      _travelStartPosition = position;
      _emit(position, 0);
      return;
    }

    final segment = Geolocator.distanceBetween(
      previous.latitude,
      previous.longitude,
      position.latitude,
      position.longitude,
    );

    _travelStartPosition ??= previous;
    final total = Geolocator.distanceBetween(
      _travelStartPosition!.latitude,
      _travelStartPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    final speed = position.speed;
    if (speed >= 4) {
      _activity = TravelActivity.inVehicle;
    } else if (speed >= 0.8 || segment >= 50) {
      _activity = TravelActivity.onFoot;
    } else if (segment < 5) {
      _activity = TravelActivity.still;
      _travelStartPosition = position;
    }

    _emit(position, total);
  }

  void _emit(Position position, double distanceTraveledMeters) {
    final moving = _activity != TravelActivity.still;
    _controller.add(
      TravelSnapshot(
        activity: _activity,
        position: position,
        distanceTraveledMeters: distanceTraveledMeters,
        isMoving: moving,
      ),
    );
  }

  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }
}
