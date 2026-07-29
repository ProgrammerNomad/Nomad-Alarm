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
    this.alarmType = AlarmType.distance,
    this.radiusMeters,
    this.speedThresholdKmh,
    this.travelMode = TravelMode.autoDetect,
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
  final AlarmType alarmType;
  final double? radiusMeters;
  final double? speedThresholdKmh;
  final TravelMode travelMode;

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
      alarmType: alarm.type,
      radiusMeters: alarm.radiusMeters,
      speedThresholdKmh: alarm.speedThresholdKmh,
      travelMode: alarm.travelMode,
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
      alarmType: json['alarmType'] != null
          ? AlarmType.values[json['alarmType'] as int]
          : AlarmType.distance,
      radiusMeters: (json['radiusMeters'] as num?)?.toDouble(),
      speedThresholdKmh: (json['speedThresholdKmh'] as num?)?.toDouble(),
      travelMode: json['travelMode'] != null
          ? TravelMode.values[json['travelMode'] as int]
          : TravelMode.autoDetect,
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
        'alarmType': alarmType.index,
        'radiusMeters': radiusMeters,
        'speedThresholdKmh': speedThresholdKmh,
        'travelMode': travelMode.index,
      };

  double get effectiveRadiusMeters =>
      radiusMeters ?? triggerDistanceMeters;
}
