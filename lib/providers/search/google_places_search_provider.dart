import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/search/search_provider.dart';

class GooglePlacesSearchProvider implements SearchProvider {
  GooglePlacesSearchProvider({
    required this.apiKey,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  static const _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  final String apiKey;
  final http.Client _client;
  final bool _ownsClient;

  @override
  SearchProviderType get type => SearchProviderType.googlePlaces;

  @override
  Future<List<SearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return [];
    }
    if (apiKey.isEmpty) {
      throw const NetworkException(
        'Google Places API key is not configured.',
      );
    }

    final uri = Uri.parse('$_baseUrl/autocomplete/json').replace(
      queryParameters: {
        'input': trimmed,
        'key': apiKey,
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
      if (data['status'] != 'OK' && data['status'] != 'ZERO_RESULTS') {
        throw NetworkException(
          'Search failed. Please try again.',
          debugMessage: data['status'] as String?,
        );
      }
      final predictions = data['predictions'] as List<dynamic>? ?? [];
      final results = <SearchResult>[];
      for (final prediction in predictions.take(5)) {
        final placeId = (prediction as Map<String, dynamic>)['place_id'] as String?;
        if (placeId == null) {
          continue;
        }
        final details = await _fetchDetails(placeId);
        if (details != null) {
          results.add(details);
        }
      }
      return results;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        'Search failed. Check your connection.',
        debugMessage: e.toString(),
      );
    }
  }

  Future<SearchResult?> _fetchDetails(String placeId) async {
    final uri = Uri.parse('$_baseUrl/details/json').replace(
      queryParameters: {
        'place_id': placeId,
        'fields': 'name,formatted_address,geometry',
        'key': apiKey,
      },
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK') {
        return null;
      }
      final result = data['result'] as Map<String, dynamic>;
      final geometry = result['geometry'] as Map<String, dynamic>;
      final location = geometry['location'] as Map<String, dynamic>;
      return SearchResult(
        name: result['name'] as String? ?? 'Unknown',
        latitude: (location['lat'] as num).toDouble(),
        longitude: (location['lng'] as num).toDouble(),
        address: result['formatted_address'] as String?,
        placeId: placeId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SearchResult?> reverseGeocode(double latitude, double longitude) async {
    if (apiKey.isEmpty) {
      return null;
    }

    final uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json',
    ).replace(
      queryParameters: {
        'latlng': '$latitude,$longitude',
        'key': apiKey,
      },
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK') {
        return null;
      }
      final results = data['results'] as List<dynamic>? ?? [];
      if (results.isEmpty) {
        return null;
      }
      final result = results.first as Map<String, dynamic>;
      final geometry = result['geometry'] as Map<String, dynamic>;
      final location = geometry['location'] as Map<String, dynamic>;
      return SearchResult(
        name: result['formatted_address'] as String? ?? 'Dropped pin',
        latitude: (location['lat'] as num).toDouble(),
        longitude: (location['lng'] as num).toDouble(),
        address: result['formatted_address'] as String?,
        placeId: result['place_id'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
