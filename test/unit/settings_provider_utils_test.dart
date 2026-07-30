import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/core/utils/settings_provider_utils.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/services/api_key_store.dart';

class _MockApiKeyStore extends Mock implements ApiKeyStore {}

void main() {
  late _MockApiKeyStore store;

  setUpAll(() {
    registerFallbackValue(ApiKeyId.mapboxToken);
  });

  setUp(() {
    store = _MockApiKeyStore();
  });

  test('missingCredentialsFor returns empty for OSM defaults', () async {
    final settings = AppSettings.defaults();
    when(() => store.read(any())).thenAnswer((_) async => null);
    when(() => store.readGoogleApiKey()).thenAnswer((_) async => null);

    final missing = await missingCredentialsFor(settings, store);
    expect(missing, isEmpty);
  });

  test('missingCredentialsFor returns Google when map is Google', () async {
    final settings = AppSettings.defaults()
      ..mapProvider = MapProviderType.google;
    when(() => store.readGoogleApiKey()).thenAnswer((_) async => null);

    final missing = await missingCredentialsFor(settings, store);
    expect(missing.length, 1);
    expect(missing.first.apiKeyId, ApiKeyId.googleMaps);
  });

  test('missingCredentialsFor skips configured Mapbox token', () async {
    final settings = AppSettings.defaults()
      ..mapProvider = MapProviderType.mapbox;
    when(() => store.readGoogleApiKey()).thenAnswer((_) async => null);
    when(() => store.read(ApiKeyId.mapboxToken))
        .thenAnswer((_) async => 'pk.test');

    final missing = await missingCredentialsFor(settings, store);
    expect(missing, isEmpty);
  });

  test('applyMapProviderChange updates search and route bundle', () {
    final settings = AppSettings.defaults();
    applyMapProviderChange(settings, MapProviderType.here);
    expect(settings.mapProvider, MapProviderType.here);
    expect(settings.searchProvider, SearchProviderType.here);
    expect(settings.routeProvider, RouteProviderType.osrm);
  });
}
