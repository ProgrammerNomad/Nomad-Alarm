import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/settings/presentation/settings_screen.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('Settings shows Backup section with Transfer Data row only',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWith((ref) async* {
            yield AppSettings.defaults();
          }),
        ],
        child: buildL10nTestApp(const SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Backup'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Backup'), findsOneWidget);
    expect(find.text('Transfer Data'), findsOneWidget);
    expect(find.text('Move, backup, or restore your data'), findsOneWidget);
    expect(find.text('Export backup'), findsNothing);
    expect(find.text('Import backup'), findsNothing);
  });
}
