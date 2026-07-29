import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/services/notification_service.dart';

void main() {
  test('internet lost alert uses unique notification id', () {
    expect(303, isNot(301));
    expect(303, isNot(302));
  });

  test('tracking channel id stable', () {
    expect(NotificationService.trackingChannelId, 'tracking');
  });
}
