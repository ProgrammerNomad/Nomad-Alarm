import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:share_plus/share_plus.dart';

/// Local share/import of alarm configuration for group travel.
class GroupTravelService {
  const GroupTravelService();

  Map<String, dynamic> exportDraft(AlarmDraft draft) {
    return {
      'version': 1,
      'type': 'nomad_alarm_config',
      'name': draft.name,
      'destLatitude': draft.destLatitude,
      'destLongitude': draft.destLongitude,
      'address': draft.address,
      'alarmType': draft.type.index,
      'triggerDistanceMeters': draft.triggerDistanceMeters,
      'speedThresholdKmh': draft.speedThresholdKmh,
      'travelMode': draft.travelMode.index,
      'voiceEnabled': draft.voiceEnabled,
      'vibrationEnabled': draft.vibrationEnabled,
      'flashlightEnabled': draft.flashlightEnabled,
      'ringtoneUri': draft.ringtoneUri,
    };
  }

  Map<String, dynamic> exportAlarm(Alarm alarm) {
    return {
      'version': 1,
      'type': 'nomad_alarm_config',
      'name': alarm.name,
      'destLatitude': alarm.destLatitude,
      'destLongitude': alarm.destLongitude,
      'address': alarm.address,
      'alarmType': alarm.type.index,
      'triggerDistanceMeters': alarm.triggerDistanceMeters,
      'radiusMeters': alarm.radiusMeters,
      'speedThresholdKmh': alarm.speedThresholdKmh,
      'travelMode': alarm.travelMode.index,
      'voiceEnabled': alarm.voiceEnabled,
      'vibrationEnabled': alarm.vibrationEnabled,
      'flashlightEnabled': alarm.flashlightEnabled,
      'ringtoneUri': alarm.ringtoneUri,
    };
  }

  Map<String, dynamic> exportBundle(List<Alarm> alarms) {
    return {
      'version': 1,
      'type': 'nomad_alarm_bundle',
      'alarms': alarms.map(exportAlarm).toList(),
    };
  }

  Future<void> shareAlarm(Alarm alarm) async {
    if (!FeatureFlags.groupTravel) {
      return;
    }
    final json = jsonEncode(exportAlarm(alarm));
    await Share.share(json, subject: alarm.name);
  }

  Future<void> shareBundle(List<Alarm> alarms) async {
    if (!FeatureFlags.familySharing || alarms.isEmpty) {
      return;
    }
    final json = jsonEncode(exportBundle(alarms));
    await Share.share(json, subject: 'Nomad Alarm bundle');
  }

  Future<void> copyToClipboard(Alarm alarm) async {
    if (!FeatureFlags.groupTravel) {
      return;
    }
    await Clipboard.setData(
      ClipboardData(text: jsonEncode(exportAlarm(alarm))),
    );
  }

  Future<void> copyBundleToClipboard(List<Alarm> alarms) async {
    if (!FeatureFlags.familySharing || alarms.isEmpty) {
      return;
    }
    await Clipboard.setData(
      ClipboardData(text: jsonEncode(exportBundle(alarms))),
    );
  }

  Future<void> copyToClipboardFromDraft(AlarmDraft draft) async {
    if (!FeatureFlags.groupTravel) {
      return;
    }
    await Clipboard.setData(
      ClipboardData(text: jsonEncode(exportDraft(draft))),
    );
  }

  AlarmDraft? parseImport(String raw) {
    if (!FeatureFlags.groupTravel) {
      return null;
    }
    try {
      final map = jsonDecode(raw.trim()) as Map<String, dynamic>;
      if (map['type'] == 'nomad_alarm_bundle') {
        final alarms = parseBundle(raw);
        return alarms.isNotEmpty ? alarms.first : null;
      }
      if (map['type'] != 'nomad_alarm_config') {
        return null;
      }
      return _draftFromMap(map);
    } catch (_) {
      return null;
    }
  }

  List<AlarmDraft> parseBundle(String raw) {
    if (!FeatureFlags.familySharing) {
      return [];
    }
    try {
      final map = jsonDecode(raw.trim()) as Map<String, dynamic>;
      if (map['type'] != 'nomad_alarm_bundle') {
        return [];
      }
      final items = map['alarms'] as List<dynamic>? ?? [];
      return items
          .map((e) => _draftFromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  AlarmDraft _draftFromMap(Map<String, dynamic> map) {
    return AlarmDraft(
      name: map['name'] as String,
      destLatitude: (map['destLatitude'] as num).toDouble(),
      destLongitude: (map['destLongitude'] as num).toDouble(),
      address: map['address'] as String?,
      type: AlarmType.values[map['alarmType'] as int? ?? 0],
      triggerDistanceMeters:
          (map['triggerDistanceMeters'] as num?)?.toDouble() ?? 500,
      speedThresholdKmh: (map['speedThresholdKmh'] as num?)?.toDouble(),
      travelMode: TravelMode.values[map['travelMode'] as int? ?? 6],
      voiceEnabled: map['voiceEnabled'] as bool? ?? true,
      vibrationEnabled: map['vibrationEnabled'] as bool? ?? true,
      flashlightEnabled: map['flashlightEnabled'] as bool? ?? false,
      ringtoneUri: map['ringtoneUri'] as String?,
    );
  }
}
