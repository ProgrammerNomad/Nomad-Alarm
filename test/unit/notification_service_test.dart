import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/services/notification_service.dart';

void main() {
  test('notification channel IDs are stable', () {
    expect(NotificationService.trackingChannelId, 'tracking');
    expect(NotificationService.alarmChannelId, 'alarm');
    expect(NotificationService.alertsChannelId, 'alerts');
  });

  test('notification IDs are distinct', () {
    expect(
      NotificationService.trackingNotificationId,
      isNot(NotificationService.alarmNotificationId),
    );
  });
}
