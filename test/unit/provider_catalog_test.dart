import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/services/api_key_store.dart';

void main() {
  test('bundleFor maps Google to Places and Directions', () {
    final bundle = ProviderCatalog.bundleFor(MapProviderType.google);
    expect(bundle.search, SearchProviderType.googlePlaces);
    expect(bundle.route, RouteProviderType.googleDirections);
  });

  test('bundleFor maps OSM to Nominatim and OSRM', () {
    final bundle = ProviderCatalog.bundleFor(MapProviderType.osm);
    expect(bundle.search, SearchProviderType.nominatim);
    expect(bundle.route, RouteProviderType.osrm);
  });

  test('credentialsFor Google map requires google key', () {
    final requirements = ProviderCatalog.credentialsFor(
      mapProvider: MapProviderType.google,
      searchProvider: SearchProviderType.googlePlaces,
      routeProvider: RouteProviderType.googleDirections,
      useRecommendedProviders: true,
      overrideSearchProvider: false,
      overrideRouteProvider: false,
    );
    expect(requirements.length, 1);
    expect(requirements.first.apiKeyId, ApiKeyId.googleMaps);
    expect(requirements.first.kind, CredentialKind.googleMaps);
  });

  test('credentialsFor OSM stack requires no keys', () {
    final requirements = ProviderCatalog.credentialsFor(
      mapProvider: MapProviderType.osm,
      searchProvider: SearchProviderType.nominatim,
      routeProvider: RouteProviderType.osrm,
      useRecommendedProviders: true,
      overrideSearchProvider: false,
      overrideRouteProvider: false,
    );
    expect(requirements, isEmpty);
  });

  test('credentialsFor override GraphHopper adds graphhopper key', () {
    final requirements = ProviderCatalog.credentialsFor(
      mapProvider: MapProviderType.osm,
      searchProvider: SearchProviderType.nominatim,
      routeProvider: RouteProviderType.graphHopper,
      useRecommendedProviders: false,
      overrideSearchProvider: true,
      overrideRouteProvider: true,
    );
    expect(
      requirements.any((r) => r.apiKeyId == ApiKeyId.graphhopperKey),
      isTrue,
    );
  });

  test('effectiveSearch uses bundle when recommended', () {
    expect(
      ProviderCatalog.effectiveSearch(
        mapProvider: MapProviderType.google,
        searchProvider: SearchProviderType.nominatim,
        useRecommendedProviders: true,
        overrideSearchProvider: false,
      ),
      SearchProviderType.googlePlaces,
    );
  });
}
