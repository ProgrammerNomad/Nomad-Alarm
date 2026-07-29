import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nomad_alarm/services/group_travel_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test('group travel bundle roundtrip', () {
    const service = GroupTravelService();
    const json = '''
{"version":1,"type":"nomad_alarm_bundle","alarms":[
{"version":1,"type":"nomad_alarm_config","name":"Integration Stop","destLatitude":48.8,"destLongitude":2.3,"alarmType":0,"triggerDistanceMeters":500,"travelMode":6,"voiceEnabled":true,"vibrationEnabled":true,"flashlightEnabled":false}
]}''';
    final drafts = service.parseBundle(json);
    expect(drafts, hasLength(1));
    expect(drafts.first.name, 'Integration Stop');
  });
}
