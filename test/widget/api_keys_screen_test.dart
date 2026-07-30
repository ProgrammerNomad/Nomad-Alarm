import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/features/settings/presentation/api_keys_screen.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import '../helpers/l10n_test_helper.dart';

class _MockApiKeyStore extends Mock implements ApiKeyStore {}

void main() {
  late _MockApiKeyStore store;

  setUpAll(() {
    registerFallbackValue(ApiKeyId.mapboxToken);
  });

  setUp(() {
    store = _MockApiKeyStore();
    when(() => store.readGoogleApiKey()).thenAnswer((_) async => null);
    when(() => store.read(any())).thenAnswer((_) async => null);
  });

  testWidgets('API keys dashboard lists all providers', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyStoreProvider.overrideWithValue(store)],
        child: buildL10nTestApp(const ApiKeysScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('API Keys'), findsOneWidget);
    expect(find.text('Google Maps'), findsOneWidget);
    expect(find.text('Mapbox'), findsOneWidget);
    expect(find.text('HERE'), findsOneWidget);
    expect(find.text('Add key'), findsWidgets);
  });
}
