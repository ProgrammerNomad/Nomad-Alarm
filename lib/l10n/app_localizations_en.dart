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
}
