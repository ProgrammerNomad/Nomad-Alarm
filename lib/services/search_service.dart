import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/search_result.dart';

class SearchService {
  SearchService({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl = 'https://nominatim.openstreetmap.org';
  static const _userAgent = 'NomadAlarm/1.0 (com.nomad.alarm)';

  final http.Client _client;
  DateTime? _lastRequestAt;

  Future<void> _throttle() async {
    if (_lastRequestAt == null) {
      return;
    }
    final elapsed = DateTime.now().difference(_lastRequestAt!);
    if (elapsed.inMilliseconds < 1000) {
      await Future<void>.delayed(Duration(milliseconds: 1000 - elapsed.inMilliseconds));
    }
  }

  Future<List<SearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return [];
    }

    await _throttle();
    _lastRequestAt = DateTime.now();

    final uri = Uri.parse('$_baseUrl/search').replace(
      queryParameters: {
        'q': trimmed,
        'format': 'json',
        'addressdetails': '1',
        'limit': '10',
      },
    );

    try {
      final response = await _client.get(
        uri,
        headers: {'User-Agent': _userAgent},
      );
      if (response.statusCode != 200) {
        throw NetworkException(
          'Search failed. Please try again.',
          debugMessage: 'HTTP ${response.statusCode}',
        );
      }
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map(_parseResult).toList();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        'Search failed. Check your connection.',
        debugMessage: e.toString(),
      );
    }
  }

  Future<SearchResult?> reverseGeocode(double latitude, double longitude) async {
    await _throttle();
    _lastRequestAt = DateTime.now();

    final uri = Uri.parse('$_baseUrl/reverse').replace(
      queryParameters: {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'format': 'json',
        'addressdetails': '1',
      },
    );

    try {
      final response = await _client.get(
        uri,
        headers: {'User-Agent': _userAgent},
      );
      if (response.statusCode != 200) {
        return null;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return _parseReverseResult(data, latitude, longitude);
    } catch (_) {
      return null;
    }
  }

  SearchResult _parseResult(dynamic item) {
    final map = item as Map<String, dynamic>;
    final lat = double.parse(map['lat'] as String);
    final lon = double.parse(map['lon'] as String);
    final name = map['name'] as String? ?? map['display_name'] as String? ?? 'Unknown';
    return SearchResult(
      name: name,
      latitude: lat,
      longitude: lon,
      address: map['display_name'] as String?,
      placeId: map['place_id']?.toString(),
    );
  }

  SearchResult _parseReverseResult(
    Map<String, dynamic> map,
    double latitude,
    double longitude,
  ) {
    final name = map['name'] as String? ??
        map['display_name'] as String? ??
        'Dropped pin';
    return SearchResult(
      name: name,
      latitude: latitude,
      longitude: longitude,
      address: map['display_name'] as String?,
      placeId: map['place_id']?.toString(),
    );
  }

  void dispose() {
    _client.close();
  }
}
