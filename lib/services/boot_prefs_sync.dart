import 'package:home_widget/home_widget.dart';
import 'package:nomad_alarm/services/widget_service.dart';

/// Syncs boot-resume preferences to Android shared prefs for [BootReceiver].
class BootPrefsSync {
  BootPrefsSync._();

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(WidgetService.appGroupId);
  }

  static Future<void> syncResumeAfterBoot(bool enabled) async {
    await HomeWidget.saveWidgetData<bool>('resume_alarm_after_boot', enabled);
  }

  static Future<void> setActiveAlarmId(int? alarmId) async {
    await HomeWidget.saveWidgetData<int>(
      'boot_active_alarm_id',
      alarmId ?? -1,
    );
  }
}
