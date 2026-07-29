import 'package:latlong2/latlong.dart';

/// Parses trip/favorite route polylines (encoded or lat,lng pairs).
abstract class PolylineUtils {
  static List<LatLng> parse(String? polyline) {
    if (polyline == null || polyline.isEmpty) {
      return [];
    }
    if (polyline.contains(';')) {
      return polyline.split(';').map((part) {
        final coords = part.split(',');
        if (coords.length < 2) {
          return null;
        }
        return LatLng(
          double.parse(coords[0]),
          double.parse(coords[1]),
        );
      }).whereType<LatLng>().toList();
    }
    return [];
  }
}
