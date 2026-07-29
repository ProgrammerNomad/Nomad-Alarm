import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/utils/travel_mode_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/route/route_provider.dart';

class OsrmRouteProvider implements RouteProvider {
  OsrmRouteProvider({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  static const _baseUrl = 'https://router.project-osrm.org';

  final http.Client _client;
  final bool _ownsClient;

  @override
  RouteProviderType get type => RouteProviderType.osrm;

  @override
  Future<RouteResult?> route({
    required LatLng from,
    required LatLng to,
    TravelMode travelMode = TravelMode.autoDetect,
  }) async {
    final profile = TravelModeUtils.osrmProfile(travelMode);
    final path =
        '${from.longitude},${from.latitude};${to.longitude},${to.latitude}';
    final uri = Uri.parse('$_baseUrl/route/v1/$profile/$path').replace(
      queryParameters: {
        'overview': 'full',
        'geometries': 'geojson',
      },
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw NetworkException(
          'Routing failed. Please try again.',
          debugMessage: 'HTTP ${response.statusCode}',
        );
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['code'] != 'Ok') {
        return null;
      }
      final routes = data['routes'] as List<dynamic>? ?? [];
      if (routes.isEmpty) {
        return null;
      }
      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as Map<String, dynamic>;
      final coordinates = geometry['coordinates'] as List<dynamic>;
      final points = coordinates
          .map(
            (coord) => LatLng(
              (coord[1] as num).toDouble(),
              (coord[0] as num).toDouble(),
            ),
          )
          .toList();
      return RouteResult(
        distanceMeters: (route['distance'] as num).toDouble(),
        durationSeconds: (route['duration'] as num).round(),
        points: points,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        'Routing failed. Check your connection.',
        debugMessage: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
