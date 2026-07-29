import 'package:flutter/services.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';

/// Pushes minimal alarm UI data to Android Auto (when enabled).
class AndroidAutoService {
  AndroidAutoService._();

  static const _channel = MethodChannel('com.nomad.alarm/android_auto');

  static Future<void> updateNavigationState({
    required String destination,
    required String distanceLabel,
    String? etaLabel,
  }) async {
    if (!FeatureFlags.androidAuto) {
      return;
    }
    try {
      await _channel.invokeMethod<void>('updateNavigation', {
        'destination': destination,
        'distance': distanceLabel,
        'eta': etaLabel,
      });
    } on PlatformException {
      // Car app optional.
    }
  }

  static Future<void> clear() async {
    if (!FeatureFlags.androidAuto) {
      return;
    }
    try {
      await _channel.invokeMethod<void>('clear');
    } on PlatformException {
      // Ignore.
    }
  }
}
