import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/services/group_travel_service.dart';

Alarm _alarm() {
  return Alarm()
    ..id = 1
    ..name = 'Stop A'
    ..destLatitude = 51.5
    ..destLongitude = -0.1
    ..type = AlarmType.distance
    ..triggerDistanceMeters = 500
    ..travelMode = TravelMode.train
    ..repeat = false
    ..voiceEnabled = true
    ..vibrationEnabled = true
    ..flashlightEnabled = false
    ..status = AlarmStatus.active
    ..createdAt = DateTime.utc(2024, 1, 1)
    ..updatedAt = DateTime.utc(2024, 1, 1);
}

void main() {
  test('export and parse alarm bundle', () {
    const service = GroupTravelService();
    final json = jsonEncode(service.exportBundle([_alarm(), _alarm()]));
    final drafts = service.parseBundle(json);
    expect(drafts, hasLength(2));
    expect(drafts.first.name, 'Stop A');
  });
}
