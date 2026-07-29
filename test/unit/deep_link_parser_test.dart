import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/deep_link_parser.dart';

void main() {
  group('DeepLinkParser', () {
    test('parse_google_maps_url with q coordinates', () {
      final result = DeepLinkParser.parse(
        'https://maps.google.com/?q=28.6139,77.2090',
      );
      expect(result, isNotNull);
      expect(result!.latitude, closeTo(28.6139, 0.0001));
      expect(result.longitude, closeTo(77.2090, 0.0001));
    });

    test('parse_google_maps_url with at path', () {
      final result = DeepLinkParser.parse(
        'https://www.google.com/maps/@28.6139,77.2090,15z',
      );
      expect(result, isNotNull);
      expect(result!.latitude, closeTo(28.6139, 0.0001));
      expect(result.longitude, closeTo(77.2090, 0.0001));
    });

    test('parse_geo_uri with label', () {
      final result = DeepLinkParser.parse('geo:28.6139,77.2090?q=New%20Delhi');
      expect(result, isNotNull);
      expect(result!.latitude, closeTo(28.6139, 0.0001));
      expect(result.longitude, closeTo(77.2090, 0.0001));
      expect(result.name, 'New Delhi');
    });

    test('parse_raw_coordinates', () {
      final result = DeepLinkParser.parse('28.6139, 77.2090');
      expect(result, isNotNull);
      expect(result!.latitude, closeTo(28.6139, 0.0001));
      expect(result.longitude, closeTo(77.2090, 0.0001));
    });

    test('returns null for invalid input', () {
      expect(DeepLinkParser.parse(''), isNull);
      expect(DeepLinkParser.parse('not a location'), isNull);
      expect(DeepLinkParser.parse('geo:999,999'), isNull);
    });
  });
}
