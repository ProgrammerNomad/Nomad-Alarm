import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/shared/widgets/nomad_empty_state.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  HistoryFilter _filter = HistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(historyEntriesByTypeProvider(_filter));
    final useMetric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? true;

    return NomadScaffold(
      title: 'History',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SegmentedButton<HistoryFilter>(
              segments: const [
                ButtonSegment(
                  value: HistoryFilter.all,
                  label: Text('All'),
                ),
                ButtonSegment(
                  value: HistoryFilter.completed,
                  label: Text('Completed'),
                ),
                ButtonSegment(
                  value: HistoryFilter.missed,
                  label: Text('Missed'),
                ),
              ],
              selected: {_filter},
              onSelectionChanged: (selection) {
                setState(() => _filter = selection.first);
              },
            ),
          ),
          Expanded(
            child: entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (entries) {
                if (entries.isEmpty) {
                  return const NomadEmptyState(
                    title: 'No history yet',
                    message:
                        'Completed and missed alarms will be logged here.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _HistoryListTile(
                      entry: entry,
                      useMetric: useMetric,
                      onTap: () => _showDetail(context, entry, useMetric),
                      onDelete: () => _confirmDelete(context, entry),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, HistoryEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text('Remove "${entry.destinationName}" from history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(historyRepositoryProvider).delete(entry.id);
    }
  }

  void _showDetail(BuildContext context, HistoryEntry entry, bool useMetric) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.destinationName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _OutcomeBadge(type: entry.type),
            const SizedBox(height: 16),
            _DetailRow(
              label: 'Date',
              value: DateFormat.yMMMd().add_jm().format(entry.occurredAt),
            ),
            if (entry.triggerDistanceMeters != null)
              _DetailRow(
                label: 'Trigger distance',
                value: formatDistance(
                  entry.triggerDistanceMeters!,
                  useMetric: useMetric,
                ),
              ),
            if (entry.snoozeCount != null && entry.snoozeCount! > 0)
              _DetailRow(
                label: 'Snoozes',
                value: '${entry.snoozeCount}',
              ),
            if (entry.notes != null && entry.notes!.isNotEmpty)
              _DetailRow(label: 'Notes', value: entry.notes!),
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
    final date = DateFormat.MMMd().add_jm().format(entry.occurredAt);
    final trigger = entry.triggerDistanceMeters;

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
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
      child: Card(
        child: ListTile(
          onTap: onTap,
          title: Text(entry.destinationName),
          subtitle: Text(date),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _OutcomeBadge(type: entry.type, compact: true),
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

class _OutcomeBadge extends StatelessWidget {
  const _OutcomeBadge({required this.type, this.compact = false});

  final HistoryType type;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (type) {
      HistoryType.completed => ('Completed', Colors.green.shade700),
      HistoryType.missed => ('Missed', Colors.orange.shade800),
      HistoryType.dismissed => ('Dismissed', Colors.blueGrey.shade700),
      HistoryType.snoozed => ('Snoozed', Colors.blue.shade700),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
