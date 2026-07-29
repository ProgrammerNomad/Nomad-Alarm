import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/utils/travel_mode_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/route/route_provider.dart';

class GoogleDirectionsProvider implements RouteProvider {
  GoogleDirectionsProvider({
    required this.apiKey,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  static const _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  final String apiKey;
  final http.Client _client;
  final bool _ownsClient;

  @override
  RouteProviderType get type => RouteProviderType.googleDirections;

  @override
  Future<RouteResult?> route({
    required LatLng from,
    required LatLng to,
    TravelMode travelMode = TravelMode.autoDetect,
  }) async {
    if (apiKey.isEmpty) {
      throw const NetworkException(
        'Google Directions API key is not configured.',
      );
    }

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'origin': '${from.latitude},${from.longitude}',
        'destination': '${to.latitude},${to.longitude}',
        'mode': TravelModeUtils.googleMode(travelMode),
        'key': apiKey,
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
      if (data['status'] != 'OK') {
        return null;
      }
      final routes = data['routes'] as List<dynamic>? ?? [];
      if (routes.isEmpty) {
        return null;
      }
      final route = routes.first as Map<String, dynamic>;
      final legs = route['legs'] as List<dynamic>? ?? [];
      if (legs.isEmpty) {
        return null;
      }
      final leg = legs.first as Map<String, dynamic>;
      final distance = leg['distance'] as Map<String, dynamic>;
      final duration = leg['duration'] as Map<String, dynamic>;
      final polyline = route['overview_polyline'] as Map<String, dynamic>?;
      final encoded = polyline?['points'] as String?;
      final points = encoded != null ? _decodePolyline(encoded) : <LatLng>[];
      return RouteResult(
        distanceMeters: (distance['value'] as num).toDouble(),
        durationSeconds: (duration['value'] as num).round(),
        encodedPolyline: encoded,
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

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    var index = 0;
    var lat = 0;
    var lng = 0;

    while (index < encoded.length) {
      var shift = 0;
      var result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  @override
  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
