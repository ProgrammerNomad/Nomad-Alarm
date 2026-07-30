import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/services/api_key_store.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage storage;
  late ApiKeyStore store;

  setUp(() {
    storage = _MockSecureStorage();
    store = ApiKeyStore(storage: storage);
  });

  test('read returns stored value', () async {
    when(
      () => storage.read(
        key: any(named: 'key'),
        aOptions: any(named: 'aOptions'),
      ),
    ).thenAnswer((invocation) async {
      final key = invocation.namedArguments[#key] as String;
      if (key == ApiKeyId.mapboxToken.storageKey) {
        return 'pk.test';
      }
      return null;
    });

    expect(await store.read(ApiKeyId.mapboxToken), 'pk.test');
  });

  test('write clears key when value is empty', () async {
    when(
      () => storage.delete(
        key: any(named: 'key'),
        aOptions: any(named: 'aOptions'),
      ),
    ).thenAnswer((_) async {});

    await store.write(ApiKeyId.googlePlaces, '   ');

    verify(
      () => storage.delete(
        key: ApiKeyId.googlePlaces.storageKey,
        aOptions: any(named: 'aOptions'),
      ),
    ).called(1);
  });

  test('readAll returns map for every key id', () async {
    when(
      () => storage.read(
        key: any(named: 'key'),
        aOptions: any(named: 'aOptions'),
      ),
    ).thenAnswer((_) async => null);

    final all = await store.readAll();
    expect(all.keys, containsAll(ApiKeyId.values));
  });

  test('writeGoogleApiKey writes to all Google slots', () async {
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
        aOptions: any(named: 'aOptions'),
      ),
    ).thenAnswer((_) async {});

    await store.writeGoogleApiKey('AIza.test-key');

    for (final id in ApiKeyId.googleSlots) {
      verify(
        () => storage.write(
          key: id.storageKey,
          value: 'AIza.test-key',
          aOptions: any(named: 'aOptions'),
        ),
      ).called(1);
    }
  });

  test('readGoogleApiKey returns first non-empty slot', () async {
    when(
      () => storage.read(
        key: any(named: 'key'),
        aOptions: any(named: 'aOptions'),
      ),
    ).thenAnswer((invocation) async {
      final key = invocation.namedArguments[#key] as String;
      if (key == ApiKeyId.googlePlaces.storageKey) {
        return 'AIza.from-places';
      }
      return null;
    });

    expect(await store.readGoogleApiKey(), 'AIza.from-places');
  });

  test('testGoogleApiKeyStatus returns all false when no key', () async {
    when(
      () => storage.read(
        key: any(named: 'key'),
        aOptions: any(named: 'aOptions'),
      ),
    ).thenAnswer((_) async => null);

    final status = await store.testGoogleApiKeyStatus();
    expect(status.maps, isFalse);
    expect(status.places, isFalse);
    expect(status.directions, isFalse);
    expect(status.allPassed, isFalse);
  });
}
