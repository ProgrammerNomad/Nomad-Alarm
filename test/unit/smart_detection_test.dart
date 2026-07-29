import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/utils/smart_detection.dart';

void main() {
  group('SmartDetection', () {
    test('detects internet lost after repeated route failures', () {
      final detection = SmartDetection();
      final start = DateTime.now().subtract(const Duration(minutes: 6));
      for (var i = 0; i < AlarmConstants.internetLostRouteFailures; i++) {
        detection.recordRouteFailure(start.add(Duration(minutes: i)));
      }
      expect(detection.isInternetLost, isTrue);
    });

    test('clears internet lost after route success', () {
      final detection = SmartDetection();
      final start = DateTime.utc(2024, 1, 1, 12);
      detection.recordRouteFailure(start);
      detection.recordRouteFailure(start);
      detection.recordRouteSuccess();
      expect(detection.isInternetLost, isFalse);
    });
  });
}
