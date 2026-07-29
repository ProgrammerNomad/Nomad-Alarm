import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/services/group_travel_service.dart';

void main() {
  test('parseImport accepts bundle and returns first draft', () {
    const service = GroupTravelService();
    const json = '''
{"version":1,"type":"nomad_alarm_bundle","alarms":[
{"version":1,"type":"nomad_alarm_config","name":"Bundle Stop","destLatitude":51.5,"destLongitude":-0.1,"alarmType":0,"triggerDistanceMeters":500,"travelMode":6,"voiceEnabled":true,"vibrationEnabled":true,"flashlightEnabled":false}
]}''';
    final parsed = service.parseImport(json);
    expect(parsed, isNotNull);
    expect(parsed!.name, 'Bundle Stop');
  });
}
