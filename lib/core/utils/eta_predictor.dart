import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';

/// On-device ETA smoothing - blends route duration with recent speed samples.
class EtaPredictor {
  EtaPredictor({this.maxSamples = 12});

  final int maxSamples;
  final List<double> _speedSamplesKmh = [];

  void recordSpeed(double speedKmh) {
    if (speedKmh <= 0) {
      return;
    }
    _speedSamplesKmh.add(speedKmh);
    if (_speedSamplesKmh.length > maxSamples) {
      _speedSamplesKmh.removeAt(0);
    }
  }

  void reset() {
    _speedSamplesKmh.clear();
  }

  /// Returns smoothed ETA minutes when [FeatureFlags.aiEtaPrediction] is on.
  double? predict({
    required double distanceMeters,
    required double currentSpeedKmh,
    double? routeEtaMinutes,
  }) {
    recordSpeed(currentSpeedKmh);

    final straightLine = estimateEtaMinutes(distanceMeters, currentSpeedKmh);
    if (!FeatureFlags.aiEtaPrediction) {
      return routeEtaMinutes ?? straightLine;
    }

    final avgSpeed = _speedSamplesKmh.isEmpty
        ? currentSpeedKmh
        : _speedSamplesKmh.reduce((a, b) => a + b) / _speedSamplesKmh.length;
    final speedBased = estimateEtaMinutes(distanceMeters, avgSpeed);

    if (routeEtaMinutes != null && speedBased != null) {
      return (routeEtaMinutes * 0.6) + (speedBased * 0.4);
    }
    return routeEtaMinutes ?? speedBased ?? straightLine;
  }
}
