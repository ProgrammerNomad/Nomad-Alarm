import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists last map viewport for offline tile downloads.
class MapViewportStore {
  MapViewportStore._();

  static const _swLatKey = 'map_viewport_sw_lat';
  static const _swLngKey = 'map_viewport_sw_lng';
  static const _neLatKey = 'map_viewport_ne_lat';
  static const _neLngKey = 'map_viewport_ne_lng';

  static Future<void> saveBounds({
    required LatLng southWest,
    required LatLng northEast,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_swLatKey, southWest.latitude);
    await prefs.setDouble(_swLngKey, southWest.longitude);
    await prefs.setDouble(_neLatKey, northEast.latitude);
    await prefs.setDouble(_neLngKey, northEast.longitude);
  }

  static Future<({LatLng southWest, LatLng northEast})?> loadBounds() async {
    final prefs = await SharedPreferences.getInstance();
    final swLat = prefs.getDouble(_swLatKey);
    final swLng = prefs.getDouble(_swLngKey);
    final neLat = prefs.getDouble(_neLatKey);
    final neLng = prefs.getDouble(_neLngKey);
    if (swLat == null || swLng == null || neLat == null || neLng == null) {
      return null;
    }
    return (
      southWest: LatLng(swLat, swLng),
      northEast: LatLng(neLat, neLng),
    );
  }
}
