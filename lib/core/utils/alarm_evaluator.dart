import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm_monitor_config.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';

/// Tracks consecutive distance increases to detect passing destination.
class PassedDestinationTracker {
  final List<double> _distanceSamples = [];
  bool _wasApproaching = false;
  DateTime? lastFixAt;

  void recordFix(DateTime fixAt) {
    lastFixAt = fixAt;
  }

  bool isGpsLost(DateTime now) {
    if (lastFixAt == null) {
      return false;
    }
    return now.difference(lastFixAt!).inSeconds >
        AlarmConstants.gpsLostThresholdSec;
  }

  void updatePassedDetection(double distance) {
    if (_distanceSamples.isEmpty) {
      _distanceSamples.add(distance);
      return;
    }
    final previous = _distanceSamples.last;
    if (distance < previous) {
      _wasApproaching = true;
    }
    _distanceSamples.add(distance);
    if (_distanceSamples.length > AlarmConstants.passedDestinationSamples) {
      _distanceSamples.removeAt(0);
    }
  }

  bool get hasPassedDestination {
    if (!_wasApproaching ||
        _distanceSamples.length < AlarmConstants.passedDestinationSamples) {
      return false;
    }
    for (var i = 1; i < _distanceSamples.length; i++) {
      if (_distanceSamples[i] <= _distanceSamples[i - 1]) {
        return false;
      }
    }
    return true;
  }

  void reset() {
    _distanceSamples.clear();
    _wasApproaching = false;
    lastFixAt = null;
  }
}

class AlarmEvaluator {
  AlarmEvaluator({PassedDestinationTracker? tracker})
      : _tracker = tracker ?? PassedDestinationTracker();

  final PassedDestinationTracker _tracker;

  PassedDestinationTracker get tracker => _tracker;

  AlarmRuntimeState evaluate({
    required AlarmMonitorConfig config,
    required Position position,
    required AlarmStatus currentStatus,
    DateTime? snoozeSuppressedUntil,
  }) {
    final distance = haversineMeters(
      position.latitude,
      position.longitude,
      config.destLatitude,
      config.destLongitude,
    );

    final speedKmh =
        position.speed >= 0 ? (position.speed * 3.6).toDouble() : 0.0;
    final now = position.timestamp;

    final gpsLost = _tracker.isGpsLost(now);
    _tracker.updatePassedDetection(distance);
    _tracker.recordFix(now);

    final snoozeActive = snoozeSuppressedUntil != null &&
        now.isBefore(snoozeSuppressedUntil);

    var status = currentStatus;
    if (!snoozeActive &&
        currentStatus == AlarmStatus.active &&
        distance <= config.triggerDistanceMeters) {
      status = AlarmStatus.triggered;
    }

    return AlarmRuntimeState(
      alarmId: config.alarmId,
      destinationName: config.name,
      address: config.address,
      latitude: position.latitude,
      longitude: position.longitude,
      destLatitude: config.destLatitude,
      destLongitude: config.destLongitude,
      distanceMeters: distance,
      speedKmh: speedKmh,
      accuracyMeters: position.accuracy,
      lastFixAt: now,
      isGpsLost: gpsLost,
      hasPassedDestination: _tracker.hasPassedDestination,
      status: status,
      etaMinutes: estimateEtaMinutes(distance, speedKmh),
    );
  }
}
