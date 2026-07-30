import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/language_display.dart';

void main() {
  test('languageEndonym returns native script names', () {
    expect(languageEndonym('en'), 'English');
    expect(languageEndonym('hi'), 'हिन्दी');
    expect(languageEndonym('ar'), 'العربية');
    expect(languageEndonym('he'), 'עברית');
  });

  test('languageEndonym returns code for unknown', () {
    expect(languageEndonym('fr'), 'fr');
  });
}
