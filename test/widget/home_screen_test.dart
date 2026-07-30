import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/home/presentation/home_screen.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/providers/current_location_label_provider.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/location_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('Home screen has single FAB for new alarm', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentPositionProvider.overrideWith((ref) async => null),
          currentLocationLabelProvider.overrideWith((ref) async => null),
          favoritesProvider.overrideWith((ref) => Stream.value(<Favorite>[])),
          recentSearchesProvider.overrideWith(
            (ref) => Stream.value(<RecentSearch>[]),
          ),
          activeAlarmsProvider.overrideWith((ref) async => []),
        ],
        child: buildL10nTestApp(const HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'New alarm'), findsNothing);
    expect(find.text('No active alarms - tap + to create one'), findsOneWidget);
    expect(find.text('Current Location'), findsOneWidget);
    expect(find.text('Search destination…'), findsOneWidget);
  });
}
