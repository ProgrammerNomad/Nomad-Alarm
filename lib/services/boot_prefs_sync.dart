import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:nomad_alarm/services/widget_service.dart';

/// Syncs boot-resume preferences to Android shared prefs for [BootReceiver].
class BootPrefsSync {
  BootPrefsSync._();

  static const _bootActiveAlarmIdsKey = 'boot_active_alarm_ids';
  static const _legacyBootActiveAlarmIdKey = 'boot_active_alarm_id';

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(WidgetService.appGroupId);
  }

  static Future<void> syncResumeAfterBoot(bool enabled) async {
    await HomeWidget.saveWidgetData<bool>('resume_alarm_after_boot', enabled);
  }

  static Future<void> setActiveAlarmIds(Iterable<int> alarmIds) async {
    final ids = alarmIds.toSet().toList()..sort();
    await HomeWidget.saveWidgetData<String>(
      _bootActiveAlarmIdsKey,
      jsonEncode(ids),
    );
    await HomeWidget.saveWidgetData<int>(
      _legacyBootActiveAlarmIdKey,
      ids.isEmpty ? -1 : ids.first,
    );
  }

  static Future<void> addActiveAlarmId(int alarmId) async {
    final ids = await getActiveAlarmIds();
    ids.add(alarmId);
    await setActiveAlarmIds(ids);
  }

  static Future<void> removeActiveAlarmId(int alarmId) async {
    final ids = await getActiveAlarmIds();
    ids.remove(alarmId);
    await setActiveAlarmIds(ids);
  }

  static Future<Set<int>> getActiveAlarmIds() async {
    final raw = await HomeWidget.getWidgetData<String>(
      _bootActiveAlarmIdsKey,
      defaultValue: '',
    );
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.map((id) => id as int).toSet();
      } catch (_) {
        // Fall through to legacy key.
      }
    }

    final legacy = await HomeWidget.getWidgetData<int>(
      _legacyBootActiveAlarmIdKey,
      defaultValue: -1,
    );
    if (legacy != null && legacy >= 0) {
      return {legacy};
    }
    return {};
  }

  /// Legacy helper - prefer [setActiveAlarmIds].
  static Future<void> setActiveAlarmId(int? alarmId) async {
    if (alarmId == null) {
      await setActiveAlarmIds(const []);
    } else {
      await setActiveAlarmIds([alarmId]);
    }
  }
}
