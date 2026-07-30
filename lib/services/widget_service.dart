import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/services/android_auto_service.dart';
import 'package:nomad_alarm/services/wear_os_service.dart';
import 'package:nomad_alarm/core/l10n/notification_l10n.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';

/// Syncs active alarm state to Android home screen widgets and Quick Settings tile.
class WidgetService {
  WidgetService._();

  static const androidSmallWidgetName = 'NomadAlarmSmallWidgetProvider';
  static const androidMediumWidgetName = 'NomadAlarmMediumWidgetProvider';
  static const androidLargeWidgetName = 'NomadAlarmLargeWidgetProvider';
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
    double? triggerDistanceMeters,
    double? speedKmh,
    String languageCode = 'en',
    int activeAlarmCount = 1,
  }) async {
    if (!FeatureFlags.homeScreenWidgets) {
      return;
    }

    final l10n = await NotificationL10n.load(languageCode);
    final distance = formatDistance(distanceMeters);
    final eta = etaMinutes != null ? formatEta(etaMinutes) : '';
    final idleDestination = l10n.widgetNoActiveAlarm;
    final trackingFallback = l10n.widgetTracking;
    final tapToOpen = l10n.widgetTapToOpen;

    double progress = 0;
    if (active && triggerDistanceMeters != null && triggerDistanceMeters > 0) {
      progress = (1 - distanceMeters / triggerDistanceMeters).clamp(0.0, 1.0);
    }

    await HomeWidget.saveWidgetData<bool>('active', active);
    await HomeWidget.saveWidgetData<String>(
      'destination',
      active ? destination : idleDestination,
    );
    await HomeWidget.saveWidgetData<String>(
      'distance',
      active
          ? (activeAlarmCount > 1
              ? '$activeAlarmCount active · $distance'
              : (eta.isNotEmpty && eta != '-'
                  ? '$distance · $eta'
                  : distance))
          : '',
    );
    await HomeWidget.saveWidgetData<int>('alarmId', active ? alarmId : -1);
    await HomeWidget.saveWidgetData<int>(
      'active_alarm_count',
      active ? activeAlarmCount : 0,
    );
    await HomeWidget.saveWidgetData<int>(
      'progress',
      (progress * 100).round(),
    );
    await HomeWidget.saveWidgetData<String>(
      'speed',
      active && speedKmh != null && speedKmh > 0
          ? '${speedKmh.toStringAsFixed(0)} km/h'
          : '',
    );
    await HomeWidget.saveWidgetData<String>('widget_no_active', idleDestination);
    await HomeWidget.saveWidgetData<String>('widget_tracking', trackingFallback);
    await HomeWidget.saveWidgetData<String>('widget_tap_to_open', tapToOpen);
    await HomeWidget.saveWidgetData<String>('widget_label', l10n.tileLabel);

    await HomeWidget.updateWidget(androidName: androidSmallWidgetName);
    await HomeWidget.updateWidget(androidName: androidMediumWidgetName);
    await HomeWidget.updateWidget(androidName: androidLargeWidgetName);

    if (FeatureFlags.quickSettingsTile) {
      await TileService.syncFromWidgetData(
        active: active,
        destination: destination,
        distance: active ? distance : '',
        languageCode: languageCode,
        alarmId: alarmId,
      );
    }

    await WearOsService.syncActiveAlarm(
      active: active,
      destination: active ? destination : null,
      distanceMeters: active ? distanceMeters : null,
      etaMinutes: etaMinutes,
    );
    if (active) {
      await AndroidAutoService.updateNavigationState(
        destination: destination,
        distanceLabel: distance,
        etaLabel: eta.isNotEmpty && eta != '-' ? eta : null,
      );
    } else {
      await AndroidAutoService.clear();
    }
  }

  static Future<void> clear({String languageCode = 'en'}) => updateActiveAlarm(
        active: false,
        destination: '',
        distanceMeters: 0,
        alarmId: -1,
        languageCode: languageCode,
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

/// Keeps the Quick Settings tile in sync with widget/alarm state.
class TileService {
  TileService._();

  static const _tileChannel = MethodChannel('com.nomad.alarm/tile');

  static Future<void> initialize() async {
    if (!FeatureFlags.quickSettingsTile) {
      return;
    }
  }

  static Future<void> syncFromWidgetData({
    required bool active,
    required String destination,
    required String distance,
    required String languageCode,
    required int alarmId,
  }) async {
    if (!FeatureFlags.quickSettingsTile) {
      return;
    }
    final l10n = await NotificationL10n.load(languageCode);
    await HomeWidget.saveWidgetData<bool>('tile_active', active);
    await HomeWidget.saveWidgetData<String>(
      'tile_subtitle',
      active && distance.isNotEmpty
          ? l10n.tileActive(distance)
          : l10n.widgetTapToOpen,
    );
    await HomeWidget.saveWidgetData<String>('tile_label', l10n.tileLabel);
    await HomeWidget.saveWidgetData<int>('tile_alarm_id', active ? alarmId : -1);
    await _requestTileUpdate();
  }

  static Future<void> clear({String languageCode = 'en'}) => syncFromWidgetData(
        active: false,
        destination: '',
        distance: '',
        languageCode: languageCode,
        alarmId: -1,
      );

  static Future<void> _requestTileUpdate() async {
    try {
      await _tileChannel.invokeMethod<void>('requestTileUpdate');
    } catch (_) {
      // Tile may not be added yet.
    }
  }
}
