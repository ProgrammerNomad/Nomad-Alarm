import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';

void main() {
  test('direct map iteration throws when map is mutated mid-loop', () {
    final map = {1: 'a', 2: 'b'};

    expect(
      () {
        for (final value in map.values) {
          if (value == 'a') {
            map.remove(2);
          }
        }
      },
      throwsConcurrentModificationError,
    );
  });

  test('snapshotMonitorValues allows safe iteration after map mutation', () {
    final map = {1: 'a', 2: 'b'};
    final seen = <String>[];

    for (final value in snapshotMonitorValues(map)) {
      seen.add(value);
      if (value == 'a') {
        map.remove(2);
      }
    }

    expect(seen, ['a', 'b']);
    expect(map, {1: 'a'});
  });
}
