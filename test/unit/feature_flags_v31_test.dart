import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';

void main() {
  test('voiceSearch flag enabled', () {
    expect(FeatureFlags.voiceSearch, isTrue);
  });

  test('familySharing flag enabled', () {
    expect(FeatureFlags.familySharing, isTrue);
  });
}
