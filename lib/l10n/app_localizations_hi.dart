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
  String get recent => 'हाल के';

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
  String get voiceAlert => 'आवाज़ अलर्ट';

  @override
  String get voiceAlertSubtitle => 'ट्रिगर होने पर बोला जाएगा';

  @override
  String get vibration => 'कंपन';

  @override
  String get flashlight => 'फ़्लैशलाइट';

  @override
  String get flashlightSubtitle => 'अलार्म पर LED स्ट्रोब';

  @override
  String get saveAndStart => 'सहेजें और शुरू करें';

  @override
  String get saveOnly => 'केवल सहेजें';

  @override
  String get settingsTitle => 'सेटिंग्स';

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
  String get language => 'भाषा';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get alarmDefaults => 'अलार्म डिफ़ॉल्ट';

  @override
  String get defaultAlertDistance => 'डिफ़ॉल्ट अलर्ट दूरी';

  @override
  String get battery => 'बैटरी';

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
      'दैनिक यात्रा के लिए - लगभग हर 10 मी पर अपडेट';

  @override
  String get batteryAggressiveDesc =>
      'अधिकतम विश्वसनीयता - गंतव्य के पास अधिक बैटरी';

  @override
  String get batterySaverDesc => 'कम GPS उपयोग - सटीकता कम हो सकती है';

  @override
  String get data => 'डेटा';

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
  String get more => 'अधिक';

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
  String get filterCompleted => 'पूर्ण';

  @override
  String get filterMissed => 'चूके';

  @override
  String get noHistoryTitle => 'अभी कोई इतिहास नहीं';

  @override
  String get noHistoryMessage => 'पूर्ण और चूके अलार्म यहाँ दर्ज होंगे।';

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
  String get fgsStartingTitle => 'नोमैड अलार्म';

  @override
  String get fgsStartingContent => 'स्थान ट्रैकिंग शुरू हो रही है…';

  @override
  String get resumeAlarmAfterBoot => 'रीबूट के बाद अलार्म जारी रखें';

  @override
  String get resumeAlarmAfterBootSubtitle =>
      'डिवाइस रीस्टार्ट पर ट्रैकिंग फिर शुरू करें (अधिक बैटरी)';
}
