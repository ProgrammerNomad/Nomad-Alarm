import 'package:flutter/foundation.dart';

abstract class FeatureFlags {
  static const bool locationAlarms = true;
  static const bool backgroundTracking = true;
  static const bool nominatimSearch = true;
  static const bool osmMaps = true;

  static const bool homeScreenWidgets = false;
  static const bool quickSettingsTile = false;
  static const bool backupRestore = false;
  static const bool deepLinkImport = false;

  static const bool googleMapsProvider = false;
  static const bool googlePlacesSearch = false;
  static const bool hereMapsProvider = false;
  static const bool mapboxProvider = false;
  static const bool offlineMapTiles = false;

  static const bool wearOs = false;
  static const bool androidAuto = false;
  static const bool aiEtaPrediction = false;
  static const bool groupTravel = false;
  static const bool familySharing = false;
  static const bool cloudBackup = false;

  static const bool debugScreen = kDebugMode;
  static const bool mockLocation = kDebugMode;
}
