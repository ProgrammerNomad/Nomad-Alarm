import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/history_entry.dart';

/// Current backup file format version.
const int backupSchemaVersion = 1;

class BackupImportResult {
  const BackupImportResult({
    required this.alarmsImported,
    required this.favoritesImported,
    required this.historyImported,
    required this.settingsImported,
  });

  final int alarmsImported;
  final int favoritesImported;
  final int historyImported;
  final bool settingsImported;
}

class BackupService {
  BackupService(this._isar);

  final Isar _isar;

  static const _runningStatuses = {
    AlarmStatus.active,
    AlarmStatus.paused,
    AlarmStatus.triggered,
  };

  Future<Map<String, dynamic>> exportToMap() async {
    final alarms = await _isar.alarms.where().findAll();
    final favorites = await _isar.favorites.where().findAll();
    final history = await _isar.historyEntrys.where().findAll();
    final settings = await _isar.appSettings.get(0);

    return {
      'version': backupSchemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'alarms': alarms
          .where((a) => !_runningStatuses.contains(a.status))
          .map(_alarmToJson)
          .toList(),
      'favorites': favorites.map(_favoriteToJson).toList(),
      'history': history.map(_historyToJson).toList(),
      if (settings != null) 'settings': _settingsToJson(settings),
    };
  }

  Future<String> exportToJson() async {
    return const JsonEncoder.withIndent('  ').convert(await exportToMap());
  }

  Future<BackupImportResult> importFromJson(String jsonString) async {
    final dynamic decoded;
    try {
      decoded = jsonDecode(jsonString);
    } catch (_) {
      throw const StorageException('Invalid backup file format.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const StorageException('Invalid backup file structure.');
    }

    final version = decoded['version'];
    if (version is! int || version != backupSchemaVersion) {
      throw StorageException(
        'Unsupported backup version: $version (expected $backupSchemaVersion).',
      );
    }

    var alarmsImported = 0;
    var favoritesImported = 0;
    var historyImported = 0;
    var settingsImported = false;

    await _isar.writeTxn(() async {
      final alarms = decoded['alarms'];
      if (alarms is List) {
        for (final item in alarms) {
          if (item is Map<String, dynamic>) {
            await _isar.alarms.put(_alarmFromJson(item));
            alarmsImported++;
          }
        }
      }

      final favorites = decoded['favorites'];
      if (favorites is List) {
        for (final item in favorites) {
          if (item is Map<String, dynamic>) {
            await _isar.favorites.put(_favoriteFromJson(item));
            favoritesImported++;
          }
        }
      }

      final history = decoded['history'];
      if (history is List) {
        for (final item in history) {
          if (item is Map<String, dynamic>) {
            await _isar.historyEntrys.put(_historyFromJson(item));
            historyImported++;
          }
        }
      }

      final settingsJson = decoded['settings'];
      if (settingsJson is Map<String, dynamic>) {
        final current = await _isar.appSettings.get(0) ?? AppSettings.defaults();
        _applySettingsFromJson(current, settingsJson);
        await _isar.appSettings.put(current);
        settingsImported = true;
      }
    });

    return BackupImportResult(
      alarmsImported: alarmsImported,
      favoritesImported: favoritesImported,
      historyImported: historyImported,
      settingsImported: settingsImported,
    );
  }

  Map<String, dynamic> _alarmToJson(Alarm alarm) => {
        'name': alarm.name,
        'destLatitude': alarm.destLatitude,
        'destLongitude': alarm.destLongitude,
        'address': alarm.address,
        'placeId': alarm.placeId,
        'type': alarm.type.index,
        'triggerDistanceMeters': alarm.triggerDistanceMeters,
        'radiusMeters': alarm.radiusMeters,
        'speedThresholdKmh': alarm.speedThresholdKmh,
        'travelMode': alarm.travelMode.index,
        'repeat': alarm.repeat,
        'voiceEnabled': alarm.voiceEnabled,
        'vibrationEnabled': alarm.vibrationEnabled,
        'flashlightEnabled': alarm.flashlightEnabled,
        'status': AlarmStatus.draft.index,
        'createdAt': alarm.createdAt.toIso8601String(),
      };

  Alarm _alarmFromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return Alarm()
      ..id = Isar.autoIncrement
      ..name = json['name'] as String
      ..destLatitude = (json['destLatitude'] as num).toDouble()
      ..destLongitude = (json['destLongitude'] as num).toDouble()
      ..address = json['address'] as String?
      ..placeId = json['placeId'] as String?
      ..type = AlarmType.values[json['type'] as int? ?? 0]
      ..triggerDistanceMeters =
          (json['triggerDistanceMeters'] as num?)?.toDouble() ?? 500
      ..radiusMeters = (json['radiusMeters'] as num?)?.toDouble()
      ..speedThresholdKmh = (json['speedThresholdKmh'] as num?)?.toDouble()
      ..travelMode = TravelMode.values[json['travelMode'] as int? ?? 6]
      ..repeat = json['repeat'] as bool? ?? false
      ..voiceEnabled = json['voiceEnabled'] as bool? ?? true
      ..vibrationEnabled = json['vibrationEnabled'] as bool? ?? true
      ..flashlightEnabled = json['flashlightEnabled'] as bool? ?? false
      ..status = AlarmStatus.draft
      ..createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '') ?? now
      ..updatedAt = now;
  }

  Map<String, dynamic> _favoriteToJson(Favorite fav) => {
        'name': fav.name,
        'category': fav.category.index,
        'latitude': fav.latitude,
        'longitude': fav.longitude,
        'address': fav.address,
        'sortOrder': fav.sortOrder,
        'createdAt': fav.createdAt.toIso8601String(),
      };

  Favorite _favoriteFromJson(Map<String, dynamic> json) {
    return Favorite()
      ..id = Isar.autoIncrement
      ..name = json['name'] as String
      ..category = FavoriteCategory.values[json['category'] as int? ?? 6]
      ..latitude = (json['latitude'] as num).toDouble()
      ..longitude = (json['longitude'] as num).toDouble()
      ..address = json['address'] as String?
      ..sortOrder = json['sortOrder'] as int? ?? 0
      ..createdAt =
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now();
  }

  Map<String, dynamic> _historyToJson(HistoryEntry entry) => {
        'destinationName': entry.destinationName,
        'destLatitude': entry.destLatitude,
        'destLongitude': entry.destLongitude,
        'type': entry.type.index,
        'occurredAt': entry.occurredAt.toIso8601String(),
        'triggerDistanceMeters': entry.triggerDistanceMeters,
        'snoozeCount': entry.snoozeCount,
        'notes': entry.notes,
      };

  HistoryEntry _historyFromJson(Map<String, dynamic> json) {
    return HistoryEntry()
      ..id = Isar.autoIncrement
      ..destinationName = json['destinationName'] as String
      ..destLatitude = (json['destLatitude'] as num).toDouble()
      ..destLongitude = (json['destLongitude'] as num).toDouble()
      ..type = HistoryType.values[json['type'] as int? ?? 0]
      ..occurredAt =
          DateTime.tryParse(json['occurredAt'] as String? ?? '') ?? DateTime.now()
      ..triggerDistanceMeters =
          (json['triggerDistanceMeters'] as num?)?.toDouble()
      ..snoozeCount = json['snoozeCount'] as int?
      ..notes = json['notes'] as String?;
  }

  Map<String, dynamic> _settingsToJson(AppSettings settings) => {
        'themeMode': settings.themeMode.index,
        'useMetric': settings.useMetric,
        'languageCode': settings.languageCode,
        'defaultTriggerDistanceMeters': settings.defaultTriggerDistanceMeters,
        'defaultVoiceEnabled': settings.defaultVoiceEnabled,
        'defaultVibrationEnabled': settings.defaultVibrationEnabled,
        'defaultFlashlightEnabled': settings.defaultFlashlightEnabled,
        'batteryProfile': settings.batteryProfile.index,
      };

  void _applySettingsFromJson(AppSettings settings, Map<String, dynamic> json) {
    settings.themeMode =
        AppThemeMode.values[json['themeMode'] as int? ?? settings.themeMode.index];
    settings.useMetric = json['useMetric'] as bool? ?? settings.useMetric;
    settings.languageCode =
        json['languageCode'] as String? ?? settings.languageCode;
    settings.defaultTriggerDistanceMeters =
        (json['defaultTriggerDistanceMeters'] as num?)?.toDouble() ??
            settings.defaultTriggerDistanceMeters;
    settings.defaultVoiceEnabled =
        json['defaultVoiceEnabled'] as bool? ?? settings.defaultVoiceEnabled;
    settings.defaultVibrationEnabled = json['defaultVibrationEnabled'] as bool? ??
        settings.defaultVibrationEnabled;
    settings.defaultFlashlightEnabled = json['defaultFlashlightEnabled']
            as bool? ??
        settings.defaultFlashlightEnabled;
    settings.batteryProfile = BatteryProfile
        .values[json['batteryProfile'] as int? ?? settings.batteryProfile.index];
  }
}
