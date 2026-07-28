abstract class AlarmConstants {
  static const double earthRadiusMeters = 6371000;

  static const int gpsLostThresholdSec = 60;
  static const int passedDestinationSamples = 3;
  static const double approachZoneMultiplier = 2.0;

  static const double defaultTriggerDistanceM = 500;
  static const double minTriggerDistanceM = 100;
  static const double maxTriggerDistanceM = 5000;

  static const int snoozeDurationMin = 2;

  static const int gpsDistanceFilterBalancedM = 10;
  static const int gpsDistanceFilterAggressiveM = 5;

  static const double gpsAccuracyGoodM = 50;
  static const double gpsAccuracyWarnM = 100;

  static const int lowBatteryThresholdPercent = 15;
  static const int lowBatteryCheckIntervalSec = 60;
}
