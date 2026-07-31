import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/smart_place_confirmation_buffer.dart';

void main() {
  test('requires three consecutive ticks for the same place', () {
    final buffer = SmartPlaceConfirmationBuffer();

    expect(buffer.recordLeadingPlace(1), isFalse);
    expect(buffer.ticks, 1);

    expect(buffer.recordLeadingPlace(1), isFalse);
    expect(buffer.ticks, 2);

    expect(buffer.recordLeadingPlace(1), isTrue);
    expect(buffer.ticks, 3);
  });

  test('resets when leading place changes', () {
    final buffer = SmartPlaceConfirmationBuffer();

    expect(buffer.recordLeadingPlace(1), isFalse);
    expect(buffer.recordLeadingPlace(1), isFalse);

    expect(buffer.recordLeadingPlace(2), isFalse);
    expect(buffer.placeId, 2);
    expect(buffer.ticks, 1);
  });

  test('reset clears state', () {
    final buffer = SmartPlaceConfirmationBuffer()
      ..recordLeadingPlace(1)
      ..recordLeadingPlace(1);

    buffer.reset();

    expect(buffer.placeId, isNull);
    expect(buffer.ticks, 0);
  });
}
