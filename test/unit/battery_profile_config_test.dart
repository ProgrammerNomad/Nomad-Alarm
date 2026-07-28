import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/constants/battery_profile_config.dart';
import 'package:nomad_alarm/models/enums.dart';

void main() {
  test('balanced profile uses high accuracy and 10m filter', () {
    final cfg = BatteryProfileConfig.forProfile(BatteryProfile.balanced);
    expect(cfg.accuracy, LocationAccuracy.high);
    expect(cfg.distanceFilterMeters, 10);
  });

  test('aggressive profile uses best accuracy and 5m filter', () {
    final cfg = BatteryProfileConfig.forProfile(BatteryProfile.aggressive);
    expect(cfg.accuracy, LocationAccuracy.best);
    expect(cfg.distanceFilterMeters, 5);
  });

  test('effectiveFor switches to aggressive near destination', () {
    final cfg = BatteryProfileConfig.effectiveFor(
      selectedProfile: BatteryProfile.balanced,
      distanceMeters: 800,
      triggerDistanceMeters: 500,
    );
    expect(cfg.accuracy, LocationAccuracy.best);
    expect(cfg.distanceFilterMeters, 5);
  });

  test('effectiveFor keeps selected profile when far', () {
    final cfg = BatteryProfileConfig.effectiveFor(
      selectedProfile: BatteryProfile.saver,
      distanceMeters: 5000,
      triggerDistanceMeters: 500,
    );
    expect(cfg.accuracy, LocationAccuracy.medium);
    expect(cfg.distanceFilterMeters, 25);
  });
}
