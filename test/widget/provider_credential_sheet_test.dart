import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/features/settings/presentation/provider_credential_sheet.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import '../helpers/l10n_test_helper.dart';

class _MockApiKeyStore extends Mock implements ApiKeyStore {}

class _SheetOpener extends ConsumerWidget {
  const _SheetOpener();

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
      child: const Text('Open'),
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
    when(() => store.writeGoogleApiKey(any())).thenAnswer((_) async {});
    when(() => store.write(any(), any())).thenAnswer((_) async {});
  });

  testWidgets('Cancel closes sheet without saving', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyStoreProvider.overrideWithValue(store)],
        child: buildL10nTestApp(const _SheetOpener()),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    verifyNever(() => store.write(any(), any()));
  });
}
