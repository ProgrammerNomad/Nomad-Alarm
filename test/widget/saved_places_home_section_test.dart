import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/home/presentation/saved_places_home_section.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('Saved Places home card shows preview chips', (tester) async {
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
    expect(find.text('Add >'), findsNothing);
    expect(find.textContaining('Home'), findsOneWidget);
    expect(find.textContaining('Office'), findsOneWidget);
    expect(find.byType(ActionChip), findsNWidgets(2));
    expect(find.byIcon(Icons.dashboard_outlined), findsNothing);
  });

  testWidgets('Saved Places home card shows empty state', (tester) async {
    await tester.pumpWidget(
      buildL10nTestApp(
        const SavedPlacesHomeSection(places: []),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saved Places'), findsOneWidget);
    expect(find.text('Add >'), findsOneWidget);
    expect(find.text('No saved places yet'), findsOneWidget);
    expect(find.text('Manage >'), findsNothing);
    expect(find.text('+ Add your first place'), findsNothing);
    expect(find.byType(ActionChip), findsNothing);
    expect(find.byIcon(Icons.dashboard_outlined), findsNothing);
  });
}
