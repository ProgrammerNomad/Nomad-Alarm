import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum ApiKeyId {
  googleMaps('google_maps'),
  googlePlaces('google_places'),
  googleDirections('google_directions'),
  mapboxToken('mapbox_token'),
  hereApiKey('here_api_key'),
  graphhopperKey('graphhopper_key');

  const ApiKeyId(this.storageKey);
  final String storageKey;
}

class ApiKeyStore {
  ApiKeyStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _storageOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  final FlutterSecureStorage _storage;

  Future<String?> read(ApiKeyId id) async {
    return _storage.read(key: id.storageKey, aOptions: _storageOptions);
  }

  Future<void> write(ApiKeyId id, String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      await clear(id);
      return;
    }
    await _storage.write(
      key: id.storageKey,
      value: trimmed,
      aOptions: _storageOptions,
    );
  }

  Future<void> clear(ApiKeyId id) async {
    await _storage.delete(key: id.storageKey, aOptions: _storageOptions);
  }

  Future<void> clearAll() async {
    for (final id in ApiKeyId.values) {
      await clear(id);
    }
  }

  Future<Map<ApiKeyId, String?>> readAll() async {
    final map = <ApiKeyId, String?>{};
    for (final id in ApiKeyId.values) {
      map[id] = await read(id);
    }
    return map;
  }

  /// Lightweight connectivity check per provider family.
  Future<bool> testConnection(ApiKeyId id, {http.Client? client}) async {
    final key = await read(id);
    if (key == null || key.isEmpty) {
      return false;
    }
    final c = client ?? http.Client();
    final ownsClient = client == null;
    try {
      switch (id) {
        case ApiKeyId.googleMaps:
        case ApiKeyId.googlePlaces:
        case ApiKeyId.googleDirections:
          final uri = Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json',
          ).replace(queryParameters: {'address': 'London', 'key': key});
          final response = await c.get(uri);
          if (response.statusCode != 200) {
            return false;
          }
          return !response.body.contains('"error_message"');
        case ApiKeyId.mapboxToken:
          final uri = Uri.parse(
            'https://api.mapbox.com/geocoding/v5/mapbox.places/london.json',
          ).replace(queryParameters: {'access_token': key, 'limit': '1'});
          final response = await c.get(uri);
          return response.statusCode == 200;
        case ApiKeyId.hereApiKey:
          final uri = Uri.parse('https://geocode.search.hereapi.com/v1/geocode')
              .replace(queryParameters: {'q': 'London', 'apiKey': key, 'limit': '1'});
          final response = await c.get(uri);
          return response.statusCode == 200;
        case ApiKeyId.graphhopperKey:
          final uri = Uri.parse('https://graphhopper.com/api/1/info')
              .replace(queryParameters: {'key': key});
          final response = await c.get(uri);
          return response.statusCode == 200;
      }
    } catch (_) {
      return false;
    } finally {
      if (ownsClient) {
        c.close();
      }
    }
  }
}
