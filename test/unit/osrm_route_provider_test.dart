import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/providers/route/osrm_route_provider.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  late _MockClient client;
  late OsrmRouteProvider provider;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    client = _MockClient();
    provider = OsrmRouteProvider(client: client);
  });

  test('parses OSRM route response', () async {
    final body = jsonEncode({
      'code': 'Ok',
      'routes': [
        {
          'distance': 1200.5,
          'duration': 180.7,
          'geometry': {
            'coordinates': [
              [-0.1, 51.5],
              [-0.11, 51.51],
            ],
          },
        },
      ],
    });

    when(() => client.get(any())).thenAnswer(
      (_) async => http.Response(body, 200),
    );

    final result = await provider.route(
      from: const LatLng(51.5, -0.1),
      to: const LatLng(51.51, -0.11),
    );

    expect(result, isNotNull);
    expect(result!.distanceMeters, 1200.5);
    expect(result.durationSeconds, 181);
    expect(result.points, hasLength(2));
    expect(result.points.first.latitude, 51.5);
    expect(result.storablePolyline, contains('51.5'));
  });

  test('returns null when OSRM has no routes', () async {
    when(() => client.get(any())).thenAnswer(
      (_) async => http.Response(jsonEncode({'code': 'Ok', 'routes': []}), 200),
    );

    final result = await provider.route(
      from: const LatLng(51.5, -0.1),
      to: const LatLng(51.51, -0.11),
    );
    expect(result, isNull);
  });
}
