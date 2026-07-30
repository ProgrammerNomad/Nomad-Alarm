import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/core/utils/settings_provider_utils.dart';
import 'package:nomad_alarm/features/settings/presentation/provider_credential_sheet.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/services/map_viewport_store.dart';
import 'package:nomad_alarm/services/offline_tile_service.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
import 'package:nomad_alarm/shared/widgets/settings_controls.dart';

class MapSettingsScreen extends ConsumerStatefulWidget {
  const MapSettingsScreen({super.key});

  @override
  ConsumerState<MapSettingsScreen> createState() => _MapSettingsScreenState();
}

class _MapSettingsScreenState extends ConsumerState<MapSettingsScreen> {
  String _cacheSize = '…';
  bool _busy = false;
  AppSettings? _saved;
  AppSettings? _pending;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _refreshCacheSize();
  }

  void _syncFromSaved(AppSettings settings) {
    if (_initialized && _pending != null) {
      return;
    }
    _saved = _cloneMapSettings(settings);
    _pending = _cloneMapSettings(settings);
    _initialized = true;
  }

  AppSettings _cloneMapSettings(AppSettings source) {
    return AppSettings()
      ..id = source.id
      ..mapProvider = source.mapProvider
      ..mapLayer = source.mapLayer
      ..searchProvider = source.searchProvider
      ..routeProvider = source.routeProvider
      ..useRecommendedProviders = source.useRecommendedProviders
      ..overrideSearchProvider = source.overrideSearchProvider
      ..overrideRouteProvider = source.overrideRouteProvider;
  }

  bool get _hasChanges {
    final saved = _saved;
    final pending = _pending;
    if (saved == null || pending == null) {
      return false;
    }
    return saved.mapProvider != pending.mapProvider ||
        saved.mapLayer != pending.mapLayer ||
        saved.searchProvider != pending.searchProvider ||
        saved.routeProvider != pending.routeProvider ||
        saved.useRecommendedProviders != pending.useRecommendedProviders ||
        saved.overrideSearchProvider != pending.overrideSearchProvider ||
        saved.overrideRouteProvider != pending.overrideRouteProvider;
  }

  Future<void> _refreshCacheSize() async {
    if (!FeatureFlags.offlineMapTiles) {
      return;
    }
    final size = await OfflineTileService.formatCacheSize();
    if (mounted) {
      setState(() => _cacheSize = size);
    }
  }

  Future<void> _saveProviders() async {
    final l10n = context.l10n;
    final pending = _pending;
    final savedSnapshot = ref.read(settingsControllerProvider).valueOrNull;
    if (pending == null || savedSnapshot == null) {
      return;
    }

    final missing = await missingCredentialsFor(
      pending,
      ref.read(apiKeyStoreProvider),
    );
    if (missing.isNotEmpty) {
      final configured = await showProviderCredentialSheet(
        context,
        ref,
        requirements: missing,
      );
      if (!configured || !mounted) {
        return;
      }
      final stillMissing = await missingCredentialsFor(
        pending,
        ref.read(apiKeyStoreProvider),
      );
      if (stillMissing.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.providerSaveBlocked)),
        );
        return;
      }
    }

    final updated = savedSnapshot
      ..mapProvider = pending.mapProvider
      ..mapLayer = pending.mapLayer
      ..searchProvider = pending.searchProvider
      ..routeProvider = pending.routeProvider
      ..useRecommendedProviders = pending.useRecommendedProviders
      ..overrideSearchProvider = pending.overrideSearchProvider
      ..overrideRouteProvider = pending.overrideRouteProvider;

    await ref.read(settingsControllerProvider.notifier).saveSettings(updated);
    ref.invalidate(mapProviderProvider);
    ref.invalidate(searchProviderProvider);
    ref.invalidate(searchRepositoryProvider);
    ref.invalidate(routeServiceProvider);
    ref.invalidate(googleApiKeyProvider);

    setState(() {
      _saved = _cloneMapSettings(updated);
      _pending = _cloneMapSettings(updated);
    });

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          missing.isEmpty && !credentialsRequiredFor(pending).any((r) => r.required)
              ? l10n.noApiKeyRequired
              : l10n.providerChangedSuccess,
        ),
      ),
    );
  }

  Future<void> _downloadRegion() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      final mapProvider = await ref.read(mapProviderProvider.future);
      final tile = mapProvider.tileConfig;
      if (tile == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.mapOfflineGoogleUnsupported)),
          );
        }
        return;
      }
      final bounds = await MapViewportStore.loadBounds();
      await OfflineTileService.downloadRegion(
        southWest: bounds?.southWest ?? const LatLng(51.45, -0.15),
        northEast: bounds?.northEast ?? const LatLng(51.55, -0.05),
        urlTemplate: tile.urlTemplate,
      );
      await _refreshCacheSize();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.mapOfflineDownloadComplete)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPrefix(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _clearCache() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      await OfflineTileService.clearCache();
      await _refreshCacheSize();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.mapOfflineCacheCleared)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _onMapProviderChanged(MapProviderType value) {
    setState(() {
      applyMapProviderChange(_pending!, value);
      if (_pending!.useRecommendedProviders) {
        _pending!
          ..overrideSearchProvider = false
          ..overrideRouteProvider = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsAsync = ref.watch(settingsControllerProvider);

    return NomadScaffold(
      title: l10n.mapSettingsTitle,
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorPrefix(e.toString()))),
        data: (settings) {
          _syncFromSaved(settings);
          final pending = _pending!;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _SectionHeader(title: l10n.providersSection),
                    Text(
                      l10n.mapProviderAutoSetsProviders,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    SettingsPickerTile(
                      title: l10n.mapProviderLabel,
                      valueLabel: _mapProviderLabel(l10n, pending.mapProvider),
                      onTap: () async {
                        final providers = ProviderCatalog.mapProvidersForPlatform();
                        final picked = await showSettingsPickerSheet<MapProviderType>(
                          context: context,
                          title: l10n.mapProviderLabel,
                          options: providers,
                          value: pending.mapProvider,
                          labelFor: (p) => _mapProviderLabel(l10n, p),
                          cancelLabel: l10n.cancel,
                          trailingFor: (p) {
                            final badge = ProviderCatalog.badgeForMap(p);
                            return badge == null ? null : ProviderBadge(kind: badge);
                          },
                        );
                        if (picked != null) {
                          _onMapProviderChanged(picked);
                        }
                      },
                    ),
                    ProviderSummaryRow(
                      title: l10n.searchProviderLabel,
                      valueLabel: _searchProviderLabel(
                        l10n,
                        effectiveSearch(pending),
                      ),
                      badge: pending.useRecommendedProviders ||
                              !pending.overrideSearchProvider
                          ? ProviderBadgeKind.recommended
                          : ProviderCatalog.badgeForSearch(pending.searchProvider),
                    ),
                    if (!pending.useRecommendedProviders &&
                        pending.overrideSearchProvider)
                      SettingsPickerTile(
                        title: l10n.searchProviderLabel,
                        valueLabel: _searchProviderLabel(
                          l10n,
                          pending.searchProvider,
                        ),
                        onTap: () async {
                          final picked =
                              await showSettingsPickerSheet<SearchProviderType>(
                            context: context,
                            title: l10n.searchProviderLabel,
                            options: ProviderCatalog.searchProviderOrder,
                            value: pending.searchProvider,
                            labelFor: (p) => _searchProviderLabel(l10n, p),
                            cancelLabel: l10n.cancel,
                          );
                          if (picked != null) {
                            setState(() => pending.searchProvider = picked);
                          }
                        },
                      ),
                    ProviderSummaryRow(
                      title: l10n.routeProviderLabel,
                      valueLabel: _routeProviderLabel(
                        l10n,
                        effectiveRoute(pending),
                      ),
                      badge: pending.useRecommendedProviders ||
                              !pending.overrideRouteProvider
                          ? ProviderBadgeKind.recommended
                          : ProviderCatalog.badgeForRoute(pending.routeProvider),
                    ),
                    if (!pending.useRecommendedProviders &&
                        pending.overrideRouteProvider)
                      SettingsPickerTile(
                        title: l10n.routeProviderLabel,
                        valueLabel: _routeProviderLabel(
                          l10n,
                          pending.routeProvider,
                        ),
                        onTap: () async {
                          final picked =
                              await showSettingsPickerSheet<RouteProviderType>(
                            context: context,
                            title: l10n.routeProviderLabel,
                            options: ProviderCatalog.routeProviderOrder,
                            value: pending.routeProvider,
                            labelFor: (p) => _routeProviderLabel(l10n, p),
                            cancelLabel: l10n.cancel,
                          );
                          if (picked != null) {
                            setState(() => pending.routeProvider = picked);
                          }
                        },
                      ),
                    SwitchListTile(
                      title: Text(l10n.useRecommendedProviders),
                      subtitle: Text(l10n.useRecommendedProvidersSubtitle),
                      value: pending.useRecommendedProviders,
                      onChanged: (value) {
                        setState(() {
                          pending.useRecommendedProviders = value;
                          if (value) {
                            pending
                              ..overrideSearchProvider = false
                              ..overrideRouteProvider = false;
                            applyMapProviderChange(
                              pending,
                              pending.mapProvider,
                            );
                          }
                        });
                      },
                    ),
                    _SectionHeader(title: l10n.advancedSection),
                    SwitchListTile(
                      title: Text(l10n.overrideSearchProvider),
                      value: pending.overrideSearchProvider,
                      onChanged: pending.useRecommendedProviders
                          ? null
                          : (value) {
                              setState(
                                () => pending.overrideSearchProvider = value,
                              );
                            },
                    ),
                    SwitchListTile(
                      title: Text(l10n.overrideRouteProvider),
                      value: pending.overrideRouteProvider,
                      onChanged: pending.useRecommendedProviders
                          ? null
                          : (value) {
                              setState(
                                () => pending.overrideRouteProvider = value,
                              );
                            },
                    ),
                    ListTile(
                      leading: const Icon(Icons.vpn_key_outlined),
                      title: Text(l10n.advancedApiKeys),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/settings/api-keys'),
                    ),
                    _SectionHeader(title: l10n.mapLayerLabel),
                    SettingsPickerTile(
                      title: l10n.mapLayerLabel,
                      valueLabel: _mapLayerLabel(l10n, pending.mapLayer),
                      onTap: () async {
                        final picked = await showSettingsPickerSheet<MapLayerType>(
                          context: context,
                          title: l10n.mapLayerLabel,
                          options: ProviderCatalog.mapLayerOrder,
                          value: pending.mapLayer,
                          labelFor: (layer) => _mapLayerLabel(l10n, layer),
                          cancelLabel: l10n.cancel,
                        );
                        if (picked != null) {
                          setState(() => pending.mapLayer = picked);
                        }
                      },
                    ),
                    if (FeatureFlags.offlineMapTiles) ...[
                      _SectionHeader(title: l10n.mapOfflineSection),
                      ListTile(
                        title: Text(l10n.mapOfflineCacheSize),
                        subtitle: Text(_cacheSize),
                      ),
                      ListTile(
                        leading: const Icon(Icons.download_outlined),
                        title: Text(l10n.mapOfflineDownload),
                        subtitle: Text(l10n.mapOfflineDownloadSubtitle),
                        enabled: !_busy,
                        onTap: _downloadRegion,
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: Text(l10n.mapOfflineClearCache),
                        enabled: !_busy,
                        onTap: _clearCache,
                      ),
                    ],
                    if (_busy)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
              PendingChangesBar(
                hasChanges: _hasChanges,
                onSave: _saveProviders,
                saveLabel: l10n.save,
              ),
            ],
          );
        },
      ),
    );
  }

  String _mapLayerLabel(dynamic l10n, MapLayerType layer) {
    return switch (layer) {
      MapLayerType.standard => l10n.mapLayerStandard,
      MapLayerType.satellite => l10n.mapLayerSatellite,
      MapLayerType.dark => l10n.mapLayerDark,
      MapLayerType.terrain => l10n.mapLayerTerrain,
    };
  }

  String _mapProviderLabel(dynamic l10n, MapProviderType type) {
    return switch (type) {
      MapProviderType.osm => l10n.mapProviderOsm,
      MapProviderType.google => l10n.mapProviderGoogle,
      MapProviderType.mapbox => l10n.mapProviderMapbox,
      MapProviderType.here => l10n.mapProviderHere,
      MapProviderType.apple => l10n.mapProviderApple,
    };
  }

  String _searchProviderLabel(dynamic l10n, SearchProviderType type) {
    return switch (type) {
      SearchProviderType.nominatim => l10n.searchProviderNominatim,
      SearchProviderType.googlePlaces => l10n.searchProviderGooglePlaces,
      SearchProviderType.photon => l10n.searchProviderPhoton,
      SearchProviderType.pelias => l10n.searchProviderPelias,
      SearchProviderType.here => l10n.searchProviderHere,
    };
  }

  String _routeProviderLabel(dynamic l10n, RouteProviderType type) {
    return switch (type) {
      RouteProviderType.osrm => l10n.routeProviderOsrm,
      RouteProviderType.googleDirections => l10n.routeProviderGoogle,
      RouteProviderType.graphHopper => l10n.routeProviderGraphhopper,
      RouteProviderType.valhalla => l10n.routeProviderValhalla,
    };
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
