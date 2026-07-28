import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Nomad Alarm'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get navTrips;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @createAlarm.
  ///
  /// In en, this message translates to:
  /// **'Create Alarm'**
  String get createAlarm;

  /// No description provided for @searchDestinationHint.
  ///
  /// In en, this message translates to:
  /// **'Search destination…'**
  String get searchDestinationHint;

  /// No description provided for @activeAlarms.
  ///
  /// In en, this message translates to:
  /// **'Active alarms'**
  String get activeAlarms;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @firstAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your first destination alarm'**
  String get firstAlarmTitle;

  /// No description provided for @firstAlarmBody.
  ///
  /// In en, this message translates to:
  /// **'Search for a place or drop a pin on the map.'**
  String get firstAlarmBody;

  /// No description provided for @searchDestination.
  ///
  /// In en, this message translates to:
  /// **'Search destination'**
  String get searchDestination;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting location…'**
  String get gettingLocation;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable - tap to open map'**
  String get locationUnavailable;

  /// No description provided for @activeAlarmFallback.
  ///
  /// In en, this message translates to:
  /// **'Active alarm'**
  String get activeAlarmFallback;

  /// No description provided for @alarmRingingDistance.
  ///
  /// In en, this message translates to:
  /// **'Alarm ringing - {distance} away'**
  String alarmRingingDistance(String distance);

  /// No description provided for @distanceAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String distanceAway(String distance);

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Never miss your stop again'**
  String get welcomeTitle;

  /// No description provided for @welcomeBullet1.
  ///
  /// In en, this message translates to:
  /// **'100% free - no ads, no subscriptions'**
  String get welcomeBullet1;

  /// No description provided for @welcomeBullet2.
  ///
  /// In en, this message translates to:
  /// **'Privacy first - no login, no tracking'**
  String get welcomeBullet2;

  /// No description provided for @welcomeBullet3.
  ///
  /// In en, this message translates to:
  /// **'Works offline for active alarms'**
  String get welcomeBullet3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @permissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions ({current}/{total})'**
  String permissionsTitle(int current, int total);

  /// No description provided for @grant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get grant;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @permLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location access'**
  String get permLocationTitle;

  /// No description provided for @permLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'We need your location to calculate distance to your destination.'**
  String get permLocationDesc;

  /// No description provided for @permNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permNotificationTitle;

  /// No description provided for @permNotificationDesc.
  ///
  /// In en, this message translates to:
  /// **'We show a small notification while your alarm is active.'**
  String get permNotificationDesc;

  /// No description provided for @permBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Background location'**
  String get permBackgroundTitle;

  /// No description provided for @permBackgroundDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow all the time so the alarm works while your screen is off.'**
  String get permBackgroundDesc;

  /// No description provided for @permExactAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms'**
  String get permExactAlarmTitle;

  /// No description provided for @permExactAlarmDesc.
  ///
  /// In en, this message translates to:
  /// **'Allows reliable wake-up when you reach your destination (Android 12+).'**
  String get permExactAlarmDesc;

  /// No description provided for @permBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery optimization'**
  String get permBatteryTitle;

  /// No description provided for @permBatteryDesc.
  ///
  /// In en, this message translates to:
  /// **'Disabling battery optimization helps GPS keep running in the background. You can skip this, but tracking may stop on some devices.'**
  String get permBatteryDesc;

  /// No description provided for @activeAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Alarm'**
  String get activeAlarmTitle;

  /// No description provided for @estimatedArrival.
  ///
  /// In en, this message translates to:
  /// **'estimated arrival'**
  String get estimatedArrival;

  /// No description provided for @gpsLostWarning.
  ///
  /// In en, this message translates to:
  /// **'GPS signal lost - last fix may be stale'**
  String get gpsLostWarning;

  /// No description provided for @passedDestinationWarning.
  ///
  /// In en, this message translates to:
  /// **'You may have passed your destination'**
  String get passedDestinationWarning;

  /// No description provided for @lowBatteryWarning.
  ///
  /// In en, this message translates to:
  /// **'Low battery - charge your phone to keep tracking reliable'**
  String get lowBatteryWarning;

  /// No description provided for @alarmPaused.
  ///
  /// In en, this message translates to:
  /// **'Alarm paused'**
  String get alarmPaused;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @openMap.
  ///
  /// In en, this message translates to:
  /// **'Open Map'**
  String get openMap;

  /// No description provided for @cancelAlarm.
  ///
  /// In en, this message translates to:
  /// **'Cancel Alarm'**
  String get cancelAlarm;

  /// No description provided for @stopApproaching.
  ///
  /// In en, this message translates to:
  /// **'Stop approaching!'**
  String get stopApproaching;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @snoozeTwoMin.
  ///
  /// In en, this message translates to:
  /// **'Snooze 2 min'**
  String get snoozeTwoMin;

  /// No description provided for @createAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Alarm'**
  String get createAlarmTitle;

  /// No description provided for @noDestinationSelected.
  ///
  /// In en, this message translates to:
  /// **'No destination selected'**
  String get noDestinationSelected;

  /// No description provided for @selectDestinationFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a destination first'**
  String get selectDestinationFirst;

  /// No description provided for @alarmSaved.
  ///
  /// In en, this message translates to:
  /// **'Alarm saved'**
  String get alarmSaved;

  /// No description provided for @alertDistance.
  ///
  /// In en, this message translates to:
  /// **'Alert distance'**
  String get alertDistance;

  /// No description provided for @voiceAlert.
  ///
  /// In en, this message translates to:
  /// **'Voice alert'**
  String get voiceAlert;

  /// No description provided for @voiceAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Spoken alert when triggered'**
  String get voiceAlertSubtitle;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @flashlight.
  ///
  /// In en, this message translates to:
  /// **'Flashlight'**
  String get flashlight;

  /// No description provided for @flashlightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'LED strobe when alarm rings'**
  String get flashlightSubtitle;

  /// No description provided for @saveAndStart.
  ///
  /// In en, this message translates to:
  /// **'Save & Start'**
  String get saveAndStart;

  /// No description provided for @saveOnly.
  ///
  /// In en, this message translates to:
  /// **'Save only'**
  String get saveOnly;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @useMetricUnits.
  ///
  /// In en, this message translates to:
  /// **'Use metric units'**
  String get useMetricUnits;

  /// No description provided for @kilometers.
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get kilometers;

  /// No description provided for @miles.
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get miles;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @alarmDefaults.
  ///
  /// In en, this message translates to:
  /// **'Alarm defaults'**
  String get alarmDefaults;

  /// No description provided for @defaultAlertDistance.
  ///
  /// In en, this message translates to:
  /// **'Default alert distance'**
  String get defaultAlertDistance;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @gpsProfile.
  ///
  /// In en, this message translates to:
  /// **'GPS profile'**
  String get gpsProfile;

  /// No description provided for @batteryBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get batteryBalanced;

  /// No description provided for @batteryAggressive.
  ///
  /// In en, this message translates to:
  /// **'Aggressive'**
  String get batteryAggressive;

  /// No description provided for @batterySaver.
  ///
  /// In en, this message translates to:
  /// **'Saver'**
  String get batterySaver;

  /// No description provided for @batteryBalancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Best for daily commutes - updates every ~10 m'**
  String get batteryBalancedDesc;

  /// No description provided for @batteryAggressiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Maximum reliability - more battery use near destination'**
  String get batteryAggressiveDesc;

  /// No description provided for @batterySaverDesc.
  ///
  /// In en, this message translates to:
  /// **'Minimum GPS use - may reduce accuracy'**
  String get batterySaverDesc;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @exportBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save alarms, favorites, settings, and history'**
  String get exportBackupSubtitle;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get importBackup;

  /// No description provided for @importBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from a JSON backup file'**
  String get importBackupSubtitle;

  /// No description provided for @importBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Import backup?'**
  String get importBackupTitle;

  /// No description provided for @importBackupBody.
  ///
  /// In en, this message translates to:
  /// **'New alarms, favorites, history, and settings from the file will be merged into this device. Running alarms are not included in backups.'**
  String get importBackupBody;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @backupReady.
  ///
  /// In en, this message translates to:
  /// **'Backup ready to share'**
  String get backupReady;

  /// No description provided for @importedSummary.
  ///
  /// In en, this message translates to:
  /// **'Imported {alarms} alarms, {favorites} favorites, {history} history entries{settings}.'**
  String importedSummary(
    int alarms,
    int favorites,
    int history,
    String settings,
  );

  /// No description provided for @importedSettingsSuffix.
  ///
  /// In en, this message translates to:
  /// **', settings'**
  String get importedSettingsSuffix;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @permissionsMenu.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissionsMenu;

  /// No description provided for @privacyMenu.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyMenu;

  /// No description provided for @aboutMenu.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutMenu;

  /// No description provided for @debugMenu.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debugMenu;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by NomadProgrammer'**
  String get developedBy;

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'A privacy-first location alarm. Free forever. No ads. No tracking.'**
  String get aboutTagline;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get openSourceLicenses;

  /// No description provided for @viewOnGitHub.
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get viewOnGitHub;

  /// No description provided for @licensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get licensesTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyHeading.
  ///
  /// In en, this message translates to:
  /// **'Your privacy matters'**
  String get privacyHeading;

  /// No description provided for @privacyBullet1.
  ///
  /// In en, this message translates to:
  /// **'No account or login required'**
  String get privacyBullet1;

  /// No description provided for @privacyBullet2.
  ///
  /// In en, this message translates to:
  /// **'No ads or analytics'**
  String get privacyBullet2;

  /// No description provided for @privacyBullet3.
  ///
  /// In en, this message translates to:
  /// **'No cloud storage - all data stays on your device'**
  String get privacyBullet3;

  /// No description provided for @privacyBullet4.
  ///
  /// In en, this message translates to:
  /// **'Location is used only for alarm distance calculation'**
  String get privacyBullet4;

  /// No description provided for @privacyBullet5.
  ///
  /// In en, this message translates to:
  /// **'Open source - inspect the code anytime'**
  String get privacyBullet5;

  /// No description provided for @fullPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Full privacy policy'**
  String get fullPrivacyPolicy;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(String message);

  /// No description provided for @semCreateAlarm.
  ///
  /// In en, this message translates to:
  /// **'Create a new location alarm'**
  String get semCreateAlarm;

  /// No description provided for @semCancelAlarm.
  ///
  /// In en, this message translates to:
  /// **'Cancel active alarm'**
  String get semCancelAlarm;

  /// No description provided for @semDismissAlarm.
  ///
  /// In en, this message translates to:
  /// **'Dismiss ringing alarm'**
  String get semDismissAlarm;

  /// No description provided for @semSnoozeAlarm.
  ///
  /// In en, this message translates to:
  /// **'Snooze alarm for two minutes'**
  String get semSnoozeAlarm;

  /// No description provided for @semExportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup file'**
  String get semExportBackup;

  /// No description provided for @semImportBackup.
  ///
  /// In en, this message translates to:
  /// **'Import backup file'**
  String get semImportBackup;

  /// No description provided for @permCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Center'**
  String get permCenterTitle;

  /// No description provided for @permGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get permGranted;

  /// No description provided for @permDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get permDenied;

  /// No description provided for @permPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Permanently denied - open settings'**
  String get permPermanentlyDenied;

  /// No description provided for @permFix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get permFix;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
