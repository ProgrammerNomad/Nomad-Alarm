import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/features/alarm/presentation/share_alarm_bottom_sheet.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';

class ActiveAlarmScreen extends ConsumerWidget {
  const ActiveAlarmScreen({
    required this.alarmId,
    super.key,
  });

  final int alarmId;

  Color _accuracyColor(double meters) {
    if (meters <= AlarmConstants.gpsAccuracyGoodM) {
      return Colors.green;
    }
    if (meters <= AlarmConstants.gpsAccuracyWarnM) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final useMetric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? true;
    final stateAsync = ref.watch(activeAlarmStateProvider(alarmId));

    ref.listen(activeAlarmStateProvider(alarmId), (prev, next) {
      final state = next.valueOrNull;
      if (state?.status == AlarmStatus.triggered && context.mounted) {
        context.go('/alarm/ring/$alarmId');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.alarmDetailsTitle),
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorPrefix(e.toString()))),
        data: (state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  state.destinationName,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.alarmNumberLabel(alarmId),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                if (state.address != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    state.address!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                Text(
                  formatDistance(state.distanceMeters, useMetric: useMetric),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  formatEta(state.etaMinutes),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.estimatedArrival,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatChip(
                      icon: Icons.speed,
                      label:
                          '${state.speedKmh.toStringAsFixed(0)} ${l10n.kmhUnit}',
                    ),
                    _StatChip(
                      icon: Icons.gps_fixed,
                      label:
                          '${state.accuracyMeters.round()} ${l10n.metersUnit}',
                      color: _accuracyColor(state.accuracyMeters),
                    ),
                  ],
                ),
                if (state.isGpsLost) ...[
                  const SizedBox(height: 16),
                  _WarningBanner(
                    message: l10n.gpsLostWarning,
                    color: Colors.orange,
                  ),
                ],
                if (state.hasPassedDestination) ...[
                  const SizedBox(height: 16),
                  _WarningBanner(
                    message: l10n.passedDestinationWarning,
                    color: Colors.red,
                  ),
                ],
                if (state.isLowBattery) ...[
                  const SizedBox(height: 16),
                  _WarningBanner(
                    message: l10n.lowBatteryWarning,
                    color: Colors.amber,
                  ),
                ],
                if (state.status == AlarmStatus.paused) ...[
                  const SizedBox(height: 16),
                  _WarningBanner(
                    message: l10n.alarmPaused,
                    color: Colors.blue,
                  ),
                ],
                const Spacer(),
                if (state.status == AlarmStatus.paused)
                  FilledButton.icon(
                    onPressed: () async {
                      await ref
                          .read(alarmServiceProvider)
                          .resumeAlarm(alarmId);
                      ref.invalidate(activeAlarmsProvider);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.resume),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(alarmServiceProvider)
                          .pauseAlarm(alarmId);
                      ref.invalidate(activeAlarmsProvider);
                    },
                    icon: const Icon(Icons.pause),
                    label: Text(l10n.pause),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (state.destLatitude != null && state.destLongitude != null) {
                      context.push(
                        '/map?lat=${state.destLatitude}&lng=${state.destLongitude}',
                      );
                    }
                  },
                  icon: const Icon(Icons.map),
                  label: Text(l10n.openMap),
                ),
                const SizedBox(height: 8),
                if (FeatureFlags.groupTravel)
                  OutlinedButton.icon(
                    onPressed: () async {
                      final alarm =
                          await ref.read(alarmRepositoryProvider).getById(alarmId);
                      if (alarm != null && context.mounted) {
                        await showShareAlarmSheet(context, alarm: alarm);
                      }
                    },
                    icon: const Icon(Icons.share_outlined),
                    label: Text(l10n.shareAlarmConfig),
                  ),
                if (FeatureFlags.groupTravel) const SizedBox(height: 8),
                Semantics(
                  label: l10n.semCancelAlarm,
                  button: true,
                  child: TextButton.icon(
                    onPressed: () async {
                      await ref
                          .read(alarmServiceProvider)
                          .cancelAlarm(alarmId);
                      ref.invalidate(activeAlarmsProvider);
                      if (context.mounted) {
                        context.go('/alarms');
                      }
                    },
                    icon: const Icon(Icons.cancel_outlined),
                    label: Text(l10n.cancelAlarm),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({
    required this.message,
    required this.color,
  });

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.warning_amber, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
