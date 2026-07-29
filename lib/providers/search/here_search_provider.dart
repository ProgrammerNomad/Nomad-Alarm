import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/search/search_provider.dart';

class HereSearchProvider implements SearchProvider {
  HereSearchProvider({
    required this.apiKey,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  static const _autocompleteUrl =
      'https://autocomplete.search.hereapi.com/v1/autocomplete';
  static const _revGeocodeUrl =
      'https://revgeocode.search.hereapi.com/v1/revgeocode';

  final String apiKey;
  final http.Client _client;
  final bool _ownsClient;

  @override
  SearchProviderType get type => SearchProviderType.here;

  @override
  Future<List<SearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return [];
    }
    if (apiKey.isEmpty) {
      throw const NetworkException('HERE API key is not configured.');
    }

    final uri = Uri.parse(_autocompleteUrl).replace(
      queryParameters: {
        'q': trimmed,
        'apiKey': apiKey,
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
      final items = data['items'] as List<dynamic>? ?? [];
      return items.map(_parseItem).toList();
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
    if (apiKey.isEmpty) {
      return null;
    }

    final uri = Uri.parse(_revGeocodeUrl).replace(
      queryParameters: {
        'at': '$latitude,$longitude',
        'apiKey': apiKey,
        'limit': '1',
      },
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>? ?? [];
      if (items.isEmpty) {
        return null;
      }
      return _parseItem(items.first);
    } catch (_) {
      return null;
    }
  }

  SearchResult _parseItem(dynamic item) {
    final map = item as Map<String, dynamic>;
    final position = map['position'] as Map<String, dynamic>;
    final address = map['address'] as Map<String, dynamic>?;
    final label = address?['label'] as String?;
    final title = map['title'] as String? ?? label ?? 'Unknown';
    return SearchResult(
      name: title,
      latitude: (position['lat'] as num).toDouble(),
      longitude: (position['lng'] as num).toDouble(),
      address: label,
      placeId: map['id'] as String?,
    );
  }

  @override
  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
