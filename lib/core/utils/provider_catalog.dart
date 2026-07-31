import 'dart:io' show Platform;

import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/services/api_key_store.dart';

enum ProviderBadgeKind {
  free,
  apiKeyRequired,
  advanced,
  recommended,
}

class ProviderBundle {
  const ProviderBundle({
    required this.search,
    required this.route,
  });

  final SearchProviderType search;
  final RouteProviderType route;
}

enum CredentialKind {
  googleMaps,
  googlePlaces,
  googleDirections,
  mapbox,
  here,
  graphhopper,
}

class CredentialRequirement {
  const CredentialRequirement({
    required this.kind,
    required this.apiKeyId,
    this.required = true,
  });

  final CredentialKind kind;
  final ApiKeyId apiKeyId;
  final bool required;
}

class GoogleApiKeyTestStatus {
  const GoogleApiKeyTestStatus({
    required this.maps,
    required this.places,
    required this.directions,
  });

  final bool maps;
  final bool places;
  final bool directions;

  bool get allPassed => maps && places && directions;
}

class ProviderCatalog {
  ProviderCatalog._();

  static const mapLayerOrder = [
    MapLayerType.standard,
    MapLayerType.dark,
    MapLayerType.satellite,
    MapLayerType.terrain,
  ];

  static List<MapProviderType> mapProvidersForPlatform() {
    return [
      MapProviderType.osm,
      MapProviderType.google,
      MapProviderType.mapbox,
      MapProviderType.here,
      if (Platform.isIOS) MapProviderType.apple,
    ];
  }

  static const searchProviderOrder = [
    SearchProviderType.nominatim,
    SearchProviderType.photon,
    SearchProviderType.pelias,
    SearchProviderType.googlePlaces,
    SearchProviderType.here,
  ];

  static const routeProviderOrder = [
    RouteProviderType.osrm,
    RouteProviderType.valhalla,
    RouteProviderType.graphHopper,
    RouteProviderType.googleDirections,
  ];

  static ProviderBundle bundleFor(MapProviderType map) {
    return switch (map) {
      MapProviderType.google => const ProviderBundle(
          search: SearchProviderType.googlePlaces,
          route: RouteProviderType.googleDirections,
        ),
      MapProviderType.here => const ProviderBundle(
          search: SearchProviderType.here,
          route: RouteProviderType.osrm,
        ),
      MapProviderType.mapbox ||
      MapProviderType.apple ||
      MapProviderType.osm =>
        const ProviderBundle(
          search: SearchProviderType.nominatim,
          route: RouteProviderType.osrm,
        ),
    };
  }

  static ProviderBadgeKind? badgeForMap(MapProviderType type) {
    return switch (type) {
      MapProviderType.osm => ProviderBadgeKind.free,
      MapProviderType.google ||
      MapProviderType.mapbox ||
      MapProviderType.here =>
        ProviderBadgeKind.apiKeyRequired,
      MapProviderType.apple => ProviderBadgeKind.free,
    };
  }

  static ProviderBadgeKind? badgeForSearch(SearchProviderType type) {
    return switch (type) {
      SearchProviderType.nominatim ||
      SearchProviderType.photon ||
      SearchProviderType.pelias =>
        ProviderBadgeKind.free,
      SearchProviderType.googlePlaces || SearchProviderType.here =>
        ProviderBadgeKind.apiKeyRequired,
    };
  }

  static ProviderBadgeKind? badgeForRoute(RouteProviderType type) {
    return switch (type) {
      RouteProviderType.osrm => ProviderBadgeKind.free,
      RouteProviderType.valhalla => ProviderBadgeKind.advanced,
      RouteProviderType.graphHopper ||
      RouteProviderType.googleDirections =>
        ProviderBadgeKind.apiKeyRequired,
    };
  }

  static SearchProviderType effectiveSearch({
    required MapProviderType mapProvider,
    required SearchProviderType searchProvider,
    required bool useRecommendedProviders,
    required bool overrideSearchProvider,
  }) {
    if (useRecommendedProviders || !overrideSearchProvider) {
      return bundleFor(mapProvider).search;
    }
    return searchProvider;
  }

  static RouteProviderType effectiveRoute({
    required MapProviderType mapProvider,
    required RouteProviderType routeProvider,
    required bool useRecommendedProviders,
    required bool overrideRouteProvider,
  }) {
    if (useRecommendedProviders || !overrideRouteProvider) {
      return bundleFor(mapProvider).route;
    }
    return routeProvider;
  }

  static List<CredentialRequirement> credentialsFor({
    required MapProviderType mapProvider,
    required SearchProviderType searchProvider,
    required RouteProviderType routeProvider,
    required bool useRecommendedProviders,
    required bool overrideSearchProvider,
    required bool overrideRouteProvider,
  }) {
    final effectiveSearch = ProviderCatalog.effectiveSearch(
      mapProvider: mapProvider,
      searchProvider: searchProvider,
      useRecommendedProviders: useRecommendedProviders,
      overrideSearchProvider: overrideSearchProvider,
    );
    final effectiveRoute = ProviderCatalog.effectiveRoute(
      mapProvider: mapProvider,
      routeProvider: routeProvider,
      useRecommendedProviders: useRecommendedProviders,
      overrideRouteProvider: overrideRouteProvider,
    );

    final requirements = <CredentialRequirement>[];

    void addGoogle({required CredentialKind kind, bool required = true}) {
      if (!requirements.any((r) => r.apiKeyId == ApiKeyId.googleMaps)) {
        requirements.add(
          CredentialRequirement(
            kind: kind,
            apiKeyId: ApiKeyId.googleMaps,
            required: required,
          ),
        );
      }
    }

    switch (mapProvider) {
      case MapProviderType.google:
        addGoogle(kind: CredentialKind.googleMaps);
      case MapProviderType.mapbox:
        requirements.add(
          const CredentialRequirement(
            kind: CredentialKind.mapbox,
            apiKeyId: ApiKeyId.mapboxToken,
          ),
        );
      case MapProviderType.here:
        requirements.add(
          const CredentialRequirement(
            kind: CredentialKind.here,
            apiKeyId: ApiKeyId.hereApiKey,
          ),
        );
      case MapProviderType.osm:
      case MapProviderType.apple:
        break;
    }

    if (effectiveSearch == SearchProviderType.googlePlaces) {
      addGoogle(kind: CredentialKind.googlePlaces);
    } else if (effectiveSearch == SearchProviderType.here &&
        mapProvider != MapProviderType.here) {
      requirements.add(
        const CredentialRequirement(
          kind: CredentialKind.here,
          apiKeyId: ApiKeyId.hereApiKey,
        ),
      );
    }

    if (effectiveRoute == RouteProviderType.googleDirections) {
      addGoogle(kind: CredentialKind.googleDirections);
    } else if (effectiveRoute == RouteProviderType.graphHopper) {
      requirements.add(
        const CredentialRequirement(
          kind: CredentialKind.graphhopper,
          apiKeyId: ApiKeyId.graphhopperKey,
        ),
      );
    }

    return requirements;
  }

  static bool requiresMapCredentials(MapProviderType mapProvider) {
    return switch (mapProvider) {
      MapProviderType.google ||
      MapProviderType.mapbox ||
      MapProviderType.here =>
        true,
      MapProviderType.osm || MapProviderType.apple => false,
    };
  }

  static List<CredentialRequirement> credentialsForMapProvider(
    MapProviderType mapProvider,
  ) {
    return switch (mapProvider) {
      MapProviderType.google => const [
          CredentialRequirement(
            kind: CredentialKind.googleMaps,
            apiKeyId: ApiKeyId.googleMaps,
          ),
        ],
      MapProviderType.mapbox => const [
          CredentialRequirement(
            kind: CredentialKind.mapbox,
            apiKeyId: ApiKeyId.mapboxToken,
          ),
        ],
      MapProviderType.here => const [
          CredentialRequirement(
            kind: CredentialKind.here,
            apiKeyId: ApiKeyId.hereApiKey,
          ),
        ],
      MapProviderType.osm || MapProviderType.apple => const [],
    };
  }

  static ApiKeyId? apiKeyIdForMapProvider(MapProviderType mapProvider) {
    return switch (mapProvider) {
      MapProviderType.google => ApiKeyId.googleMaps,
      MapProviderType.mapbox => ApiKeyId.mapboxToken,
      MapProviderType.here => ApiKeyId.hereApiKey,
      MapProviderType.osm || MapProviderType.apple => null,
    };
  }
}
