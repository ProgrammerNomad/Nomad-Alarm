import 'package:nomad_alarm/models/enums.dart';

/// Portable alarm configuration for share/import (.nomadalarm v1).
class SharedAlarmPayload {
  const SharedAlarmPayload({
    required this.destinationName,
    required this.lat,
    required this.lng,
    required this.triggerDistanceMeters,
    required this.voice,
    required this.vibration,
    required this.flashlight,
    required this.travelMode,
    required this.alarmType,
    this.address,
    this.notes,
    this.version = 1,
  });

  final int version;
  final String destinationName;
  final double lat;
  final double lng;
  final String? address;
  final double triggerDistanceMeters;
  final bool voice;
  final bool vibration;
  final bool flashlight;
  final TravelMode travelMode;
  final AlarmType alarmType;
  final String? notes;
}

enum SharedAlarmParseError {
  corruptedFile,
  missingCoordinates,
  unsupportedVersion,
}

class SharedAlarmParseException implements Exception {
  const SharedAlarmParseException(this.error);

  final SharedAlarmParseError error;
}
