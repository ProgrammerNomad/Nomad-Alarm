import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/core/utils/settings_provider_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/services/api_key_store.dart';

class _MockApiKeyStore extends Mock implements ApiKeyStore {}

void main() {
  late _MockApiKeyStore store;

  setUpAll(() {
    registerFallbackValue(ApiKeyId.googleMaps);
    registerFallbackValue(CredentialKind.googleMaps);
  });

  setUp(() {
    store = _MockApiKeyStore();
  });

  test('hasMapProviderCredential requires googleMaps slot for Google', () async {
    when(() => store.read(ApiKeyId.googleMaps)).thenAnswer((_) async => null);
    when(() => store.read(ApiKeyId.googlePlaces))
        .thenAnswer((_) async => 'places-only');

    expect(
      await hasMapProviderCredential(store, MapProviderType.google),
      isFalse,
    );
  });

  test('hasMapProviderCredential true when maps slot set', () async {
    when(() => store.read(ApiKeyId.googleMaps))
        .thenAnswer((_) async => 'maps-key');

    expect(
      await hasMapProviderCredential(store, MapProviderType.google),
      isTrue,
    );
  });

  test('requiresMapCredentials is false for OSM', () {
    expect(ProviderCatalog.requiresMapCredentials(MapProviderType.osm), isFalse);
    expect(ProviderCatalog.requiresMapCredentials(MapProviderType.google), isTrue);
  });
}
