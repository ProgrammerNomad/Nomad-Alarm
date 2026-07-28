import 'dart:math';

import 'package:nomad_alarm/core/constants/alarm_constants.dart';

/// Great-circle distance between two WGS84 coordinates in meters.
double haversineMeters(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const radius = AlarmConstants.earthRadiusMeters;
  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return radius * c;
}

double _toRadians(double degrees) => degrees * pi / 180;

/// Format distance for display (meters or km).
String formatDistance(double meters, {bool useMetric = true}) {
  if (!useMetric) {
    final feet = meters * 3.28084;
    if (feet >= 5280) {
      return '${(feet / 5280).toStringAsFixed(1)} mi';
    }
    return '${feet.round()} ft';
  }
  if (meters >= 1000) {
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
  return '${meters.round()} m';
}
