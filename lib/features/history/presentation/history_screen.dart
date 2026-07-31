import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/features/history/history_list_item.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/shared/widgets/alarm_journey_detail_sheet.dart';
import 'package:nomad_alarm/shared/widgets/nomad_empty_state.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({this.initialFilter, super.key});

  final HistoryFilter? initialFilter;

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late HistoryFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter ?? HistoryFilter.all;
  }

  @override
  void didUpdateWidget(HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFilter != null &&
        widget.initialFilter != oldWidget.initialFilter) {
      _filter = widget.initialFilter!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final itemsAsync = ref.watch(unifiedHistoryProvider(_filter));
    final allEntriesAsync = ref.watch(historyEntriesProvider);
    final activeAsync = ref.watch(activeAlarmsProvider);
    final draftsAsync = ref.watch(draftAlarmsProvider);
    final useMetric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? true;

    return NomadScaffold(
      title: l10n.historyTitle,
      body: Column(
        children: [
          allEntriesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, stackTrace) => const SizedBox.shrink(),
            data: (allEntries) => activeAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, stackTrace) => const SizedBox.shrink(),
              data: (activeAlarms) => draftsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, stackTrace) => const SizedBox.shrink(),
                data: (drafts) => _HistoryStatsHeader(
                  activeCount: activeAlarms.length,
                  savedCount: drafts.length,
                  entries: allEntries,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: HistoryFilter.values.map((filter) {
                final label = switch (filter) {
                  HistoryFilter.all => l10n.filterAll,
                  HistoryFilter.active => l10n.filterActive,
                  HistoryFilter.saved => l10n.filterSaved,
                  HistoryFilter.completed => l10n.filterCompleted,
                  HistoryFilter.missed => l10n.filterMissed,
                  HistoryFilter.dismissed => l10n.filterDismissed,
                  HistoryFilter.snoozed => l10n.filterSnoozed,
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: _filter == filter,
                    onSelected: (_) => setState(() => _filter = filter),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: itemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text(l10n.errorPrefix(error.toString()))),
              data: (items) {
                if (items.isEmpty) {
                  if (_filter == HistoryFilter.active) {
                    return NomadEmptyState(
                      title: l10n.historyActiveEmptyTitle,
                      message: l10n.historyActiveEmptyMessage,
                    );
                  }
                  if (_filter == HistoryFilter.saved) {
                    return NomadEmptyState(
                      title: l10n.historySavedEmptyTitle,
                      message: l10n.historySavedEmptyMessage,
                    );
                  }
                  return NomadEmptyState(
                    title: l10n.noHistoryTitle,
                    message: l10n.noHistoryMessage,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return switch (item) {
                      ActiveHistoryItem(:final alarm) => _ActiveHistoryListTile(
                          alarm: alarm,
                          useMetric: useMetric,
                          onTap: () => _openActiveAlarm(context, alarm),
                        ),
                      DraftHistoryItem(:final alarm) => _DraftHistoryListTile(
                          alarm: alarm,
                          useMetric: useMetric,
                          onStart: () => _startDraftAlarm(alarm.id),
                          onDelete: () => _confirmDeleteDraft(context, alarm),
                        ),
                      PastHistoryItem(:final entry) => _HistoryListTile(
                          entry: entry,
                          useMetric: useMetric,
                          onTap: () => showAlarmJourneyDetailSheet(
                            context: context,
                            ref: ref,
                            entry: entry,
                            useMetric: useMetric,
                          ),
                          onDelete: () => _confirmDelete(context, entry),
                        ),
                    };
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openActiveAlarm(BuildContext context, Alarm alarm) {
    if (alarm.status == AlarmStatus.triggered) {
      context.push('/alarm/ring/${alarm.id}');
    } else {
      context.push('/alarm/active/${alarm.id}');
    }
  }

  Future<void> _startDraftAlarm(int alarmId) async {
    final l10n = context.l10n;
    try {
      await ref.read(alarmServiceProvider).startAlarm(alarmId);
      ref.invalidate(activeAlarmsProvider);
      ref.invalidate(draftAlarmsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.alarmCreatedSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPrefix(e.toString()))),
        );
      }
    }
  }

  Future<void> _confirmDeleteDraft(BuildContext context, Alarm alarm) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSavedAlarmTitle),
        content: Text(l10n.deleteSavedAlarmBody(alarm.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(alarmRepositoryProvider).delete(alarm.id);
      ref.invalidate(draftAlarmsProvider);
      ref.invalidate(alarmsProvider);
    }
  }

  Future<void> _confirmDelete(BuildContext context, HistoryEntry entry) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEntryTitle),
        content: Text(l10n.deleteEntryBody(entry.destinationName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(historyRepositoryProvider).delete(entry.id);
    }
  }
}

class _HistoryStatsHeader extends StatelessWidget {
  const _HistoryStatsHeader({
    required this.activeCount,
    required this.savedCount,
    required this.entries,
  });

  final int activeCount;
  final int savedCount;
  final List<HistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final completed =
        entries.where((e) => e.type == HistoryType.completed).length;
    final missed = entries.where((e) => e.type == HistoryType.missed).length;
    final totalOutcomes = completed + missed;
    final successRate = totalOutcomes > 0
        ? (completed / totalOutcomes * 100).round()
        : null;

    if (activeCount == 0 && savedCount == 0 && entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: l10n.historyStatsActive,
                  value: '$activeCount',
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: l10n.historyStatsSaved,
                  value: '$savedCount',
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: l10n.historyStatsCompleted,
                  value: '$completed',
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: l10n.historyStatsMissed,
                  value: '$missed',
                ),
              ),
              if (successRate != null)
                Expanded(
                  child: _StatItem(
                    label: l10n.historyStatsSuccessRate,
                    value: '$successRate%',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ActiveHistoryListTile extends ConsumerWidget {
  const _ActiveHistoryListTile({
    required this.alarm,
    required this.useMetric,
    required this.onTap,
  });

  final Alarm alarm;
  final bool useMetric;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final stateAsync = ref.watch(activeAlarmStateProvider(alarm.id));
    final startedAt = alarm.startedAt;
    final startedLabel = startedAt != null
        ? DateFormat.MMMd().add_jm().format(startedAt)
        : l10n.historyStartedAt;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          Icons.circle,
          size: 12,
          color: _statusColor(alarm.status),
        ),
        title: Text(alarm.name),
        subtitle: stateAsync.when(
          loading: () => Text('$startedLabel · ${l10n.historyStatusTracking}'),
          error: (_, stackTrace) =>
              Text('$startedLabel · ${l10n.historyStatusTracking}'),
          data: (state) {
            final statusLabel = switch (state.status) {
              AlarmStatus.paused => l10n.alarmStatusPaused,
              AlarmStatus.triggered => l10n.stopApproaching,
              _ => l10n.historyStatusTracking,
            };
            final distance =
                formatDistance(state.distanceMeters, useMetric: useMetric);
            final eta = formatEta(state.etaMinutes);
            final detail = state.etaMinutes != null ? '$distance · $eta' : distance;
            return Text('$startedLabel · $statusLabel · $detail');
          },
        ),
        trailing: _ActiveStatusBadge(status: alarm.status),
      ),
    );
  }

  Color _statusColor(AlarmStatus status) {
    return switch (status) {
      AlarmStatus.paused => Colors.amber,
      AlarmStatus.triggered => Colors.red,
      _ => Colors.green,
    };
  }
}

class _ActiveStatusBadge extends StatelessWidget {
  const _ActiveStatusBadge({required this.status});

  final AlarmStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = switch (status) {
      AlarmStatus.paused => l10n.alarmStatusPaused,
      AlarmStatus.triggered => l10n.stopApproaching,
      _ => l10n.filterActive,
    };
    final color = switch (status) {
      AlarmStatus.paused => Colors.amber,
      AlarmStatus.triggered => Colors.red,
      _ => Colors.green,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _DraftHistoryListTile extends StatelessWidget {
  const _DraftHistoryListTile({
    required this.alarm,
    required this.useMetric,
    required this.onStart,
    required this.onDelete,
  });

  final Alarm alarm;
  final bool useMetric;
  final VoidCallback onStart;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final savedAt = DateFormat.MMMd().add_jm().format(alarm.createdAt);
    final trigger =
        formatDistance(alarm.triggerDistanceMeters, useMetric: useMetric);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alarm.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('$savedAt · $trigger'),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.alarmStatusSaved,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(onPressed: onStart, child: Text(l10n.startAlarm)),
                TextButton(onPressed: onDelete, child: Text(l10n.delete)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryListTile extends StatelessWidget {
  const _HistoryListTile({
    required this.entry,
    required this.useMetric,
    required this.onTap,
    required this.onDelete,
  });

  final HistoryEntry entry;
  final bool useMetric;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = DateFormat.MMMd().add_jm().format(entry.occurredAt);
    final trigger = entry.triggerDistanceMeters;

    return Dismissible(
      key: ValueKey('history-${entry.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Semantics(
        label: l10n.semDeleteHistoryEntry,
        button: true,
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ),
      child: Card(
        child: ListTile(
          onTap: onTap,
          title: Text(entry.destinationName),
          subtitle: Text(date),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              HistoryOutcomeBadge(type: entry.type, compact: true),
              if (trigger != null) ...[
                const SizedBox(height: 4),
                Text(
                  formatDistance(trigger, useMetric: useMetric),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
