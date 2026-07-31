import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/features/alarm/presentation/import_alarm_flow.dart';

Future<void> showCreateAlarmSheet(BuildContext context) async {
  final l10n = context.l10n;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(
              l10n.createAlarmSheetTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_alarm_outlined),
            title: Text(l10n.newAlarm),
            onTap: () {
              Navigator.pop(context);
              context.push('/alarm/new');
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(l10n.importAlarm),
            onTap: () {
              Navigator.pop(context);
              ImportAlarmFlow.showChooseSourceSheet(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ),
        ],
      ),
    ),
  );
}
