import 'package:nomad_alarm/models/enums.dart';

/// Maps [TravelMode] to routing engine profile names.
abstract class TravelModeUtils {
  static String osrmProfile(TravelMode mode) {
    return switch (mode) {
      TravelMode.walking => 'foot',
      TravelMode.cycling => 'bike',
      TravelMode.train ||
      TravelMode.bus ||
      TravelMode.metro ||
      TravelMode.car ||
      TravelMode.autoDetect =>
        'driving',
    };
  }

  static String googleMode(TravelMode mode) {
    return switch (mode) {
      TravelMode.walking => 'walking',
      TravelMode.cycling => 'bicycling',
      TravelMode.train ||
      TravelMode.bus ||
      TravelMode.metro ||
      TravelMode.car ||
      TravelMode.autoDetect =>
        'driving',
    };
  }

  static String graphHopperProfile(TravelMode mode) {
    return switch (mode) {
      TravelMode.walking => 'foot',
      TravelMode.cycling => 'bike',
      _ => 'car',
    };
  }
}
