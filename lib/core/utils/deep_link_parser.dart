import 'package:open_location_code/open_location_code.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';

/// Parsed coordinates and optional label from a shared link or URI.
class DeepLinkLocation {
  const DeepLinkLocation({
    required this.latitude,
    required this.longitude,
    this.name,
    this.address,
  });

  final double latitude;
  final double longitude;
  final String? name;
  final String? address;

  DestinationArgs toDestinationArgs() {
    return DestinationArgs(
      name: name ?? address ?? '$latitude, $longitude',
      latitude: latitude,
      longitude: longitude,
      address: address ?? name,
    );
  }
}

/// Parses geo URIs, Google Maps URLs, and raw coordinate strings.
class DeepLinkParser {
  const DeepLinkParser._();

  static DeepLinkLocation? parse(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri != null) {
      if (uri.scheme == 'geo') {
        return _parseGeoUri(uri);
      }
      if (_isMapsHost(uri.host)) {
        return _parseMapsUri(uri);
      }
    }

    return _parseRawCoordinates(trimmed) ?? _parsePlusCode(trimmed);
  }

  /// Plus Codes look like `9C3W+Q8` optionally followed by a city name.
  static DeepLinkLocation? _parsePlusCode(String input) {
    final match = RegExp(
      r'^([23456789CFGHJMPQRVWX]{4,8}\+[23456789CFGHJMPQRVWX]{2,3})(?:\s+(.*))?$',
      caseSensitive: false,
    ).firstMatch(input.trim());
    if (match == null) {
      return null;
    }
    final code = match.group(1)!;
    final label = match.group(2);
    try {
      final area = PlusCode(code).decode();
      return DeepLinkLocation(
        latitude: area.center.latitude,
        longitude: area.center.longitude,
        name: label ?? code,
        address: label != null ? 'Plus Code: $code' : code,
      );
    } catch (_) {
      return DeepLinkLocation(
        latitude: 0,
        longitude: 0,
        name: label ?? code,
        address: 'Plus Code: $code',
      );
    }
  }

  static bool _isMapsHost(String host) {
    return host.contains('google.') && host.contains('maps') ||
        host == 'maps.google.com' ||
        host == 'www.google.com' ||
        host == 'goo.gl';
  }

  static DeepLinkLocation? _parseGeoUri(Uri uri) {
    final path = uri.path;
    final coords = _parseCoordinatePair(path.replaceFirst('/', ''));
    if (coords == null) {
      return null;
    }
    final query = uri.queryParameters['q'] ?? uri.fragment;
    return DeepLinkLocation(
      latitude: coords.$1,
      longitude: coords.$2,
      name: query.isNotEmpty ? Uri.decodeComponent(query) : null,
    );
  }

  static DeepLinkLocation? _parseMapsUri(Uri uri) {
    final q = uri.queryParameters['q'];
    if (q != null) {
      final coords = _parseCoordinatePair(q);
      if (coords != null) {
        return DeepLinkLocation(
          latitude: coords.$1,
          longitude: coords.$2,
        );
      }
      return null;
    }

    final ll = uri.queryParameters['ll'];
    if (ll != null) {
      final coords = _parseCoordinatePair(ll);
      if (coords != null) {
        return DeepLinkLocation(
          latitude: coords.$1,
          longitude: coords.$2,
        );
      }
    }

    // https://www.google.com/maps/@28.6139,77.2090,15z
    final path = uri.path;
    if (path.contains('@')) {
      final atPart = path.split('@').last;
      final coords = _parseCoordinatePair(atPart.split('z').first);
      if (coords != null) {
        return DeepLinkLocation(
          latitude: coords.$1,
          longitude: coords.$2,
        );
      }
    }

    return null;
  }

  static DeepLinkLocation? _parseRawCoordinates(String input) {
    final coords = _parseCoordinatePair(input);
    if (coords == null) {
      return null;
    }
    return DeepLinkLocation(
      latitude: coords.$1,
      longitude: coords.$2,
    );
  }

  static (double, double)? _parseCoordinatePair(String input) {
    final cleaned = input.split('?').first.split(',').take(2).join(',');
    final parts = cleaned.split(',');
    if (parts.length < 2) {
      return null;
    }
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) {
      return null;
    }
    if (lat.abs() > 90 || lng.abs() > 180) {
      return null;
    }
    return (lat, lng);
  }
}
