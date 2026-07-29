import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/history/presentation/history_screen.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('History empty state is localized in English', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyEntriesByTypeProvider.overrideWith(
            (ref, filter) => Stream.value(<HistoryEntry>[]),
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
  });

  testWidgets('History empty state is localized in Hindi', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyEntriesByTypeProvider.overrideWith(
            (ref, filter) => Stream.value(<HistoryEntry>[]),
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
}
