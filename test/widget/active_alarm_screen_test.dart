import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/alarm/presentation/active_alarm_screen.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';

void main() {
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
          activeAlarmStateProvider(1).overrideWith(
            (ref) => Stream.value(state),
          ),
        ],
        child: const MaterialApp(
          home: ActiveAlarmScreen(alarmId: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Station'), findsOneWidget);
    expect(find.text('750 m'), findsOneWidget);
    expect(find.text('~8 min'), findsOneWidget);
  });
}
