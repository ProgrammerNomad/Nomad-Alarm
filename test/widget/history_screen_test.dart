import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/history/presentation/history_screen.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import '../helpers/l10n_test_helper.dart';

Alarm _sampleActiveAlarm({required int id, required String name}) {
  return Alarm()
    ..id = id
    ..name = name
    ..destLatitude = 28.5
    ..destLongitude = 77.3
    ..triggerDistanceMeters = 500
    ..status = AlarmStatus.active
    ..startedAt = DateTime(2026, 1, 15, 10);
}

Alarm _sampleDraftAlarm({required int id, required String name}) {
  return Alarm()
    ..id = id
    ..name = name
    ..destLatitude = 28.5
    ..destLongitude = 77.3
    ..triggerDistanceMeters = 500
    ..status = AlarmStatus.draft
    ..createdAt = DateTime(2026, 1, 20, 14);
}

void main() {
  testWidgets('History empty state is localized in English', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeAlarmsProvider.overrideWith((ref) async => []),
          draftAlarmsProvider.overrideWith((ref) async => []),
          historyEntriesProvider.overrideWith(
            (ref) => Stream.value(<HistoryEntry>[]),
          ),
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(AppSettings.defaults()),
          ),
        ],
        child: buildL10nTestApp(const HistoryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No history yet'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets('History empty state is localized in Hindi', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeAlarmsProvider.overrideWith((ref) async => []),
          draftAlarmsProvider.overrideWith((ref) async => []),
          historyEntriesProvider.overrideWith(
            (ref) => Stream.value(<HistoryEntry>[]),
          ),
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(AppSettings.defaults()..languageCode = 'hi'),
          ),
        ],
        child: buildL10nTestApp(
          const HistoryScreen(),
          locale: const Locale('hi'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('अभी कोई इतिहास नहीं'), findsOneWidget);
    expect(find.text('सभी'), findsOneWidget);
  });

  testWidgets('History Active filter shows running alarms', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeAlarmsProvider.overrideWith(
            (ref) async => [_sampleActiveAlarm(id: 1, name: 'Noida')],
          ),
          draftAlarmsProvider.overrideWith((ref) async => []),
          historyEntriesProvider.overrideWith(
            (ref) => Stream.value(<HistoryEntry>[]),
          ),
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(AppSettings.defaults()),
          ),
        ],
        child: buildL10nTestApp(
          const HistoryScreen(initialFilter: HistoryFilter.active),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Noida'), findsOneWidget);
    expect(find.text('No history yet'), findsNothing);
  });

  testWidgets('History All merges active alarms with past entries', (tester) async {
    final past = HistoryEntry()
      ..id = 10
      ..destinationName = 'Past Stop'
      ..destLatitude = 1
      ..destLongitude = 2
      ..type = HistoryType.completed
      ..occurredAt = DateTime(2026, 1, 10);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeAlarmsProvider.overrideWith(
            (ref) async => [_sampleActiveAlarm(id: 2, name: 'India')],
          ),
          draftAlarmsProvider.overrideWith((ref) async => []),
          historyEntriesProvider.overrideWith(
            (ref) => Stream.value([past]),
          ),
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(AppSettings.defaults()),
          ),
        ],
        child: buildL10nTestApp(const HistoryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('India'), findsOneWidget);
    expect(find.text('Past Stop'), findsOneWidget);
  });

  testWidgets('History All shows saved draft alarms', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeAlarmsProvider.overrideWith((ref) async => []),
          draftAlarmsProvider.overrideWith(
            (ref) async => [_sampleDraftAlarm(id: 3, name: 'Prayagraj')],
          ),
          historyEntriesProvider.overrideWith(
            (ref) => Stream.value(<HistoryEntry>[]),
          ),
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(AppSettings.defaults()),
          ),
        ],
        child: buildL10nTestApp(const HistoryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prayagraj'), findsOneWidget);
    expect(find.text('Saved'), findsWidgets);
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('History Saved filter lists draft alarms only', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeAlarmsProvider.overrideWith(
            (ref) async => [_sampleActiveAlarm(id: 1, name: 'Running')],
          ),
          draftAlarmsProvider.overrideWith(
            (ref) async => [_sampleDraftAlarm(id: 4, name: 'Draft Stop')],
          ),
          historyEntriesProvider.overrideWith(
            (ref) => Stream.value(<HistoryEntry>[]),
          ),
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(AppSettings.defaults()),
          ),
        ],
        child: buildL10nTestApp(
          const HistoryScreen(initialFilter: HistoryFilter.saved),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Draft Stop'), findsOneWidget);
    expect(find.text('Running'), findsNothing);
  });
}
