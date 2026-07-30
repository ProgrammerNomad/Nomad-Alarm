// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nomad Alarm';

  @override
  String get navHome => 'Home';

  @override
  String get navTrips => 'Trips';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get createAlarm => 'Create Alarm';

  @override
  String get searchDestinationHint => 'Search destination…';

  @override
  String get activeAlarms => 'Active alarms';

  @override
  String get favorites => 'Favorites';

  @override
  String get recent => 'Recent';

  @override
  String get firstAlarmTitle => 'Set your first destination alarm';

  @override
  String get firstAlarmBody => 'Search for a place or drop a pin on the map.';

  @override
  String get searchDestination => 'Search destination';

  @override
  String get gettingLocation => 'Getting location…';

  @override
  String get locationUnavailable => 'Location unavailable - tap to open map';

  @override
  String get activeAlarmFallback => 'Active alarm';

  @override
  String alarmRingingDistance(String distance) {
    return 'Alarm ringing - $distance away';
  }

  @override
  String distanceAway(String distance) {
    return '$distance away';
  }

  @override
  String get welcomeTitle => 'Never miss your stop again';

  @override
  String get welcomeBullet1 => '100% free - no ads, no subscriptions';

  @override
  String get welcomeBullet2 => 'Privacy first - no login, no tracking';

  @override
  String get welcomeBullet3 => 'Works offline for active alarms';

  @override
  String get getStarted => 'Get Started';

  @override
  String permissionsTitle(int current, int total) {
    return 'Permissions ($current/$total)';
  }

  @override
  String get grant => 'Grant';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get required => 'Required';

  @override
  String get permLocationTitle => 'Location access';

  @override
  String get permLocationDesc =>
      'We need your location to calculate distance to your destination.';

  @override
  String get permNotificationTitle => 'Notifications';

  @override
  String get permNotificationDesc =>
      'We show a small notification while your alarm is active.';

  @override
  String get permBackgroundTitle => 'Background location';

  @override
  String get permBackgroundDesc =>
      'Allow all the time so the alarm works while your screen is off.';

  @override
  String get permExactAlarmTitle => 'Exact alarms';

  @override
  String get permExactAlarmDesc =>
      'Allows reliable wake-up when you reach your destination (Android 12+).';

  @override
  String get permBatteryTitle => 'Battery optimization';

  @override
  String get permBatteryDesc =>
      'Disabling battery optimization helps GPS keep running in the background. You can skip this, but tracking may stop on some devices.';

  @override
  String get activeAlarmTitle => 'Active Alarm';

  @override
  String get estimatedArrival => 'estimated arrival';

  @override
  String get gpsLostWarning => 'GPS signal lost - last fix may be stale';

  @override
  String get passedDestinationWarning => 'You may have passed your destination';

  @override
  String get lowBatteryWarning =>
      'Low battery - charge your phone to keep tracking reliable';

  @override
  String get alarmPaused => 'Alarm paused';

  @override
  String get resume => 'Resume';

  @override
  String get pause => 'Pause';

  @override
  String get openMap => 'Open Map';

  @override
  String get cancelAlarm => 'Cancel Alarm';

  @override
  String get stopApproaching => 'Stop approaching!';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get snoozeTwoMin => 'Snooze 2 min';

  @override
  String get createAlarmTitle => 'Create Alarm';

  @override
  String get noDestinationSelected => 'No destination selected';

  @override
  String get selectDestinationFirst => 'Please select a destination first';

  @override
  String get alarmSaved => 'Alarm saved';

  @override
  String get alertDistance => 'Alert distance';

  @override
  String get voiceAlert => 'Voice alert';

  @override
  String get voiceAlertSubtitle => 'Spoken alert when triggered';

  @override
  String get vibration => 'Vibration';

  @override
  String get flashlight => 'Flashlight';

  @override
  String get flashlightSubtitle => 'LED strobe when alarm rings';

  @override
  String get saveAndStart => 'Save & Start';

  @override
  String get saveOnly => 'Save only';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get units => 'Units';

  @override
  String get useMetricUnits => 'Use metric units';

  @override
  String get kilometers => 'Kilometers';

  @override
  String get miles => 'Miles';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get alarmDefaults => 'Alarm defaults';

  @override
  String get defaultAlertDistance => 'Default alert distance';

  @override
  String get battery => 'Battery';

  @override
  String get gpsProfile => 'GPS profile';

  @override
  String get batteryBalanced => 'Balanced';

  @override
  String get batteryAggressive => 'Aggressive';

  @override
  String get batterySaver => 'Saver';

  @override
  String get batteryBalancedDesc =>
      'Best for daily commutes - updates every ~10 m';

  @override
  String get batteryAggressiveDesc =>
      'Maximum reliability - more battery use near destination';

  @override
  String get batterySaverDesc => 'Minimum GPS use - may reduce accuracy';

  @override
  String get data => 'Data';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get exportBackupSubtitle =>
      'Save alarms, favorites, settings, and history';

  @override
  String get importBackup => 'Import backup';

  @override
  String get importBackupSubtitle => 'Restore from a JSON backup file';

  @override
  String get importBackupTitle => 'Import backup?';

  @override
  String get importBackupBody =>
      'New alarms, favorites, history, and settings from the file will be merged into this device. Running alarms are not included in backups.';

  @override
  String get import => 'Import';

  @override
  String get backupReady => 'Backup ready to share';

  @override
  String importedSummary(
    int alarms,
    int favorites,
    int history,
    String settings,
  ) {
    return 'Imported $alarms alarms, $favorites favorites, $history history entries$settings.';
  }

  @override
  String get importedSettingsSuffix => ', settings';

  @override
  String get more => 'More';

  @override
  String get permissionsMenu => 'Permissions';

  @override
  String get privacyMenu => 'Privacy';

  @override
  String get aboutMenu => 'About';

  @override
  String get debugMenu => 'Debug';

  @override
  String get aboutTitle => 'About';

  @override
  String get developedBy => 'Developed by NomadProgrammer';

  @override
  String get aboutTagline =>
      'A privacy-first location alarm. Free forever. No ads. No tracking.';

  @override
  String get openSourceLicenses => 'Open source licenses';

  @override
  String get viewOnGitHub => 'View on GitHub';

  @override
  String get licensesTitle => 'Open source licenses';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyHeading => 'Your privacy matters';

  @override
  String get privacyBullet1 => 'No account or login required';

  @override
  String get privacyBullet2 => 'No ads or analytics';

  @override
  String get privacyBullet3 =>
      'No cloud storage - all data stays on your device';

  @override
  String get privacyBullet4 =>
      'Location is used only for alarm distance calculation';

  @override
  String get privacyBullet5 => 'Open source - inspect the code anytime';

  @override
  String get fullPrivacyPolicy => 'Full privacy policy';

  @override
  String get cancel => 'Cancel';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get semCreateAlarm => 'Create a new location alarm';

  @override
  String get semCancelAlarm => 'Cancel active alarm';

  @override
  String get semDismissAlarm => 'Dismiss ringing alarm';

  @override
  String get semSnoozeAlarm => 'Snooze alarm for two minutes';

  @override
  String get semExportBackup => 'Export backup file';

  @override
  String get semImportBackup => 'Import backup file';

  @override
  String get permCenterTitle => 'Permission Center';

  @override
  String get permGranted => 'Granted';

  @override
  String get permDenied => 'Denied';

  @override
  String get permPermanentlyDenied => 'Permanently denied - open settings';

  @override
  String get permFix => 'Fix';

  @override
  String get searchHintExtended => 'Station, landmark, address…';

  @override
  String searchFailed(String message) {
    return 'Search failed: $message';
  }

  @override
  String get noResultsFound => 'No results found';

  @override
  String get savedToFavorites => 'Saved to favorites';

  @override
  String get searchEmptyHint => 'Search for a station, landmark, or address';

  @override
  String get importFromClipboard => 'Import from clipboard';

  @override
  String get deepLinkInvalid => 'Could not parse location from clipboard';

  @override
  String get deepLinkImported => 'Destination imported';

  @override
  String get mapTitle => 'Map';

  @override
  String get droppedPin => 'Dropped pin';

  @override
  String get lookingUpAddress => 'Looking up address…';

  @override
  String get setAlarm => 'Set Alarm';

  @override
  String get saveFavorite => 'Save Favorite';

  @override
  String get semCenterOnMap => 'Center map on your location';

  @override
  String get semSetAlarmFromPin => 'Set alarm for dropped pin';

  @override
  String get historyTitle => 'History';

  @override
  String get filterAll => 'All';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get filterMissed => 'Missed';

  @override
  String get noHistoryTitle => 'No history yet';

  @override
  String get noHistoryMessage =>
      'Completed and missed alarms will be logged here.';

  @override
  String get deleteEntryTitle => 'Delete entry?';

  @override
  String deleteEntryBody(String name) {
    return 'Remove \"$name\" from history?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get dateLabel => 'Date';

  @override
  String get triggerDistanceLabel => 'Trigger distance';

  @override
  String get snoozesLabel => 'Snoozes';

  @override
  String get notesLabel => 'Notes';

  @override
  String get outcomeCompleted => 'Completed';

  @override
  String get outcomeMissed => 'Missed';

  @override
  String get outcomeDismissed => 'Dismissed';

  @override
  String get outcomeSnoozed => 'Snoozed';

  @override
  String get semDeleteHistoryEntry => 'Delete history entry';

  @override
  String get tripsTitle => 'Trips';

  @override
  String get noTripsTitle => 'No trips yet';

  @override
  String get noTripsMessage => 'Your completed journeys will appear here.';

  @override
  String get startedLabel => 'Started';

  @override
  String get endedLabel => 'Ended';

  @override
  String get durationLabel => 'Duration';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get maxSpeedLabel => 'Max speed';

  @override
  String get avgSpeedLabel => 'Avg speed';

  @override
  String get alarmIdLabel => 'Alarm ID';

  @override
  String get tripOutcomeCancelled => 'Cancelled';

  @override
  String get tripOutcomePassed => 'Passed';

  @override
  String get saveFavoriteTrip => 'Save as favorite trip';

  @override
  String get favoriteTripSaved => 'Favorite trip saved';

  @override
  String get createAlarmFromTrip => 'Create alarm from trip';

  @override
  String get semSaveFavoriteTrip => 'Save trip as favorite';

  @override
  String get semCreateAlarmFromTrip => 'Create new alarm from this trip';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get kmhUnit => 'km/h';

  @override
  String get notifTrackingChannel => 'Active Alarm';

  @override
  String get notifTrackingChannelDesc =>
      'Shows distance while alarm is tracking';

  @override
  String get notifAlarmChannel => 'Alarm Ring';

  @override
  String get notifAlarmChannelDesc => 'Alerts when you reach your destination';

  @override
  String get notifWarningsChannel => 'Warnings';

  @override
  String get notifGpsLostTitle => 'GPS signal lost';

  @override
  String get notifGpsLostBody => 'Location updates paused - check your GPS';

  @override
  String get notifLowBatteryTitle => 'Low battery';

  @override
  String get notifLowBatteryBody =>
      'Charge your phone to keep the alarm running reliably';

  @override
  String notifToDestination(String distance) {
    return '$distance to destination';
  }

  @override
  String get widgetNoActiveAlarm => 'No active alarm';

  @override
  String get widgetTracking => 'Tracking…';

  @override
  String get widgetTapToOpen => 'Tap to open';

  @override
  String tileActiveDistance(String distance) {
    return '$distance away';
  }

  @override
  String get semSearchSubmit => 'Search for destination';

  @override
  String get semImportFromClipboard => 'Import destination from clipboard';

  @override
  String get metersUnit => 'm';

  @override
  String get mphUnit => 'mph';

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugUnavailable => 'Debug screen unavailable';

  @override
  String get debugBackgroundService => 'Background service';

  @override
  String get debugBattery => 'Battery';

  @override
  String get debugActiveAlarmId => 'Active alarm ID';

  @override
  String get debugLoadingGps => 'Loading GPS state…';

  @override
  String get debugDistance => 'Distance';

  @override
  String get debugEta => 'ETA';

  @override
  String get debugSpeed => 'Speed';

  @override
  String get debugAccuracy => 'Accuracy';

  @override
  String get debugGpsLost => 'GPS lost';

  @override
  String get debugLowBattery => 'Low battery flag';

  @override
  String get debugPosition => 'Position';

  @override
  String get debugCharging => 'charging';

  @override
  String get debugDischarging => 'discharging';

  @override
  String get debugCopySnapshot => 'Copy snapshot';

  @override
  String get debugRefresh => 'Refresh';

  @override
  String get debugSnapshotCopied => 'Debug snapshot copied';

  @override
  String get fgsStartingTitle => 'Nomad Alarm';

  @override
  String get fgsStartingContent => 'Starting location tracking…';

  @override
  String get resumeAlarmAfterBoot => 'Resume alarm after reboot';

  @override
  String get resumeAlarmAfterBootSubtitle =>
      'Relaunch tracking when the device restarts (uses more battery)';

  @override
  String get mapsSection => 'Maps & routing';

  @override
  String get mapSettingsTitle => 'Map settings';

  @override
  String get mapSettingsSubtitle => 'Providers, offline tiles, API keys';

  @override
  String get mapProvidersSection => 'Providers';

  @override
  String get mapProviderLabel => 'Map provider';

  @override
  String get searchProviderLabel => 'Search provider';

  @override
  String get routeProviderLabel => 'Route provider';

  @override
  String get mapProviderOsm => 'OpenStreetMap';

  @override
  String get mapProviderGoogle => 'Google Maps';

  @override
  String get mapProviderMapbox => 'Mapbox';

  @override
  String get mapProviderHere => 'HERE';

  @override
  String get searchProviderNominatim => 'Nominatim (OSM)';

  @override
  String get searchProviderGooglePlaces => 'Google Places';

  @override
  String get searchProviderPhoton => 'Photon';

  @override
  String get searchProviderPelias => 'Pelias';

  @override
  String get searchProviderHere => 'HERE';

  @override
  String get routeProviderOsrm => 'OSRM';

  @override
  String get routeProviderGoogle => 'Google Directions';

  @override
  String get routeProviderGraphhopper => 'GraphHopper';

  @override
  String get routeProviderValhalla => 'Valhalla';

  @override
  String get apiKeysTitle => 'API keys';

  @override
  String get apiKeysIntro =>
      'Keys are stored encrypted on device and never included in backups.';

  @override
  String get apiKeySaved => 'API key saved';

  @override
  String get apiKeyTest => 'Test';

  @override
  String get apiKeyTestSuccess => 'Connection successful';

  @override
  String get apiKeyTestFailure => 'Connection failed - check the key';

  @override
  String get apiKeyGoogle => 'Google API key';

  @override
  String get apiKeyGoogleHint => 'One key for Maps, Places, and Directions';

  @override
  String get apiKeyGoogleHelp => 'Setup guide';

  @override
  String get googleMapKeyRequired =>
      'Google Maps requires an API key. Add one in Settings, then choose Google as the map provider.';

  @override
  String get googleMapKeyRequiredAction => 'Open API keys';

  @override
  String get googleMapKeySetupGuide => 'How to create a Google API key';

  @override
  String get apiKeyGoogleMaps => 'Google Maps SDK';

  @override
  String get apiKeyGooglePlaces => 'Google Places';

  @override
  String get apiKeyGoogleDirections => 'Google Directions';

  @override
  String get apiKeyMapbox => 'Mapbox access token';

  @override
  String get apiKeyHere => 'HERE API key';

  @override
  String get apiKeyGraphhopper => 'GraphHopper API key';

  @override
  String get apiKeyGoogleMapsHint =>
      'Also add to AndroidManifest for native map';

  @override
  String get apiKeyGooglePlacesHint => 'Places API key';

  @override
  String get apiKeyGoogleDirectionsHint => 'Directions API key';

  @override
  String get apiKeyMapboxHint => 'pk.… token';

  @override
  String get apiKeyHereHint => 'HERE REST API key';

  @override
  String get apiKeyGraphhopperHint => 'Optional for higher limits';

  @override
  String get saveKey => 'Save';

  @override
  String get mapOfflineSection => 'Offline tiles';

  @override
  String get mapOfflineCacheSize => 'Cache size';

  @override
  String get mapOfflineDownload => 'Download sample region';

  @override
  String get mapOfflineDownloadSubtitle =>
      'London area, zoom 10–16 (OSM/Mapbox/HERE tiles)';

  @override
  String get mapOfflineDownloadComplete => 'Offline region downloaded';

  @override
  String get mapOfflineClearCache => 'Clear offline cache';

  @override
  String get mapOfflineCacheCleared => 'Offline cache cleared';

  @override
  String get mapOfflineGoogleUnsupported =>
      'Offline tiles are not available for Google native map';

  @override
  String get mapLayerLabel => 'Map layer';

  @override
  String get mapLayerStandard => 'Standard';

  @override
  String get mapLayerSatellite => 'Satellite';

  @override
  String get mapLayerDark => 'Dark';

  @override
  String get alarmTypeLabel => 'Alarm type';

  @override
  String get alarmTypeDistance => 'Distance';

  @override
  String get alarmTypeArrival => 'Arrival (geofence enter)';

  @override
  String get alarmTypeDeparture => 'Departure (geofence exit)';

  @override
  String get alarmTypeRadius => 'Radius';

  @override
  String get alarmTypeEta => 'ETA';

  @override
  String get alarmTypeSpeed => 'Speed';

  @override
  String get alarmTypeGeofence => 'Geofence';

  @override
  String get travelModeLabel => 'Travel mode';

  @override
  String get travelModeTrain => 'Train';

  @override
  String get travelModeBus => 'Bus';

  @override
  String get travelModeMetro => 'Metro';

  @override
  String get travelModeCar => 'Car';

  @override
  String get travelModeWalking => 'Walking';

  @override
  String get travelModeCycling => 'Cycling';

  @override
  String get travelModeAuto => 'Auto detect';

  @override
  String get speedThresholdLabel => 'Speed threshold';

  @override
  String get etaTriggerMinutes => 'Alert when ETA below (minutes)';

  @override
  String get shareAlarmConfig => 'Share alarm';

  @override
  String get shareAlarmConfigSuccess => 'Alarm config copied to clipboard';

  @override
  String get groupTravelTitle => 'Group travel';

  @override
  String get customRingtone => 'Custom ringtone';

  @override
  String get pickRingtone => 'Pick ringtone';

  @override
  String get arabic => 'Arabic';

  @override
  String get hebrew => 'Hebrew';

  @override
  String get cloudBackupUpload => 'Upload backup to cloud';

  @override
  String get cloudBackupUrlHint => 'HTTPS upload URL';

  @override
  String get cloudBackupSuccess => 'Backup uploaded successfully';

  @override
  String get cloudBackupFailed => 'Cloud upload failed';

  @override
  String get importAlarmConfig => 'Alarm config imported';

  @override
  String get lockScreenInfo => 'Show on lock screen';

  @override
  String get lockScreenInfoSubtitle =>
      'Display distance and ETA on lock screen notifications';

  @override
  String get notifInternetLostTitle => 'Internet connection lost';

  @override
  String get notifInternetLostBody =>
      'Route ETA may be unavailable until connection returns';

  @override
  String get shareAllAlarms => 'Share active alarms';

  @override
  String get importAlarmBundle => 'Import alarm bundle';

  @override
  String alarmBundleImported(int count) {
    return 'Imported $count alarms';
  }

  @override
  String get mapLayerTerrain => 'Terrain';

  @override
  String get mapProviderApple => 'Apple Maps';

  @override
  String get highContrast => 'High contrast';

  @override
  String get highContrastSubtitle => 'Increase contrast for readability';

  @override
  String get voiceSearchHint => 'Speak destination name';

  @override
  String get tileTapToCancel => 'Tap to cancel alarm';

  @override
  String get tileTapToCreate => 'Tap to create alarm';
}
