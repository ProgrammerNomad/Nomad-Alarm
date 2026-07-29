import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/settings/presentation/map_settings_screen.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import '../helpers/l10n_test_helper.dart';

class _FixedSettingsController extends SettingsController {
  @override
  Future<AppSettings> build() async => AppSettings.defaults();
}

void main() {
  testWidgets('Map settings screen shows provider section', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsControllerProvider.overrideWith(_FixedSettingsController.new),
        ],
        child: buildL10nTestApp(const MapSettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Map settings'), findsOneWidget);
    expect(find.text('Map provider'), findsOneWidget);
    expect(find.text('Search provider'), findsOneWidget);
    expect(find.text('Route provider'), findsOneWidget);
  });
}
