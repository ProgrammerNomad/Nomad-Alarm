import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/features/settings/presentation/map_settings_screen.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import '../helpers/l10n_test_helper.dart';

class _FixedSettingsController extends SettingsController {
  AppSettings _settings = AppSettings.defaults();

  @override
  Future<AppSettings> build() async => _settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
    state = AsyncData(settings);
  }
}

class _MockApiKeyStore extends Mock implements ApiKeyStore {}

void main() {
  late _MockApiKeyStore apiKeyStore;

  setUpAll(() {
    registerFallbackValue(ApiKeyId.mapboxToken);
  });

  setUp(() {
    apiKeyStore = _MockApiKeyStore();
    when(() => apiKeyStore.readGoogleApiKey()).thenAnswer((_) async => null);
    when(() => apiKeyStore.read(any())).thenAnswer((_) async => null);
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        settingsControllerProvider.overrideWith(_FixedSettingsController.new),
        apiKeyStoreProvider.overrideWithValue(apiKeyStore),
      ],
      child: buildL10nTestApp(const MapSettingsScreen()),
    );
  }

  testWidgets('Map settings shows providers section', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Map settings'), findsOneWidget);
    expect(find.text('Providers'), findsOneWidget);
    expect(find.text('Search provider'), findsOneWidget);
    expect(find.text('Route provider'), findsOneWidget);
    expect(find.byType(RadioListTile<MapProviderType>), findsNothing);
  });

  testWidgets('Save disabled until provider changes', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final saveButton = find.widgetWithText(FilledButton, 'Save');
    expect(tester.widget<FilledButton>(saveButton).onPressed, isNull);
  });

  testWidgets('Google save without key shows credential sheet', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Map provider'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Google Maps'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Google Maps requires an API key'), findsOneWidget);
    expect(find.text('Configure & Save'), findsOneWidget);
  });
}
