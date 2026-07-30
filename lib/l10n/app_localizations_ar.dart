// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Nomad Alarm';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navTrips => 'الرحلات';

  @override
  String get navHistory => 'السجل';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get createAlarm => 'إنشاء منبه';

  @override
  String get searchDestinationHint => 'ابحث عن الوجهة…';

  @override
  String get activeAlarms => 'منبهات نشطة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get recent => 'الأخيرة';

  @override
  String get firstAlarmTitle => 'عيّن أول منبه وجهة';

  @override
  String get firstAlarmBody => 'ابحث عن مكان أو ضع دبوسًا على الخريطة.';

  @override
  String get searchDestination => 'البحث عن وجهة';

  @override
  String get gettingLocation => 'جاري تحديد الموقع…';

  @override
  String get locationUnavailable => 'الموقع غير متاح - اضغط لفتح الخريطة';

  @override
  String get activeAlarmFallback => 'منبه نشط';

  @override
  String alarmRingingDistance(String distance) {
    return 'المنبه يعمل - على بعد $distance';
  }

  @override
  String distanceAway(String distance) {
    return 'على بعد $distance';
  }

  @override
  String get welcomeTitle => 'لا تفوّت محطتك مرة أخرى';

  @override
  String get welcomeBullet1 => 'مجاني 100% - بدون إعلانات أو اشتراكات';

  @override
  String get welcomeBullet2 => 'الخصوصية أولاً - بدون تسجيل دخول أو تتبع';

  @override
  String get welcomeBullet3 => 'يعمل دون اتصال للمنبهات النشطة';

  @override
  String get getStarted => 'ابدأ';

  @override
  String permissionsTitle(int current, int total) {
    return 'الأذونات ($current/$total)';
  }

  @override
  String get grant => 'منح';

  @override
  String get skipForNow => 'تخطّ الآن';

  @override
  String get required => 'مطلوب';

  @override
  String get permLocationTitle => 'الوصول إلى الموقع';

  @override
  String get permLocationDesc => 'نحتاج موقعك لحساب المسافة إلى وجهتك.';

  @override
  String get permNotificationTitle => 'الإشعارات';

  @override
  String get permNotificationDesc => 'نعرض إشعارًا صغيرًا أثناء تشغيل المنبه.';

  @override
  String get permBackgroundTitle => 'الموقع في الخلفية';

  @override
  String get permBackgroundDesc => 'اسمح دائمًا ليعمل المنبه عند إطفاء الشاشة.';

  @override
  String get permExactAlarmTitle => 'منبهات دقيقة';

  @override
  String get permExactAlarmDesc =>
      'تنبيه موثوق عند الوصول إلى وجهتك (Android 12+).';

  @override
  String get permBatteryTitle => 'تحسين البطارية';

  @override
  String get permBatteryDesc =>
      'إيقاف تحسين البطارية يساعد GPS على العمل في الخلفية. يمكنك التخطي، لكن التتبع قد يتوقف على بعض الأجهزة.';

  @override
  String get activeAlarmTitle => 'منبه نشط';

  @override
  String get estimatedArrival => 'الوصول المتوقع';

  @override
  String get gpsLostWarning => 'فُقد إشارة GPS - آخر موقع قد يكون قديمًا';

  @override
  String get passedDestinationWarning => 'ربما تجاوزت وجهتك';

  @override
  String get lowBatteryWarning => 'بطارية منخفضة - شحن الهاتف للتتبع الموثوق';

  @override
  String get alarmPaused => 'المنبه متوقف مؤقتًا';

  @override
  String get resume => 'استئناف';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get openMap => 'فتح الخريطة';

  @override
  String get cancelAlarm => 'إلغاء المنبه';

  @override
  String get stopApproaching => 'اقتربت من المحطة!';

  @override
  String get dismiss => 'تجاهل';

  @override
  String get snoozeTwoMin => 'غفوة دقيقتين';

  @override
  String get createAlarmTitle => 'إنشاء منبه';

  @override
  String get noDestinationSelected => 'لم تُحدَّد وجهة';

  @override
  String get selectDestinationFirst => 'يرجى اختيار وجهة أولاً';

  @override
  String get alarmSaved => 'تم حفظ المنبه';

  @override
  String get alertDistance => 'مسافة التنبيه';

  @override
  String get voiceAlert => 'تنبيه صوتي';

  @override
  String get voiceAlertSubtitle => 'تنبيه منطوق عند التفعيل';

  @override
  String get vibration => 'اهتزاز';

  @override
  String get flashlight => 'مصباح';

  @override
  String get flashlightSubtitle => 'وميض LED عند رنين المنبه';

  @override
  String get saveAndStart => 'حفظ وبدء';

  @override
  String get saveOnly => 'حفظ فقط';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get units => 'الوحدات';

  @override
  String get useMetricUnits => 'استخدام الوحدات المترية';

  @override
  String get kilometers => 'كيلومترات';

  @override
  String get miles => 'أميال';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get hindi => 'الهندية';

  @override
  String get alarmDefaults => 'إعدادات المنبه الافتراضية';

  @override
  String get defaultAlertDistance => 'مسافة التنبيه الافتراضية';

  @override
  String get battery => 'البطارية';

  @override
  String get gpsProfile => 'ملف GPS';

  @override
  String get batteryBalanced => 'متوازن';

  @override
  String get batteryAggressive => 'مكثّف';

  @override
  String get batterySaver => 'توفير';

  @override
  String get batteryBalancedDesc => 'الأفضل للتنقل اليومي - تحديث كل ~10 م';

  @override
  String get batteryAggressiveDesc =>
      'أقصى موثوقية - استهلاك بطارية أكبر قرب الوجهة';

  @override
  String get batterySaverDesc => 'أقل استخدام GPS - قد تقل الدقة';

  @override
  String get data => 'البيانات';

  @override
  String get exportBackup => 'تصدير النسخة الاحتياطية';

  @override
  String get exportBackupSubtitle => 'حفظ المنبهات والمفضلة والإعدادات والسجل';

  @override
  String get importBackup => 'استيراد النسخة الاحتياطية';

  @override
  String get importBackupSubtitle => 'استعادة من ملف JSON احتياطي';

  @override
  String get importBackupTitle => 'استيراد النسخة الاحتياطية؟';

  @override
  String get importBackupBody =>
      'ستُدمَج المنبهات والمفضلة والسجل والإعدادات من الملف. المنبهات الجارية غير مشمولة.';

  @override
  String get import => 'استيراد';

  @override
  String get backupReady => 'النسخة الاحتياطية جاهزة للمشاركة';

  @override
  String importedSummary(
    int alarms,
    int favorites,
    int history,
    String settings,
  ) {
    return 'تم استيراد $alarms منبهات، $favorites مفضلة، $history سجل$settings.';
  }

  @override
  String get importedSettingsSuffix => '، الإعدادات';

  @override
  String get more => 'المزيد';

  @override
  String get permissionsMenu => 'الأذونات';

  @override
  String get privacyMenu => 'الخصوصية';

  @override
  String get aboutMenu => 'حول';

  @override
  String get debugMenu => 'تصحيح';

  @override
  String get aboutTitle => 'حول';

  @override
  String get developedBy => 'طوّره NomadProgrammer';

  @override
  String get aboutTagline =>
      'منبه موقع يحترم الخصوصية. مجاني للأبد. بدون إعلانات أو تتبع.';

  @override
  String get openSourceLicenses => 'تراخيص مفتوحة المصدر';

  @override
  String get viewOnGitHub => 'عرض على GitHub';

  @override
  String get licensesTitle => 'تراخيص مفتوحة المصدر';

  @override
  String get privacyTitle => 'الخصوصية';

  @override
  String get privacyHeading => 'خصوصيتك مهمة';

  @override
  String get privacyBullet1 => 'لا حاجة لحساب أو تسجيل دخول';

  @override
  String get privacyBullet2 => 'بدون إعلانات أو تحليلات';

  @override
  String get privacyBullet3 => 'بدون تخزين سحابي - كل البيانات على جهازك';

  @override
  String get privacyBullet4 => 'يُستخدم الموقع فقط لحساب مسافة المنبه';

  @override
  String get privacyBullet5 => 'مفتوح المصدر - راجع الكود في أي وقت';

  @override
  String get fullPrivacyPolicy => 'سياسة الخصوصية الكاملة';

  @override
  String get cancel => 'إلغاء';

  @override
  String errorPrefix(String message) {
    return 'خطأ: $message';
  }

  @override
  String get semCreateAlarm => 'إنشاء منبه موقع جديد';

  @override
  String get semCancelAlarm => 'إلغاء المنبه النشط';

  @override
  String get semDismissAlarm => 'تجاهل المنبه الرنان';

  @override
  String get semSnoozeAlarm => 'غفوة المنبه لدقيقتين';

  @override
  String get semExportBackup => 'تصدير ملف النسخة الاحتياطية';

  @override
  String get semImportBackup => 'استيراد ملف النسخة الاحتياطية';

  @override
  String get permCenterTitle => 'مركز الأذونات';

  @override
  String get permGranted => 'ممنوح';

  @override
  String get permDenied => 'مرفوض';

  @override
  String get permPermanentlyDenied => 'مرفوض نهائيًا - افتح الإعدادات';

  @override
  String get permFix => 'إصلاح';

  @override
  String get searchHintExtended => 'محطة، معلم، عنوان…';

  @override
  String searchFailed(String message) {
    return 'فشل البحث: $message';
  }

  @override
  String get noResultsFound => 'لا توجد نتائج';

  @override
  String get savedToFavorites => 'حُفظ في المفضلة';

  @override
  String get searchEmptyHint => 'ابحث عن محطة أو معلم أو عنوان';

  @override
  String get importFromClipboard => 'استيراد من الحافظة';

  @override
  String get deepLinkInvalid => 'تعذّر تحليل الموقع من الحافظة';

  @override
  String get deepLinkImported => 'تم استيراد الوجهة';

  @override
  String get mapTitle => 'الخريطة';

  @override
  String get droppedPin => 'دبوس موضوع';

  @override
  String get lookingUpAddress => 'جاري البحث عن العنوان…';

  @override
  String get setAlarm => 'تعيين منبه';

  @override
  String get saveFavorite => 'حفظ في المفضلة';

  @override
  String get semCenterOnMap => 'توسيط الخريطة على موقعك';

  @override
  String get semSetAlarmFromPin => 'تعيين منبه للدبوس';

  @override
  String get historyTitle => 'السجل';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterCompleted => 'مكتمل';

  @override
  String get filterMissed => 'فائت';

  @override
  String get noHistoryTitle => 'لا يوجد سجل بعد';

  @override
  String get noHistoryMessage => 'سيُسجَّل المنبهات المكتملة والفائتة هنا.';

  @override
  String get deleteEntryTitle => 'حذف السجل؟';

  @override
  String deleteEntryBody(String name) {
    return 'إزالة \"$name\" من السجل؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get triggerDistanceLabel => 'مسافة التفعيل';

  @override
  String get snoozesLabel => 'الغفوات';

  @override
  String get notesLabel => 'ملاحظات';

  @override
  String get outcomeCompleted => 'مكتمل';

  @override
  String get outcomeMissed => 'فائت';

  @override
  String get outcomeDismissed => 'مُتجاهَل';

  @override
  String get outcomeSnoozed => 'غفوة';

  @override
  String get semDeleteHistoryEntry => 'حذف سجل';

  @override
  String get tripsTitle => 'الرحلات';

  @override
  String get noTripsTitle => 'لا توجد رحلات بعد';

  @override
  String get noTripsMessage => 'ستظهر رحلاتك المكتملة هنا.';

  @override
  String get startedLabel => 'بدأ';

  @override
  String get endedLabel => 'انتهى';

  @override
  String get durationLabel => 'المدة';

  @override
  String get distanceLabel => 'المسافة';

  @override
  String get maxSpeedLabel => 'السرعة القصوى';

  @override
  String get avgSpeedLabel => 'متوسط السرعة';

  @override
  String get alarmIdLabel => 'معرّف المنبه';

  @override
  String get tripOutcomeCancelled => 'ملغى';

  @override
  String get tripOutcomePassed => 'تجاوز';

  @override
  String get saveFavoriteTrip => 'حفظ كرحلة مفضلة';

  @override
  String get favoriteTripSaved => 'حُفظت الرحلة المفضلة';

  @override
  String get createAlarmFromTrip => 'إنشاء منبه من الرحلة';

  @override
  String get semSaveFavoriteTrip => 'حفظ الرحلة كمفضلة';

  @override
  String get semCreateAlarmFromTrip => 'إنشاء منبه جديد من هذه الرحلة';

  @override
  String versionLabel(String version) {
    return 'الإصدار $version';
  }

  @override
  String get kmhUnit => 'كم/س';

  @override
  String get notifTrackingChannel => 'منبه نشط';

  @override
  String get notifTrackingChannelDesc => 'يعرض المسافة أثناء تتبع المنبه';

  @override
  String get notifAlarmChannel => 'رنين المنبه';

  @override
  String get notifAlarmChannelDesc => 'تنبيه عند الوصول إلى الوجهة';

  @override
  String get notifWarningsChannel => 'تحذيرات';

  @override
  String get notifGpsLostTitle => 'فُقد إشارة GPS';

  @override
  String get notifGpsLostBody => 'توقّفت تحديثات الموقع - تحقق من GPS';

  @override
  String get notifLowBatteryTitle => 'بطارية منخفضة';

  @override
  String get notifLowBatteryBody => 'اشحن هاتفك للحفاظ على عمل المنبه';

  @override
  String notifToDestination(String distance) {
    return '$distance إلى الوجهة';
  }

  @override
  String get widgetNoActiveAlarm => 'لا يوجد منبه نشط';

  @override
  String get widgetTracking => 'جاري التتبع…';

  @override
  String get widgetTapToOpen => 'اضغط للفتح';

  @override
  String tileActiveDistance(String distance) {
    return 'على بعد $distance';
  }

  @override
  String get semSearchSubmit => 'البحث عن وجهة';

  @override
  String get semImportFromClipboard => 'استيراد وجهة من الحافظة';

  @override
  String get metersUnit => 'م';

  @override
  String get mphUnit => 'ميل/س';

  @override
  String get debugTitle => 'تصحيح';

  @override
  String get debugUnavailable => 'شاشة التصحيح غير متاحة';

  @override
  String get debugBackgroundService => 'خدمة الخلفية';

  @override
  String get debugBattery => 'البطارية';

  @override
  String get debugActiveAlarmId => 'معرّف المنبه النشط';

  @override
  String get debugLoadingGps => 'جاري تحميل حالة GPS…';

  @override
  String get debugDistance => 'المسافة';

  @override
  String get debugEta => 'ETA';

  @override
  String get debugSpeed => 'السرعة';

  @override
  String get debugAccuracy => 'الدقة';

  @override
  String get debugGpsLost => 'GPS مفقود';

  @override
  String get debugLowBattery => 'علامة بطارية منخفضة';

  @override
  String get debugPosition => 'الموقع';

  @override
  String get debugCharging => 'يشحن';

  @override
  String get debugDischarging => 'لا يشحن';

  @override
  String get debugCopySnapshot => 'نسخ اللقطة';

  @override
  String get debugRefresh => 'تحديث';

  @override
  String get debugSnapshotCopied => 'نُسخت لقطة التصحيح';

  @override
  String get fgsStartingTitle => 'Nomad Alarm';

  @override
  String get fgsStartingContent => 'جاري بدء تتبع الموقع…';

  @override
  String get resumeAlarmAfterBoot => 'استئناف المنبه بعد إعادة التشغيل';

  @override
  String get resumeAlarmAfterBootSubtitle =>
      'إعادة التتبع عند إعادة تشغيل الجهاز (استهلاك بطارية أكبر)';

  @override
  String get mapsSection => 'الخرائط والتوجيه';

  @override
  String get mapSettingsTitle => 'إعدادات الخريطة';

  @override
  String get mapSettingsSubtitle => 'المزودون، البلاطات دون اتصال، مفاتيح API';

  @override
  String get mapProvidersSection => 'المزودون';

  @override
  String get mapProviderLabel => 'مزود الخريطة';

  @override
  String get searchProviderLabel => 'مزود البحث';

  @override
  String get routeProviderLabel => 'مزود المسار';

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
  String get apiKeysTitle => 'مفاتيح API';

  @override
  String get apiKeysIntro =>
      'تُخزَّن المفاتيح مشفّرة على الجهاز ولا تُضمَّن في النسخ الاحتياطية.';

  @override
  String get apiKeySaved => 'حُفظ مفتاح API';

  @override
  String get apiKeyTest => 'اختبار';

  @override
  String get apiKeyTestSuccess => 'نجح الاتصال';

  @override
  String get apiKeyTestFailure => 'فشل الاتصال - تحقق من المفتاح';

  @override
  String get apiKeyGoogle => 'مفتاح Google API';

  @override
  String get apiKeyGoogleHint => 'مفتاح واحد للخرائط والأماكن والاتجاهات';

  @override
  String get apiKeyGoogleHelp => 'دليل الإعداد';

  @override
  String get googleMapKeyRequired =>
      'يتطلب Google Maps مفتاح API. أضفه في الإعدادات ثم اختر Google كمزود الخريطة.';

  @override
  String get googleMapKeyRequiredAction => 'فتح مفاتيح API';

  @override
  String get googleMapKeySetupGuide => 'كيفية إنشاء مفتاح Google API';

  @override
  String get apiKeyGoogleMaps => 'Google Maps SDK';

  @override
  String get apiKeyGooglePlaces => 'Google Places';

  @override
  String get apiKeyGoogleDirections => 'Google Directions';

  @override
  String get apiKeyMapbox => 'رمز Mapbox';

  @override
  String get apiKeyHere => 'مفتاح HERE API';

  @override
  String get apiKeyGraphhopper => 'مفتاح GraphHopper API';

  @override
  String get apiKeyGoogleMapsHint =>
      'أضف أيضًا إلى AndroidManifest للخريطة الأصلية';

  @override
  String get apiKeyGooglePlacesHint => 'مفتاح Places API';

  @override
  String get apiKeyGoogleDirectionsHint => 'مفتاح Directions API';

  @override
  String get apiKeyMapboxHint => 'رمز pk.…';

  @override
  String get apiKeyHereHint => 'مفتاح HERE REST API';

  @override
  String get apiKeyGraphhopperHint => 'اختياري لحدود أعلى';

  @override
  String get saveKey => 'حفظ';

  @override
  String get mapOfflineSection => 'بلاطات دون اتصال';

  @override
  String get mapOfflineCacheSize => 'حجم الذاكرة المؤقتة';

  @override
  String get mapOfflineDownload => 'تنزيل منطقة نموذجية';

  @override
  String get mapOfflineDownloadSubtitle => 'منطقة لندن، تكبير 10–16';

  @override
  String get mapOfflineDownloadComplete => 'تم تنزيل المنطقة دون اتصال';

  @override
  String get mapOfflineClearCache => 'مسح الذاكرة المؤقتة';

  @override
  String get mapOfflineCacheCleared => 'مُسحت الذاكرة المؤقتة';

  @override
  String get mapOfflineGoogleUnsupported =>
      'البلاطات دون اتصال غير متاحة لخريطة Google الأصلية';

  @override
  String get mapLayerLabel => 'طبقة الخريطة';

  @override
  String get mapLayerStandard => 'قياسي';

  @override
  String get mapLayerSatellite => 'قمر صناعي';

  @override
  String get mapLayerDark => 'داكن';

  @override
  String get alarmTypeLabel => 'نوع المنبه';

  @override
  String get alarmTypeDistance => 'مسافة';

  @override
  String get alarmTypeArrival => 'وصول (دخول السياج)';

  @override
  String get alarmTypeDeparture => 'مغادرة (خروج السياج)';

  @override
  String get alarmTypeRadius => 'نصف قطر';

  @override
  String get alarmTypeEta => 'ETA';

  @override
  String get alarmTypeSpeed => 'سرعة';

  @override
  String get alarmTypeGeofence => 'سياج جغرافي';

  @override
  String get travelModeLabel => 'وسيلة السفر';

  @override
  String get travelModeTrain => 'قطار';

  @override
  String get travelModeBus => 'حافلة';

  @override
  String get travelModeMetro => 'مترو';

  @override
  String get travelModeCar => 'سيارة';

  @override
  String get travelModeWalking => 'مشي';

  @override
  String get travelModeCycling => 'دراجة';

  @override
  String get travelModeAuto => 'اكتشاف تلقائي';

  @override
  String get speedThresholdLabel => 'حد السرعة';

  @override
  String get etaTriggerMinutes => 'تنبيه عند ETA أقل من (دقائق)';

  @override
  String get shareAlarmConfig => 'مشاركة المنبه';

  @override
  String get shareAlarmConfigSuccess => 'نُسخ إعداد المنبه إلى الحافظة';

  @override
  String get groupTravelTitle => 'سفر جماعي';

  @override
  String get customRingtone => 'نغمة مخصصة';

  @override
  String get pickRingtone => 'اختر نغمة';

  @override
  String get arabic => 'العربية';

  @override
  String get hebrew => 'العبرية';

  @override
  String get cloudBackupUpload => 'رفع النسخة الاحتياطية إلى السحابة';

  @override
  String get cloudBackupUrlHint => 'رابط HTTPS للرفع';

  @override
  String get cloudBackupSuccess => 'تم رفع النسخة الاحتياطية بنجاح';

  @override
  String get cloudBackupFailed => 'فشل الرفع إلى السحابة';

  @override
  String get importAlarmConfig => 'تم استيراد إعداد المنبه';

  @override
  String get lockScreenInfo => 'عرض على شاشة القفل';

  @override
  String get lockScreenInfoSubtitle => 'عرض المسافة وETA في إشعار شاشة القفل';

  @override
  String get notifInternetLostTitle => 'فُقد اتصال الإنترنت';

  @override
  String get notifInternetLostBody => 'قد لا يتوفر ETA للمسار حتى يعود الاتصال';

  @override
  String get shareAllAlarms => 'مشاركة المنبهات النشطة';

  @override
  String get importAlarmBundle => 'استيراد حزمة منبهات';

  @override
  String alarmBundleImported(int count) {
    return 'تم استيراد $count منبهات';
  }

  @override
  String get mapLayerTerrain => 'تضاريس';

  @override
  String get mapProviderApple => 'Apple Maps';

  @override
  String get highContrast => 'تباين عالٍ';

  @override
  String get highContrastSubtitle => 'زيادة التباين لسهولة القراءة';

  @override
  String get voiceSearchHint => 'انطق اسم الوجهة';

  @override
  String get tileTapToCancel => 'اضغط لإلغاء المنبه';

  @override
  String get tileTapToCreate => 'اضغط لإنشاء منبه';
}
