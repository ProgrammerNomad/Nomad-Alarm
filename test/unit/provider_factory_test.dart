import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/map/google_map_provider.dart';
import 'package:nomad_alarm/providers/map/mapbox_map_provider.dart';
import 'package:nomad_alarm/providers/map/osm_map_provider.dart';
import 'package:nomad_alarm/providers/route/osrm_route_provider.dart';
import 'package:nomad_alarm/providers/search/google_places_search_provider.dart';
import 'package:nomad_alarm/providers/search/nominatim_search_provider.dart';
import 'package:nomad_alarm/providers/search/photon_search_provider.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import 'package:nomad_alarm/services/provider_factory.dart';

class _MockApiKeyStore extends Mock implements ApiKeyStore {}

void main() {
  late _MockApiKeyStore apiKeyStore;
  late ProviderFactory factory;

  setUpAll(() {
    registerFallbackValue(ApiKeyId.googleMaps);
    registerFallbackValue(CredentialKind.googleMaps);
  });

  setUp(() {
    apiKeyStore = _MockApiKeyStore();
    factory = ProviderFactory(apiKeyStore: apiKeyStore);
  });

  tearDown(() {
    factory.dispose();
  });

  test('createMapProvider returns OSM by default', () async {
    final settings = AppSettings.defaults();
    final provider = await factory.createMapProvider(settings);
    expect(provider, isA<OsmMapProvider>());
    expect(provider.type, MapProviderType.osm);
  });

  test('createMapProvider returns Google when selected', () async {
    final settings = AppSettings.defaults()..mapProvider = MapProviderType.google;
    final provider = await factory.createMapProvider(settings);
    expect(provider, isA<GoogleMapProvider>());
  });

  test('createMapProvider falls back to OSM for Mapbox without token', () async {
    when(() => apiKeyStore.read(ApiKeyId.mapboxToken)).thenAnswer((_) async => null);
    final settings = AppSettings.defaults()..mapProvider = MapProviderType.mapbox;
    final provider = await factory.createMapProvider(settings);
    expect(provider, isA<OsmMapProvider>());
  });

  test('createMapProvider returns Mapbox when token present', () async {
    when(() => apiKeyStore.read(ApiKeyId.mapboxToken))
        .thenAnswer((_) async => 'pk.test-token');
    final settings = AppSettings.defaults()..mapProvider = MapProviderType.mapbox;
    final provider = await factory.createMapProvider(settings);
    expect(provider, isA<MapboxMapProvider>());
  });

  test('createSearchProvider returns Nominatim by default', () async {
    final settings = AppSettings.defaults();
    final provider = await factory.createSearchProvider(settings);
    expect(provider, isA<NominatimSearchProvider>());
  });

  test('createSearchProvider returns Photon when selected', () async {
    final settings = AppSettings.defaults()
      ..useRecommendedProviders = false
      ..overrideSearchProvider = true
      ..searchProvider = SearchProviderType.photon;
    final provider = await factory.createSearchProvider(settings);
    expect(provider, isA<PhotonSearchProvider>());
  });

  test('createSearchProvider uses bundle when recommended', () async {
    final settings = AppSettings.defaults()
      ..mapProvider = MapProviderType.google
      ..searchProvider = SearchProviderType.nominatim
      ..useRecommendedProviders = true;
    when(() => apiKeyStore.readGoogleKeyFor(CredentialKind.googlePlaces))
        .thenAnswer((_) async => 'AIza.test');
    final provider = await factory.createSearchProvider(settings);
    expect(provider, isA<GooglePlacesSearchProvider>());
  });

  test('createRouteProvider returns OSRM by default', () async {
    final settings = AppSettings.defaults();
    final provider = await factory.createRouteProvider(settings);
    expect(provider, isA<OsrmRouteProvider>());
  });

  test('createRouteProvider falls back to OSRM for GraphHopper without key', () async {
    when(() => apiKeyStore.read(ApiKeyId.graphhopperKey))
        .thenAnswer((_) async => null);
    final settings = AppSettings.defaults()
      ..routeProvider = RouteProviderType.graphHopper;
    final provider = await factory.createRouteProvider(settings);
    expect(provider, isA<OsrmRouteProvider>());
  });
}
