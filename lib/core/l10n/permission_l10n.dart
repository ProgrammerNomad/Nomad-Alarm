import 'package:nomad_alarm/l10n/app_localizations.dart';
import 'package:nomad_alarm/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permission onboarding steps with localized titles and descriptions.
List<PermissionInfo> localizedPermissionSteps(AppLocalizations l10n) {
  return [
    PermissionInfo(
      type: NomadPermissionType.location,
      title: l10n.permLocationTitle,
      description: l10n.permLocationDesc,
      permission: Permission.locationWhenInUse,
    ),
    PermissionInfo(
      type: NomadPermissionType.notification,
      title: l10n.permNotificationTitle,
      description: l10n.permNotificationDesc,
      permission: Permission.notification,
    ),
    PermissionInfo(
      type: NomadPermissionType.backgroundLocation,
      title: l10n.permBackgroundTitle,
      description: l10n.permBackgroundDesc,
      permission: Permission.locationAlways,
    ),
    PermissionInfo(
      type: NomadPermissionType.exactAlarm,
      title: l10n.permExactAlarmTitle,
      description: l10n.permExactAlarmDesc,
      permission: Permission.scheduleExactAlarm,
    ),
    PermissionInfo(
      type: NomadPermissionType.batteryOptimization,
      title: l10n.permBatteryTitle,
      description: l10n.permBatteryDesc,
      permission: Permission.ignoreBatteryOptimizations,
      skippable: true,
    ),
  ];
}
