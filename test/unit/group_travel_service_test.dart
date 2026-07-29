import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/services/group_travel_service.dart';

void main() {
  const service = GroupTravelService();

  test('export and parse roundtrip', () {
    final alarm = Alarm()
      ..name = 'Station'
      ..destLatitude = 51.5
      ..destLongitude = -0.1
      ..type = AlarmType.distance
      ..triggerDistanceMeters = 500
      ..travelMode = TravelMode.train
      ..voiceEnabled = true
      ..vibrationEnabled = true
      ..flashlightEnabled = false;

    final exported = service.exportAlarm(alarm);
    final draft = service.parseImport(
      '{"version":1,"type":"nomad_alarm_config",'
      '"name":"Station","destLatitude":51.5,"destLongitude":-0.1,'
      '"alarmType":0,"triggerDistanceMeters":500,"travelMode":0,'
      '"voiceEnabled":true,"vibrationEnabled":true,"flashlightEnabled":false}',
    );
    expect(exported['name'], 'Station');
    expect(draft?.name, 'Station');
    expect(draft?.travelMode, TravelMode.train);
  });
}
