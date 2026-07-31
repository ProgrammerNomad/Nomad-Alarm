import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/utils/favorite_category_utils.dart';
import 'package:nomad_alarm/core/utils/place_confidence_engine.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/smart_place_providers.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
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
    final l10n = context.l10n;
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
        ..writeln('Speed: ${state.speedKmh.toStringAsFixed(1)} ${l10n.kmhUnit}')
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
        SnackBar(content: Text(l10n.debugSnapshotCopied)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (!FeatureFlags.debugScreen || !kDebugMode) {
      return NomadScaffold(
        title: l10n.debugTitle,
        showBackButton: true,
        body: Center(child: Text(l10n.debugUnavailable)),
      );
    }

    final activeId = ref.watch(alarmServiceProvider).activeAlarmId;
    final stateAsync = activeId != null
        ? ref.watch(activeAlarmStateProvider(activeId))
        : null;
    final useMetric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? true;

    return NomadScaffold(
      title: l10n.debugTitle,
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DebugTile(
            label: l10n.debugBackgroundService,
            value: '$_serviceRunning',
          ),
          _DebugTile(
            label: l10n.debugBattery,
            value: _batteryLevel != null
                ? '$_batteryLevel% (${_isCharging == true ? l10n.debugCharging : l10n.debugDischarging})'
                : '…',
          ),
          _DebugTile(label: l10n.debugActiveAlarmId, value: '$activeId'),
          if (stateAsync != null)
            stateAsync.when(
              loading: () => ListTile(title: Text(l10n.debugLoadingGps)),
              error: (e, _) => ListTile(title: Text(l10n.errorPrefix(e.toString()))),
              data: (state) => Column(
                children: [
                  _DebugTile(
                    label: l10n.debugDistance,
                    value: formatDistance(
                      state.distanceMeters,
                      useMetric: useMetric,
                    ),
                  ),
                  _DebugTile(
                    label: l10n.debugEta,
                    value: formatEta(state.etaMinutes),
                  ),
                  _DebugTile(
                    label: l10n.debugSpeed,
                    value: '${state.speedKmh.toStringAsFixed(1)} ${l10n.kmhUnit}',
                  ),
                  _DebugTile(
                    label: l10n.debugAccuracy,
                    value: '${state.accuracyMeters.round()} ${l10n.metersUnit}',
                  ),
                  _DebugTile(
                    label: l10n.debugGpsLost,
                    value: '${state.isGpsLost}',
                  ),
                  _DebugTile(
                    label: l10n.debugLowBattery,
                    value: '${state.isLowBattery}',
                  ),
                  if (state.latitude != null && state.longitude != null)
                    _DebugTile(
                      label: l10n.debugPosition,
                      value:
                          '${state.latitude!.toStringAsFixed(5)}, ${state.longitude!.toStringAsFixed(5)}',
                    ),
                ],
              ),
            ),
          if (FeatureFlags.smartPlaces) ...[
            const Divider(height: 32),
            Text(
              l10n.debugSmartPlaces,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Consumer(
              builder: (context, ref, _) {
                final favoritesAsync = ref.watch(favoritesProvider);
                final snapshot =
                    ref.read(smartPlaceServiceProvider).lastSnapshot;
                return favoritesAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(l10n.errorPrefix(e.toString())),
                  data: (places) {
                    if (places.isEmpty) {
                      return Text(l10n.savedPlacesEmptyTitle);
                    }
                    final results = snapshot?.results ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (snapshot != null)
                          _DebugTile(
                            label: 'Confirmation buffer',
                            value:
                                '${snapshot.confirmationTicks}/3 (place ${snapshot.leadingPlaceId ?? '-'})',
                          ),
                        ...places.take(5).map((place) {
                          PlaceConfidenceResult? match;
                          for (final r in results) {
                            if (r.placeId == place.id) {
                              match = r;
                              break;
                            }
                          }
                          final visual =
                              FavoriteCategoryUtils.visual(place.category);
                          return Card(
                            child: ExpansionTile(
                              title: Row(
                                children: [
                                  Icon(
                                    visual.icon,
                                    size: 16,
                                    color: visual.color,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(place.name)),
                                ],
                              ),
                              subtitle: match != null
                                  ? Text('${match.confidencePercent.round()}% (debug)')
                                  : null,
                              children: [
                                if (match != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      0,
                                      16,
                                      8,
                                    ),
                                    child: Text(l10n.debugConfidenceWhy),
                                  ),
                                  ...match.breakdown.map(
                                    (factor) => ListTile(
                                      dense: true,
                                      leading: Icon(
                                        factor.status ==
                                                ConfidenceFactorStatus.pass
                                            ? Icons.check_circle_outline
                                            : Icons.cancel_outlined,
                                        size: 18,
                                      ),
                                      title: Text(factor.label),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _copySnapshot(ref),
            icon: const Icon(Icons.copy),
            label: Text(l10n.debugCopySnapshot),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _refreshExtras,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.debugRefresh),
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
