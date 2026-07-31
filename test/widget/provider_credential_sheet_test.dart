import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/features/settings/presentation/provider_credential_sheet.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import '../helpers/l10n_test_helper.dart';

class _MockApiKeyStore extends Mock implements ApiKeyStore {}

class _GoogleSheetOpener extends ConsumerWidget {
  const _GoogleSheetOpener();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        await showMapProviderCredentialSheet(
          context,
          ref,
          provider: MapProviderType.google,
        );
      },
      child: const Text('Open Google'),
    );
  }
}

class _MapboxSheetOpener extends ConsumerWidget {
  const _MapboxSheetOpener();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        await showProviderCredentialSheet(
          context,
          ref,
          requirements: const [
            CredentialRequirement(
              kind: CredentialKind.mapbox,
              apiKeyId: ApiKeyId.mapboxToken,
            ),
          ],
        );
      },
      child: const Text('Open Mapbox'),
    );
  }
}

void main() {
  late _MockApiKeyStore store;

  setUpAll(() {
    registerFallbackValue(ApiKeyId.mapboxToken);
  });

  setUp(() {
    store = _MockApiKeyStore();
    when(() => store.read(any())).thenAnswer((_) async => null);
    when(() => store.readGoogleApiKey()).thenAnswer((_) async => null);
    when(() => store.write(any(), any())).thenAnswer((_) async {});
    when(() => store.writeGoogleApiKey(any())).thenAnswer((_) async {});
    when(() => store.testConnection(any())).thenAnswer((_) async => true);
    when(() => store.testGoogleApiKeyStatus(
          mapsKey: any(named: 'mapsKey'),
          placesKey: any(named: 'placesKey'),
          directionsKey: any(named: 'directionsKey'),
        )).thenAnswer(
      (_) async => const GoogleApiKeyTestStatus(
        maps: true,
        places: false,
        directions: false,
      ),
    );
  });

  testWidgets('Google sheet shows single key field and API checklist',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyStoreProvider.overrideWithValue(store)],
        child: buildL10nTestApp(const _GoogleSheetOpener()),
      ),
    );

    await tester.tap(find.text('Open Google'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Configure'), findsNothing);
    expect(find.textContaining('Maps SDK for Android'), findsOneWidget);
    expect(find.textContaining('Places API'), findsOneWidget);
    expect(find.textContaining('Directions API'), findsOneWidget);
    expect(find.text('Google API key'), findsOneWidget);
  });

  testWidgets('Google sheet disables save until maps test passes',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyStoreProvider.overrideWithValue(store)],
        child: buildL10nTestApp(const _GoogleSheetOpener()),
      ),
    );

    await tester.tap(find.text('Open Google'));
    await tester.pumpAndSettle();

    expect(find.text('Save & Use Google Maps'), findsOneWidget);
    final saveButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Save & Use Google Maps'),
    );
    expect(saveButton.onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'AIza-test-key');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Test'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Maps SDK for Android: OK'), findsOneWidget);
    expect(find.textContaining('Places API: failed'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Save & Use Google Maps'),
          )
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('Google save writes key to all Google slots', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyStoreProvider.overrideWithValue(store)],
        child: buildL10nTestApp(const _GoogleSheetOpener()),
      ),
    );

    await tester.tap(find.text('Open Google'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'AIza-test-key');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save & Use Google Maps'));
    await tester.pumpAndSettle();

    verify(() => store.writeGoogleApiKey('AIza-test-key')).called(1);
    verifyNever(() => store.write(any(), any()));
  });

  testWidgets('Mapbox cancel closes sheet without saving', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyStoreProvider.overrideWithValue(store)],
        child: buildL10nTestApp(const _MapboxSheetOpener()),
      ),
    );

    await tester.tap(find.text('Open Mapbox'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    verifyNever(() => store.write(any(), any()));
  });
}
