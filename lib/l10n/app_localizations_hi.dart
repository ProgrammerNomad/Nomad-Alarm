// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'नोमैड अलार्म';

  @override
  String get navHome => 'होम';

  @override
  String get navAlarms => 'अलार्म';

  @override
  String get navTrips => 'यात्राएँ';

  @override
  String get navHistory => 'इतिहास';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get createAlarm => 'अलार्म बनाएँ';

  @override
  String get searchDestinationHint => 'गंतव्य खोजें…';

  @override
  String get activeAlarms => 'सक्रिय अलार्म';

  @override
  String get favorites => 'पसंदीदा';

  @override
  String get savedPlaces => 'Saved Places';

  @override
  String get savedPlacesManage => 'Manage';

  @override
  String get savedPlacesAddAction => 'Add';

  @override
  String get savedPlacesMore => '+ More';

  @override
  String get savedPlacesEmptyTitle => 'No saved places yet';

  @override
  String get savedPlacesEmptyBody =>
      'Save places you travel to often. Nomad Alarm can start an alarm automatically when you\'re heading there.';

  @override
  String get savedPlacesAdd => 'Add places';

  @override
  String get savedPlacesAddFirst => '+ Add your first place';

  @override
  String get savedPlacesEdit => 'Edit place';

  @override
  String get savedPlacesSave => 'Save place';

  @override
  String get savedPlaceName => 'Name';

  @override
  String get savedPlaceCategory => 'Category';

  @override
  String get savedPlaceLocationHint => 'Search destination…';

  @override
  String get savedPlacesDelete => 'Delete place';

  @override
  String get savedPlacesSmartAlarmHelp =>
      'Nomad Alarm will start an alarm when it\'s highly confident you\'re traveling here. You can stop it anytime.';

  @override
  String get smartAlarm => 'Smart Alarm';

  @override
  String get smartAlarmOff => 'Off';

  @override
  String get smartAlarmSuggest => 'Suggest';

  @override
  String get smartAlarmAutomatic => 'Automatic';

  @override
  String smartAlarmModeSummary(String mode) {
    return 'Smart Alarm · $mode';
  }

  @override
  String get lastUsed => 'Last used';

  @override
  String lastUsedFormatted(String when) {
    return 'Last used · $when';
  }

  @override
  String get lastUsedNever => 'Never used';

  @override
  String autoStartedCount(int count) {
    return 'Auto started · $count times';
  }

  @override
  String get savedPlaceCategoryHome => 'Home';

  @override
  String get savedPlaceCategoryOffice => 'Office';

  @override
  String get savedPlaceCategorySchool => 'School';

  @override
  String get savedPlaceCategoryStation => 'Station';

  @override
  String get savedPlaceCategoryBusStop => 'Bus stop';

  @override
  String get savedPlaceCategoryMetro => 'Metro';

  @override
  String get savedPlaceCategoryAirport => 'Airport';

  @override
  String get savedPlaceCategoryHospital => 'Hospital';

  @override
  String get savedPlaceCategoryCustom => 'Custom';

  @override
  String smartAlarmOnboardingTitle(String name) {
    return 'Would you like Nomad Alarm to automatically detect when you\'re travelling to $name?';
  }

  @override
  String get smartAlarmOnboardingNo => 'No';

  @override
  String get smartAlarmOnboardingSuggest => 'Suggest';

  @override
  String get smartAlarmOnboardingAutomatic => 'Automatically start';

  @override
  String get smartPlacesSettings => 'Smart Places';

  @override
  String get enableSmartAlarm => 'Enable Smart Alarm';

  @override
  String get smartPlacesSettingsSubtitle => 'Automatic alarms for saved places';

  @override
  String get smartPlacesSettingsHelp =>
      'Automatically detect trips for Saved Places.';

  @override
  String get alarmSourceAuto => 'AUTO';

  @override
  String notifSmartAlarmActiveTitle(String place) {
    return '$place Alarm Active';
  }

  @override
  String notifSmartAlarmActiveBody(String distance) {
    return 'We\'ll alert you $distance before you arrive.';
  }

  @override
  String get notifSmartAlarmStop => 'Stop';

  @override
  String get notifSmartAlarmOpen => 'Open';

  @override
  String get debugSmartPlaces => 'Smart Places (debug)';

  @override
  String get debugConfidenceWhy => 'Why?';

  @override
  String get recent => 'हाल के';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get firstAlarmTitle => 'अपना पहला गंतव्य अलार्म सेट करें';

  @override
  String get firstAlarmBody => 'कोई स्थान खोजें या मानचित्र पर पिन लगाएँ।';

  @override
  String get searchDestination => 'गंतव्य खोजें';

  @override
  String get gettingLocation => 'स्थान प्राप्त हो रहा है…';

  @override
  String get locationUnavailable =>
      'स्थान उपलब्ध नहीं - मानचित्र खोलने के लिए टैप करें';

  @override
  String get activeAlarmFallback => 'सक्रिय अलार्म';

  @override
  String alarmRingingDistance(String distance) {
    return 'अलार्म बज रहा है - $distance दूर';
  }

  @override
  String distanceAway(String distance) {
    return '$distance दूर';
  }

  @override
  String get welcomeTitle => 'अपना स्टॉप कभी न चूकें';

  @override
  String get welcomeBullet1 => '100% मुफ़्त - कोई विज्ञापन या सदस्यता नहीं';

  @override
  String get welcomeBullet2 => 'गोपनीयता पहले - कोई लॉगिन या ट्रैकिंग नहीं';

  @override
  String get welcomeBullet3 => 'सक्रिय अलार्म के लिए ऑफ़लाइन काम करता है';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String permissionsTitle(int current, int total) {
    return 'अनुमतियाँ ($current/$total)';
  }

  @override
  String get grant => 'अनुमति दें';

  @override
  String get skipForNow => 'अभी छोड़ें';

  @override
  String get required => 'आवश्यक';

  @override
  String get permLocationTitle => 'स्थान की अनुमति';

  @override
  String get permLocationDesc =>
      'गंतव्य की दूरी जानने के लिए हमें आपके स्थान की ज़रूरत है।';

  @override
  String get permNotificationTitle => 'सूचनाएँ';

  @override
  String get permNotificationDesc =>
      'अलार्म सक्रिय होने पर हम एक छोटी सूचना दिखाते हैं।';

  @override
  String get permBackgroundTitle => 'पृष्ठभूमि स्थान';

  @override
  String get permBackgroundDesc =>
      'स्क्रीन बंद होने पर भी अलार्म काम करे, इसके लिए हमेशा अनुमति दें।';

  @override
  String get permExactAlarmTitle => 'सटीक अलार्म';

  @override
  String get permExactAlarmDesc =>
      'गंतव्य पर पहुँचने पर विश्वसनीय अलर्ट (Android 12+).';

  @override
  String get permBatteryTitle => 'बैटरी अनुकूलन';

  @override
  String get permBatteryDesc =>
      'बैटरी अनुकूलन बंद करने से GPS पृष्ठभूमि में चलता रहता है। छोड़ सकते हैं, पर कुछ फ़ोन पर ट्रैकिंग रुक सकती है।';

  @override
  String get activeAlarmTitle => 'सक्रिय अलार्म';

  @override
  String get estimatedArrival => 'अनुमानित आगमन';

  @override
  String get gpsLostWarning =>
      'GPS सिग्नल खो गया - अंतिम स्थिति पुरानी हो सकती है';

  @override
  String get passedDestinationWarning =>
      'आप अपने गंतव्य से आगे निकल गए हो सकते हैं';

  @override
  String get lowBatteryWarning =>
      'कम बैटरी - विश्वसनीय ट्रैकिंग के लिए फ़ोन चार्ज करें';

  @override
  String get alarmPaused => 'अलार्म रोका गया';

  @override
  String get resume => 'जारी रखें';

  @override
  String get pause => 'रोकें';

  @override
  String get openMap => 'मानचित्र खोलें';

  @override
  String get cancelAlarm => 'अलार्म रद्द करें';

  @override
  String get stopApproaching => 'स्टॉप नज़दीक है!';

  @override
  String get dismiss => 'बंद करें';

  @override
  String get snoozeTwoMin => '2 मिनट स्नूज़';

  @override
  String get createAlarmTitle => 'अलार्म बनाएँ';

  @override
  String get noDestinationSelected => 'कोई गंतव्य चयनित नहीं';

  @override
  String get selectDestinationFirst => 'पहले गंतव्य चुनें';

  @override
  String get alarmSaved => 'अलार्म सहेजा गया';

  @override
  String get alertDistance => 'अलर्ट दूरी';

  @override
  String get voiceAlert => 'आवाज़ घोषणाएँ';

  @override
  String get voiceAlertSubtitle => 'ट्रिगर होने पर बोला जाएगा';

  @override
  String get vibration => 'कंपन';

  @override
  String get flashlight => 'फ़्लैशलाइट';

  @override
  String get flashlightSubtitle => 'अलार्म बजने पर LED फ्लैश करें।';

  @override
  String get saveAndStart => 'सहेजें और शुरू करें';

  @override
  String get saveOnly => 'केवल सहेजें';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsSubtitle =>
      'ऐप व्यवहार, मानचित्र, सूचनाएँ और गोपनीयता प्रबंधित करें।';

  @override
  String get alarmsTitle => 'अलार्म';

  @override
  String get appearance => 'दिखावट';

  @override
  String get theme => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeDark => 'गहरा';

  @override
  String get units => 'इकाइयाँ';

  @override
  String get useMetricUnits => 'मीट्रिक इकाइयाँ';

  @override
  String get kilometers => 'किलोमीटर';

  @override
  String get miles => 'मील';

  @override
  String get distanceUnitsLabel => 'दूरी की इकाइयाँ';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get alarmDefaults => 'अलार्म';

  @override
  String get defaultAlertDistance => 'डिफ़ॉल्ट अलार्म दूरी';

  @override
  String get battery => 'पावर और बैटरी';

  @override
  String get gpsProfile => 'GPS प्रोफ़ाइल';

  @override
  String get batteryBalanced => 'संतुलित';

  @override
  String get batteryAggressive => 'आक्रामक';

  @override
  String get batterySaver => 'बचत';

  @override
  String get batteryBalancedDesc =>
      'दैनिक यात्रा के लिए सर्वोत्तम। लगभग हर 10 मीटर पर स्थान अपडेट।';

  @override
  String get batteryAggressiveDesc =>
      'अधिकतम विश्वसनीयता - गंतव्य के पास अधिक बैटरी';

  @override
  String get batterySaverDesc => 'कम GPS उपयोग - सटीकता कम हो सकती है';

  @override
  String get data => 'डेटा';

  @override
  String get backupSection => 'बैकअप';

  @override
  String get transferData => 'डेटा स्थानांतरण';

  @override
  String get transferDataTitle => 'डेटा स्थानांतरण';

  @override
  String get transferDataSubtitle =>
      'डेटा बैकअप, स्थानांतरण या पुनर्स्थापित करें';

  @override
  String get transferDataIntro =>
      'अपने बैकअप प्रबंधित करें और डेटा स्थानांतरण करें।';

  @override
  String get exportBackupDescription =>
      'अलार्म, स्थान, सेटिंग्स और इतिहास सहेजें।';

  @override
  String get importBackupDescription =>
      'पहले निर्यात किया गया बैकअप पुनर्स्थापित करें।';

  @override
  String get uploadBackupDescription =>
      'एन्क्रिप्टेड बैकअप अपने HTTPS सर्वर पर अपलोड करें।';

  @override
  String get autoBackup => 'स्वचालित बैकअप';

  @override
  String get autoBackupComingSoon => 'अनुसूचित बैकअप भविष्य के अपडेट में आएगा';

  @override
  String get lastBackup => 'अंतिम बैकअप';

  @override
  String get lastBackupNever => 'कभी नहीं';

  @override
  String get exportBackup => 'बैकअप निर्यात';

  @override
  String get exportBackupSubtitle =>
      'अलार्म, पसंदीदा, सेटिंग्स और इतिहास सहेजें';

  @override
  String get importBackup => 'बैकअप आयात';

  @override
  String get importBackupSubtitle => 'JSON बैकअप फ़ाइल से पुनर्स्थापित करें';

  @override
  String get importBackupTitle => 'बैकअप आयात करें?';

  @override
  String get importBackupBody =>
      'फ़ाइल से नए अलार्म, पसंदीदा, इतिहास और सेटिंग्स इस डिवाइस में जोड़े जाएँगे। चल रहे अलार्म बैकअप में शामिल नहीं होते।';

  @override
  String get import => 'आयात';

  @override
  String get backupReady => 'बैकअप साझा करने के लिए तैयार';

  @override
  String importedSummary(
    int alarms,
    int favorites,
    int history,
    String settings,
  ) {
    return '$alarms अलार्म, $favorites पसंदीदा, $history इतिहास प्रविष्टियाँ$settings आयात की गईं।';
  }

  @override
  String get importedSettingsSuffix => ', सेटिंग्स';

  @override
  String get more => 'सिस्टम';

  @override
  String get permissionsMenu => 'अनुमतियाँ';

  @override
  String get privacyMenu => 'गोपनीयता';

  @override
  String get aboutMenu => 'परिचय';

  @override
  String get debugMenu => 'डीबग';

  @override
  String get aboutTitle => 'परिचय';

  @override
  String get developedBy => 'NomadProgrammer द्वारा विकसित';

  @override
  String get aboutTagline =>
      'गोपनीयता-प्रथम स्थान अलार्म। हमेशा मुफ़्त। कोई विज्ञापन या ट्रacking नहीं।';

  @override
  String get openSourceLicenses => 'ओपन सोर्स लाइसेंस';

  @override
  String get viewOnGitHub => 'GitHub पर देखें';

  @override
  String get licensesTitle => 'ओपन सोर्स लाइसेंस';

  @override
  String get privacyTitle => 'गोपनीयता';

  @override
  String get privacyHeading => 'आपकी गोपनीयता महत्वपूर्ण है';

  @override
  String get privacyBullet1 => 'कोई खाता या लॉगिन आवश्यक नहीं';

  @override
  String get privacyBullet2 => 'कोई विज्ञापन या एनालिटिक्स नहीं';

  @override
  String get privacyBullet3 =>
      'कोई क्लाउड स्टोरेज नहीं - सारा डेटा आपके फ़ोन पर';

  @override
  String get privacyBullet4 => 'स्थान केवल अलार्म दूरी के लिए उपयोग होता है';

  @override
  String get privacyBullet5 => 'ओपन सोर्स - कोड कभी भी देख सकते हैं';

  @override
  String get fullPrivacyPolicy => 'पूर्ण गोपनीयता नीति';

  @override
  String get cancel => 'रद्द करें';

  @override
  String errorPrefix(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get semCreateAlarm => 'नया स्थान अलार्म बनाएँ';

  @override
  String get semCancelAlarm => 'सक्रिय अलार्म रद्द करें';

  @override
  String get semDismissAlarm => 'बज रहा अलार्म बंद करें';

  @override
  String get semSnoozeAlarm => 'अलार्म दो मिनट के लिए स्नूज़ करें';

  @override
  String get semExportBackup => 'बैकअप फ़ाइल निर्यात करें';

  @override
  String get semImportBackup => 'बैकअप फ़ाइल आयात करें';

  @override
  String get permCenterTitle => 'अनुमति केंद्र';

  @override
  String get permGranted => 'अनुमति दी गई';

  @override
  String get permDenied => 'अस्वीकृत';

  @override
  String get permPermanentlyDenied => 'स्थायी रूप से अस्वीकृत - सेटिंग्स खोलें';

  @override
  String get permFix => 'ठीक करें';

  @override
  String get searchHintExtended => 'स्टेशन, लैंडमार्क, पता…';

  @override
  String searchFailed(String message) {
    return 'खोज विफल: $message';
  }

  @override
  String get noResultsFound => 'कोई परिणाम नहीं मिला';

  @override
  String get savedToFavorites => 'पसंदीदा में सहेजा गया';

  @override
  String get searchEmptyHint => 'स्टेशन, लैंडमार्क या पता खोजें';

  @override
  String get importFromClipboard => 'क्लिपबोर्ड से आयात करें';

  @override
  String get deepLinkInvalid => 'क्लिपबोर्ड से स्थान पार्स नहीं हो सका';

  @override
  String get deepLinkImported => 'गंतव्य आयात किया गया';

  @override
  String get mapTitle => 'मानचित्र';

  @override
  String get droppedPin => 'पिन लगाया';

  @override
  String get lookingUpAddress => 'पता खोजा जा रहा है…';

  @override
  String get setAlarm => 'अलार्म सेट करें';

  @override
  String get saveFavorite => 'पसंदीदा सहेजें';

  @override
  String get semCenterOnMap => 'मानचित्र को अपने स्थान पर केंद्रित करें';

  @override
  String get semSetAlarmFromPin => 'पिन के लिए अलार्म सेट करें';

  @override
  String get historyTitle => 'इतिहास';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterActive => 'Active';

  @override
  String get filterSaved => 'Saved';

  @override
  String get filterCompleted => 'पूर्ण';

  @override
  String get filterMissed => 'चूके';

  @override
  String get filterDismissed => 'रद्द';

  @override
  String get filterSnoozed => 'स्नूज़';

  @override
  String get historyStatsCompleted => 'पूर्ण';

  @override
  String get historyStatsActive => 'Active';

  @override
  String get historyStatsSaved => 'Saved';

  @override
  String get historyStatsMissed => 'चूके';

  @override
  String get historyStatsSuccessRate => 'सफलता दर';

  @override
  String get journeyDetailsTitle => 'यात्रा विवरण';

  @override
  String get noHistoryTitle => 'अभी कोई इतिहास नहीं';

  @override
  String get noHistoryMessage =>
      'Running alarms appear under Active or All. Completed and missed alarms are logged here after they finish.';

  @override
  String get historyActiveEmptyTitle => 'No active alarms';

  @override
  String get historyActiveEmptyMessage =>
      'Running alarms appear here while tracking.';

  @override
  String get historySavedEmptyTitle => 'No saved alarms';

  @override
  String get historySavedEmptyMessage =>
      'Alarms you save without starting appear here.';

  @override
  String get viewAllActiveInHistory => 'View all active in History';

  @override
  String get historyStatusTracking => 'Tracking';

  @override
  String get historyStartedAt => 'Started';

  @override
  String get deleteEntryTitle => 'प्रविष्टि हटाएँ?';

  @override
  String deleteEntryBody(String name) {
    return '\"$name\" को इतिहास से हटाएँ?';
  }

  @override
  String get delete => 'हटाएँ';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get triggerDistanceLabel => 'ट्रिगर दूरी';

  @override
  String get snoozesLabel => 'स्नूज़';

  @override
  String get notesLabel => 'नोट्स';

  @override
  String get outcomeCompleted => 'पूर्ण';

  @override
  String get outcomeMissed => 'चूका';

  @override
  String get outcomeDismissed => 'खारिज';

  @override
  String get outcomeSnoozed => 'स्नूज़';

  @override
  String get semDeleteHistoryEntry => 'इतिहास प्रविष्टि हटाएँ';

  @override
  String get tripsTitle => 'यात्राएँ';

  @override
  String get noTripsTitle => 'अभी कोई यात्रा नहीं';

  @override
  String get noTripsMessage => 'आपकी पूर्ण यात्राएँ यहाँ दिखेंगी।';

  @override
  String get startedLabel => 'शुरू';

  @override
  String get endedLabel => 'समाप्त';

  @override
  String get durationLabel => 'अवधि';

  @override
  String get distanceLabel => 'दूरी';

  @override
  String get maxSpeedLabel => 'अधिकतम गति';

  @override
  String get avgSpeedLabel => 'औसत गति';

  @override
  String get alarmIdLabel => 'अलार्म ID';

  @override
  String get tripOutcomeCancelled => 'रद्द';

  @override
  String get tripOutcomePassed => 'पार किया';

  @override
  String get saveFavoriteTrip => 'पसंदीदा यात्रा के रूप में सहेजें';

  @override
  String get favoriteTripSaved => 'पसंदीदा यात्रा सहेजी गई';

  @override
  String get createAlarmFromTrip => 'यात्रा से अलार्म बनाएँ';

  @override
  String get semSaveFavoriteTrip => 'यात्रा को पसंदीदा के रूप में सहेजें';

  @override
  String get semCreateAlarmFromTrip => 'इस यात्रा से नया अलार्म बनाएँ';

  @override
  String versionLabel(String version) {
    return 'संस्करण $version';
  }

  @override
  String get kmhUnit => 'किमी/घं';

  @override
  String get notifTrackingChannel => 'सक्रिय अलार्म';

  @override
  String get notifTrackingChannelDesc => 'अलार्म ट्रैक होने पर दूरी दिखाता है';

  @override
  String get notifAlarmChannel => 'अलार्म बजना';

  @override
  String get notifAlarmChannelDesc => 'गंतव्य पर पहुँचने पर अलर्ट';

  @override
  String get notifWarningsChannel => 'चेतावनियाँ';

  @override
  String get notifGpsLostTitle => 'GPS सिग्नल खो गया';

  @override
  String get notifGpsLostBody => 'स्थान अपडेट रुके - GPS जाँचें';

  @override
  String get notifLowBatteryTitle => 'कम बैटरी';

  @override
  String get notifLowBatteryBody => 'अलार्म चलाने के लिए फ़ोन चार्ज करें';

  @override
  String notifToDestination(String distance) {
    return 'गंतव्य $distance दूर';
  }

  @override
  String get widgetNoActiveAlarm => 'कोई सक्रिय अलार्म नहीं';

  @override
  String get widgetTracking => 'ट्रैक हो रहा है…';

  @override
  String get widgetTapToOpen => 'खोलने के लिए टैप करें';

  @override
  String tileActiveDistance(String distance) {
    return '$distance दूर';
  }

  @override
  String get semSearchSubmit => 'गंतव्य खोजें';

  @override
  String get semImportFromClipboard => 'क्लिपबोर्ड से गंतव्य आयात करें';

  @override
  String get metersUnit => 'मी';

  @override
  String get mphUnit => 'मील/घं';

  @override
  String get debugTitle => 'डीबग';

  @override
  String get debugUnavailable => 'डीबग स्क्रीन उपलब्ध नहीं';

  @override
  String get debugBackgroundService => 'पृष्ठभूमि सेवा';

  @override
  String get debugBattery => 'बैटरी';

  @override
  String get debugActiveAlarmId => 'सक्रिय अलार्म ID';

  @override
  String get debugLoadingGps => 'GPS स्थिति लोड हो रही है…';

  @override
  String get debugDistance => 'दूरी';

  @override
  String get debugEta => 'ETA';

  @override
  String get debugSpeed => 'गति';

  @override
  String get debugAccuracy => 'सटीकता';

  @override
  String get debugGpsLost => 'GPS खो गया';

  @override
  String get debugLowBattery => 'कम बैटरी फ़्लैग';

  @override
  String get debugPosition => 'स्थिति';

  @override
  String get debugCharging => 'चार्ज हो रहा';

  @override
  String get debugDischarging => 'चार्ज नहीं';

  @override
  String get debugCopySnapshot => 'स्नैपशॉट कॉपी करें';

  @override
  String get debugRefresh => 'रीफ़्रेश';

  @override
  String get debugSnapshotCopied => 'डीबग स्नैपशॉट कॉपी किया गया';

  @override
  String get fgsStartingTitle => 'Starting location tracking…';

  @override
  String get fgsStartingContent => 'Preparing GPS…';

  @override
  String get resumeAlarmAfterBoot => 'रीबूट के बाद अलार्म जारी रखें';

  @override
  String get resumeAlarmAfterBootSubtitle =>
      'डिवाइस रीस्टार्ट पर ट्रैकिंग फिर शुरू करें (अधिक बैटरी)';

  @override
  String get mapsSection => 'मानचित्र और रूट';

  @override
  String get mapSettingsTitle => 'मानचित्र सेटिंग्स';

  @override
  String get mapSettingsSubtitle => 'प्रदाता, परतें और ऑफ़लाइन टाइल';

  @override
  String get mapProvidersSection => 'प्रदाता';

  @override
  String get mapProviderLabel => 'मानचित्र प्रदाता';

  @override
  String get searchProviderLabel => 'खोज प्रदाता';

  @override
  String get routeProviderLabel => 'रूट प्रदाता';

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
  String get apiKeysTitle => 'API कुंजी';

  @override
  String get apiKeysIntro =>
      'कुंजी एन्क्रिप्टेड रूप में डिवाइस पर संग्रहीत हैं; बैकअप में शामिल नहीं।';

  @override
  String get apiKeySaved => 'API कुंजी सहेजी गई';

  @override
  String get apiKeyTest => 'जाँचें';

  @override
  String get apiKeyTestSuccess => 'कनेक्शन सफल';

  @override
  String get apiKeyTestFailure => 'कनेक्शन विफल - कुंजी जाँचें';

  @override
  String get apiKeyGoogle => 'Google API कुंजी';

  @override
  String get apiKeyGoogleHint => 'Maps, Places और Directions के लिए एक कुंजी';

  @override
  String get apiKeyGoogleHelp => 'सेटअप गाइड';

  @override
  String get googleMapKeyRequired =>
      'Google Maps के लिए API कुंजी चाहिए। Settings में कुंजी जोड़ें, फिर map provider Google चुनें।';

  @override
  String get googleMapKeyRequiredAction => 'API कुंजी खोलें';

  @override
  String get googleMapKeySetupGuide => 'Google API कुंजी कैसे बनाएँ';

  @override
  String get apiKeyGoogleMaps => 'Google Maps SDK';

  @override
  String get apiKeyGooglePlaces => 'Google Places';

  @override
  String get apiKeyGoogleDirections => 'Google Directions';

  @override
  String get apiKeyMapbox => 'Mapbox टोकन';

  @override
  String get apiKeyHere => 'HERE API कुंजी';

  @override
  String get apiKeyGraphhopper => 'GraphHopper API कुंजी';

  @override
  String get apiKeyGoogleMapsHint =>
      'नेटिव मानचित्र के लिए AndroidManifest में भी जोड़ें';

  @override
  String get apiKeyGooglePlacesHint => 'Places API कुंजी';

  @override
  String get apiKeyGoogleDirectionsHint => 'Directions API कुंजी';

  @override
  String get apiKeyMapboxHint => 'pk.… टोकन';

  @override
  String get apiKeyHereHint => 'HERE REST API कुंजी';

  @override
  String get apiKeyGraphhopperHint => 'उच्च सीमा के लिए वैकल्पिक';

  @override
  String get saveKey => 'सहेजें';

  @override
  String get mapOfflineSection => 'ऑफ़लाइन टाइल';

  @override
  String get mapOfflineCacheSize => 'कैश आकार';

  @override
  String get mapOfflineDownload => 'नमूना क्षेत्र डाउनलोड';

  @override
  String get mapOfflineDownloadSubtitle => 'लंदन क्षेत्र, ज़ूम 10–16';

  @override
  String get mapOfflineDownloadComplete => 'ऑफ़लाइन क्षेत्र डाउनलोड हो गया';

  @override
  String get mapOfflineClearCache => 'ऑफ़लाइन कैश साफ़ करें';

  @override
  String get mapOfflineCacheCleared => 'ऑफ़लाइन कैश साफ़ हो गया';

  @override
  String get mapOfflineGoogleUnsupported =>
      'Google नेटिव मानचित्र के लिए ऑफ़लाइन टाइल उपलब्ध नहीं';

  @override
  String get mapLayerLabel => 'मानचित्र परत';

  @override
  String get mapLayerStandard => 'मानक';

  @override
  String get mapLayerSatellite => 'उपग्रह';

  @override
  String get mapLayerDark => 'डार्क';

  @override
  String get alarmTypeLabel => 'अलार्म प्रकार';

  @override
  String get alarmTypeDistance => 'दूरी';

  @override
  String get alarmTypeArrival => 'आगमन';

  @override
  String get alarmTypeDeparture => 'प्रस्थान';

  @override
  String get alarmTypeRadius => 'त्रिज्या';

  @override
  String get alarmTypeEta => 'ETA';

  @override
  String get alarmTypeSpeed => 'गति';

  @override
  String get alarmTypeGeofence => 'जियोफेंस';

  @override
  String get travelModeLabel => 'यात्रा मोड';

  @override
  String get travelModeTrain => 'ट्रेन';

  @override
  String get travelModeBus => 'बस';

  @override
  String get travelModeMetro => 'मेट्रो';

  @override
  String get travelModeCar => 'कार';

  @override
  String get travelModeWalking => 'पैदल';

  @override
  String get travelModeCycling => 'साइकिल';

  @override
  String get travelModeAuto => 'ऑटो';

  @override
  String get speedThresholdLabel => 'गति सीमा';

  @override
  String get etaTriggerMinutes => 'ETA सीमा (मिनट)';

  @override
  String get shareAlarmConfig => 'अलार्म साझा करें';

  @override
  String get shareAlarmConfigSuccess => 'अलार्म कॉन्फ़िग क्लिपबोर्ड पर';

  @override
  String get groupTravelTitle => 'समूह यात्रा';

  @override
  String get customRingtone => 'कस्टम रिंगटोन';

  @override
  String get pickRingtone => 'रिंगटोन चुनें';

  @override
  String get arabic => 'अरबी';

  @override
  String get hebrew => 'हिब्रू';

  @override
  String get cloudBackupUpload => 'क्लाउड पर बैकअप अपलोड करें';

  @override
  String get cloudBackupUrlHint => 'अपने HTTPS सर्वर पर बैकअप अपलोड करें।';

  @override
  String get cloudBackupSuccess => 'बैकअप सफलतापूर्वक अपलोड हुआ';

  @override
  String get cloudBackupFailed => 'क्लाउड अपलोड विफल';

  @override
  String get importAlarmConfig => 'अलार्म कॉन्फ़िग आयात किया गया';

  @override
  String get lockScreenInfo => 'लॉक स्क्रीन पर दिखाएँ';

  @override
  String get lockScreenInfoSubtitle => 'लॉक स्क्रीन पर दूरी और ETA दिखाएँ।';

  @override
  String get notifInternetLostTitle => 'इंटरनेट कनेक्शन खो गया';

  @override
  String get notifInternetLostBody =>
      'कनेक्शन वापस आने तक रूट ETA उपलब्ध नहीं हो सकता';

  @override
  String get shareAllAlarms => 'सक्रिय अलार्म साझा करें';

  @override
  String get importAlarmBundle => 'अलार्म बंडल आयात करें';

  @override
  String alarmBundleImported(int count) {
    return '$count अलार्म आयात किए गए';
  }

  @override
  String get mapLayerTerrain => 'भू-आकृति';

  @override
  String get mapProviderApple => 'Apple Maps';

  @override
  String get highContrast => 'उच्च कंट्रास्ट';

  @override
  String get highContrastSubtitle => 'पठनीयता के लिए कंट्रास्ट बढ़ाएँ';

  @override
  String get accessibilitySection => 'सुगम्यता';

  @override
  String get voiceSearchHint => 'गंतव्य का नाम बोलें';

  @override
  String get tileTapToCancel => 'अलार्म रद्द करने के लिए टैप करें';

  @override
  String get tileTapToCreate => 'अलार्म बनाने के लिए टैप करें';

  @override
  String get alarmCreatedSuccess => 'अलार्म सफलतापूर्वक बनाया गया';

  @override
  String get alarmDetailsTitle => 'अलार्म विवरण';

  @override
  String get addAnotherAlarm => 'एक और अलार्म जोड़ें';

  @override
  String get newAlarm => 'नया अलार्म';

  @override
  String get createAlarmSheetTitle => 'Create alarm';

  @override
  String get importAlarm => 'Import alarm';

  @override
  String get alarmStatusSaved => 'Saved';

  @override
  String get startAlarm => 'Start';

  @override
  String get deleteSavedAlarmTitle => 'Delete saved alarm?';

  @override
  String deleteSavedAlarmBody(String name) {
    return 'Remove \"$name\"?';
  }

  @override
  String activeAlarmsNotificationTitle(int count) {
    return '$count active alarms';
  }

  @override
  String get alarmStatusTracking => 'ट्रैकिंग';

  @override
  String get alarmStatusPaused => 'रोका गया';

  @override
  String alarmNumberLabel(int number) {
    return 'अलार्म #$number';
  }

  @override
  String activeAlarmsCount(int count) {
    return 'सक्रिय अलार्म ($count)';
  }

  @override
  String get save => 'सहेजें';

  @override
  String get providersSection => 'प्रदाता';

  @override
  String get providerChangedSuccess => 'प्रदाता सफलतापूर्वक बदला गया।';

  @override
  String get noApiKeyRequired =>
      'कोई API कुंजी आवश्यक नहीं। प्रदाता सफलतापूर्वक बदला गया।';

  @override
  String get configureAndSave => 'कॉन्फ़िगर करें और सहेजें';

  @override
  String get configure => 'कॉन्फ़िगर करें';

  @override
  String saveAndUseProvider(String provider) {
    return '$provider सहेजें और उपयोग करें';
  }

  @override
  String get manageCredentials => 'क्रेडेंशियल प्रबंधित करें';

  @override
  String get editCredentials => 'क्रेडेंशियल संपादित करें';

  @override
  String get removeCredentials => 'क्रेडेंशियल हटाएं';

  @override
  String get testConnection => 'कनेक्शन परीक्षण';

  @override
  String get credentialRequired => 'आवश्यक';

  @override
  String get credentialOptional => 'वैकल्पिक';

  @override
  String get providerConfigured => 'कॉन्फ़िगर किया गया';

  @override
  String get googleMapsConfiguredSuccess => 'Google Maps कॉन्फ़िगर हो गया।';

  @override
  String removeCredentialsConfirm(String provider) {
    return '$provider के लिए संग्रहीत क्रेडेंशियल हटाएं?';
  }

  @override
  String get testFailed => 'कनेक्शन विफल';

  @override
  String get testPassed => 'कनेक्शन सफल';

  @override
  String get providerSaveBlocked =>
      'मान्य API कुंजी दर्ज होने तक सहेजना अवरुद्ध है।';

  @override
  String get credentialGoogleMapsTitle =>
      'Google Maps के लिए API कुंजी आवश्यक है';

  @override
  String get credentialGoogleServicesTitle =>
      'Google सेवाओं के लिए API कुंजी आवश्यक है';

  @override
  String get credentialGoogleMapsBody =>
      'एक मानक Google API कुंजी का उपयोग करें। Google Cloud Console में नीचे दिए API एक ही प्रोजेक्ट पर सक्षम करें, फिर अपनी कुंजी पेस्ट करें।';

  @override
  String googleTestResultOk(String service) {
    return '$service: OK';
  }

  @override
  String googleTestResultFailed(String service) {
    return '$service: विफल';
  }

  @override
  String get credentialMapboxTitle => 'Mapbox के लिए एक्सेस टोकन आवश्यक है';

  @override
  String get credentialMapboxBody =>
      'Mapbox मानचित्र के लिए अपना Mapbox टोकन दर्ज करें।';

  @override
  String get credentialHereTitle => 'HERE के लिए API कुंजी आवश्यक है';

  @override
  String get credentialHereBody => 'अपनी HERE REST API कुंजी दर्ज करें।';

  @override
  String get credentialGraphhopperTitle =>
      'GraphHopper के लिए API कुंजी आवश्यक है';

  @override
  String get credentialGraphhopperBody =>
      'रूटिंग के लिए GraphHopper API कुंजी दर्ज करें।';

  @override
  String get googleServiceMaps => 'Android के लिए Maps SDK';

  @override
  String get googleServicePlaces => 'Places API';

  @override
  String get googleServiceDirections => 'Directions API';

  @override
  String get googleServiceAlsoUsed => 'सक्षम होने पर भी उपयोग (एक ही कुंजी)';

  @override
  String get advancedSection => 'उन्नत';

  @override
  String get advancedApiKeys => 'API कुंजी';

  @override
  String get useRecommendedProviders => 'अनुशंसित प्रदाता उपयोग करें';

  @override
  String get useRecommendedProvidersSubtitle =>
      'खोज और रूट को मानचित्र प्रदाता से मिलाए रखें';

  @override
  String get overrideSearchProvider => 'खोज प्रदाता ओवरराइड करें';

  @override
  String get overrideRouteProvider => 'रूट प्रदाता ओवरराइड करें';

  @override
  String get mapProviderAutoSetsProviders =>
      'मानचित्र प्रदाता बदलने पर अनुशंसित खोज और रूट अपडेट होते हैं।';

  @override
  String get apiKeyStatusConfigured => 'कॉन्फ़िगर किया गया';

  @override
  String get apiKeyStatusNotConfigured => 'कॉन्फ़िगर नहीं';

  @override
  String get apiKeyClear => 'साफ़ करें';

  @override
  String get apiKeyUpdate => 'कुंजी अपडेट करें';

  @override
  String get apiKeyAdd => 'कुंजी जोड़ें';

  @override
  String get testAllConfiguredKeys =>
      'सभी कॉन्फ़िगर की गई कुंजियाँ परीक्षण करें';

  @override
  String get apiKeysSecurityFooter =>
      'एन्क्रिप्टेड · Android Keystore · बैकअप में शामिल नहीं';

  @override
  String get languageFollowSystem => 'सिस्टम का अनुसरण करें';

  @override
  String get distancePresetCustom => 'कस्टम';

  @override
  String get batteryBalancedRecommended => 'संतुलित (अनुशंसित)';

  @override
  String get resumeAlarmAfterBootBatteryWarning =>
      'रीस्टार्ट के बाद सक्रिय अलार्म स्वचालित रूप से फिर से शुरू करें। बैटरी उपयोग बढ़ सकता है।';

  @override
  String get uploadBackupViaHttps => 'HTTPS के माध्यम से बैकअप अपलोड करें';

  @override
  String get shareLiveTrip => 'अलार्म साझा करें';

  @override
  String get importSharedAlarm => 'साझा अलार्म आयात करें';

  @override
  String get permRestricted => 'प्रतिबंधित';

  @override
  String get permLimited => 'सीमित';

  @override
  String get permProvisional => 'अनंतिम';

  @override
  String get aboutPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get aboutTermsOfService => 'सेवा की शर्तें';

  @override
  String get aboutDonateSupport => 'दान / सहायता';

  @override
  String get openMapSettings => 'मानचित्र सेटिंग्स खोलें';

  @override
  String get currentLocationLabel => 'वर्तमान स्थान';

  @override
  String get activeAlarmsEmptyHint =>
      'कोई सक्रिय अलार्म नहीं - बनाने के लिए + टैप करें';

  @override
  String get languageEndonymHint =>
      'भाषा के नाम उनकी मूल लिपि में दिखाए जाते हैं';

  @override
  String get shareAlarmTitle => 'Share Alarm';

  @override
  String get shareAlarmSubtitle => 'Share this alarm with someone else.';

  @override
  String get shareModePackageTitle => 'Alarm Package';

  @override
  String get shareModePackageSubtitle =>
      'Complete alarm configuration file (.nomadalarm)';

  @override
  String get shareModeDestinationTitle => 'Destination Only';

  @override
  String get shareModeDestinationSubtitle => 'Maps link anyone can open';

  @override
  String get shareModeQrTitle => 'QR Code';

  @override
  String get shareModeQrSubtitle => 'Generate a scannable code';

  @override
  String get shareModeCopyCoordsTitle => 'Copy Coordinates';

  @override
  String get sharePreviewTitle => 'Share preview';

  @override
  String get shareCoordsCopied => 'Coordinates copied';

  @override
  String get recommendedLabel => 'Recommended';

  @override
  String get enabledLabel => 'Enabled';

  @override
  String get disabledLabel => 'Disabled';

  @override
  String get importPreviewTitle => 'Import Shared Alarm';

  @override
  String get importPreviewDestination => 'Destination';

  @override
  String get importPreviewCoordinates => 'Coordinates';

  @override
  String get importEditBeforeSaving => 'Edit Before Saving';

  @override
  String get importSuccessTitle => 'Alarm Imported';

  @override
  String get importStartNow => 'Start Now';

  @override
  String get importSuccessEdit => 'Edit';

  @override
  String get importSuccessBack => 'Back';

  @override
  String get importErrorMissingCoordinates => 'Missing coordinates.';

  @override
  String get importErrorUnsupportedVersion => 'Unsupported version.';

  @override
  String get importErrorCorruptedFile => 'Corrupted file.';

  @override
  String get importDuplicateTitle => 'This alarm already exists.';

  @override
  String get importDuplicateBody =>
      'An alarm for this destination is already saved.';

  @override
  String get importDuplicateUpdate => 'Update Existing';

  @override
  String get importDuplicateCreateCopy => 'Create Copy';

  @override
  String get importSourceFile => 'Browse file (.nomadalarm / .json)';

  @override
  String get importSourceQr => 'Scan QR code';

  @override
  String get importSourceClipboard => 'Paste from clipboard';

  @override
  String get importClipboardDetected => 'Shared alarm detected.';

  @override
  String importBundleTitle(int count) {
    return '$count alarms found';
  }

  @override
  String get importBundleBody => 'Import all alarms from this bundle?';

  @override
  String get importBundleAll => 'Import All';

  @override
  String get importBundleFirstOnly => 'First Only';

  @override
  String importPreviewProgress(int current, int total) {
    return 'Alarm $current of $total';
  }

  @override
  String importProgressSaved(int current, int total) {
    return 'Saved $current of $total';
  }
}
