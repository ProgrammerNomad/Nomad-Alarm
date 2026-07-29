import 'package:flutter/services.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';

/// Syncs active alarm state to Wear OS companion (when enabled).
class WearOsService {
  WearOsService._();

  static const _channel = MethodChannel('com.nomad.alarm/wear');

  static Future<void> syncActiveAlarm({
    required bool active,
    String? destination,
    double? distanceMeters,
    double? etaMinutes,
  }) async {
    if (!FeatureFlags.wearOs) {
      return;
    }
    try {
      await _channel.invokeMethod<void>('syncAlarm', {
        'active': active,
        'destination': destination,
        'distanceMeters': distanceMeters,
        'etaMinutes': etaMinutes,
      });
    } on PlatformException {
      // Wear module optional.
    }
  }
}
