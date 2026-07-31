import 'dart:io';

import 'package:flutter/services.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/shared_alarm_payload.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/shared_alarm_codec.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SharedAlarmShareService {
  const SharedAlarmShareService();

  Future<void> shareAlarmPackage(SharedAlarmPayload payload) async {
    final json = SharedAlarmCodec.encode(payload);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${SharedAlarmCodec.slugFileName(payload.destinationName)}');
    await file.writeAsString(json);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/x-nomadalarm')],
      subject: payload.destinationName,
    );
  }

  Future<void> shareDestinationOnly(SharedAlarmPayload payload) async {
    final text = '${payload.destinationName}\n'
        'https://maps.google.com/?q=${payload.lat},${payload.lng}';
    await Share.share(text, subject: payload.destinationName);
  }

  Future<void> copyCoordinates(SharedAlarmPayload payload) async {
    await Clipboard.setData(
      ClipboardData(text: '${payload.lat},${payload.lng}'),
    );
  }
}

class SharedAlarmDuplicateMatcher {
  const SharedAlarmDuplicateMatcher();

  static const _matchRadiusMeters = 50.0;

  Alarm? findMatch(List<Alarm> existing, SharedAlarmPayload payload) {
    for (final alarm in existing) {
      if (_namesSimilar(alarm.name, payload.destinationName) &&
          haversineMeters(
                alarm.destLatitude,
                alarm.destLongitude,
                payload.lat,
                payload.lng,
              ) <=
              _matchRadiusMeters) {
        return alarm;
      }
    }
    return null;
  }

  bool _namesSimilar(String a, String b) {
    return a.trim().toLowerCase() == b.trim().toLowerCase();
  }
}

AlarmDraft applyPayloadToAlarm(Alarm existing, SharedAlarmPayload payload) {
  return AlarmDraft(
    name: payload.destinationName,
    destLatitude: payload.lat,
    destLongitude: payload.lng,
    address: payload.address ?? existing.address,
    placeId: existing.placeId,
    triggerDistanceMeters: payload.triggerDistanceMeters,
    travelMode: payload.travelMode,
    type: payload.alarmType,
    voiceEnabled: payload.voice,
    vibrationEnabled: payload.vibration,
    flashlightEnabled: payload.flashlight,
    ringtoneUri: existing.ringtoneUri,
    notes: payload.notes,
  );
}

Future<void> updateAlarmFromPayload(
  Alarm existing,
  SharedAlarmPayload payload,
  AlarmRepository repo,
) async {
  existing
    ..name = payload.destinationName
    ..destLatitude = payload.lat
    ..destLongitude = payload.lng
    ..address = payload.address ?? existing.address
    ..triggerDistanceMeters = payload.triggerDistanceMeters
    ..type = payload.alarmType
    ..travelMode = payload.travelMode
    ..voiceEnabled = payload.voice
    ..vibrationEnabled = payload.vibration
    ..flashlightEnabled = payload.flashlight
    ..updatedAt = DateTime.now();
  await repo.update(existing);
}

String copyNameForDuplicate(String name) {
  final base = name.trim();
  if (base.endsWith(' (copy)')) {
    return '$base 2';
  }
  return '$base (copy)';
}
