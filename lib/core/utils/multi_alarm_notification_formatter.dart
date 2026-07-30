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
  String appName = 'Nomad Alarm',
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
      title: appName,
      content: 'No active alarms',
    );
  }

  if (tracking.length == 1) {
    final state = tracking.first;
    final distance = formatDistance(state.distanceMeters);
    final eta = state.etaMinutes != null ? formatEta(state.etaMinutes) : null;
    final body = eta != null ? '$distance · $eta' : distance;
    return MultiAlarmNotificationContent(
      title: appName,
      content: '${state.destinationName} · $body',
    );
  }

  final nearest = tracking.first;
  final distance = formatDistance(nearest.distanceMeters);
  final eta = nearest.etaMinutes != null ? formatEta(nearest.etaMinutes) : null;
  final nearestBody = eta != null ? '$distance · $eta' : distance;
  return MultiAlarmNotificationContent(
    title: appName,
    content:
        '${tracking.length} active alarms · Nearest: ${nearest.destinationName} · $nearestBody',
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
