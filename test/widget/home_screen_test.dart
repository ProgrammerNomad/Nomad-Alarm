import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/home/presentation/alarms_screen.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('Alarms screen has single FAB and alarm-manager layout', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesProvider.overrideWith((ref) => Stream.value(<Favorite>[])),
          recentSearchesProvider.overrideWith(
            (ref) => Stream.value(<RecentSearch>[]),
          ),
          activeAlarmsProvider.overrideWith((ref) async => []),
        ],
        child: buildL10nTestApp(const AlarmsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'New alarm'), findsNothing);
    expect(find.text('Alarms'), findsOneWidget);
    expect(find.text('No active alarms - tap + to create one'), findsOneWidget);
    expect(find.text('Import Shared Alarm'), findsNothing);
    expect(find.text('Current Location'), findsNothing);
    expect(find.text('Search destination…'), findsOneWidget);
    expect(find.text('Saved Places'), findsOneWidget);
  });

  testWidgets('Alarms screen shows Saved Places card with preview chips',
      (tester) async {
    final home = Favorite.createDefaults(
      name: 'Home',
      latitude: 51.5,
      longitude: -0.1,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesProvider.overrideWith((ref) => Stream.value([home])),
          recentSearchesProvider.overrideWith(
            (ref) => Stream.value(<RecentSearch>[]),
          ),
          activeAlarmsProvider.overrideWith((ref) async => []),
        ],
        child: buildL10nTestApp(const AlarmsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saved Places'), findsOneWidget);
    expect(find.textContaining('Home'), findsOneWidget);
  });

  testWidgets('FAB opens create alarm sheet with New Alarm and Import alarm',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesProvider.overrideWith((ref) => Stream.value(<Favorite>[])),
          recentSearchesProvider.overrideWith(
            (ref) => Stream.value(<RecentSearch>[]),
          ),
          activeAlarmsProvider.overrideWith((ref) async => []),
        ],
        child: buildL10nTestApp(const AlarmsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Create alarm'), findsOneWidget);
    expect(find.text('New alarm'), findsOneWidget);
    expect(find.text('Import alarm'), findsOneWidget);
    expect(find.text('Saved Places'), findsWidgets);
    expect(find.text('Cancel'), findsOneWidget);
  });
}
