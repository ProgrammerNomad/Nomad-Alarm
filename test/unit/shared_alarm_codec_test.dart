import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/shared_alarm_payload.dart';
import 'package:nomad_alarm/services/shared_alarm_codec.dart';

void main() {
  const sample = SharedAlarmPayload(
    destinationName: 'Noida Railway Station',
    lat: 28.5355,
    lng: 77.3910,
    address: 'Sector 18',
    triggerDistanceMeters: 500,
    voice: true,
    vibration: true,
    flashlight: false,
    travelMode: TravelMode.metro,
    alarmType: AlarmType.distance,
    notes: 'Get off here.',
  );

  test('encode/decode roundtrip preserves v1 payload', () {
    final raw = SharedAlarmCodec.encode(sample);
    final decoded = SharedAlarmCodec.decode(raw);

    expect(decoded.destinationName, sample.destinationName);
    expect(decoded.lat, sample.lat);
    expect(decoded.lng, sample.lng);
    expect(decoded.address, sample.address);
    expect(decoded.triggerDistanceMeters, sample.triggerDistanceMeters);
    expect(decoded.voice, sample.voice);
    expect(decoded.vibration, sample.vibration);
    expect(decoded.flashlight, sample.flashlight);
    expect(decoded.travelMode, sample.travelMode);
    expect(decoded.alarmType, sample.alarmType);
    expect(decoded.notes, sample.notes);

    final map = jsonDecode(raw) as Map<String, dynamic>;
    expect(map['version'], 1);
    expect(map['type'], 'nomad_alarm');
    expect(map.containsKey('currentLocation'), isFalse);
    expect(map.containsKey('history'), isFalse);
    expect(map.containsKey('apiKeys'), isFalse);
  });

  test('decode legacy nomad_alarm_config format', () {
    const legacy = '''
{
  "type": "nomad_alarm_config",
  "name": "Legacy Stop",
  "destLatitude": 12.34,
  "destLongitude": 56.78,
  "triggerDistanceMeters": 300,
  "voiceEnabled": false,
  "vibrationEnabled": true,
  "flashlightEnabled": true
}
''';
    final decoded = SharedAlarmCodec.decode(legacy);
    expect(decoded.destinationName, 'Legacy Stop');
    expect(decoded.lat, 12.34);
    expect(decoded.lng, 56.78);
    expect(decoded.triggerDistanceMeters, 300);
    expect(decoded.voice, isFalse);
    expect(decoded.vibration, isTrue);
    expect(decoded.flashlight, isTrue);
  });

  test('decodeBundle handles nomad_alarm_bundle', () {
    const bundle = '''
{
  "type": "nomad_alarm_bundle",
  "alarms": [
    {
      "type": "nomad_alarm_config",
      "name": "A",
      "destLatitude": 1,
      "destLongitude": 2
    },
    {
      "type": "nomad_alarm_config",
      "name": "B",
      "destLatitude": 3,
      "destLongitude": 4
    }
  ]
}
''';
    final items = SharedAlarmCodec.decodeBundle(bundle);
    expect(items, hasLength(2));
    expect(items.first.destinationName, 'A');
    expect(items.last.destinationName, 'B');
  });

  test('missing coordinates throws missingCoordinates', () {
    const raw = '{"version":1,"type":"nomad_alarm","destination":{"name":"X"}}';
    expect(
      () => SharedAlarmCodec.decode(raw),
      throwsA(
        isA<SharedAlarmParseException>().having(
          (e) => e.error,
          'error',
          SharedAlarmParseError.missingCoordinates,
        ),
      ),
    );
  });

  test('unsupported version throws unsupportedVersion', () {
    const raw = '''
{
  "version": 99,
  "type": "nomad_alarm",
  "destination": {"name": "X", "lat": 1, "lng": 2},
  "alarm": {}
}
''';
    expect(
      () => SharedAlarmCodec.decode(raw),
      throwsA(
        isA<SharedAlarmParseException>().having(
          (e) => e.error,
          'error',
          SharedAlarmParseError.unsupportedVersion,
        ),
      ),
    );
  });

  test('slugFileName produces safe .nomadalarm filename', () {
    expect(
      SharedAlarmCodec.slugFileName('Noida Railway Station!'),
      'noida_railway_station.nomadalarm',
    );
  });
}
