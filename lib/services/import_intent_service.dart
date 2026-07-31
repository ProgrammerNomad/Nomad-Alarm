import 'package:flutter/services.dart';

/// Receives alarm payloads shared into Nomad Alarm from Android intents.
class ImportIntentService {
  ImportIntentService._();

  static const _channel = MethodChannel('com.nomad.alarm/import');

  static String? _pendingRaw;

  static Future<void> initialize() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onImportPayload') {
        _pendingRaw = call.arguments as String?;
      }
    });
    try {
      final initial = await _channel.invokeMethod<String>('getPendingImport');
      if (initial != null && initial.isNotEmpty) {
        _pendingRaw = initial;
      }
    } on PlatformException {
      // Channel unavailable (non-Android or tests).
    }
  }

  static String? consumePendingRaw() {
    final value = _pendingRaw;
    _pendingRaw = null;
    return value;
  }

  static void setPendingRaw(String raw) {
    _pendingRaw = raw;
  }
}
