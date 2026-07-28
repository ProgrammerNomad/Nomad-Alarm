import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        trackingChannelId,
        'Active Alarm',
        description: 'Shows distance while alarm is tracking',
        importance: Importance.low,
      ),
    );
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        alarmChannelId,
        'Alarm Ring',
        description: 'Alerts when you reach your destination',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
    );
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        alertsChannelId,
        'Warnings',
        description: 'GPS and battery warnings',
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
    await _plugin.show(
      trackingNotificationId,
      state.destinationName,
      '${formatDistance(state.distanceMeters)} to destination',
      _trackingDetails(state.alarmId),
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
    await _plugin.show(
      alarmNotificationId,
      'Stop approaching!',
      destinationName,
      NotificationDetails(
        android: AndroidNotificationDetails(
          alarmChannelId,
          'Alarm Ring',
          channelDescription: 'Alerts when you reach your destination',
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
    await _plugin.show(
      301,
      'GPS signal lost',
      'Location updates paused - check your GPS',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          alertsChannelId,
          'Warnings',
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

  NotificationDetails _trackingDetails(int alarmId) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        trackingChannelId,
        'Active Alarm',
        channelDescription: 'Shows distance while alarm is tracking',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        actions: [
          AndroidNotificationAction(
            'pause',
            'Pause',
            showsUserInterface: false,
            cancelNotification: false,
          ),
          AndroidNotificationAction(
            'cancel',
            'Cancel',
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
