import 'package:home_widget/home_widget.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';

/// Syncs active alarm state to Android home screen widgets.
class WidgetService {
  WidgetService._();

  static const androidSmallWidgetName = 'NomadAlarmSmallWidgetProvider';
  static const androidMediumWidgetName = 'NomadAlarmMediumWidgetProvider';
  static const appGroupId = 'com.nomad.alarm.widget';

  static Future<void> initialize() async {
    if (!FeatureFlags.homeScreenWidgets) {
      return;
    }
    await HomeWidget.setAppGroupId(appGroupId);
  }

  static Future<void> updateActiveAlarm({
    required bool active,
    required String destination,
    required double distanceMeters,
    double? etaMinutes,
    required int alarmId,
  }) async {
    if (!FeatureFlags.homeScreenWidgets) {
      return;
    }

    final distance = formatDistance(distanceMeters);
    final eta = etaMinutes != null ? formatEta(etaMinutes) : '';

    await HomeWidget.saveWidgetData<bool>('active', active);
    await HomeWidget.saveWidgetData<String>(
      'destination',
      active ? destination : 'No active alarm',
    );
    await HomeWidget.saveWidgetData<String>(
      'distance',
      active ? (eta.isNotEmpty && eta != '-' ? '$distance · $eta' : distance) : '',
    );
    await HomeWidget.saveWidgetData<int>('alarmId', active ? alarmId : -1);
    await HomeWidget.updateWidget(androidName: androidSmallWidgetName);
    await HomeWidget.updateWidget(androidName: androidMediumWidgetName);
  }

  static Future<void> clear() => updateActiveAlarm(
        active: false,
        destination: '',
        distanceMeters: 0,
        alarmId: -1,
      );

  /// Returns launch URI when app opened from widget tap.
  static Future<Uri?> getLaunchUri() {
    return HomeWidget.initiallyLaunchedFromHomeWidget();
  }

  static void registerLaunchHandler(void Function(Uri?) handler) {
    if (!FeatureFlags.homeScreenWidgets) {
      return;
    }
    HomeWidget.widgetClicked.listen((uri) => handler(uri));
  }
}
