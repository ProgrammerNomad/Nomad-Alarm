import 'package:battery_plus/battery_plus.dart';

/// Reads device battery level for low-battery warnings.
class BatteryMonitorService {
  BatteryMonitorService() : _battery = Battery();

  final Battery _battery;

  Future<int> get level async {
    try {
      return await _battery.batteryLevel;
    } catch (_) {
      return 100;
    }
  }

  Future<bool> get isCharging async {
    try {
      final state = await _battery.batteryState;
      return state == BatteryState.charging || state == BatteryState.full;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isLowBattery(int thresholdPercent) async {
    if (await isCharging) {
      return false;
    }
    return (await level) < thresholdPercent;
  }
}
