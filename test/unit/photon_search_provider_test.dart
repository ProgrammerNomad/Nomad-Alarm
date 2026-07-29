import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/providers/search/photon_search_provider.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  late _MockClient client;
  late PhotonSearchProvider provider;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    client = _MockClient();
    provider = PhotonSearchProvider(client: client);
  });

  test('parses Photon GeoJSON features', () async {
    final body = jsonEncode({
      'features': [
        {
          'geometry': {'coordinates': [-0.1278, 51.5074]},
          'properties': {
            'name': 'London',
            'city': 'London',
            'country': 'United Kingdom',
          },
        },
      ],
    });

    when(() => client.get(any())).thenAnswer(
      (_) async => http.Response(body, 200),
    );

    final results = await provider.search('London');
    expect(results, hasLength(1));
    expect(results.first.name, 'London');
    expect(results.first.latitude, 51.5074);
    expect(results.first.longitude, -0.1278);
  });
}
