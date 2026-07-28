import 'package:nomad_alarm/models/enums.dart';

class AlarmRuntimeState {
  const AlarmRuntimeState({
    required this.alarmId,
    required this.destinationName,
    required this.distanceMeters,
    required this.speedKmh,
    required this.accuracyMeters,
    required this.lastFixAt,
    required this.isGpsLost,
    required this.hasPassedDestination,
    required this.status,
    this.address,
    this.destLatitude,
    this.destLongitude,
  });

  final int alarmId;
  final String destinationName;
  final String? address;
  final double? destLatitude;
  final double? destLongitude;
  final double distanceMeters;
  final double speedKmh;
  final double accuracyMeters;
  final DateTime lastFixAt;
  final bool isGpsLost;
  final bool hasPassedDestination;
  final AlarmStatus status;

  AlarmRuntimeState copyWith({
    double? distanceMeters,
    double? speedKmh,
    double? accuracyMeters,
    DateTime? lastFixAt,
    bool? isGpsLost,
    bool? hasPassedDestination,
    AlarmStatus? status,
  }) {
    return AlarmRuntimeState(
      alarmId: alarmId,
      destinationName: destinationName,
      address: address,
      destLatitude: destLatitude,
      destLongitude: destLongitude,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      speedKmh: speedKmh ?? this.speedKmh,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      lastFixAt: lastFixAt ?? this.lastFixAt,
      isGpsLost: isGpsLost ?? this.isGpsLost,
      hasPassedDestination:
          hasPassedDestination ?? this.hasPassedDestination,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'alarmId': alarmId,
        'destinationName': destinationName,
        'address': address,
        'destLatitude': destLatitude,
        'destLongitude': destLongitude,
        'distanceMeters': distanceMeters,
        'speedKmh': speedKmh,
        'accuracyMeters': accuracyMeters,
        'lastFixAt': lastFixAt.toIso8601String(),
        'isGpsLost': isGpsLost,
        'hasPassedDestination': hasPassedDestination,
        'status': status.index,
      };

  factory AlarmRuntimeState.fromJson(Map<String, dynamic> json) {
    return AlarmRuntimeState(
      alarmId: json['alarmId'] as int,
      destinationName: json['destinationName'] as String,
      address: json['address'] as String?,
      destLatitude: (json['destLatitude'] as num?)?.toDouble(),
      destLongitude: (json['destLongitude'] as num?)?.toDouble(),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      speedKmh: (json['speedKmh'] as num).toDouble(),
      accuracyMeters: (json['accuracyMeters'] as num).toDouble(),
      lastFixAt: DateTime.parse(json['lastFixAt'] as String),
      isGpsLost: json['isGpsLost'] as bool,
      hasPassedDestination: json['hasPassedDestination'] as bool,
      status: AlarmStatus.values[json['status'] as int],
    );
  }
}
