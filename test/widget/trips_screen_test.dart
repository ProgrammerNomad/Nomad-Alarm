import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/trip/presentation/trips_screen.dart';
import 'package:nomad_alarm/models/trip.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('Trips empty state is localized in English', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripsProvider.overrideWith((ref) => Stream.value(<Trip>[])),
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(AppSettings.defaults()),
          ),
        ],
        child: buildL10nTestApp(const TripsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No trips yet'), findsOneWidget);
  });

  testWidgets('Trips empty state is localized in Hindi', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripsProvider.overrideWith((ref) => Stream.value(<Trip>[])),
          appSettingsProvider.overrideWith(
            (ref) => Stream.value(AppSettings.defaults()..languageCode = 'hi'),
          ),
        ],
        child: buildL10nTestApp(
          const TripsScreen(),
          locale: const Locale('hi'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('अभी कोई यात्रा नहीं'), findsOneWidget);
  });
}
