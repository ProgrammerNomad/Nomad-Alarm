import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';

/// Serializable alarm config for background isolate monitoring.
class AlarmMonitorConfig {
  const AlarmMonitorConfig({
    required this.alarmId,
    required this.name,
    required this.destLatitude,
    required this.destLongitude,
    required this.triggerDistanceMeters,
    this.address,
    this.voiceEnabled = true,
    this.vibrationEnabled = true,
    this.batteryProfile = BatteryProfile.balanced,
  });

  final int alarmId;
  final String name;
  final double destLatitude;
  final double destLongitude;
  final double triggerDistanceMeters;
  final String? address;
  final bool voiceEnabled;
  final bool vibrationEnabled;
  final BatteryProfile batteryProfile;

  factory AlarmMonitorConfig.fromAlarm(
    Alarm alarm, {
    BatteryProfile batteryProfile = BatteryProfile.balanced,
  }) {
    return AlarmMonitorConfig(
      alarmId: alarm.id,
      name: alarm.name,
      destLatitude: alarm.destLatitude,
      destLongitude: alarm.destLongitude,
      triggerDistanceMeters: alarm.triggerDistanceMeters,
      address: alarm.address,
      voiceEnabled: alarm.voiceEnabled,
      vibrationEnabled: alarm.vibrationEnabled,
      batteryProfile: batteryProfile,
    );
  }

  factory AlarmMonitorConfig.fromJson(Map<String, dynamic> json) {
    return AlarmMonitorConfig(
      alarmId: json['alarmId'] as int,
      name: json['name'] as String,
      destLatitude: (json['destLatitude'] as num).toDouble(),
      destLongitude: (json['destLongitude'] as num).toDouble(),
      triggerDistanceMeters: (json['triggerDistanceMeters'] as num).toDouble(),
      address: json['address'] as String?,
      voiceEnabled: json['voiceEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      batteryProfile: json['batteryProfile'] != null
          ? BatteryProfile.values[json['batteryProfile'] as int]
          : BatteryProfile.balanced,
    );
  }

  Map<String, dynamic> toJson() => {
        'alarmId': alarmId,
        'name': name,
        'destLatitude': destLatitude,
        'destLongitude': destLongitude,
        'triggerDistanceMeters': triggerDistanceMeters,
        'address': address,
        'voiceEnabled': voiceEnabled,
        'vibrationEnabled': vibrationEnabled,
        'batteryProfile': batteryProfile.index,
      };
}
