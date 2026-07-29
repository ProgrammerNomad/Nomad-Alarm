import 'package:flutter/foundation.dart';

abstract class FeatureFlags {
  static const bool locationAlarms = true;
  static const bool backgroundTracking = true;
  static const bool nominatimSearch = true;
  static const bool osmMaps = true;

  static const bool homeScreenWidgets = true;
  static const bool quickSettingsTile = true;
  static const bool backupRestore = true;
  static const bool deepLinkImport = true;

  static const bool googleMapsProvider = true;
  static const bool googlePlacesSearch = true;
  static const bool hereMapsProvider = true;
  static const bool mapboxProvider = true;
  static const bool offlineMapTiles = true;

  static const bool wearOs = true;
  static const bool androidAuto = true;
  static const bool aiEtaPrediction = true;
  static const bool groupTravel = true;
  static const bool familySharing = true;
  static const bool cloudBackup = true;
  static const bool voiceSearch = true;

  static const bool debugScreen = kDebugMode;
  static const bool mockLocation = kDebugMode;
}
