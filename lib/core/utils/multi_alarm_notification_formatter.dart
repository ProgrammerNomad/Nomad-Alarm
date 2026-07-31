import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';

class MultiAlarmNotificationContent {
  const MultiAlarmNotificationContent({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;
}

/// Builds collapsed foreground-service notification text for one or many alarms.
MultiAlarmNotificationContent formatMultiAlarmNotification(
  List<AlarmRuntimeState> states, {
  String noActiveAlarmsLabel = 'No active alarms',
  String Function(int count)? activeAlarmsTitle,
  String nearestLabel = 'Nearest',
}) {
  final tracking = states
      .where(
        (state) =>
            state.status == AlarmStatus.active ||
            state.status == AlarmStatus.paused,
      )
      .toList()
    ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

  if (tracking.isEmpty) {
    return MultiAlarmNotificationContent(
      title: noActiveAlarmsLabel,
      content: noActiveAlarmsLabel,
    );
  }

  if (tracking.length == 1) {
    final state = tracking.first;
    final distance = formatDistance(state.distanceMeters);
    final eta = state.etaMinutes != null ? formatEta(state.etaMinutes) : null;
    final body = eta != null ? '$distance · $eta' : distance;
    return MultiAlarmNotificationContent(
      title: state.destinationName,
      content: body,
    );
  }

  final nearest = tracking.first;
  final distance = formatDistance(nearest.distanceMeters);
  final eta = nearest.etaMinutes != null ? formatEta(nearest.etaMinutes) : null;
  final nearestBody = eta != null ? '$distance · $eta' : distance;
  final title = activeAlarmsTitle?.call(tracking.length) ??
      '${tracking.length} active alarms';
  return MultiAlarmNotificationContent(
    title: title,
    content: '$nearestLabel: ${nearest.destinationName} · $nearestBody',
  );
}

/// Picks the nearest actively tracked alarm for widgets and tiles.
AlarmRuntimeState? nearestActiveAlarmState(List<AlarmRuntimeState> states) {
  final tracking = states
      .where((state) => state.status == AlarmStatus.active)
      .toList()
    ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
  if (tracking.isEmpty) {
    return null;
  }
  return tracking.first;
}
