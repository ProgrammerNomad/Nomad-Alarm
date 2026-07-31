import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/home/presentation/saved_places_home_section.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('Saved Places home card shows compact preview picks', (tester) async {
    final home = Favorite.createDefaults(
      name: 'Home',
      latitude: 51.5,
      longitude: -0.1,
      category: FavoriteCategory.home,
    );
    final office = Favorite.createDefaults(
      name: 'Office',
      latitude: 51.6,
      longitude: -0.2,
      category: FavoriteCategory.office,
    );

    await tester.pumpWidget(
      buildL10nTestApp(
        SavedPlacesHomeSection(places: [home, office]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saved Places'), findsOneWidget);
    expect(find.text('Manage >'), findsOneWidget);
    expect(find.textContaining('Home'), findsOneWidget);
    expect(find.textContaining('Office'), findsOneWidget);
    expect(find.byType(ActionChip), findsNothing);
  });

  testWidgets('Saved Places home card shows compact empty CTA', (tester) async {
    await tester.pumpWidget(
      buildL10nTestApp(
        const SavedPlacesHomeSection(places: []),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saved Places'), findsOneWidget);
    expect(find.text('Manage >'), findsOneWidget);
    expect(find.text('+ Add your first place'), findsOneWidget);
    expect(find.text('Add places'), findsNothing);
    expect(
      find.textContaining('Save places you travel to often'),
      findsNothing,
    );
    expect(find.byType(ActionChip), findsNothing);
    expect(find.byIcon(Icons.dashboard_outlined), findsNothing);
  });
}
