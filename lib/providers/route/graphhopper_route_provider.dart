import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/utils/travel_mode_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/route/route_provider.dart';

class GraphhopperRouteProvider implements RouteProvider {
  GraphhopperRouteProvider({
    required this.apiKey,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  static const _baseUrl = 'https://graphhopper.com/api/1/route';

  final String apiKey;
  final http.Client _client;
  final bool _ownsClient;

  @override
  RouteProviderType get type => RouteProviderType.graphHopper;

  @override
  Future<RouteResult?> route({
    required LatLng from,
    required LatLng to,
    TravelMode travelMode = TravelMode.autoDetect,
  }) async {
    if (apiKey.isEmpty) {
      throw const NetworkException(
        'GraphHopper API key is not configured.',
      );
    }

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'point': [
          '${from.latitude},${from.longitude}',
          '${to.latitude},${to.longitude}',
        ],
        'vehicle': TravelModeUtils.graphHopperProfile(travelMode),
        'key': apiKey,
        'points_encoded': 'false',
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
      final paths = data['paths'] as List<dynamic>? ?? [];
      if (paths.isEmpty) {
        return null;
      }
      final path = paths.first as Map<String, dynamic>;
      final pointsData = path['points'] as Map<String, dynamic>?;
      final coordinates = pointsData?['coordinates'] as List<dynamic>? ?? [];
      final points = coordinates
          .map(
            (coord) => LatLng(
              (coord[1] as num).toDouble(),
              (coord[0] as num).toDouble(),
            ),
          )
          .toList();
      return RouteResult(
        distanceMeters: (path['distance'] as num).toDouble(),
        durationSeconds: ((path['time'] as num) / 1000).round(),
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
