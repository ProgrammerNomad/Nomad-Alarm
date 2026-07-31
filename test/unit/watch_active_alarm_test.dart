import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/repositories/history_repository.dart';
import 'package:nomad_alarm/repositories/trip_repository.dart';
import 'package:nomad_alarm/services/alarm_service.dart';
import 'package:nomad_alarm/services/battery_monitor_service.dart';
import 'package:nomad_alarm/services/flashlight_service.dart';
import 'package:nomad_alarm/services/notification_service.dart';
import 'package:nomad_alarm/services/speech_service.dart';

class _MockAlarmRepository extends Mock implements AlarmRepository {}

class _MockTripRepository extends Mock implements TripRepository {}

class _MockHistoryRepository extends Mock implements HistoryRepository {}

class _MockNotificationService extends Mock implements NotificationService {}

class _MockSpeechService extends Mock implements SpeechService {}

void main() {
  late _MockAlarmRepository alarmRepository;
  late _MockTripRepository tripRepository;
  late _MockHistoryRepository historyRepository;
  late _MockNotificationService notificationService;
  late _MockSpeechService speechService;
  late AlarmService alarmService;

  setUp(() {
    alarmRepository = _MockAlarmRepository();
    tripRepository = _MockTripRepository();
    historyRepository = _MockHistoryRepository();
    notificationService = _MockNotificationService();
    speechService = _MockSpeechService();
    alarmService = AlarmService(
      alarmRepository: alarmRepository,
      tripRepository: tripRepository,
      historyRepository: historyRepository,
      notificationService: notificationService,
      speechService: speechService,
      flashlightService: FlashlightService(),
      batteryMonitorService: BatteryMonitorService(),
    );
  });

  test('watchActiveAlarm replays lastState to new subscribers', () async {
    final state = AlarmRuntimeState(
      alarmId: 1,
      destinationName: 'Test',
      distanceMeters: 500,
      speedKmh: 10,
      accuracyMeters: 5,
      lastFixAt: DateTime.utc(2024, 1, 1),
      isGpsLost: false,
      hasPassedDestination: false,
      status: AlarmStatus.active,
    );

    alarmService.seedSessionStateForTest(1, state);

    final first = await alarmService.watchActiveAlarm(1).first;
    expect(first.distanceMeters, 500);
    expect(first.destinationName, 'Test');
  });
}
