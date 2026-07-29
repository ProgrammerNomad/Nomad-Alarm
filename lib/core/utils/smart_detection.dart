import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';

/// Heuristics for tunnel, train stopped, and connectivity hints.
class SmartDetection {
  SmartDetection();

  int _lowSpeedSamples = 0;
  int _poorAccuracySamples = 0;
  int _routeFailureSamples = 0;
  DateTime? _lastMovementAt;
  DateTime? _internetLostSince;

  void reset() {
    _lowSpeedSamples = 0;
    _poorAccuracySamples = 0;
    _routeFailureSamples = 0;
    _lastMovementAt = null;
    _internetLostSince = null;
  }

  void update({
    required double speedKmh,
    required double accuracyMeters,
    required DateTime fixAt,
  }) {
    if (speedKmh > 3) {
      _lastMovementAt = fixAt;
      _lowSpeedSamples = 0;
    } else if (_lastMovementAt != null) {
      _lowSpeedSamples++;
    }

    if (accuracyMeters > AlarmConstants.tunnelAccuracyThresholdM) {
      _poorAccuracySamples++;
    } else {
      _poorAccuracySamples = 0;
    }
  }

  void recordRouteSuccess() {
    _routeFailureSamples = 0;
    _internetLostSince = null;
  }

  void recordRouteFailure(DateTime at) {
    if (!FeatureFlags.aiEtaPrediction) {
      return;
    }
    _routeFailureSamples++;
    _internetLostSince ??= at;
  }

  bool get isTrainStopped {
    if (!FeatureFlags.aiEtaPrediction) {
      return false;
    }
    return _lowSpeedSamples >= AlarmConstants.trainStoppedSamples;
  }

  bool get isLikelyTunnel {
    if (!FeatureFlags.aiEtaPrediction) {
      return false;
    }
    return _poorAccuracySamples >= AlarmConstants.tunnelAccuracySamples;
  }

  bool get isInternetLost {
    if (!FeatureFlags.aiEtaPrediction) {
      return false;
    }
    if (_routeFailureSamples < AlarmConstants.internetLostRouteFailures) {
      return false;
    }
    final since = _internetLostSince;
    if (since == null) {
      return false;
    }
    return DateTime.now().difference(since).inMinutes >=
        AlarmConstants.internetLostAlertMinutes;
  }
}
