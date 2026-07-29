import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/search/presentation/search_screen.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import '../helpers/l10n_test_helper.dart';

class _EmptySearchController extends SearchController {
  @override
  Future<List<SearchResult>> build() async => [];
}

void main() {
  testWidgets('Search screen shows localized hint in English', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          searchControllerProvider.overrideWith(_EmptySearchController.new),
          recentSearchesProvider.overrideWith(
            (ref) => Stream.value(<RecentSearch>[]),
          ),
        ],
        child: buildL10nTestApp(const SearchScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Station, landmark, address…'), findsOneWidget);
  });

  testWidgets('Search screen shows localized hint in Hindi', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          searchControllerProvider.overrideWith(_EmptySearchController.new),
          recentSearchesProvider.overrideWith(
            (ref) => Stream.value(<RecentSearch>[]),
          ),
        ],
        child: buildL10nTestApp(
          const SearchScreen(),
          locale: const Locale('hi'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('स्टेशन, लैंडमार्क, पता…'), findsOneWidget);
  });
}
