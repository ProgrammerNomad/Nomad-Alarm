import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/location_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import 'package:nomad_alarm/services/map_service.dart';

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
  LatLng? _droppedPin;
  SearchResult? _pinResult;
  bool _loadingPinAddress = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final positionAsync = ref.watch(currentPositionProvider);
    final mapService = ref.watch(mapServiceProvider);

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
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: widget.initialZoom ?? MapService.defaultZoom,
              minZoom: MapService.minZoom,
              maxZoom: MapService.maxZoom,
              onLongPress: (tapPosition, point) => _onLongPress(point),
            ),
            children: [
              TileLayer(
                urlTemplate: mapService.tileUrl,
                userAgentPackageName: 'com.nomad.alarm',
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

  Future<void> _onLongPress(LatLng point) async {
    setState(() {
      _droppedPin = point;
      _pinResult = null;
      _loadingPinAddress = true;
    });

    final result = await ref.read(searchRepositoryProvider).reverseGeocode(
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
    _mapController.move(
      LatLng(position.latitude, position.longitude),
      MapService.defaultZoom,
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
