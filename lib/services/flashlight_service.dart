import 'dart:async';

import 'package:torch_light/torch_light.dart';

/// Controls device flashlight for alarm ring alerts.
class FlashlightService {
  Timer? _strobeTimer;
  var _available = false;

  Future<bool> get isAvailable async {
    try {
      _available = await TorchLight.isTorchAvailable();
      return _available;
    } catch (_) {
      _available = false;
      return false;
    }
  }

  Future<void> startStrobe() async {
    if (!await isAvailable) {
      return;
    }
    await stop();
    var on = false;
    _strobeTimer = Timer.periodic(const Duration(milliseconds: 500), (_) async {
      try {
        on = !on;
        if (on) {
          await TorchLight.enableTorch();
        } else {
          await TorchLight.disableTorch();
        }
      } catch (_) {}
    });
  }

  Future<void> stop() async {
    _strobeTimer?.cancel();
    _strobeTimer = null;
    try {
      await TorchLight.disableTorch();
    } catch (_) {}
  }
}
