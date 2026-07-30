// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'Nomad Alarm';

  @override
  String get navHome => 'בית';

  @override
  String get navTrips => 'נסיעות';

  @override
  String get navHistory => 'היסטוריה';

  @override
  String get navSettings => 'הגדרות';

  @override
  String get createAlarm => 'יצירת התראה';

  @override
  String get searchDestinationHint => 'חיפוש יעד…';

  @override
  String get activeAlarms => 'התראות פעילות';

  @override
  String get favorites => 'מועדפים';

  @override
  String get recent => 'אחרונים';

  @override
  String get firstAlarmTitle => 'הגדר את התראת היעד הראשונה';

  @override
  String get firstAlarmBody => 'חפש מקום או הצב סיכה על המפה.';

  @override
  String get searchDestination => 'חיפוש יעד';

  @override
  String get gettingLocation => 'מאתר מיקום…';

  @override
  String get locationUnavailable => 'מיקום לא זמין - הקש לפתיחת מפה';

  @override
  String get activeAlarmFallback => 'התראה פעילה';

  @override
  String alarmRingingDistance(String distance) {
    return 'התראה פועלת - $distance מרחק';
  }

  @override
  String distanceAway(String distance) {
    return '$distance מרחק';
  }

  @override
  String get welcomeTitle => 'אל תפספס את התחנה שלך';

  @override
  String get welcomeBullet1 => '100% חינם - ללא פרסומות או מנויים';

  @override
  String get welcomeBullet2 => 'פרטיות קודמת - ללא התחברות או מעקב';

  @override
  String get welcomeBullet3 => 'עובד במצב לא מקוון להתראות פעילות';

  @override
  String get getStarted => 'התחל';

  @override
  String permissionsTitle(int current, int total) {
    return 'הרשאות ($current/$total)';
  }

  @override
  String get grant => 'אשר';

  @override
  String get skipForNow => 'דלג לעת עתה';

  @override
  String get required => 'נדרש';

  @override
  String get permLocationTitle => 'גישה למיקום';

  @override
  String get permLocationDesc =>
      'אנחנו צריכים את המיקום שלך כדי לחשב מרחק ליעד.';

  @override
  String get permNotificationTitle => 'התראות';

  @override
  String get permNotificationDesc => 'מוצגת התראה קטנה בזמן שההתראה פעילה.';

  @override
  String get permBackgroundTitle => 'מיקום ברקע';

  @override
  String get permBackgroundDesc => 'אפשר תמיד כדי שההתראה תעבוד כשהמסך כבוי.';

  @override
  String get permExactAlarmTitle => 'התראות מדויקות';

  @override
  String get permExactAlarmDesc => 'התראה אמינה בהגעה ליעד (Android 12+).';

  @override
  String get permBatteryTitle => 'אופטימיזציית סוללה';

  @override
  String get permBatteryDesc =>
      'ביטול אופטימיזציה עוזר ל-GPS לרוץ ברקע. אפשר לדלג, אך המעקב עלול להיעצר.';

  @override
  String get activeAlarmTitle => 'התראה פעילה';

  @override
  String get estimatedArrival => 'זמן הגעה משוער';

  @override
  String get gpsLostWarning => 'אות GPS אבד - המיקום האחרון עלול להיות ישן';

  @override
  String get passedDestinationWarning => 'ייתכן שעברת את היעד';

  @override
  String get lowBatteryWarning => 'סוללה נמוכה - טען את הטלפון למעקב אמין';

  @override
  String get alarmPaused => 'ההתראה מושהית';

  @override
  String get resume => 'המשך';

  @override
  String get pause => 'השהה';

  @override
  String get openMap => 'פתח מפה';

  @override
  String get cancelAlarm => 'בטל התראה';

  @override
  String get stopApproaching => 'מתקרבים לתחנה!';

  @override
  String get dismiss => 'סגור';

  @override
  String get snoozeTwoMin => 'נודניק 2 דק\'';

  @override
  String get createAlarmTitle => 'יצירת התראה';

  @override
  String get noDestinationSelected => 'לא נבחר יעד';

  @override
  String get selectDestinationFirst => 'בחר יעד קודם';

  @override
  String get alarmSaved => 'ההתראה נשמרה';

  @override
  String get alertDistance => 'מרחק התראה';

  @override
  String get voiceAlert => 'התראה קולית';

  @override
  String get voiceAlertSubtitle => 'הודעה מדוברת בעת הפעלה';

  @override
  String get vibration => 'רטט';

  @override
  String get flashlight => 'פנס';

  @override
  String get flashlightSubtitle => 'הבהוב LED כשההתראה מצלצלת';

  @override
  String get saveAndStart => 'שמור והתחל';

  @override
  String get saveOnly => 'שמור בלבד';

  @override
  String get settingsTitle => 'הגדרות';

  @override
  String get appearance => 'מראה';

  @override
  String get theme => 'ערכת נושא';

  @override
  String get themeSystem => 'מערכת';

  @override
  String get themeLight => 'בהיר';

  @override
  String get themeDark => 'כהה';

  @override
  String get units => 'יחידות';

  @override
  String get useMetricUnits => 'יחידות מטריות';

  @override
  String get kilometers => 'קילומטרים';

  @override
  String get miles => 'מיילים';

  @override
  String get distanceUnitsLabel => 'יחידות מרחק';

  @override
  String get language => 'שפה';

  @override
  String get english => 'אנגלית';

  @override
  String get hindi => 'הינדי';

  @override
  String get alarmDefaults => 'ברירות מחדל להתראה';

  @override
  String get defaultAlertDistance => 'מרחק התראה ברירת מחדל';

  @override
  String get battery => 'סוללה';

  @override
  String get gpsProfile => 'פרופיל GPS';

  @override
  String get batteryBalanced => 'מאוזן';

  @override
  String get batteryAggressive => 'אגרסיבי';

  @override
  String get batterySaver => 'חיסכון';

  @override
  String get batteryBalancedDesc => 'מתאים לנסיעות יומיות - עדכון כל ~10 מ\'';

  @override
  String get batteryAggressiveDesc => 'אמינות מקסימלית - יותר סוללה ליד היעד';

  @override
  String get batterySaverDesc => 'שימוש מינימלי ב-GPS - עלול לפגוע בדיוק';

  @override
  String get data => 'נתונים';

  @override
  String get exportBackup => 'ייצוא גיבוי';

  @override
  String get exportBackupSubtitle => 'שמור התראות, מועדפים, הגדרות והיסטוריה';

  @override
  String get importBackup => 'ייבוא גיבוי';

  @override
  String get importBackupSubtitle => 'שחזור מקובץ JSON';

  @override
  String get importBackupTitle => 'לייבא גיבוי?';

  @override
  String get importBackupBody =>
      'התראות, מועדפים, היסטוריה והגדרות מהקובץ ימוזגו למכשיר. התראות פעילות לא נכללות.';

  @override
  String get import => 'ייבוא';

  @override
  String get backupReady => 'הגיבוי מוכן לשיתוף';

  @override
  String importedSummary(
    int alarms,
    int favorites,
    int history,
    String settings,
  ) {
    return 'יובאו $alarms התראות, $favorites מועדפים, $history רשומות$settings.';
  }

  @override
  String get importedSettingsSuffix => ', הגדרות';

  @override
  String get more => 'עוד';

  @override
  String get permissionsMenu => 'הרשאות';

  @override
  String get privacyMenu => 'פרטיות';

  @override
  String get aboutMenu => 'אודות';

  @override
  String get debugMenu => 'Debug';

  @override
  String get aboutTitle => 'אודות';

  @override
  String get developedBy => 'פותח על ידי NomadProgrammer';

  @override
  String get aboutTagline =>
      'התראת מיקום שמכבדת פרטיות. חינם לנצח. ללא פרסומות או מעקב.';

  @override
  String get openSourceLicenses => 'רישיונות קוד פתוח';

  @override
  String get viewOnGitHub => 'צפה ב-GitHub';

  @override
  String get licensesTitle => 'רישיונות קוד פתוח';

  @override
  String get privacyTitle => 'פרטיות';

  @override
  String get privacyHeading => 'הפרטיות שלך חשובה';

  @override
  String get privacyBullet1 => 'לא נדרש חשבון או התחברות';

  @override
  String get privacyBullet2 => 'ללא פרסומות או אנליטיקה';

  @override
  String get privacyBullet3 => 'ללא אחסון ענן - כל הנתונים במכשיר';

  @override
  String get privacyBullet4 => 'המיקום משמש רק לחישוב מרחק ההתראה';

  @override
  String get privacyBullet5 => 'קוד פתוח - בדוק את הקוד בכל עת';

  @override
  String get fullPrivacyPolicy => 'מדיניות פרטיות מלאה';

  @override
  String get cancel => 'ביטול';

  @override
  String errorPrefix(String message) {
    return 'שגיאה: $message';
  }

  @override
  String get semCreateAlarm => 'יצירת התראת מיקום חדשה';

  @override
  String get semCancelAlarm => 'ביטול התראה פעילה';

  @override
  String get semDismissAlarm => 'סגירת התראה מצלצלת';

  @override
  String get semSnoozeAlarm => 'נודניק לשתי דקות';

  @override
  String get semExportBackup => 'ייצוא קובץ גיבוי';

  @override
  String get semImportBackup => 'ייבוא קובץ גיבוי';

  @override
  String get permCenterTitle => 'מרכז הרשאות';

  @override
  String get permGranted => 'אושר';

  @override
  String get permDenied => 'נדחה';

  @override
  String get permPermanentlyDenied => 'נדחה לצמיתות - פתח הגדרות';

  @override
  String get permFix => 'תקן';

  @override
  String get searchHintExtended => 'תחנה, ציון דרך, כתובת…';

  @override
  String searchFailed(String message) {
    return 'החיפוש נכשל: $message';
  }

  @override
  String get noResultsFound => 'לא נמצאו תוצאות';

  @override
  String get savedToFavorites => 'נשמר במועדפים';

  @override
  String get searchEmptyHint => 'חפש תחנה, ציון דרך או כתובת';

  @override
  String get importFromClipboard => 'ייבוא מהלוח';

  @override
  String get deepLinkInvalid => 'לא ניתן לנתח מיקום מהלוח';

  @override
  String get deepLinkImported => 'היעד יובא';

  @override
  String get mapTitle => 'מפה';

  @override
  String get droppedPin => 'סיכה הוצבה';

  @override
  String get lookingUpAddress => 'מחפש כתובת…';

  @override
  String get setAlarm => 'הגדר התראה';

  @override
  String get saveFavorite => 'שמור במועדפים';

  @override
  String get semCenterOnMap => 'מרכז מפה על המיקום שלך';

  @override
  String get semSetAlarmFromPin => 'הגדר התראה לסיכה';

  @override
  String get historyTitle => 'היסטוריה';

  @override
  String get filterAll => 'הכל';

  @override
  String get filterCompleted => 'הושלם';

  @override
  String get filterMissed => 'הוחמץ';

  @override
  String get noHistoryTitle => 'אין היסטוריה עדיין';

  @override
  String get noHistoryMessage => 'התראות שהושלמו או הוחמצו יירשמו כאן.';

  @override
  String get deleteEntryTitle => 'למחוק רשומה?';

  @override
  String deleteEntryBody(String name) {
    return 'להסיר את \"$name\" מההיסטוריה?';
  }

  @override
  String get delete => 'מחק';

  @override
  String get dateLabel => 'תאריך';

  @override
  String get triggerDistanceLabel => 'מרחק הפעלה';

  @override
  String get snoozesLabel => 'נודניקים';

  @override
  String get notesLabel => 'הערות';

  @override
  String get outcomeCompleted => 'הושלם';

  @override
  String get outcomeMissed => 'הוחמץ';

  @override
  String get outcomeDismissed => 'נדחה';

  @override
  String get outcomeSnoozed => 'נודניק';

  @override
  String get semDeleteHistoryEntry => 'מחק רשומת היסטוריה';

  @override
  String get tripsTitle => 'נסיעות';

  @override
  String get noTripsTitle => 'אין נסיעות עדיין';

  @override
  String get noTripsMessage => 'הנסיעות שהושלמו יופיעו כאן.';

  @override
  String get startedLabel => 'התחיל';

  @override
  String get endedLabel => 'הסתיים';

  @override
  String get durationLabel => 'משך';

  @override
  String get distanceLabel => 'מרחק';

  @override
  String get maxSpeedLabel => 'מהירות מרבית';

  @override
  String get avgSpeedLabel => 'מהירות ממוצעת';

  @override
  String get alarmIdLabel => 'מזהה התראה';

  @override
  String get tripOutcomeCancelled => 'בוטל';

  @override
  String get tripOutcomePassed => 'עבר';

  @override
  String get saveFavoriteTrip => 'שמור כנסיעה מועדפת';

  @override
  String get favoriteTripSaved => 'נסיעה מועדפת נשמרה';

  @override
  String get createAlarmFromTrip => 'צור התראה מהנסיעה';

  @override
  String get semSaveFavoriteTrip => 'שמור נסיעה כמועדפת';

  @override
  String get semCreateAlarmFromTrip => 'צור התראה חדשה מהנסיעה';

  @override
  String versionLabel(String version) {
    return 'גרסה $version';
  }

  @override
  String get kmhUnit => 'קמ\"ש';

  @override
  String get notifTrackingChannel => 'התראה פעילה';

  @override
  String get notifTrackingChannelDesc => 'מציג מרחק בזמן מעקב';

  @override
  String get notifAlarmChannel => 'צלצול התראה';

  @override
  String get notifAlarmChannelDesc => 'התראה בהגעה ליעד';

  @override
  String get notifWarningsChannel => 'אזהרות';

  @override
  String get notifGpsLostTitle => 'אות GPS אבד';

  @override
  String get notifGpsLostBody => 'עדכוני מיקום הופסקו - בדוק GPS';

  @override
  String get notifLowBatteryTitle => 'סוללה נמוכה';

  @override
  String get notifLowBatteryBody => 'טען את הטלפון כדי לשמור על ההתראה';

  @override
  String notifToDestination(String distance) {
    return '$distance ליעד';
  }

  @override
  String get widgetNoActiveAlarm => 'אין התראה פעילה';

  @override
  String get widgetTracking => 'מעקב…';

  @override
  String get widgetTapToOpen => 'הקש לפתיחה';

  @override
  String tileActiveDistance(String distance) {
    return '$distance מרחק';
  }

  @override
  String get semSearchSubmit => 'חפש יעד';

  @override
  String get semImportFromClipboard => 'ייבוא יעד מהלוח';

  @override
  String get metersUnit => 'מ\'';

  @override
  String get mphUnit => 'מייל/ש';

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugUnavailable => 'מסך Debug לא זמין';

  @override
  String get debugBackgroundService => 'שירות רקע';

  @override
  String get debugBattery => 'סוללה';

  @override
  String get debugActiveAlarmId => 'מזהה התראה פעילה';

  @override
  String get debugLoadingGps => 'טוען מצב GPS…';

  @override
  String get debugDistance => 'מרחק';

  @override
  String get debugEta => 'ETA';

  @override
  String get debugSpeed => 'מהירות';

  @override
  String get debugAccuracy => 'דיוק';

  @override
  String get debugGpsLost => 'GPS אבד';

  @override
  String get debugLowBattery => 'דגל סוללה נמוכה';

  @override
  String get debugPosition => 'מיקום';

  @override
  String get debugCharging => 'נטען';

  @override
  String get debugDischarging => 'לא נטען';

  @override
  String get debugCopySnapshot => 'העתק תמונת מצב';

  @override
  String get debugRefresh => 'רענן';

  @override
  String get debugSnapshotCopied => 'תמונת Debug הועתקה';

  @override
  String get fgsStartingTitle => 'Nomad Alarm';

  @override
  String get fgsStartingContent => 'מתחיל מעקב מיקום…';

  @override
  String get resumeAlarmAfterBoot => 'המשך התראה אחרי אתחול';

  @override
  String get resumeAlarmAfterBootSubtitle =>
      'הפעל מעקב מחדש לאחר הפעלה מחדש (יותר סוללה)';

  @override
  String get mapsSection => 'מפות וניווט';

  @override
  String get mapSettingsTitle => 'הגדרות מפה';

  @override
  String get mapSettingsSubtitle => 'ספקים, שכבות ואריחים לא מקוונים';

  @override
  String get mapProvidersSection => 'ספקים';

  @override
  String get mapProviderLabel => 'ספק מפה';

  @override
  String get searchProviderLabel => 'ספק חיפוש';

  @override
  String get routeProviderLabel => 'ספק מסלול';

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
  String get apiKeysTitle => 'מפתחות API';

  @override
  String get apiKeysIntro => 'מפתחות נשמרים מוצפנים במכשיר ולא בגיבוי.';

  @override
  String get apiKeySaved => 'מפתח API נשמר';

  @override
  String get apiKeyTest => 'בדיקה';

  @override
  String get apiKeyTestSuccess => 'החיבור הצליח';

  @override
  String get apiKeyTestFailure => 'החיבור נכשל - בדוק מפתח';

  @override
  String get apiKeyGoogle => 'מפתח Google API';

  @override
  String get apiKeyGoogleHint => 'מפתח אחד למפות, Places ו-Directions';

  @override
  String get apiKeyGoogleHelp => 'מדריך הגדרה';

  @override
  String get googleMapKeyRequired =>
      'Google Maps דורש מפתח API. הוסף בהגדרות ובחר Google כספק מפות.';

  @override
  String get googleMapKeyRequiredAction => 'פתח מפתחות API';

  @override
  String get googleMapKeySetupGuide => 'איך ליצור מפתח Google API';

  @override
  String get apiKeyGoogleMaps => 'Google Maps SDK';

  @override
  String get apiKeyGooglePlaces => 'Google Places';

  @override
  String get apiKeyGoogleDirections => 'Google Directions';

  @override
  String get apiKeyMapbox => 'אסימון Mapbox';

  @override
  String get apiKeyHere => 'מפתח HERE API';

  @override
  String get apiKeyGraphhopper => 'מפתח GraphHopper API';

  @override
  String get apiKeyGoogleMapsHint => 'הוסף גם ל-AndroidManifest למפה מקורית';

  @override
  String get apiKeyGooglePlacesHint => 'מפתח Places API';

  @override
  String get apiKeyGoogleDirectionsHint => 'מפתח Directions API';

  @override
  String get apiKeyMapboxHint => 'אסימון pk.…';

  @override
  String get apiKeyHereHint => 'מפתח HERE REST API';

  @override
  String get apiKeyGraphhopperHint => 'אופציונלי למגבלות גבוהות';

  @override
  String get saveKey => 'שמור';

  @override
  String get mapOfflineSection => 'אריחים לא מקוונים';

  @override
  String get mapOfflineCacheSize => 'גודל מטמון';

  @override
  String get mapOfflineDownload => 'הורד אזור לדוגמה';

  @override
  String get mapOfflineDownloadSubtitle => 'אזור לונדון, זום 10–16';

  @override
  String get mapOfflineDownloadComplete => 'אזור לא מקוון הורד';

  @override
  String get mapOfflineClearCache => 'נקה מטמון לא מקוון';

  @override
  String get mapOfflineCacheCleared => 'מטמון לא מקוון נוקה';

  @override
  String get mapOfflineGoogleUnsupported =>
      'אריחים לא מקוונים לא זמינים למפת Google';

  @override
  String get mapLayerLabel => 'שכבת מפה';

  @override
  String get mapLayerStandard => 'רגיל';

  @override
  String get mapLayerSatellite => 'לוויין';

  @override
  String get mapLayerDark => 'כהה';

  @override
  String get alarmTypeLabel => 'סוג התראה';

  @override
  String get alarmTypeDistance => 'מרחק';

  @override
  String get alarmTypeArrival => 'הגעה (כניסה לגדר)';

  @override
  String get alarmTypeDeparture => 'יציאה (עזיבת גדר)';

  @override
  String get alarmTypeRadius => 'רדיוס';

  @override
  String get alarmTypeEta => 'ETA';

  @override
  String get alarmTypeSpeed => 'מהירות';

  @override
  String get alarmTypeGeofence => 'גדר גאוגרפית';

  @override
  String get travelModeLabel => 'אמצעי נסיעה';

  @override
  String get travelModeTrain => 'רכבת';

  @override
  String get travelModeBus => 'אוטובוס';

  @override
  String get travelModeMetro => 'רכבת תחתית';

  @override
  String get travelModeCar => 'רכב';

  @override
  String get travelModeWalking => 'הליכה';

  @override
  String get travelModeCycling => 'אופניים';

  @override
  String get travelModeAuto => 'זיהוי אוטומטי';

  @override
  String get speedThresholdLabel => 'סף מהירות';

  @override
  String get etaTriggerMinutes => 'התראה כש-ETA מתחת (דקות)';

  @override
  String get shareAlarmConfig => 'שתף התראה';

  @override
  String get shareAlarmConfigSuccess => 'תצורת התראה הועתקה ללוח';

  @override
  String get groupTravelTitle => 'נסיעה קבוצתית';

  @override
  String get customRingtone => 'רינגטון מותאם';

  @override
  String get pickRingtone => 'בחר רינגטון';

  @override
  String get arabic => 'ערבית';

  @override
  String get hebrew => 'עברית';

  @override
  String get cloudBackupUpload => 'העלה גיבוי לענן';

  @override
  String get cloudBackupUrlHint => 'כתובת HTTPS להעלאה';

  @override
  String get cloudBackupSuccess => 'הגיבוי הועלה בהצלחה';

  @override
  String get cloudBackupFailed => 'העלאה לענן נכשלה';

  @override
  String get importAlarmConfig => 'תצורת התראה יובאה';

  @override
  String get lockScreenInfo => 'הצג במסך נעילה';

  @override
  String get lockScreenInfoSubtitle => 'הצג מרחק ו-ETA בהתראת מסך נעילה';

  @override
  String get notifInternetLostTitle => 'חיבור האינטרנט אבד';

  @override
  String get notifInternetLostBody =>
      'ETA מסלול עלול להיות לא זמין עד שהחיבור יחזור';

  @override
  String get shareAllAlarms => 'שתף התראות פעילות';

  @override
  String get importAlarmBundle => 'ייבוא חבילת התראות';

  @override
  String alarmBundleImported(int count) {
    return 'יובאו $count התראות';
  }

  @override
  String get mapLayerTerrain => 'שטח';

  @override
  String get mapProviderApple => 'Apple Maps';

  @override
  String get highContrast => 'ניגודיות גבוהה';

  @override
  String get highContrastSubtitle => 'הגבר ניגודיות לקריאות';

  @override
  String get voiceSearchHint => 'אמור שם יעד';

  @override
  String get tileTapToCancel => 'הקש לביטול התראה';

  @override
  String get tileTapToCreate => 'הקש ליצירת התראה';

  @override
  String get alarmCreatedSuccess => 'ההתראה נוצרה בהצלחה';

  @override
  String get alarmDetailsTitle => 'פרטי התראה';

  @override
  String get addAnotherAlarm => 'הוסף התראה נוספת';

  @override
  String get newAlarm => 'התראה חדשה';

  @override
  String get alarmStatusTracking => 'מעקב';

  @override
  String get alarmStatusPaused => 'מושהה';

  @override
  String alarmNumberLabel(int number) {
    return 'התראה #$number';
  }

  @override
  String activeAlarmsCount(int count) {
    return 'התראות פעילות ($count)';
  }

  @override
  String get save => 'שמור';

  @override
  String get providersSection => 'ספקים';

  @override
  String get providerChangedSuccess => 'הספק שונה בהצלחה.';

  @override
  String get noApiKeyRequired => 'לא נדרש מפתח API. הספק שונה בהצלחה.';

  @override
  String get configureAndSave => 'הגדר ושמור';

  @override
  String get providerSaveBlocked => 'השמירה חסומה עד להזנת מפתח API תקין.';

  @override
  String get credentialGoogleMapsTitle => 'Google Maps דורש מפתח API';

  @override
  String get credentialGoogleServicesTitle => 'שירותי Google דורשים מפתח API';

  @override
  String get credentialGoogleMapsBody =>
      'מפתח אחד מכסה Maps, Places ו-Directions כשהם מופעלים.';

  @override
  String get credentialMapboxTitle => 'Mapbox דורש אסימון גישה';

  @override
  String get credentialMapboxBody =>
      'הזן את אסימון Mapbox לשימוש במפות Mapbox.';

  @override
  String get credentialHereTitle => 'HERE דורש מפתח API';

  @override
  String get credentialHereBody => 'הזן את מפתח HERE REST API.';

  @override
  String get credentialGraphhopperTitle => 'GraphHopper דורש מפתח API';

  @override
  String get credentialGraphhopperBody => 'הזן מפתח GraphHopper לניתוב.';

  @override
  String get googleServiceMaps => 'Maps SDK ל-Android';

  @override
  String get googleServicePlaces => 'Places API';

  @override
  String get googleServiceDirections => 'Directions API';

  @override
  String get googleServiceAlsoUsed => 'בשימוש גם כשמופעל (אותו מפתח)';

  @override
  String get advancedSection => 'מתקדם';

  @override
  String get advancedApiKeys => 'מפתחות API';

  @override
  String get useRecommendedProviders => 'השתמש בספקים מומלצים';

  @override
  String get useRecommendedProvidersSubtitle =>
      'שמור על חיפוש ומסלול תואמים לספק המפות';

  @override
  String get overrideSearchProvider => 'עקוף ספק חיפוש';

  @override
  String get overrideRouteProvider => 'עקוף ספק מסלול';

  @override
  String get mapProviderAutoSetsProviders =>
      'שינוי ספק המפות מעדכן חיפוש ומסלול מומלצים.';

  @override
  String get apiKeyStatusConfigured => 'מוגדר';

  @override
  String get apiKeyStatusNotConfigured => 'לא מוגדר';

  @override
  String get apiKeyClear => 'נקה';

  @override
  String get apiKeyUpdate => 'עדכן מפתח';

  @override
  String get apiKeyAdd => 'הוסף מפתח';

  @override
  String get testAllConfiguredKeys => 'בדוק את כל המפתחות המוגדרים';

  @override
  String get apiKeysSecurityFooter =>
      'מוצפן · Android Keystore · לא כלול בגיבוי';

  @override
  String get languageFollowSystem => 'עקוב אחר המערכת';

  @override
  String get distancePresetCustom => 'מותאם';

  @override
  String get batteryBalancedRecommended => 'מאוזן (מומלץ)';

  @override
  String get resumeAlarmAfterBootBatteryWarning =>
      'הפעל מעקב מחדש לאחר אתחול. צורך יותר סוללה.';

  @override
  String get uploadBackupViaHttps => 'העלה גיבוי דרך HTTPS';

  @override
  String get shareLiveTrip => 'שתף נסיעה חיה';

  @override
  String get importSharedAlarm => 'ייבא התראה משותפת';

  @override
  String get permRestricted => 'מוגבל';

  @override
  String get permLimited => 'חלקי';

  @override
  String get permProvisional => 'זמני';

  @override
  String get aboutPrivacyPolicy => 'מדיניות פרטיות';

  @override
  String get aboutTermsOfService => 'תנאי שירות';

  @override
  String get aboutDonateSupport => 'תרום / תמוך';

  @override
  String get openMapSettings => 'פתח הגדרות מפה';

  @override
  String get currentLocationLabel => 'מיקום נוכחי';

  @override
  String get activeAlarmsEmptyHint => 'אין התראות פעילות - הקש + ליצירה';

  @override
  String get languageEndonymHint => 'שמות השפות מוצגים בכתב המקורי שלהן';
}
