import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/services/battery_monitor_service.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  int? _batteryLevel;
  bool? _isCharging;
  bool? _serviceRunning;

  @override
  void initState() {
    super.initState();
    _refreshExtras();
  }

  Future<void> _refreshExtras() async {
    final battery = BatteryMonitorService();
    final level = await battery.level;
    final charging = await battery.isCharging;
    final running = await ref.read(backgroundServiceRunningProvider.future);
    if (mounted) {
      setState(() {
        _batteryLevel = level;
        _isCharging = charging;
        _serviceRunning = running;
      });
    }
  }

  Future<void> _copySnapshot(WidgetRef ref) async {
    final alarmService = ref.read(alarmServiceProvider);
    final activeId = alarmService.activeAlarmId;
    final state = activeId != null
        ? await alarmService.getRuntimeState(activeId)
        : null;

    final buffer = StringBuffer()
      ..writeln('Nomad Alarm Debug Snapshot')
      ..writeln('Active alarm ID: $activeId')
      ..writeln('Background service: $_serviceRunning')
      ..writeln('Battery: $_batteryLevel% charging=$_isCharging');

    if (state != null) {
      buffer
        ..writeln('Destination: ${state.destinationName}')
        ..writeln('Distance: ${formatDistance(state.distanceMeters)}')
        ..writeln('ETA: ${formatEta(state.etaMinutes)}')
        ..writeln('Speed: ${state.speedKmh.toStringAsFixed(1)} km/h')
        ..writeln('GPS lost: ${state.isGpsLost}')
        ..writeln('Low battery: ${state.isLowBattery}');
      if (state.latitude != null && state.longitude != null) {
        buffer.writeln(
          'Position: ${state.latitude!.toStringAsFixed(5)}, '
          '${state.longitude!.toStringAsFixed(5)}',
        );
      }
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debug snapshot copied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!FeatureFlags.debugScreen || !kDebugMode) {
      return const NomadScaffold(
        title: 'Debug',
        showBackButton: true,
        body: Center(child: Text('Debug screen unavailable')),
      );
    }

    final activeId = ref.watch(alarmServiceProvider).activeAlarmId;
    final stateAsync = activeId != null
        ? ref.watch(activeAlarmStateProvider(activeId))
        : null;

    return NomadScaffold(
      title: 'Debug',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DebugTile(label: 'Background service', value: '$_serviceRunning'),
          _DebugTile(
            label: 'Battery',
            value: _batteryLevel != null
                ? '$_batteryLevel% (${_isCharging == true ? 'charging' : 'discharging'})'
                : '…',
          ),
          _DebugTile(label: 'Active alarm ID', value: '$activeId'),
          if (stateAsync != null)
            stateAsync.when(
              loading: () => const ListTile(title: Text('Loading GPS state…')),
              error: (e, _) => ListTile(title: Text('Error: $e')),
              data: (state) => Column(
                children: [
                  _DebugTile(
                    label: 'Distance',
                    value: formatDistance(state.distanceMeters),
                  ),
                  _DebugTile(label: 'ETA', value: formatEta(state.etaMinutes)),
                  _DebugTile(
                    label: 'Speed',
                    value: '${state.speedKmh.toStringAsFixed(1)} km/h',
                  ),
                  _DebugTile(
                    label: 'Accuracy',
                    value: '${state.accuracyMeters.round()} m',
                  ),
                  _DebugTile(label: 'GPS lost', value: '${state.isGpsLost}'),
                  _DebugTile(
                    label: 'Low battery flag',
                    value: '${state.isLowBattery}',
                  ),
                  if (state.latitude != null && state.longitude != null)
                    _DebugTile(
                      label: 'Position',
                      value:
                          '${state.latitude!.toStringAsFixed(5)}, ${state.longitude!.toStringAsFixed(5)}',
                    ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _copySnapshot(ref),
            icon: const Icon(Icons.copy),
            label: const Text('Copy snapshot'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _refreshExtras,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

class _DebugTile extends StatelessWidget {
  const _DebugTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
