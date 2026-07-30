import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/features/alarm/presentation/active_alarm_screen.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/alarm_service.dart';
import '../helpers/l10n_test_helper.dart';

class MockAlarmRepository extends Mock implements AlarmRepository {}

class MockAlarmService extends Mock implements AlarmService {}

void main() {
  late MockAlarmRepository alarmRepository;
  late MockAlarmService alarmService;

  setUp(() {
    alarmRepository = MockAlarmRepository();
    alarmService = MockAlarmService();
    when(() => alarmService.activeAlarmId).thenReturn(1);
    when(() => alarmRepository.getById(1)).thenAnswer((_) async {
      return Alarm()
        ..id = 1
        ..name = 'Paused'
        ..destLatitude = 0
        ..destLongitude = 0
        ..type = AlarmType.distance
        ..triggerDistanceMeters = 500
        ..travelMode = TravelMode.train
        ..repeat = false
        ..voiceEnabled = true
        ..vibrationEnabled = true
        ..flashlightEnabled = false
        ..status = AlarmStatus.paused
        ..createdAt = DateTime.utc(2024, 1, 1)
        ..updatedAt = DateTime.utc(2024, 1, 1);
    });
  });

  testWidgets('Active alarm screen shows distance from stream', (tester) async {
    final state = AlarmRuntimeState(
      alarmId: 1,
      destinationName: 'Test Station',
      distanceMeters: 750,
      speedKmh: 40,
      accuracyMeters: 12,
      lastFixAt: DateTime.utc(2024, 6, 1, 12),
      isGpsLost: false,
      hasPassedDestination: false,
      status: AlarmStatus.active,
      etaMinutes: 8,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          alarmRepositoryProvider.overrideWith((ref) => alarmRepository),
          alarmServiceProvider.overrideWith((ref) => alarmService),
          activeAlarmStateProvider(1).overrideWith(
            (ref) => Stream.value(state),
          ),
        ],
        child: buildL10nTestApp(const ActiveAlarmScreen(alarmId: 1)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Station'), findsOneWidget);
    expect(find.text('Alarm #1'), findsOneWidget);
    expect(find.text('Alarm details'), findsOneWidget);
    expect(find.text('750 m'), findsOneWidget);
    expect(find.text('~8 min'), findsOneWidget);
  });
}
