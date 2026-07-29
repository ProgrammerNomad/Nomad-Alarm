import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/utils/polyline_utils.dart';
import 'package:nomad_alarm/services/map_service.dart';

/// Mini-map showing a trip route polyline and destination pin.
class TripRouteMap extends StatelessWidget {
  const TripRouteMap({
    super.key,
    required this.destLatitude,
    required this.destLongitude,
    this.routePolyline,
    this.height = 180,
  });

  final double destLatitude;
  final double destLongitude;
  final String? routePolyline;
  final double height;

  @override
  Widget build(BuildContext context) {
    final points = PolylineUtils.parse(routePolyline);
    final dest = LatLng(destLatitude, destLongitude);
    final center = points.isNotEmpty
        ? points[points.length ~/ 2]
        : dest;

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 13,
            minZoom: MapService.minZoom,
            maxZoom: MapService.maxZoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: MapService.standardTileUrl,
              userAgentPackageName: 'com.nomad.alarm',
            ),
            if (points.length >= 2)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: points,
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 4,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                Marker(
                  point: dest,
                  width: 32,
                  height: 32,
                  child: Icon(
                    Icons.place,
                    color: Theme.of(context).colorScheme.error,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
