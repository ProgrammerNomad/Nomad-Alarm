import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/models/enums.dart';

class RouteResult {
  const RouteResult({
    required this.distanceMeters,
    required this.durationSeconds,
    this.encodedPolyline,
    this.points = const [],
  });

  final double distanceMeters;
  final int durationSeconds;
  final String? encodedPolyline;
  final List<LatLng> points;

  double? get durationMinutes =>
      durationSeconds > 0 ? durationSeconds / 60.0 : null;

  /// Polyline suitable for persisting on trips/favorites.
  String? get storablePolyline {
    if (encodedPolyline != null && encodedPolyline!.isNotEmpty) {
      return encodedPolyline;
    }
    if (points.isEmpty) {
      return null;
    }
    return points.map((p) => '${p.latitude},${p.longitude}').join(';');
  }
}

abstract class RouteProvider {
  RouteProviderType get type;

  Future<RouteResult?> route({
    required LatLng from,
    required LatLng to,
    TravelMode travelMode = TravelMode.autoDetect,
  });

  void dispose() {}
}
