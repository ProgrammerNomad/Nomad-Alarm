import 'package:apple_maps_flutter/apple_maps_flutter.dart' as amaps;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/location_providers.dart';
import 'package:nomad_alarm/providers/map/map_provider.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import 'package:nomad_alarm/services/map_service.dart';
import 'package:nomad_alarm/services/map_viewport_store.dart';
import 'package:nomad_alarm/services/offline_tile_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialZoom,
  });

  final double? initialLatitude;
  final double? initialLongitude;
  final double? initialZoom;

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  gmaps.GoogleMapController? _googleMapController;
  LatLng? _droppedPin;
  SearchResult? _pinResult;
  bool _loadingPinAddress = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final positionAsync = ref.watch(currentPositionProvider);
    final mapProviderAsync = ref.watch(mapProviderProvider);

    final position = positionAsync.valueOrNull;

    final initialCenter = LatLng(
      widget.initialLatitude ?? position?.latitude ?? 51.5074,
      widget.initialLongitude ?? position?.longitude ?? -0.1278,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mapTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: mapProviderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorPrefix(e.toString()))),
        data: (mapProvider) => Stack(
          children: [
            _buildMap(mapProvider, initialCenter, position),
            if (mapProvider.displayMode == MapDisplayMode.flutterMap &&
                position != null)
              Positioned(
                right: 16,
                top: 16,
                child: Material(
                  elevation: 2,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: l10n.mapTitle,
                    icon: const Icon(Icons.explore),
                    onPressed: () => _mapController.rotate(0),
                  ),
                ),
              ),
            if (mapProvider.attribution.isNotEmpty)
              Positioned(
                left: 8,
                bottom: _droppedPin != null ? 180 : 8,
                child: Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      mapProvider.attribution,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            if (_droppedPin != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: _PinBottomSheet(
                  result: _pinResult,
                  loading: _loadingPinAddress,
                  onSetAlarm: _setAlarmFromPin,
                  onSaveFavorite: _saveFavoriteFromPin,
                  onDismiss: () => setState(() {
                    _droppedPin = null;
                    _pinResult = null;
                  }),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Semantics(
        label: l10n.semCenterOnMap,
        button: true,
        child: FloatingActionButton(
          onPressed: () => _centerOnUser(position),
          child: const Icon(Icons.gps_fixed),
        ),
      ),
    );
  }

  Widget _buildMap(
    MapProvider mapProvider,
    LatLng initialCenter,
    Position? position,
  ) {
    if (mapProvider.displayMode == MapDisplayMode.appleNative) {
      return amaps.AppleMap(
        initialCameraPosition: amaps.CameraPosition(
          target: amaps.LatLng(initialCenter.latitude, initialCenter.longitude),
          zoom: widget.initialZoom ?? MapService.defaultZoom,
        ),
        myLocationEnabled: true,
        onLongPress: (point) => _onLongPress(
          LatLng(point.latitude, point.longitude),
        ),
        annotations: {
          if (_droppedPin != null)
            amaps.Annotation(
              annotationId: amaps.AnnotationId('pin'),
              position: amaps.LatLng(_droppedPin!.latitude, _droppedPin!.longitude),
            ),
        },
      );
    }

    if (mapProvider.displayMode == MapDisplayMode.googleNative) {
      final googleKey = ref.watch(googleApiKeyProvider).valueOrNull;
      if (googleKey == null || googleKey.isEmpty) {
        return _GoogleMapKeyMissingPanel(
          onOpenMapSettings: () => context.push('/settings/map'),
          onOpenGuide: () async {
            final uri = Uri.parse(AppConstants.settingsGuideGoogleSetupUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        );
      }
      return gmaps.GoogleMap(
        initialCameraPosition: gmaps.CameraPosition(
          target: gmaps.LatLng(initialCenter.latitude, initialCenter.longitude),
          zoom: widget.initialZoom ?? MapService.defaultZoom,
        ),
        myLocationEnabled: true,
        trafficEnabled: true,
        onMapCreated: (controller) => _googleMapController = controller,
        onLongPress: (point) => _onLongPress(
          LatLng(point.latitude, point.longitude),
        ),
        markers: {
          if (_droppedPin != null)
            gmaps.Marker(
              markerId: const gmaps.MarkerId('pin'),
              position: gmaps.LatLng(_droppedPin!.latitude, _droppedPin!.longitude),
            ),
        },
      );
    }

    final tile = mapProvider.tileConfig!;
    final zoom = widget.initialZoom ?? tile.defaultZoom;

    final tileProvider = FeatureFlags.offlineMapTiles
        ? const FMTCStore(OfflineTileService.storeName).getTileProvider()
        : null;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: zoom,
        minZoom: tile.minZoom,
        maxZoom: tile.maxZoom,
        onLongPress: (tapPosition, point) => _onLongPress(point),
        onMapEvent: (_) => _persistViewport(),
      ),
      children: [
        TileLayer(
          urlTemplate: tile.urlTemplate,
          userAgentPackageName: 'com.nomad.alarm',
          additionalOptions: tile.additionalOptions,
          tileProvider: tileProvider,
        ),
        if (position != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(position.latitude, position.longitude),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
            ],
          ),
        if (_droppedPin != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _droppedPin!,
                width: 40,
                height: 48,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _onLongPress(LatLng point) async {
    setState(() {
      _droppedPin = point;
      _pinResult = null;
      _loadingPinAddress = true;
    });

    final repo = await ref.read(searchRepositoryProvider.future);
    final result = await repo.reverseGeocode(
      point.latitude,
      point.longitude,
    );

    if (!mounted) {
      return;
    }

    final l10n = context.l10n;
    setState(() {
      _loadingPinAddress = false;
      _pinResult = result ??
          SearchResult(
            name: l10n.droppedPin,
            latitude: point.latitude,
            longitude: point.longitude,
          );
    });
  }

  void _centerOnUser(Position? position) {
    if (position == null) {
      return;
    }
    final target = LatLng(position.latitude, position.longitude);
    if (_googleMapController != null) {
      _googleMapController!.animateCamera(
        gmaps.CameraUpdate.newLatLng(
          gmaps.LatLng(target.latitude, target.longitude),
        ),
      );
    } else {
      _mapController.move(target, MapService.defaultZoom);
    }
  }

  void _persistViewport() {
    if (_googleMapController != null) {
      return;
    }
    final bounds = _mapController.camera.visibleBounds;
    MapViewportStore.saveBounds(
      southWest: bounds.southWest,
      northEast: bounds.northEast,
    );
  }

  void _setAlarmFromPin() {
    final result = _pinResult;
    if (result == null) {
      return;
    }
    context.push(
      '/alarm/new',
      extra: DestinationArgs.fromSearchResult(result),
    );
  }

  Future<void> _saveFavoriteFromPin() async {
    final result = _pinResult;
    if (result == null) {
      return;
    }
    await ref.read(favoriteRepositoryProvider).save(
          name: result.name,
          latitude: result.latitude,
          longitude: result.longitude,
          address: result.address,
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.savedToFavorites)),
      );
    }
  }
}

class _PinBottomSheet extends StatelessWidget {
  const _PinBottomSheet({
    required this.result,
    required this.loading,
    required this.onSetAlarm,
    required this.onSaveFavorite,
    required this.onDismiss,
  });

  final SearchResult? result;
  final bool loading;
  final VoidCallback onSetAlarm;
  final VoidCallback onSaveFavorite;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      elevation: 8,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: loading
                      ? Text(l10n.lookingUpAddress)
                      : Text(
                          result?.displayAddress ?? l10n.droppedPin,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onDismiss,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Semantics(
              label: l10n.semSetAlarmFromPin,
              button: true,
              child: FilledButton.icon(
                onPressed: loading ? null : onSetAlarm,
                icon: const Icon(Icons.alarm_add),
                label: Text(l10n.setAlarm),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: loading ? null : onSaveFavorite,
              icon: const Icon(Icons.favorite_border),
              label: Text(l10n.saveFavorite),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleMapKeyMissingPanel extends StatelessWidget {
  const _GoogleMapKeyMissingPanel({
    required this.onOpenMapSettings,
    required this.onOpenGuide,
  });

  final VoidCallback onOpenMapSettings;
  final VoidCallback onOpenGuide;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.googleMapKeyRequired,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onOpenMapSettings,
              icon: const Icon(Icons.map_outlined),
              label: Text(l10n.openMapSettings),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onOpenGuide,
              icon: const Icon(Icons.help_outline),
              label: Text(l10n.googleMapKeySetupGuide),
            ),
          ],
        ),
      ),
    );
  }
}
