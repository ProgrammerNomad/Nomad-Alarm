import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/providers/map/map_provider.dart';
import 'package:nomad_alarm/providers/search/search_provider.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import 'package:nomad_alarm/services/provider_factory.dart';
import 'package:nomad_alarm/services/route_service.dart';

final apiKeyStoreProvider = Provider<ApiKeyStore>((ref) {
  return ApiKeyStore();
});

final googleApiKeyProvider = FutureProvider<String?>((ref) async {
  return ref.watch(apiKeyStoreProvider).readGoogleApiKey();
});

final providerFactoryProvider = Provider<ProviderFactory>((ref) {
  final factory = ProviderFactory(apiKeyStore: ref.watch(apiKeyStoreProvider));
  ref.onDispose(factory.dispose);
  return factory;
});

final mapProviderProvider = FutureProvider<MapProvider>((ref) async {
  final settings = await ref.watch(settingsControllerProvider.future);
  return ref.read(providerFactoryProvider).createMapProvider(settings);
});

final searchProviderProvider = FutureProvider<SearchProvider>((ref) async {
  final settings = await ref.watch(settingsControllerProvider.future);
  return ref.read(providerFactoryProvider).createSearchProvider(settings);
});

final routeServiceProvider = Provider<RouteService>((ref) {
  final settings = ref.watch(settingsControllerProvider).requireValue;
  final service = RouteService(
    factory: ref.watch(providerFactoryProvider),
    settings: settings,
  );
  ref.listen(settingsControllerProvider, (previous, next) {
    next.whenData(service.updateSettings);
  });
  ref.onDispose(service.dispose);
  return service;
});
