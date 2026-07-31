import 'dart:io' show Platform;

import 'package:http/http.dart' as http;
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/map/apple_map_provider.dart';
import 'package:nomad_alarm/providers/map/google_map_provider.dart';
import 'package:nomad_alarm/providers/map/here_map_provider.dart';
import 'package:nomad_alarm/providers/map/map_provider.dart';
import 'package:nomad_alarm/providers/map/mapbox_map_provider.dart';
import 'package:nomad_alarm/providers/map/osm_map_provider.dart';
import 'package:nomad_alarm/providers/route/google_directions_provider.dart';
import 'package:nomad_alarm/providers/route/graphhopper_route_provider.dart';
import 'package:nomad_alarm/providers/route/osrm_route_provider.dart';
import 'package:nomad_alarm/providers/route/route_provider.dart';
import 'package:nomad_alarm/providers/route/valhalla_route_provider.dart';
import 'package:nomad_alarm/providers/search/google_places_search_provider.dart';
import 'package:nomad_alarm/providers/search/here_search_provider.dart';
import 'package:nomad_alarm/providers/search/nominatim_search_provider.dart';
import 'package:nomad_alarm/providers/search/pelias_search_provider.dart';
import 'package:nomad_alarm/providers/search/photon_search_provider.dart';
import 'package:nomad_alarm/providers/search/search_provider.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/core/utils/settings_provider_utils.dart';
import 'package:nomad_alarm/services/api_key_store.dart';

class ProviderFactory {
  ProviderFactory({
    ApiKeyStore? apiKeyStore,
    http.Client? httpClient,
  })  : _apiKeyStore = apiKeyStore ?? ApiKeyStore(),
        _httpClient = httpClient ?? http.Client(),
        _ownsClient = httpClient == null;

  final ApiKeyStore _apiKeyStore;
  final http.Client _httpClient;
  final bool _ownsClient;

  ApiKeyStore get apiKeyStore => _apiKeyStore;

  Future<MapProvider> createMapProvider(AppSettings settings) async {
    final layer = settings.mapLayer;
    switch (settings.mapProvider) {
      case MapProviderType.google:
        if (FeatureFlags.googleMapsProvider) {
          return const GoogleMapProvider();
        }
        return OsmMapProvider(layer: layer);
      case MapProviderType.mapbox:
        if (FeatureFlags.mapboxProvider) {
          final token = await _apiKeyStore.read(ApiKeyId.mapboxToken);
          if (token != null && token.isNotEmpty) {
            return MapboxMapProvider(accessToken: token, layer: layer);
          }
        }
        return OsmMapProvider(layer: layer);
      case MapProviderType.here:
        if (FeatureFlags.hereMapsProvider) {
          final key = await _apiKeyStore.read(ApiKeyId.hereApiKey);
          if (key != null && key.isNotEmpty) {
            return HereMapProvider(apiKey: key);
          }
        }
        return OsmMapProvider(layer: layer);
      case MapProviderType.apple:
        if (Platform.isIOS) {
          return const AppleMapProvider();
        }
        return OsmMapProvider(layer: layer);
      case MapProviderType.osm:
        return OsmMapProvider(layer: layer);
    }
  }

  Future<SearchProvider> createSearchProvider(AppSettings settings) async {
    switch (effectiveSearch(settings)) {
      case SearchProviderType.googlePlaces:
        if (FeatureFlags.googlePlacesSearch) {
          final key = await _apiKeyStore.readGoogleKeyFor(
            CredentialKind.googlePlaces,
          );
          if (key != null && key.isNotEmpty) {
            return GooglePlacesSearchProvider(apiKey: key, client: _httpClient);
          }
        }
        return NominatimSearchProvider(client: _httpClient);
      case SearchProviderType.photon:
        return PhotonSearchProvider(client: _httpClient);
      case SearchProviderType.pelias:
        return PeliasSearchProvider(client: _httpClient);
      case SearchProviderType.here:
        if (FeatureFlags.hereMapsProvider) {
          final key = await _apiKeyStore.read(ApiKeyId.hereApiKey);
          if (key != null && key.isNotEmpty) {
            return HereSearchProvider(apiKey: key, client: _httpClient);
          }
        }
        return NominatimSearchProvider(client: _httpClient);
      case SearchProviderType.nominatim:
        return NominatimSearchProvider(client: _httpClient);
    }
  }

  Future<RouteProvider> createRouteProvider(AppSettings settings) async {
    switch (effectiveRoute(settings)) {
      case RouteProviderType.googleDirections:
        if (FeatureFlags.googleMapsProvider) {
          final key = await _apiKeyStore.readGoogleKeyFor(
            CredentialKind.googleDirections,
          );
          if (key != null && key.isNotEmpty) {
            return GoogleDirectionsProvider(apiKey: key, client: _httpClient);
          }
        }
        return OsrmRouteProvider(client: _httpClient);
      case RouteProviderType.graphHopper:
        final key = await _apiKeyStore.read(ApiKeyId.graphhopperKey);
        if (key != null && key.isNotEmpty) {
          return GraphhopperRouteProvider(
            apiKey: key,
            client: _httpClient,
          );
        }
        return OsrmRouteProvider(client: _httpClient);
      case RouteProviderType.valhalla:
        return ValhallaRouteProvider(client: _httpClient);
      case RouteProviderType.osrm:
        return OsrmRouteProvider(client: _httpClient);
    }
  }

  void dispose() {
    if (_ownsClient) {
      _httpClient.close();
    }
  }
}
