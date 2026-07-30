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

Future<bool> hasCredential(ApiKeyStore store, ApiKeyId id) async {
  if (ApiKeyId.googleSlots.contains(id)) {
    final key = await store.readGoogleApiKey();
    return key != null && key.isNotEmpty;
  }
  final value = await store.read(id);
  return value != null && value.isNotEmpty;
}

Future<List<CredentialRequirement>> missingCredentialsFor(
  AppSettings settings,
  ApiKeyStore store,
) async {
  final required = credentialsRequiredFor(settings);
  final missing = <CredentialRequirement>[];
  for (final requirement in required) {
    if (requirement.required && !await hasCredential(store, requirement.apiKeyId)) {
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
