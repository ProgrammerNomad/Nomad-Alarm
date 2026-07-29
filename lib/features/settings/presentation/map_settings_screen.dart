import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/services/map_viewport_store.dart';
import 'package:nomad_alarm/services/offline_tile_service.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class MapSettingsScreen extends ConsumerStatefulWidget {
  const MapSettingsScreen({super.key});

  @override
  ConsumerState<MapSettingsScreen> createState() => _MapSettingsScreenState();
}

class _MapSettingsScreenState extends ConsumerState<MapSettingsScreen> {
  String _cacheSize = '…';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refreshCacheSize();
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsAsync = ref.watch(settingsControllerProvider);

    return NomadScaffold(
      title: l10n.mapSettingsTitle,
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorPrefix(e.toString()))),
        data: (settings) => ListView(
          children: [
            _SectionHeader(title: l10n.mapProvidersSection),
            ListTile(
              title: Text(l10n.mapLayerLabel),
              trailing: DropdownButton<MapLayerType>(
                value: settings.mapLayer,
                underline: const SizedBox.shrink(),
                items: MapLayerType.values
                    .map(
                      (layer) => DropdownMenuItem(
                        value: layer,
                        child: Text(_mapLayerLabel(l10n, layer)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }
                  await ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..mapLayer = value,
                      );
                  ref.invalidate(mapProviderProvider);
                },
              ),
            ),
            ListTile(
              title: Text(l10n.mapProviderLabel),
              trailing: DropdownButton<MapProviderType>(
                value: settings.mapProvider,
                underline: const SizedBox.shrink(),
                items: MapProviderType.values
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(_mapProviderLabel(l10n, p)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }
                  await ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..mapProvider = value,
                      );
                  ref.invalidate(mapProviderProvider);
                },
              ),
            ),
            ListTile(
              title: Text(l10n.searchProviderLabel),
              trailing: DropdownButton<SearchProviderType>(
                value: settings.searchProvider,
                underline: const SizedBox.shrink(),
                items: SearchProviderType.values
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(_searchProviderLabel(l10n, p)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }
                  await ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..searchProvider = value,
                      );
                  ref.invalidate(searchProviderProvider);
                  ref.invalidate(searchRepositoryProvider);
                },
              ),
            ),
            ListTile(
              title: Text(l10n.routeProviderLabel),
              trailing: DropdownButton<RouteProviderType>(
                value: settings.routeProvider,
                underline: const SizedBox.shrink(),
                items: RouteProviderType.values
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(_routeProviderLabel(l10n, p)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }
                  await ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..routeProvider = value,
                      );
                  ref.invalidate(routeServiceProvider);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.vpn_key_outlined),
              title: Text(l10n.apiKeysTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/api-keys'),
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
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
