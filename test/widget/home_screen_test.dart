import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/home/presentation/home_screen.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/location_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import 'package:nomad_alarm/services/isar_service.dart';

void main() {
  testWidgets('Home screen shows create alarm FAB', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isarServiceProvider.overrideWith((ref) async {
            throw UnimplementedError('not needed for FAB test');
          }),
          currentPositionProvider.overrideWith((ref) async => null),
          favoritesProvider.overrideWith((ref) async => []),
          recentSearchesProvider.overrideWith((ref) async => []),
          activeAlarmsProvider.overrideWith((ref) async => []),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Create Alarm'), findsOneWidget);
  });
}
