import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/search/search_provider.dart';

class PhotonSearchProvider implements SearchProvider {
  PhotonSearchProvider({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  static const _baseUrl = 'https://photon.komoot.io';

  final http.Client _client;
  final bool _ownsClient;

  @override
  SearchProviderType get type => SearchProviderType.photon;

  @override
  Future<List<SearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return [];
    }

    final uri = Uri.parse('$_baseUrl/api/').replace(
      queryParameters: {
        'q': trimmed,
        'limit': '10',
      },
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw NetworkException(
          'Search failed. Please try again.',
          debugMessage: 'HTTP ${response.statusCode}',
        );
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final features = data['features'] as List<dynamic>? ?? [];
      return features.map(_parseFeature).toList();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        'Search failed. Check your connection.',
        debugMessage: e.toString(),
      );
    }
  }

  @override
  Future<SearchResult?> reverseGeocode(double latitude, double longitude) async {
    final uri = Uri.parse('$_baseUrl/reverse').replace(
      queryParameters: {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'limit': '1',
      },
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final features = data['features'] as List<dynamic>? ?? [];
      if (features.isEmpty) {
        return null;
      }
      return _parseFeature(features.first);
    } catch (_) {
      return null;
    }
  }

  SearchResult _parseFeature(dynamic feature) {
    final map = feature as Map<String, dynamic>;
    final geometry = map['geometry'] as Map<String, dynamic>;
    final coords = geometry['coordinates'] as List<dynamic>;
    final properties = map['properties'] as Map<String, dynamic>? ?? {};
    final name = properties['name'] as String? ??
        properties['street'] as String? ??
        properties['city'] as String? ??
        'Unknown';
    return SearchResult(
      name: name,
      latitude: (coords[1] as num).toDouble(),
      longitude: (coords[0] as num).toDouble(),
      address: _formatAddress(properties),
      placeId: properties['osm_id']?.toString(),
    );
  }

  String? _formatAddress(Map<String, dynamic> properties) {
    final parts = <String>[
      if (properties['street'] != null) properties['street'] as String,
      if (properties['city'] != null) properties['city'] as String,
      if (properties['state'] != null) properties['state'] as String,
      if (properties['country'] != null) properties['country'] as String,
    ];
    return parts.isEmpty ? null : parts.join(', ');
  }

  @override
  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
