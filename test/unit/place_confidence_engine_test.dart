import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/place_confidence_engine.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';

Favorite _place({
  required int id,
  required String name,
  required double lat,
  required double lng,
  int autoStarted = 50,
}) {
  return Favorite.createDefaults(
    name: name,
    latitude: lat,
    longitude: lng,
    category: FavoriteCategory.home,
  )
    ..id = id
    ..autoStartedCount = autoStarted;
}

void main() {
  final engine = PlaceConfidenceEngine();

  test('home scores higher than distant airport with wrong heading', () {
    const userLat = 51.4;
    const userLng = -0.2;
    const homeLat = 51.5;
    const homeLng = -0.1;
    const airportLat = 48.0;
    const airportLng = 2.0;

    final home = engine.score(
      PlaceConfidenceInput(
        place: _place(id: 1, name: 'Home', lat: homeLat, lng: homeLng),
        currentLatitude: userLat,
        currentLongitude: userLng,
        currentHeadingDegrees: 45,
        distanceTraveledMeters: 2000,
        isInVehicle: true,
        isMoving: true,
        insideDestination: false,
        recentlyTriggered: false,
      ),
    );

    final airport = engine.score(
      PlaceConfidenceInput(
        place: _place(id: 2, name: 'Airport', lat: airportLat, lng: airportLng),
        currentLatitude: userLat,
        currentLongitude: userLng,
        currentHeadingDegrees: 45,
        distanceTraveledMeters: 2000,
        isInVehicle: true,
        isMoving: true,
        insideDestination: false,
        recentlyTriggered: false,
      ),
    );

    expect(home.confidencePercent, greaterThan(airport.confidencePercent));
    expect(home.breakdown.length, greaterThan(3));
  });

  test('still or inside destination yields zero confidence', () {
    final inside = engine.score(
      PlaceConfidenceInput(
        place: _place(id: 1, name: 'Home', lat: 51.5, lng: -0.1),
        currentLatitude: 51.5,
        currentLongitude: -0.1,
        currentHeadingDegrees: 0,
        distanceTraveledMeters: 0,
        isInVehicle: false,
        isMoving: false,
        insideDestination: true,
        recentlyTriggered: false,
      ),
    );
    expect(inside.confidencePercent, 0);
    expect(inside.meetsThreshold, isFalse);
  });

  test('recent cooldown yields zero confidence', () {
    final cooled = engine.score(
      PlaceConfidenceInput(
        place: _place(id: 1, name: 'Home', lat: 51.5, lng: -0.1),
        currentLatitude: 51.4,
        currentLongitude: -0.2,
        currentHeadingDegrees: 45,
        distanceTraveledMeters: 2000,
        isInVehicle: true,
        isMoving: true,
        insideDestination: false,
        recentlyTriggered: true,
      ),
    );
    expect(cooled.confidencePercent, 0);
    expect(cooled.meetsThreshold, isFalse);
  });
}
