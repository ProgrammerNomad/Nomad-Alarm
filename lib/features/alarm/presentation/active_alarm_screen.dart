import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';

class ActiveAlarmScreen extends ConsumerStatefulWidget {
  const ActiveAlarmScreen({
    required this.alarmId,
    super.key,
  });

  final int alarmId;

  @override
  ConsumerState<ActiveAlarmScreen> createState() => _ActiveAlarmScreenState();
}

class _ActiveAlarmScreenState extends ConsumerState<ActiveAlarmScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureMonitoring());
  }

  Future<void> _ensureMonitoring() async {
    final alarm = await ref.read(alarmRepositoryProvider).getById(widget.alarmId);
    if (alarm == null || !mounted) {
      return;
    }
    if (alarm.status == AlarmStatus.active &&
        ref.read(alarmServiceProvider).activeAlarmId != widget.alarmId) {
      await ref.read(alarmServiceProvider).startAlarm(widget.alarmId);
    }
  }

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
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(activeAlarmStateProvider(widget.alarmId));

    ref.listen(activeAlarmStateProvider(widget.alarmId), (prev, next) {
      final state = next.valueOrNull;
      if (state?.status == AlarmStatus.triggered && mounted) {
        context.go('/alarm/ring/${widget.alarmId}');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Alarm'),
        automaticallyImplyLeading: false,
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
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
                  formatDistance(state.distanceMeters),
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
                  'estimated arrival',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatChip(
                      icon: Icons.speed,
                      label: '${state.speedKmh.toStringAsFixed(0)} km/h',
                    ),
                    _StatChip(
                      icon: Icons.gps_fixed,
                      label: '${state.accuracyMeters.round()} m',
                      color: _accuracyColor(state.accuracyMeters),
                    ),
                  ],
                ),
                if (state.isGpsLost) ...[
                  const SizedBox(height: 16),
                  _WarningBanner(
                    message: 'GPS signal lost - last fix may be stale',
                    color: Colors.orange,
                  ),
                ],
                if (state.hasPassedDestination) ...[
                  const SizedBox(height: 16),
                  _WarningBanner(
                    message: 'You may have passed your destination',
                    color: Colors.red,
                  ),
                ],
                if (state.isLowBattery) ...[
                  const SizedBox(height: 16),
                  _WarningBanner(
                    message: 'Low battery - charge your phone to keep tracking reliable',
                    color: Colors.amber,
                  ),
                ],
                if (state.status == AlarmStatus.paused) ...[
                  const SizedBox(height: 16),
                  _WarningBanner(
                    message: 'Alarm paused',
                    color: Colors.blue,
                  ),
                ],
                const Spacer(),
                if (state.status == AlarmStatus.paused)
                  FilledButton.icon(
                    onPressed: () async {
                      await ref
                          .read(alarmServiceProvider)
                          .resumeAlarm(widget.alarmId);
                      ref.invalidate(activeAlarmsProvider);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Resume'),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(alarmServiceProvider)
                          .pauseAlarm(widget.alarmId);
                      ref.invalidate(activeAlarmsProvider);
                    },
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
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
                  label: const Text('Open Map'),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () async {
                    await ref
                        .read(alarmServiceProvider)
                        .cancelAlarm(widget.alarmId);
                    ref.invalidate(activeAlarmsProvider);
                    if (context.mounted) {
                      context.go('/home');
                    }
                  },
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel Alarm'),
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
