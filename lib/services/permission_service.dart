import 'package:permission_handler/permission_handler.dart';

enum NomadPermissionType {
  location,
  notification,
  backgroundLocation,
  exactAlarm,
  batteryOptimization,
}

class PermissionInfo {
  const PermissionInfo({
    required this.type,
    required this.title,
    required this.description,
    required this.permission,
    this.skippable = true,
  });

  final NomadPermissionType type;
  final String title;
  final String description;
  final Permission permission;
  final bool skippable;
}

class PermissionService {
  static const permissionSteps = [
    PermissionInfo(
      type: NomadPermissionType.location,
      title: 'Location access',
      description:
          'We need your location to calculate distance to your destination.',
      permission: Permission.locationWhenInUse,
    ),
    PermissionInfo(
      type: NomadPermissionType.notification,
      title: 'Notifications',
      description:
          'We show a small notification while your alarm is active.',
      permission: Permission.notification,
    ),
    PermissionInfo(
      type: NomadPermissionType.backgroundLocation,
      title: 'Background location',
      description:
          'Allow all the time so the alarm works while your screen is off.',
      permission: Permission.locationAlways,
    ),
    PermissionInfo(
      type: NomadPermissionType.exactAlarm,
      title: 'Exact alarms',
      description:
          'Allows reliable wake-up when you reach your destination (Android 12+).',
      permission: Permission.scheduleExactAlarm,
    ),
    PermissionInfo(
      type: NomadPermissionType.batteryOptimization,
      title: 'Battery optimization',
      description:
          'Disabling battery optimization helps GPS keep running in the background. You can skip this, but tracking may stop on some devices.',
      permission: Permission.ignoreBatteryOptimizations,
      skippable: true,
    ),
  ];

  Future<bool> isGranted(Permission permission) async {
    return permission.isGranted;
  }

  Future<PermissionStatus> request(Permission permission) async {
    return permission.request();
  }

  Future<Map<NomadPermissionType, PermissionStatus>> getAllStatuses() async {
    return {
      NomadPermissionType.location: await Permission.locationWhenInUse.status,
      NomadPermissionType.notification: await Permission.notification.status,
      NomadPermissionType.backgroundLocation:
          await Permission.locationAlways.status,
      NomadPermissionType.exactAlarm: await Permission.scheduleExactAlarm.status,
      NomadPermissionType.batteryOptimization:
          await Permission.ignoreBatteryOptimizations.status,
    };
  }

  Future<bool> hasMinimumPermissions() async {
    final location = await Permission.locationWhenInUse.isGranted;
    final notifications = await Permission.notification.isGranted;
    return location && notifications;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}
