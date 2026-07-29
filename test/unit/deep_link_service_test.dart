import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/services/deep_link_service.dart';

void main() {
  group('DeepLinkService', () {
    test('parse returns destination from raw coordinates', () {
      final result = DeepLinkService.parse('28.6139, 77.2090');
      expect(result, isNotNull);
      expect(result!.latitude, closeTo(28.6139, 0.0001));
      expect(result.longitude, closeTo(77.2090, 0.0001));
    });

    test('parse returns null for invalid input', () {
      expect(DeepLinkService.parse('not a location'), isNull);
    });

    test('consumePendingDestination returns null when no pending URI', () {
      expect(DeepLinkService.consumePendingDestination(), isNull);
    });
  });
}
