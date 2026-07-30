import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:nomad_alarm/services/api_key_store.dart';

/// Applies the user-supplied Google API key to the native Maps SDK on Android.
class GoogleMapsInit {
  GoogleMapsInit._();

  static const _channel = MethodChannel('com.nomad.alarm/google_maps');

  static Future<void> applyFromStore({ApiKeyStore? store}) async {
    if (!Platform.isAndroid) {
      return;
    }
    final key = await (store ?? ApiKeyStore()).readGoogleApiKey();
    await applyKey(key);
  }

  static Future<void> applyKey(String? key) async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      await _channel.invokeMethod<void>(
        'setGoogleMapsApiKey',
        {'apiKey': key ?? ''},
      );
    } on PlatformException {
      // Native bridge unavailable (e.g. tests).
    }
  }
}
