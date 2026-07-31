import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/shared/widgets/alarm_journey_detail_sheet.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('History journey detail shows entry without trip', (tester) async {
    final entry = HistoryEntry()
      ..destinationName = 'Central Station'
      ..destLatitude = 51.5
      ..destLongitude = -0.1
      ..type = HistoryType.completed
      ..occurredAt = DateTime(2026, 1, 15, 10, 30);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(AppSettings.defaults()),
          ),
        ],
        child: buildL10nTestApp(
          Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: AlarmJourneyDetailContent(
                          entry: entry,
                          trip: null,
                          useMetric: true,
                        ),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Central Station'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Journey details'), findsNothing);
  });
}
