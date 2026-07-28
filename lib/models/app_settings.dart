import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/enums.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = 0;

  @enumerated
  late AppThemeMode themeMode;
  late String accentColor;
  late String fontFamily;

  @enumerated
  late MapProviderType mapProvider;
  @enumerated
  late SearchProviderType searchProvider;
  @enumerated
  late RouteProviderType routeProvider;

  late bool useMetric;
  late String languageCode;

  late double defaultTriggerDistanceMeters;
  late bool defaultVoiceEnabled;
  late bool defaultVibrationEnabled;

  @enumerated
  late BatteryProfile batteryProfile;

  late bool hasCompletedWelcome;
  late bool hasCompletedPermissions;

  late bool debugLoggingEnabled;

  late bool persistentNotificationEnabled;
  late bool lockScreenInfoEnabled;

  static AppSettings defaults() {
    return AppSettings()
      ..themeMode = AppThemeMode.system
      ..accentColor = 'blue'
      ..fontFamily = 'roboto'
      ..mapProvider = MapProviderType.osm
      ..searchProvider = SearchProviderType.nominatim
      ..routeProvider = RouteProviderType.osrm
      ..useMetric = true
      ..languageCode = 'en'
      ..defaultTriggerDistanceMeters = 500
      ..defaultVoiceEnabled = true
      ..defaultVibrationEnabled = true
      ..batteryProfile = BatteryProfile.balanced
      ..hasCompletedWelcome = false
      ..hasCompletedPermissions = false
      ..debugLoggingEnabled = false
      ..persistentNotificationEnabled = true
      ..lockScreenInfoEnabled = true;
  }
}
