import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_he.dart';
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
    Locale('ar'),
    Locale('en'),
    Locale('he'),
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

  /// No description provided for @distanceUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance units'**
  String get distanceUnitsLabel;

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

  /// No description provided for @searchHintExtended.
  ///
  /// In en, this message translates to:
  /// **'Station, landmark, address…'**
  String get searchHintExtended;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed: {message}'**
  String searchFailed(String message);

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @savedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved to favorites'**
  String get savedToFavorites;

  /// No description provided for @searchEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a station, landmark, or address'**
  String get searchEmptyHint;

  /// No description provided for @importFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Import from clipboard'**
  String get importFromClipboard;

  /// No description provided for @deepLinkInvalid.
  ///
  /// In en, this message translates to:
  /// **'Could not parse location from clipboard'**
  String get deepLinkInvalid;

  /// No description provided for @deepLinkImported.
  ///
  /// In en, this message translates to:
  /// **'Destination imported'**
  String get deepLinkImported;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTitle;

  /// No description provided for @droppedPin.
  ///
  /// In en, this message translates to:
  /// **'Dropped pin'**
  String get droppedPin;

  /// No description provided for @lookingUpAddress.
  ///
  /// In en, this message translates to:
  /// **'Looking up address…'**
  String get lookingUpAddress;

  /// No description provided for @setAlarm.
  ///
  /// In en, this message translates to:
  /// **'Set Alarm'**
  String get setAlarm;

  /// No description provided for @saveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Save Favorite'**
  String get saveFavorite;

  /// No description provided for @semCenterOnMap.
  ///
  /// In en, this message translates to:
  /// **'Center map on your location'**
  String get semCenterOnMap;

  /// No description provided for @semSetAlarmFromPin.
  ///
  /// In en, this message translates to:
  /// **'Set alarm for dropped pin'**
  String get semSetAlarmFromPin;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get filterCompleted;

  /// No description provided for @filterMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get filterMissed;

  /// No description provided for @noHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryTitle;

  /// No description provided for @noHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Completed and missed alarms will be logged here.'**
  String get noHistoryMessage;

  /// No description provided for @deleteEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete entry?'**
  String get deleteEntryTitle;

  /// No description provided for @deleteEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from history?'**
  String deleteEntryBody(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @triggerDistanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Trigger distance'**
  String get triggerDistanceLabel;

  /// No description provided for @snoozesLabel.
  ///
  /// In en, this message translates to:
  /// **'Snoozes'**
  String get snoozesLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @outcomeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get outcomeCompleted;

  /// No description provided for @outcomeMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get outcomeMissed;

  /// No description provided for @outcomeDismissed.
  ///
  /// In en, this message translates to:
  /// **'Dismissed'**
  String get outcomeDismissed;

  /// No description provided for @outcomeSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get outcomeSnoozed;

  /// No description provided for @semDeleteHistoryEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete history entry'**
  String get semDeleteHistoryEntry;

  /// No description provided for @tripsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tripsTitle;

  /// No description provided for @noTripsTitle.
  ///
  /// In en, this message translates to:
  /// **'No trips yet'**
  String get noTripsTitle;

  /// No description provided for @noTripsMessage.
  ///
  /// In en, this message translates to:
  /// **'Your completed journeys will appear here.'**
  String get noTripsMessage;

  /// No description provided for @startedLabel.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get startedLabel;

  /// No description provided for @endedLabel.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get endedLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @maxSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Max speed'**
  String get maxSpeedLabel;

  /// No description provided for @avgSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg speed'**
  String get avgSpeedLabel;

  /// No description provided for @alarmIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Alarm ID'**
  String get alarmIdLabel;

  /// No description provided for @tripOutcomeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tripOutcomeCancelled;

  /// No description provided for @tripOutcomePassed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get tripOutcomePassed;

  /// No description provided for @saveFavoriteTrip.
  ///
  /// In en, this message translates to:
  /// **'Save as favorite trip'**
  String get saveFavoriteTrip;

  /// No description provided for @favoriteTripSaved.
  ///
  /// In en, this message translates to:
  /// **'Favorite trip saved'**
  String get favoriteTripSaved;

  /// No description provided for @createAlarmFromTrip.
  ///
  /// In en, this message translates to:
  /// **'Create alarm from trip'**
  String get createAlarmFromTrip;

  /// No description provided for @semSaveFavoriteTrip.
  ///
  /// In en, this message translates to:
  /// **'Save trip as favorite'**
  String get semSaveFavoriteTrip;

  /// No description provided for @semCreateAlarmFromTrip.
  ///
  /// In en, this message translates to:
  /// **'Create new alarm from this trip'**
  String get semCreateAlarmFromTrip;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @kmhUnit.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get kmhUnit;

  /// No description provided for @notifTrackingChannel.
  ///
  /// In en, this message translates to:
  /// **'Active Alarm'**
  String get notifTrackingChannel;

  /// No description provided for @notifTrackingChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Shows distance while alarm is tracking'**
  String get notifTrackingChannelDesc;

  /// No description provided for @notifAlarmChannel.
  ///
  /// In en, this message translates to:
  /// **'Alarm Ring'**
  String get notifAlarmChannel;

  /// No description provided for @notifAlarmChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Alerts when you reach your destination'**
  String get notifAlarmChannelDesc;

  /// No description provided for @notifWarningsChannel.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get notifWarningsChannel;

  /// No description provided for @notifGpsLostTitle.
  ///
  /// In en, this message translates to:
  /// **'GPS signal lost'**
  String get notifGpsLostTitle;

  /// No description provided for @notifGpsLostBody.
  ///
  /// In en, this message translates to:
  /// **'Location updates paused - check your GPS'**
  String get notifGpsLostBody;

  /// No description provided for @notifLowBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Low battery'**
  String get notifLowBatteryTitle;

  /// No description provided for @notifLowBatteryBody.
  ///
  /// In en, this message translates to:
  /// **'Charge your phone to keep the alarm running reliably'**
  String get notifLowBatteryBody;

  /// No description provided for @notifToDestination.
  ///
  /// In en, this message translates to:
  /// **'{distance} to destination'**
  String notifToDestination(String distance);

  /// No description provided for @widgetNoActiveAlarm.
  ///
  /// In en, this message translates to:
  /// **'No active alarm'**
  String get widgetNoActiveAlarm;

  /// No description provided for @widgetTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking…'**
  String get widgetTracking;

  /// No description provided for @widgetTapToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to open'**
  String get widgetTapToOpen;

  /// No description provided for @tileActiveDistance.
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String tileActiveDistance(String distance);

  /// No description provided for @semSearchSubmit.
  ///
  /// In en, this message translates to:
  /// **'Search for destination'**
  String get semSearchSubmit;

  /// No description provided for @semImportFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Import destination from clipboard'**
  String get semImportFromClipboard;

  /// No description provided for @metersUnit.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get metersUnit;

  /// No description provided for @mphUnit.
  ///
  /// In en, this message translates to:
  /// **'mph'**
  String get mphUnit;

  /// No description provided for @debugTitle.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debugTitle;

  /// No description provided for @debugUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Debug screen unavailable'**
  String get debugUnavailable;

  /// No description provided for @debugBackgroundService.
  ///
  /// In en, this message translates to:
  /// **'Background service'**
  String get debugBackgroundService;

  /// No description provided for @debugBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get debugBattery;

  /// No description provided for @debugActiveAlarmId.
  ///
  /// In en, this message translates to:
  /// **'Active alarm ID'**
  String get debugActiveAlarmId;

  /// No description provided for @debugLoadingGps.
  ///
  /// In en, this message translates to:
  /// **'Loading GPS state…'**
  String get debugLoadingGps;

  /// No description provided for @debugDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get debugDistance;

  /// No description provided for @debugEta.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get debugEta;

  /// No description provided for @debugSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get debugSpeed;

  /// No description provided for @debugAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get debugAccuracy;

  /// No description provided for @debugGpsLost.
  ///
  /// In en, this message translates to:
  /// **'GPS lost'**
  String get debugGpsLost;

  /// No description provided for @debugLowBattery.
  ///
  /// In en, this message translates to:
  /// **'Low battery flag'**
  String get debugLowBattery;

  /// No description provided for @debugPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get debugPosition;

  /// No description provided for @debugCharging.
  ///
  /// In en, this message translates to:
  /// **'charging'**
  String get debugCharging;

  /// No description provided for @debugDischarging.
  ///
  /// In en, this message translates to:
  /// **'discharging'**
  String get debugDischarging;

  /// No description provided for @debugCopySnapshot.
  ///
  /// In en, this message translates to:
  /// **'Copy snapshot'**
  String get debugCopySnapshot;

  /// No description provided for @debugRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get debugRefresh;

  /// No description provided for @debugSnapshotCopied.
  ///
  /// In en, this message translates to:
  /// **'Debug snapshot copied'**
  String get debugSnapshotCopied;

  /// No description provided for @fgsStartingTitle.
  ///
  /// In en, this message translates to:
  /// **'Nomad Alarm'**
  String get fgsStartingTitle;

  /// No description provided for @fgsStartingContent.
  ///
  /// In en, this message translates to:
  /// **'Starting location tracking…'**
  String get fgsStartingContent;

  /// No description provided for @resumeAlarmAfterBoot.
  ///
  /// In en, this message translates to:
  /// **'Resume alarm after reboot'**
  String get resumeAlarmAfterBoot;

  /// No description provided for @resumeAlarmAfterBootSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Relaunch tracking when the device restarts (uses more battery)'**
  String get resumeAlarmAfterBootSubtitle;

  /// No description provided for @mapsSection.
  ///
  /// In en, this message translates to:
  /// **'Maps & routing'**
  String get mapsSection;

  /// No description provided for @mapSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Map settings'**
  String get mapSettingsTitle;

  /// No description provided for @mapSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Providers, layers, and offline tiles'**
  String get mapSettingsSubtitle;

  /// No description provided for @mapProvidersSection.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get mapProvidersSection;

  /// No description provided for @mapProviderLabel.
  ///
  /// In en, this message translates to:
  /// **'Map provider'**
  String get mapProviderLabel;

  /// No description provided for @searchProviderLabel.
  ///
  /// In en, this message translates to:
  /// **'Search provider'**
  String get searchProviderLabel;

  /// No description provided for @routeProviderLabel.
  ///
  /// In en, this message translates to:
  /// **'Route provider'**
  String get routeProviderLabel;

  /// No description provided for @mapProviderOsm.
  ///
  /// In en, this message translates to:
  /// **'OpenStreetMap'**
  String get mapProviderOsm;

  /// No description provided for @mapProviderGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get mapProviderGoogle;

  /// No description provided for @mapProviderMapbox.
  ///
  /// In en, this message translates to:
  /// **'Mapbox'**
  String get mapProviderMapbox;

  /// No description provided for @mapProviderHere.
  ///
  /// In en, this message translates to:
  /// **'HERE'**
  String get mapProviderHere;

  /// No description provided for @searchProviderNominatim.
  ///
  /// In en, this message translates to:
  /// **'Nominatim (OSM)'**
  String get searchProviderNominatim;

  /// No description provided for @searchProviderGooglePlaces.
  ///
  /// In en, this message translates to:
  /// **'Google Places'**
  String get searchProviderGooglePlaces;

  /// No description provided for @searchProviderPhoton.
  ///
  /// In en, this message translates to:
  /// **'Photon'**
  String get searchProviderPhoton;

  /// No description provided for @searchProviderPelias.
  ///
  /// In en, this message translates to:
  /// **'Pelias'**
  String get searchProviderPelias;

  /// No description provided for @searchProviderHere.
  ///
  /// In en, this message translates to:
  /// **'HERE'**
  String get searchProviderHere;

  /// No description provided for @routeProviderOsrm.
  ///
  /// In en, this message translates to:
  /// **'OSRM'**
  String get routeProviderOsrm;

  /// No description provided for @routeProviderGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google Directions'**
  String get routeProviderGoogle;

  /// No description provided for @routeProviderGraphhopper.
  ///
  /// In en, this message translates to:
  /// **'GraphHopper'**
  String get routeProviderGraphhopper;

  /// No description provided for @routeProviderValhalla.
  ///
  /// In en, this message translates to:
  /// **'Valhalla'**
  String get routeProviderValhalla;

  /// No description provided for @apiKeysTitle.
  ///
  /// In en, this message translates to:
  /// **'API keys'**
  String get apiKeysTitle;

  /// No description provided for @apiKeysIntro.
  ///
  /// In en, this message translates to:
  /// **'Keys are stored encrypted on device and never included in backups.'**
  String get apiKeysIntro;

  /// No description provided for @apiKeySaved.
  ///
  /// In en, this message translates to:
  /// **'API key saved'**
  String get apiKeySaved;

  /// No description provided for @apiKeyTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get apiKeyTest;

  /// No description provided for @apiKeyTestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connection successful'**
  String get apiKeyTestSuccess;

  /// No description provided for @apiKeyTestFailure.
  ///
  /// In en, this message translates to:
  /// **'Connection failed - check the key'**
  String get apiKeyTestFailure;

  /// No description provided for @apiKeyGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google API key'**
  String get apiKeyGoogle;

  /// No description provided for @apiKeyGoogleHint.
  ///
  /// In en, this message translates to:
  /// **'One key for Maps, Places, and Directions'**
  String get apiKeyGoogleHint;

  /// No description provided for @apiKeyGoogleHelp.
  ///
  /// In en, this message translates to:
  /// **'Setup guide'**
  String get apiKeyGoogleHelp;

  /// No description provided for @googleMapKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Google Maps requires an API key. Add one in Settings, then choose Google as the map provider.'**
  String get googleMapKeyRequired;

  /// No description provided for @googleMapKeyRequiredAction.
  ///
  /// In en, this message translates to:
  /// **'Open API keys'**
  String get googleMapKeyRequiredAction;

  /// No description provided for @googleMapKeySetupGuide.
  ///
  /// In en, this message translates to:
  /// **'How to create a Google API key'**
  String get googleMapKeySetupGuide;

  /// No description provided for @apiKeyGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Google Maps SDK'**
  String get apiKeyGoogleMaps;

  /// No description provided for @apiKeyGooglePlaces.
  ///
  /// In en, this message translates to:
  /// **'Google Places'**
  String get apiKeyGooglePlaces;

  /// No description provided for @apiKeyGoogleDirections.
  ///
  /// In en, this message translates to:
  /// **'Google Directions'**
  String get apiKeyGoogleDirections;

  /// No description provided for @apiKeyMapbox.
  ///
  /// In en, this message translates to:
  /// **'Mapbox access token'**
  String get apiKeyMapbox;

  /// No description provided for @apiKeyHere.
  ///
  /// In en, this message translates to:
  /// **'HERE API key'**
  String get apiKeyHere;

  /// No description provided for @apiKeyGraphhopper.
  ///
  /// In en, this message translates to:
  /// **'GraphHopper API key'**
  String get apiKeyGraphhopper;

  /// No description provided for @apiKeyGoogleMapsHint.
  ///
  /// In en, this message translates to:
  /// **'Also add to AndroidManifest for native map'**
  String get apiKeyGoogleMapsHint;

  /// No description provided for @apiKeyGooglePlacesHint.
  ///
  /// In en, this message translates to:
  /// **'Places API key'**
  String get apiKeyGooglePlacesHint;

  /// No description provided for @apiKeyGoogleDirectionsHint.
  ///
  /// In en, this message translates to:
  /// **'Directions API key'**
  String get apiKeyGoogleDirectionsHint;

  /// No description provided for @apiKeyMapboxHint.
  ///
  /// In en, this message translates to:
  /// **'pk.… token'**
  String get apiKeyMapboxHint;

  /// No description provided for @apiKeyHereHint.
  ///
  /// In en, this message translates to:
  /// **'HERE REST API key'**
  String get apiKeyHereHint;

  /// No description provided for @apiKeyGraphhopperHint.
  ///
  /// In en, this message translates to:
  /// **'Optional for higher limits'**
  String get apiKeyGraphhopperHint;

  /// No description provided for @saveKey.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveKey;

  /// No description provided for @mapOfflineSection.
  ///
  /// In en, this message translates to:
  /// **'Offline tiles'**
  String get mapOfflineSection;

  /// No description provided for @mapOfflineCacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache size'**
  String get mapOfflineCacheSize;

  /// No description provided for @mapOfflineDownload.
  ///
  /// In en, this message translates to:
  /// **'Download sample region'**
  String get mapOfflineDownload;

  /// No description provided for @mapOfflineDownloadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'London area, zoom 10–16 (OSM/Mapbox/HERE tiles)'**
  String get mapOfflineDownloadSubtitle;

  /// No description provided for @mapOfflineDownloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Offline region downloaded'**
  String get mapOfflineDownloadComplete;

  /// No description provided for @mapOfflineClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear offline cache'**
  String get mapOfflineClearCache;

  /// No description provided for @mapOfflineCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Offline cache cleared'**
  String get mapOfflineCacheCleared;

  /// No description provided for @mapOfflineGoogleUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Offline tiles are not available for Google native map'**
  String get mapOfflineGoogleUnsupported;

  /// No description provided for @mapLayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Map layer'**
  String get mapLayerLabel;

  /// No description provided for @mapLayerStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get mapLayerStandard;

  /// No description provided for @mapLayerSatellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get mapLayerSatellite;

  /// No description provided for @mapLayerDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get mapLayerDark;

  /// No description provided for @alarmTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Alarm type'**
  String get alarmTypeLabel;

  /// No description provided for @alarmTypeDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get alarmTypeDistance;

  /// No description provided for @alarmTypeArrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival (geofence enter)'**
  String get alarmTypeArrival;

  /// No description provided for @alarmTypeDeparture.
  ///
  /// In en, this message translates to:
  /// **'Departure (geofence exit)'**
  String get alarmTypeDeparture;

  /// No description provided for @alarmTypeRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get alarmTypeRadius;

  /// No description provided for @alarmTypeEta.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get alarmTypeEta;

  /// No description provided for @alarmTypeSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get alarmTypeSpeed;

  /// No description provided for @alarmTypeGeofence.
  ///
  /// In en, this message translates to:
  /// **'Geofence'**
  String get alarmTypeGeofence;

  /// No description provided for @travelModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Travel mode'**
  String get travelModeLabel;

  /// No description provided for @travelModeTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get travelModeTrain;

  /// No description provided for @travelModeBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get travelModeBus;

  /// No description provided for @travelModeMetro.
  ///
  /// In en, this message translates to:
  /// **'Metro'**
  String get travelModeMetro;

  /// No description provided for @travelModeCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get travelModeCar;

  /// No description provided for @travelModeWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get travelModeWalking;

  /// No description provided for @travelModeCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get travelModeCycling;

  /// No description provided for @travelModeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto detect'**
  String get travelModeAuto;

  /// No description provided for @speedThresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed threshold'**
  String get speedThresholdLabel;

  /// No description provided for @etaTriggerMinutes.
  ///
  /// In en, this message translates to:
  /// **'Alert when ETA below (minutes)'**
  String get etaTriggerMinutes;

  /// No description provided for @shareAlarmConfig.
  ///
  /// In en, this message translates to:
  /// **'Share alarm'**
  String get shareAlarmConfig;

  /// No description provided for @shareAlarmConfigSuccess.
  ///
  /// In en, this message translates to:
  /// **'Alarm config copied to clipboard'**
  String get shareAlarmConfigSuccess;

  /// No description provided for @groupTravelTitle.
  ///
  /// In en, this message translates to:
  /// **'Group travel'**
  String get groupTravelTitle;

  /// No description provided for @customRingtone.
  ///
  /// In en, this message translates to:
  /// **'Custom ringtone'**
  String get customRingtone;

  /// No description provided for @pickRingtone.
  ///
  /// In en, this message translates to:
  /// **'Pick ringtone'**
  String get pickRingtone;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @hebrew.
  ///
  /// In en, this message translates to:
  /// **'Hebrew'**
  String get hebrew;

  /// No description provided for @cloudBackupUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload backup to cloud'**
  String get cloudBackupUpload;

  /// No description provided for @cloudBackupUrlHint.
  ///
  /// In en, this message translates to:
  /// **'HTTPS upload URL'**
  String get cloudBackupUrlHint;

  /// No description provided for @cloudBackupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup uploaded successfully'**
  String get cloudBackupSuccess;

  /// No description provided for @cloudBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Cloud upload failed'**
  String get cloudBackupFailed;

  /// No description provided for @importAlarmConfig.
  ///
  /// In en, this message translates to:
  /// **'Alarm config imported'**
  String get importAlarmConfig;

  /// No description provided for @lockScreenInfo.
  ///
  /// In en, this message translates to:
  /// **'Show on lock screen'**
  String get lockScreenInfo;

  /// No description provided for @lockScreenInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display distance and ETA on lock screen notifications'**
  String get lockScreenInfoSubtitle;

  /// No description provided for @notifInternetLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Internet connection lost'**
  String get notifInternetLostTitle;

  /// No description provided for @notifInternetLostBody.
  ///
  /// In en, this message translates to:
  /// **'Route ETA may be unavailable until connection returns'**
  String get notifInternetLostBody;

  /// No description provided for @shareAllAlarms.
  ///
  /// In en, this message translates to:
  /// **'Share active alarms'**
  String get shareAllAlarms;

  /// No description provided for @importAlarmBundle.
  ///
  /// In en, this message translates to:
  /// **'Import alarm bundle'**
  String get importAlarmBundle;

  /// No description provided for @alarmBundleImported.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} alarms'**
  String alarmBundleImported(int count);

  /// No description provided for @mapLayerTerrain.
  ///
  /// In en, this message translates to:
  /// **'Terrain'**
  String get mapLayerTerrain;

  /// No description provided for @mapProviderApple.
  ///
  /// In en, this message translates to:
  /// **'Apple Maps'**
  String get mapProviderApple;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get highContrast;

  /// No description provided for @highContrastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Increase contrast for readability'**
  String get highContrastSubtitle;

  /// No description provided for @voiceSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Speak destination name'**
  String get voiceSearchHint;

  /// No description provided for @tileTapToCancel.
  ///
  /// In en, this message translates to:
  /// **'Tap to cancel alarm'**
  String get tileTapToCancel;

  /// No description provided for @tileTapToCreate.
  ///
  /// In en, this message translates to:
  /// **'Tap to create alarm'**
  String get tileTapToCreate;

  /// No description provided for @alarmCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Alarm created successfully'**
  String get alarmCreatedSuccess;

  /// No description provided for @alarmDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alarm details'**
  String get alarmDetailsTitle;

  /// No description provided for @addAnotherAlarm.
  ///
  /// In en, this message translates to:
  /// **'Add another alarm'**
  String get addAnotherAlarm;

  /// No description provided for @newAlarm.
  ///
  /// In en, this message translates to:
  /// **'New alarm'**
  String get newAlarm;

  /// No description provided for @alarmStatusTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get alarmStatusTracking;

  /// No description provided for @alarmStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get alarmStatusPaused;

  /// No description provided for @alarmNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Alarm #{number}'**
  String alarmNumberLabel(int number);

  /// No description provided for @activeAlarmsCount.
  ///
  /// In en, this message translates to:
  /// **'Active alarms ({count})'**
  String activeAlarmsCount(int count);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @providersSection.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get providersSection;

  /// No description provided for @providerChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Provider changed successfully.'**
  String get providerChangedSuccess;

  /// No description provided for @noApiKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'No API key required. Provider changed successfully.'**
  String get noApiKeyRequired;

  /// No description provided for @configureAndSave.
  ///
  /// In en, this message translates to:
  /// **'Configure & Save'**
  String get configureAndSave;

  /// No description provided for @providerSaveBlocked.
  ///
  /// In en, this message translates to:
  /// **'Save blocked until a valid API key is entered.'**
  String get providerSaveBlocked;

  /// No description provided for @credentialGoogleMapsTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Maps requires an API key'**
  String get credentialGoogleMapsTitle;

  /// No description provided for @credentialGoogleServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Google services require an API key'**
  String get credentialGoogleServicesTitle;

  /// No description provided for @credentialGoogleMapsBody.
  ///
  /// In en, this message translates to:
  /// **'One key covers Maps, Places, and Directions when those providers are enabled.'**
  String get credentialGoogleMapsBody;

  /// No description provided for @credentialMapboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Mapbox requires an access token'**
  String get credentialMapboxTitle;

  /// No description provided for @credentialMapboxBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your Mapbox access token to use Mapbox maps.'**
  String get credentialMapboxBody;

  /// No description provided for @credentialHereTitle.
  ///
  /// In en, this message translates to:
  /// **'HERE requires an API key'**
  String get credentialHereTitle;

  /// No description provided for @credentialHereBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your HERE REST API key.'**
  String get credentialHereBody;

  /// No description provided for @credentialGraphhopperTitle.
  ///
  /// In en, this message translates to:
  /// **'GraphHopper requires an API key'**
  String get credentialGraphhopperTitle;

  /// No description provided for @credentialGraphhopperBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your GraphHopper API key for routing.'**
  String get credentialGraphhopperBody;

  /// No description provided for @googleServiceMaps.
  ///
  /// In en, this message translates to:
  /// **'Maps SDK for Android'**
  String get googleServiceMaps;

  /// No description provided for @googleServicePlaces.
  ///
  /// In en, this message translates to:
  /// **'Places API'**
  String get googleServicePlaces;

  /// No description provided for @googleServiceDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions API'**
  String get googleServiceDirections;

  /// No description provided for @googleServiceAlsoUsed.
  ///
  /// In en, this message translates to:
  /// **'Also used when enabled (same key)'**
  String get googleServiceAlsoUsed;

  /// No description provided for @advancedSection.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advancedSection;

  /// No description provided for @advancedApiKeys.
  ///
  /// In en, this message translates to:
  /// **'API Keys'**
  String get advancedApiKeys;

  /// No description provided for @useRecommendedProviders.
  ///
  /// In en, this message translates to:
  /// **'Use recommended providers'**
  String get useRecommendedProviders;

  /// No description provided for @useRecommendedProvidersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep search and route matched to your map provider'**
  String get useRecommendedProvidersSubtitle;

  /// No description provided for @overrideSearchProvider.
  ///
  /// In en, this message translates to:
  /// **'Override search provider'**
  String get overrideSearchProvider;

  /// No description provided for @overrideRouteProvider.
  ///
  /// In en, this message translates to:
  /// **'Override route provider'**
  String get overrideRouteProvider;

  /// No description provided for @mapProviderAutoSetsProviders.
  ///
  /// In en, this message translates to:
  /// **'Changing the map provider updates recommended search and route.'**
  String get mapProviderAutoSetsProviders;

  /// No description provided for @apiKeyStatusConfigured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get apiKeyStatusConfigured;

  /// No description provided for @apiKeyStatusNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get apiKeyStatusNotConfigured;

  /// No description provided for @apiKeyClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get apiKeyClear;

  /// No description provided for @apiKeyUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update key'**
  String get apiKeyUpdate;

  /// No description provided for @apiKeyAdd.
  ///
  /// In en, this message translates to:
  /// **'Add key'**
  String get apiKeyAdd;

  /// No description provided for @testAllConfiguredKeys.
  ///
  /// In en, this message translates to:
  /// **'Test all configured keys'**
  String get testAllConfiguredKeys;

  /// No description provided for @apiKeysSecurityFooter.
  ///
  /// In en, this message translates to:
  /// **'Encrypted · Android Keystore · Not included in backup'**
  String get apiKeysSecurityFooter;

  /// No description provided for @languageFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get languageFollowSystem;

  /// No description provided for @distancePresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get distancePresetCustom;

  /// No description provided for @batteryBalancedRecommended.
  ///
  /// In en, this message translates to:
  /// **'Balanced (Recommended)'**
  String get batteryBalancedRecommended;

  /// No description provided for @resumeAlarmAfterBootBatteryWarning.
  ///
  /// In en, this message translates to:
  /// **'Relaunch tracking when the device restarts. Uses more battery.'**
  String get resumeAlarmAfterBootBatteryWarning;

  /// No description provided for @uploadBackupViaHttps.
  ///
  /// In en, this message translates to:
  /// **'Upload Backup via HTTPS'**
  String get uploadBackupViaHttps;

  /// No description provided for @shareLiveTrip.
  ///
  /// In en, this message translates to:
  /// **'Share Live Trip'**
  String get shareLiveTrip;

  /// No description provided for @importSharedAlarm.
  ///
  /// In en, this message translates to:
  /// **'Import Shared Alarm'**
  String get importSharedAlarm;

  /// No description provided for @permRestricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get permRestricted;

  /// No description provided for @permLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get permLimited;

  /// No description provided for @permProvisional.
  ///
  /// In en, this message translates to:
  /// **'Provisional'**
  String get permProvisional;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get aboutPrivacyPolicy;

  /// No description provided for @aboutTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get aboutTermsOfService;

  /// No description provided for @aboutDonateSupport.
  ///
  /// In en, this message translates to:
  /// **'Donate / Support'**
  String get aboutDonateSupport;

  /// No description provided for @openMapSettings.
  ///
  /// In en, this message translates to:
  /// **'Open map settings'**
  String get openMapSettings;

  /// No description provided for @currentLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocationLabel;

  /// No description provided for @activeAlarmsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No active alarms - tap + to create one'**
  String get activeAlarmsEmptyHint;

  /// No description provided for @languageEndonymHint.
  ///
  /// In en, this message translates to:
  /// **'Language names are shown in their native script'**
  String get languageEndonymHint;
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
      <String>['ar', 'en', 'he', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
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
