import 'dart:convert';

import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/shared_alarm_payload.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';

/// Encode/decode `.nomadalarm` v1 JSON with legacy `nomad_alarm_config` support.
class SharedAlarmCodec {
  const SharedAlarmCodec._();

  static const supportedVersions = {1};

  static SharedAlarmPayload decode(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const SharedAlarmParseException(SharedAlarmParseError.corruptedFile);
    }
    try {
      final map = jsonDecode(trimmed) as Map<String, dynamic>;
      return _fromMap(map);
    } on SharedAlarmParseException {
      rethrow;
    } catch (_) {
      throw const SharedAlarmParseException(SharedAlarmParseError.corruptedFile);
    }
  }

  static List<SharedAlarmPayload> decodeBundle(String raw) {
    final trimmed = raw.trim();
    try {
      final map = jsonDecode(trimmed) as Map<String, dynamic>;
      if (map['type'] == 'nomad_alarm_bundle') {
        final items = map['alarms'] as List<dynamic>? ?? [];
        return items
            .map((e) => _fromLegacyConfigMap(e as Map<String, dynamic>))
            .toList();
      }
      return [decode(trimmed)];
    } on SharedAlarmParseException {
      rethrow;
    } catch (_) {
      throw const SharedAlarmParseException(SharedAlarmParseError.corruptedFile);
    }
  }

  static String encode(SharedAlarmPayload payload) {
    return jsonEncode(_toMap(payload));
  }

  static SharedAlarmPayload fromAlarm(Alarm alarm, {String? notes}) {
    return SharedAlarmPayload(
      destinationName: alarm.name,
      lat: alarm.destLatitude,
      lng: alarm.destLongitude,
      address: alarm.address,
      triggerDistanceMeters: alarm.triggerDistanceMeters,
      voice: alarm.voiceEnabled,
      vibration: alarm.vibrationEnabled,
      flashlight: alarm.flashlightEnabled,
      travelMode: alarm.travelMode,
      alarmType: alarm.type,
      notes: notes,
    );
  }

  static SharedAlarmPayload fromDraft(AlarmDraft draft, {String? notes}) {
    return SharedAlarmPayload(
      destinationName: draft.name,
      lat: draft.destLatitude,
      lng: draft.destLongitude,
      address: draft.address,
      triggerDistanceMeters: draft.triggerDistanceMeters,
      voice: draft.voiceEnabled,
      vibration: draft.vibrationEnabled,
      flashlight: draft.flashlightEnabled,
      travelMode: draft.travelMode,
      alarmType: draft.type,
      notes: notes ?? draft.notes,
    );
  }

  static AlarmDraft toDraft(SharedAlarmPayload payload) {
    return AlarmDraft(
      name: payload.destinationName,
      destLatitude: payload.lat,
      destLongitude: payload.lng,
      address: payload.address,
      triggerDistanceMeters: payload.triggerDistanceMeters,
      voiceEnabled: payload.voice,
      vibrationEnabled: payload.vibration,
      flashlightEnabled: payload.flashlight,
      travelMode: payload.travelMode,
      type: payload.alarmType,
      notes: payload.notes,
    );
  }

  static String slugFileName(String name) {
    final slug = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return '${slug.isEmpty ? 'alarm' : slug}.nomadalarm';
  }

  static Map<String, dynamic> _toMap(SharedAlarmPayload payload) {
    return {
      'version': payload.version,
      'type': 'nomad_alarm',
      'destination': {
        'name': payload.destinationName,
        'lat': payload.lat,
        'lng': payload.lng,
        if (payload.address != null) 'address': payload.address,
      },
      'alarm': {
        'radiusMeters': payload.triggerDistanceMeters,
        'voice': payload.voice,
        'vibration': payload.vibration,
        'flashlight': payload.flashlight,
        'travelMode': payload.travelMode.index,
        'alarmType': payload.alarmType.index,
      },
      if (payload.notes != null && payload.notes!.isNotEmpty)
        'notes': payload.notes,
    };
  }

  static SharedAlarmPayload _fromMap(Map<String, dynamic> map) {
    if (map['type'] == 'nomad_alarm_config') {
      return _fromLegacyConfigMap(map);
    }
    if (map['type'] == 'nomad_alarm_bundle') {
      final items = map['alarms'] as List<dynamic>? ?? [];
      if (items.isEmpty) {
        throw const SharedAlarmParseException(
          SharedAlarmParseError.corruptedFile,
        );
      }
      return _fromLegacyConfigMap(items.first as Map<String, dynamic>);
    }

    final version = map['version'] as int? ?? 1;
    if (!supportedVersions.contains(version)) {
      throw const SharedAlarmParseException(
        SharedAlarmParseError.unsupportedVersion,
      );
    }

    final dest = map['destination'] as Map<String, dynamic>?;
    if (dest == null) {
      throw const SharedAlarmParseException(
        SharedAlarmParseError.missingCoordinates,
      );
    }

    final lat = (dest['lat'] as num?)?.toDouble();
    final lng = (dest['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) {
      throw const SharedAlarmParseException(
        SharedAlarmParseError.missingCoordinates,
      );
    }

    final alarm = map['alarm'] as Map<String, dynamic>? ?? {};
    return SharedAlarmPayload(
      version: version,
      destinationName: dest['name'] as String? ?? 'Imported alarm',
      lat: lat,
      lng: lng,
      address: dest['address'] as String?,
      triggerDistanceMeters:
          (alarm['radiusMeters'] as num?)?.toDouble() ?? 500,
      voice: alarm['voice'] as bool? ?? true,
      vibration: alarm['vibration'] as bool? ?? true,
      flashlight: alarm['flashlight'] as bool? ?? false,
      travelMode: TravelMode.values[alarm['travelMode'] as int? ?? 6],
      alarmType: AlarmType.values[alarm['alarmType'] as int? ?? 0],
      notes: map['notes'] as String?,
    );
  }

  static SharedAlarmPayload _fromLegacyConfigMap(Map<String, dynamic> map) {
    final lat = (map['destLatitude'] as num?)?.toDouble();
    final lng = (map['destLongitude'] as num?)?.toDouble();
    if (lat == null || lng == null) {
      throw const SharedAlarmParseException(
        SharedAlarmParseError.missingCoordinates,
      );
    }
    return SharedAlarmPayload(
      destinationName: map['name'] as String? ?? 'Imported alarm',
      lat: lat,
      lng: lng,
      address: map['address'] as String?,
      triggerDistanceMeters:
          (map['triggerDistanceMeters'] as num?)?.toDouble() ?? 500,
      voice: map['voiceEnabled'] as bool? ?? true,
      vibration: map['vibrationEnabled'] as bool? ?? true,
      flashlight: map['flashlightEnabled'] as bool? ?? false,
      travelMode: TravelMode.values[map['travelMode'] as int? ?? 6],
      alarmType: AlarmType.values[map['alarmType'] as int? ?? 0],
    );
  }
}
