import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/models/enums.dart';

/// Maps [BatteryProfile] to GPS stream settings per docs/BATTERY.md.
class BatteryProfileConfig {
  const BatteryProfileConfig({
    required this.accuracy,
    required this.distanceFilterMeters,
  });

  final LocationAccuracy accuracy;
  final int distanceFilterMeters;

  LocationSettings toLocationSettings() {
    return LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilterMeters,
    );
  }

  static BatteryProfileConfig forProfile(BatteryProfile profile) {
    return switch (profile) {
      BatteryProfile.balanced => const BatteryProfileConfig(
          accuracy: LocationAccuracy.high,
          distanceFilterMeters: AlarmConstants.gpsDistanceFilterBalancedM,
        ),
      BatteryProfile.aggressive => const BatteryProfileConfig(
          accuracy: LocationAccuracy.best,
          distanceFilterMeters: AlarmConstants.gpsDistanceFilterAggressiveM,
        ),
      BatteryProfile.saver => const BatteryProfileConfig(
          accuracy: LocationAccuracy.medium,
          distanceFilterMeters: 25,
        ),
    };
  }

  /// Auto-switch to aggressive when within 2× trigger distance.
  static BatteryProfileConfig effectiveFor({
    required BatteryProfile selectedProfile,
    required double distanceMeters,
    required double triggerDistanceMeters,
  }) {
    if (distanceMeters <= triggerDistanceMeters * AlarmConstants.approachZoneMultiplier) {
      return forProfile(BatteryProfile.aggressive);
    }
    return forProfile(selectedProfile);
  }
}
