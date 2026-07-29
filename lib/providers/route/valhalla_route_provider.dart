import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/route/route_provider.dart';

class ValhallaRouteProvider implements RouteProvider {
  ValhallaRouteProvider({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  static const _baseUrl = 'https://valhalla1.openstreetmap.de/route';

  final http.Client _client;
  final bool _ownsClient;

  @override
  RouteProviderType get type => RouteProviderType.valhalla;

  @override
  Future<RouteResult?> route({
    required LatLng from,
    required LatLng to,
    TravelMode travelMode = TravelMode.autoDetect,
  }) async {
    final costing = switch (travelMode) {
      TravelMode.walking => 'pedestrian',
      TravelMode.cycling => 'bicycle',
      _ => 'auto',
    };
    final body = jsonEncode({
      'locations': [
        {'lat': from.latitude, 'lon': from.longitude},
        {'lat': to.latitude, 'lon': to.longitude},
      ],
      'costing': costing,
      'directions_options': {'units': 'kilometers'},
    });

    try {
      final response = await _client.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode != 200) {
        throw NetworkException(
          'Routing failed. Please try again.',
          debugMessage: 'HTTP ${response.statusCode}',
        );
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final trip = data['trip'] as Map<String, dynamic>?;
      if (trip == null) {
        return null;
      }
      final legs = trip['legs'] as List<dynamic>? ?? [];
      if (legs.isEmpty) {
        return null;
      }
      final leg = legs.first as Map<String, dynamic>;
      final summary = leg['summary'] as Map<String, dynamic>;
      final shape = leg['shape'] as String?;
      final points = shape != null ? _decodePolyline(shape) : <LatLng>[];
      return RouteResult(
        distanceMeters: (summary['length'] as num).toDouble() * 1000,
        durationSeconds: (summary['time'] as num).round(),
        encodedPolyline: shape,
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
