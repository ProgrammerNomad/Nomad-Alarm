import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nomad_alarm/core/l10n/notification_l10n.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';

typedef NotificationTapHandler = void Function(String? payload);

class NotificationService {
  NotificationService();

  static const trackingChannelId = 'tracking';
  static const alarmChannelId = 'alarm';
  static const alertsChannelId = 'alerts';

  static const trackingNotificationId = 100;
  static const alarmNotificationId = 200;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificationTapHandler? onNotificationTap;
  void Function(String action, int alarmId)? onNotificationAction;

  String _languageCode = 'en';
  NotificationL10n? _l10n;

  Future<void> setLanguageCode(String languageCode) async {
    _languageCode = languageCode;
    _l10n = await NotificationL10n.load(languageCode);
    await _ensureChannels();
  }

  Future<NotificationL10n> _strings() async {
    _l10n ??= await NotificationL10n.load(_languageCode);
    return _l10n!;
  }

  Future<void> initialize({String languageCode = 'en'}) async {
    _languageCode = languageCode;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await setLanguageCode(languageCode);
  }

  Future<void> _ensureChannels() async {
    final strings = await _strings();
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        trackingChannelId,
        strings.trackingChannelName,
        description: strings.trackingChannelDesc,
        importance: Importance.low,
      ),
    );
    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        alarmChannelId,
        strings.alarmChannelName,
        description: strings.alarmChannelDesc,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
    );
    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        alertsChannelId,
        strings.warningsChannelName,
        importance: Importance.high,
      ),
    );
  }

  Future<String?> getLaunchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details!.notificationResponse?.payload;
    }
    return null;
  }

  void _onResponse(NotificationResponse response) {
    final payload = response.payload;
    final actionId = response.actionId;

    if (payload != null && payload.startsWith('active:') && actionId != null) {
      final alarmId = int.tryParse(payload.split(':').last);
      if (alarmId != null) {
        onNotificationAction?.call(actionId, alarmId);
        return;
      }
    }

    onNotificationTap?.call(payload);
  }

  Future<void> showTrackingNotification(AlarmRuntimeState state) async {
    final strings = await _strings();
    final distance = formatDistance(state.distanceMeters);
    final body = state.etaMinutes != null
        ? '$distance · ${formatEta(state.etaMinutes)}'
        : strings.toDestination(distance);
    await _plugin.show(
      trackingNotificationId,
      state.destinationName,
      body,
      await _trackingDetails(state.alarmId, strings),
      payload: 'active:${state.alarmId}',
    );
  }

  Future<void> updateTrackingNotification(AlarmRuntimeState state) async {
    await showTrackingNotification(state);
  }

  Future<void> showAlarmRingNotification(
    int alarmId,
    String destinationName,
  ) async {
    final strings = await _strings();
    await _plugin.show(
      alarmNotificationId,
      strings.stopApproaching,
      destinationName,
      NotificationDetails(
        android: AndroidNotificationDetails(
          alarmChannelId,
          strings.alarmChannelName,
          channelDescription: strings.alarmChannelDesc,
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
          ongoing: true,
          autoCancel: false,
        ),
      ),
      payload: 'ring:$alarmId',
    );
  }

  Future<void> showGpsLostAlert(int alarmId) async {
    final strings = await _strings();
    await _plugin.show(
      301,
      strings.gpsLostTitle,
      strings.gpsLostBody,
      NotificationDetails(
        android: AndroidNotificationDetails(
          alertsChannelId,
          strings.warningsChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: 'active:$alarmId',
    );
  }

  Future<void> showLowBatteryAlert(int alarmId) async {
    final strings = await _strings();
    await _plugin.show(
      302,
      strings.lowBatteryTitle,
      strings.lowBatteryBody,
      NotificationDetails(
        android: AndroidNotificationDetails(
          alertsChannelId,
          strings.warningsChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: 'active:$alarmId',
    );
  }

  Future<void> cancelTrackingNotification() async {
    await _plugin.cancel(trackingNotificationId);
  }

  Future<void> cancelAlarmNotification() async {
    await _plugin.cancel(alarmNotificationId);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<NotificationDetails> _trackingDetails(
    int alarmId,
    NotificationL10n strings,
  ) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        trackingChannelId,
        strings.trackingChannelName,
        channelDescription: strings.trackingChannelDesc,
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        actions: [
          AndroidNotificationAction(
            'pause',
            strings.pause,
            showsUserInterface: false,
            cancelNotification: false,
          ),
          AndroidNotificationAction(
            'cancel',
            strings.cancel,
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
      ),
    );
  }

  String actionPayload(String action, int alarmId) => 'action:$action:$alarmId';
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // Background tap handling is limited; main isolate handles on resume.
}
