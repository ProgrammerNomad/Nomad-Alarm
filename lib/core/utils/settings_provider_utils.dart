import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/services/api_key_store.dart';

SearchProviderType effectiveSearch(AppSettings settings) {
  return ProviderCatalog.effectiveSearch(
    mapProvider: settings.mapProvider,
    searchProvider: settings.searchProvider,
    useRecommendedProviders: settings.useRecommendedProviders,
    overrideSearchProvider: settings.overrideSearchProvider,
  );
}

RouteProviderType effectiveRoute(AppSettings settings) {
  return ProviderCatalog.effectiveRoute(
    mapProvider: settings.mapProvider,
    routeProvider: settings.routeProvider,
    useRecommendedProviders: settings.useRecommendedProviders,
    overrideRouteProvider: settings.overrideRouteProvider,
  );
}

AppSettings applyMapProviderChange(AppSettings settings, MapProviderType map) {
  final bundle = ProviderCatalog.bundleFor(map);
  settings
    ..mapProvider = map
    ..searchProvider = bundle.search
    ..routeProvider = bundle.route;
  return settings;
}

List<CredentialRequirement> credentialsRequiredFor(AppSettings settings) {
  return ProviderCatalog.credentialsFor(
    mapProvider: settings.mapProvider,
    searchProvider: settings.searchProvider,
    routeProvider: settings.routeProvider,
    useRecommendedProviders: settings.useRecommendedProviders,
    overrideSearchProvider: settings.overrideSearchProvider,
    overrideRouteProvider: settings.overrideRouteProvider,
  );
}

Future<bool> hasCredential(
  ApiKeyStore store,
  ApiKeyId id, {
  CredentialKind? kind,
}) async {
  if (ApiKeyId.googleSlots.contains(id)) {
    final effectiveKind = kind ?? CredentialKind.googleMaps;
    final key = await store.readGoogleKeyFor(effectiveKind);
    if (effectiveKind == CredentialKind.googleMaps) {
      final mapsKey = await store.read(ApiKeyId.googleMaps);
      return mapsKey != null && mapsKey.isNotEmpty;
    }
    return key != null && key.isNotEmpty;
  }
  final value = await store.read(id);
  return value != null && value.isNotEmpty;
}

Future<bool> hasMapProviderCredential(
  ApiKeyStore store,
  MapProviderType mapProvider,
) async {
  final keyId = ProviderCatalog.apiKeyIdForMapProvider(mapProvider);
  if (keyId == null) {
    return true;
  }
  if (keyId == ApiKeyId.googleMaps) {
    final mapsKey = await store.read(ApiKeyId.googleMaps);
    return mapsKey != null && mapsKey.isNotEmpty;
  }
  return hasCredential(store, keyId);
}

Future<List<CredentialRequirement>> missingCredentialsFor(
  AppSettings settings,
  ApiKeyStore store,
) async {
  final required = credentialsRequiredFor(settings);
  final missing = <CredentialRequirement>[];
  for (final requirement in required) {
    if (requirement.required &&
        !await hasCredential(
          store,
          requirement.apiKeyId,
          kind: requirement.kind,
        )) {
      if (!missing.any((m) => m.apiKeyId == requirement.apiKeyId)) {
        missing.add(requirement);
      }
    }
  }
  return missing;
}

void ensureProviderSettingsDefaults(AppSettings settings) {
  if (!settings.useRecommendedProviders &&
      !settings.overrideSearchProvider &&
      !settings.overrideRouteProvider) {
    final bundle = ProviderCatalog.bundleFor(settings.mapProvider);
    if (settings.searchProvider == bundle.search &&
        settings.routeProvider == bundle.route) {
      settings.useRecommendedProviders = true;
    }
  }
}
