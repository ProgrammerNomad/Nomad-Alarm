import 'dart:math';

import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/enums.dart';

enum ConfidenceFactorStatus { pass, partial, fail }

class ConfidenceFactorBreakdown {
  const ConfidenceFactorBreakdown({
    required this.key,
    required this.label,
    required this.weight,
    required this.score,
    required this.status,
  });

  final String key;
  final String label;
  final double weight;
  final double score;
  final ConfidenceFactorStatus status;
}

class PlaceConfidenceInput {
  const PlaceConfidenceInput({
    required this.place,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.currentHeadingDegrees,
    required this.distanceTraveledMeters,
    required this.isInVehicle,
    required this.isMoving,
    required this.insideDestination,
    required this.recentlyTriggered,
  });

  final Favorite place;
  final double currentLatitude;
  final double currentLongitude;
  final double? currentHeadingDegrees;
  final double distanceTraveledMeters;
  final bool isInVehicle;
  final bool isMoving;
  final bool insideDestination;
  final bool recentlyTriggered;
}

class PlaceConfidenceResult {
  const PlaceConfidenceResult({
    required this.placeId,
    required this.confidencePercent,
    required this.breakdown,
  });

  final int placeId;
  final double confidencePercent;
  final List<ConfidenceFactorBreakdown> breakdown;

  bool get meetsThreshold => confidencePercent >= 90;
}

class PlaceConfidenceEngine {
  static const _directionWeight = 0.35;
  static const _movementWeight = 0.20;
  static const _tripsWeight = 0.25;
  static const _distanceWeight = 0.10;
  static const _activityWeight = 0.10;

  PlaceConfidenceResult score(PlaceConfidenceInput input) {
    if (input.insideDestination || input.recentlyTriggered || !input.isMoving) {
      return PlaceConfidenceResult(
        placeId: input.place.id,
        confidencePercent: 0,
        breakdown: _emptyBreakdown(input),
      );
    }

    final distanceMeters = haversineMeters(
      input.currentLatitude,
      input.currentLongitude,
      input.place.latitude,
      input.place.longitude,
    );

    final directionScore = _directionScore(
      input.currentLatitude,
      input.currentLongitude,
      input.place.latitude,
      input.place.longitude,
      input.currentHeadingDegrees,
    );
    final movementScore =
        (input.distanceTraveledMeters / 1000).clamp(0.0, 1.0);
    final tripsScore = (input.place.autoStartedCount / 50).clamp(0.0, 1.0);
    final distanceScore = _distanceScore(distanceMeters);
    final activityScore = input.isInVehicle
        ? 1.0
        : input.isMoving
            ? 0.4
            : 0.0;

    final weighted = directionScore * _directionWeight +
        movementScore * _movementWeight +
        tripsScore * _tripsWeight +
        distanceScore * _distanceWeight +
        activityScore * _activityWeight;

    final percent = (weighted * 100).clamp(0.0, 100.0);

    final breakdown = [
      ConfidenceFactorBreakdown(
        key: 'moving',
        label: 'Moving',
        weight: _movementWeight,
        score: movementScore,
        status: _statusFor(movementScore),
      ),
      ConfidenceFactorBreakdown(
        key: 'direction',
        label: 'Direction match',
        weight: _directionWeight,
        score: directionScore,
        status: _statusFor(directionScore),
      ),
      ConfidenceFactorBreakdown(
        key: 'frequent',
        label: 'Frequent destination',
        weight: _tripsWeight,
        score: tripsScore,
        status: _statusFor(tripsScore),
      ),
      ConfidenceFactorBreakdown(
        key: 'distance',
        label: 'Distance band',
        weight: _distanceWeight,
        score: distanceScore,
        status: _statusFor(distanceScore),
      ),
      ConfidenceFactorBreakdown(
        key: 'activity',
        label: input.isInVehicle ? 'In vehicle' : 'Activity',
        weight: _activityWeight,
        score: activityScore,
        status: _statusFor(activityScore),
      ),
      ConfidenceFactorBreakdown(
        key: 'recent',
        label: 'Not recently triggered',
        weight: 0,
        score: input.recentlyTriggered ? 0 : 1,
        status: input.recentlyTriggered
            ? ConfidenceFactorStatus.fail
            : ConfidenceFactorStatus.pass,
      ),
    ];

    return PlaceConfidenceResult(
      placeId: input.place.id,
      confidencePercent: percent,
      breakdown: breakdown,
    );
  }

  static List<PlaceConfidenceResult> rankCandidates({
    required List<Favorite> places,
    required PlaceConfidenceInput Function(Favorite place) inputFor,
  }) {
    final engine = PlaceConfidenceEngine();
    final results = places.map((p) => engine.score(inputFor(p))).toList()
      ..sort((a, b) {
        final byScore = b.confidencePercent.compareTo(a.confidencePercent);
        if (byScore != 0) {
          return byScore;
        }
        final placeA = places.firstWhere((p) => p.id == a.placeId);
        final placeB = places.firstWhere((p) => p.id == b.placeId);
        final byPriority = placeB.priority.compareTo(placeA.priority);
        if (byPriority != 0) {
          return byPriority;
        }
        return placeB.predictionAccuracy.compareTo(placeA.predictionAccuracy);
      });
    return results;
  }

  static double _directionScore(
    double fromLat,
    double fromLng,
    double toLat,
    double toLng,
    double? headingDegrees,
  ) {
    if (headingDegrees == null) {
      return 0.5;
    }
    final bearing = _bearingDegrees(fromLat, fromLng, toLat, toLng);
    final delta = _angleDelta(headingDegrees, bearing);
    if (delta <= 30) {
      return 1.0;
    }
    if (delta <= 60) {
      return 0.5;
    }
    return 0;
  }

  static double _distanceScore(double distanceMeters) {
    if (distanceMeters <= 500) {
      return 0.2;
    }
    if (distanceMeters <= 5000) {
      return 0.6;
    }
    if (distanceMeters <= 50000) {
      return 1.0;
    }
    if (distanceMeters <= 150000) {
      return 0.7;
    }
    return 0.3;
  }

  static ConfidenceFactorStatus _statusFor(double score) {
    if (score >= 0.75) {
      return ConfidenceFactorStatus.pass;
    }
    if (score >= 0.35) {
      return ConfidenceFactorStatus.partial;
    }
    return ConfidenceFactorStatus.fail;
  }

  static List<ConfidenceFactorBreakdown> _emptyBreakdown(
    PlaceConfidenceInput input,
  ) {
    return [
      ConfidenceFactorBreakdown(
        key: 'moving',
        label: 'Moving',
        weight: _movementWeight,
        score: 0,
        status: input.isMoving
            ? ConfidenceFactorStatus.pass
            : ConfidenceFactorStatus.fail,
      ),
    ];
  }

  static double _bearingDegrees(
    double fromLat,
    double fromLng,
    double toLat,
    double toLng,
  ) {
    final lat1 = fromLat * pi / 180;
    final lat2 = toLat * pi / 180;
    final dLng = (toLng - fromLng) * pi / 180;
    final y = sin(dLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  static double _angleDelta(double a, double b) {
    final diff = (a - b).abs() % 360;
    return diff > 180 ? 360 - diff : diff;
  }
}
