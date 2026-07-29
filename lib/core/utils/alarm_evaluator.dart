import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/core/utils/eta_predictor.dart';
import 'package:nomad_alarm/core/utils/smart_detection.dart';
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
  AlarmEvaluator({
    PassedDestinationTracker? tracker,
    EtaPredictor? etaPredictor,
    SmartDetection? smartDetection,
  })  : _tracker = tracker ?? PassedDestinationTracker(),
        _etaPredictor = etaPredictor ?? EtaPredictor(),
        _smartDetection = smartDetection ?? SmartDetection();

  final PassedDestinationTracker _tracker;
  final EtaPredictor _etaPredictor;
  final SmartDetection _smartDetection;
  bool _wasInsideGeofence = false;

  PassedDestinationTracker get tracker => _tracker;

  EtaPredictor get etaPredictor => _etaPredictor;

  SmartDetection get smartDetection => _smartDetection;

  void reset() {
    _tracker.reset();
    _etaPredictor.reset();
    _smartDetection.reset();
    _wasInsideGeofence = false;
  }

  AlarmRuntimeState evaluate({
    required AlarmMonitorConfig config,
    required Position position,
    required AlarmStatus currentStatus,
    DateTime? snoozeSuppressedUntil,
    double? routeEtaMinutes,
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

    _smartDetection.update(
      speedKmh: speedKmh,
      accuracyMeters: position.accuracy,
      fixAt: now,
    );

    final snoozeActive = snoozeSuppressedUntil != null &&
        now.isBefore(snoozeSuppressedUntil);

    final insideGeofence = distance <= config.effectiveRadiusMeters;
    final etaMinutes = _etaPredictor.predict(
      distanceMeters: distance,
      currentSpeedKmh: speedKmh,
      routeEtaMinutes: routeEtaMinutes,
    );

    var shouldTrigger = false;
    switch (config.alarmType) {
      case AlarmType.distance:
      case AlarmType.arrival:
        shouldTrigger = insideGeofence;
      case AlarmType.radius:
      case AlarmType.geofence:
        shouldTrigger = insideGeofence;
      case AlarmType.departure:
        shouldTrigger = _wasInsideGeofence && !insideGeofence;
      case AlarmType.eta:
        shouldTrigger =
            etaMinutes != null && etaMinutes <= config.triggerDistanceMeters;
      case AlarmType.speed:
        final threshold = config.speedThresholdKmh ?? 0;
        shouldTrigger = speedKmh >= threshold &&
            distance <= config.triggerDistanceMeters * 2;
    }
    _wasInsideGeofence = insideGeofence;

    var status = currentStatus;
    if (!snoozeActive &&
        currentStatus == AlarmStatus.active &&
        shouldTrigger) {
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
      isGpsLost: gpsLost || _smartDetection.isLikelyTunnel,
      hasPassedDestination: _tracker.hasPassedDestination,
      status: status,
      etaMinutes: etaMinutes,
      isInternetLost: _smartDetection.isInternetLost,
    );
  }
}
