import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/providers/search/nominatim_search_provider.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  late _MockClient client;
  late NominatimSearchProvider provider;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    client = _MockClient();
    provider = NominatimSearchProvider(client: client);
  });

  test('parses Nominatim search results', () async {
    final body = jsonEncode([
      {
        'display_name': 'London, UK',
        'lat': '51.5074',
        'lon': '-0.1278',
        'name': 'London',
      },
    ]);

    when(() => client.get(any(), headers: any(named: 'headers'))).thenAnswer(
      (_) async => http.Response(body, 200),
    );

    final results = await provider.search('London');
    expect(results, hasLength(1));
    expect(results.first.name, 'London');
    expect(results.first.latitude, 51.5074);
    expect(results.first.address, 'London, UK');
  });

  test('returns empty list for blank query', () async {
    final results = await provider.search('   ');
    expect(results, isEmpty);
    verifyNever(() => client.get(any(), headers: any(named: 'headers')));
  });
}
