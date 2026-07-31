import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/models/enums.dart';

Future<SmartAlarmMode?> showSmartAlarmOnboardingSheet(
  BuildContext context, {
  required String placeName,
  SmartAlarmMode initial = SmartAlarmMode.automatic,
}) {
  return showModalBottomSheet<SmartAlarmMode>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      var selected = initial;
      final l10n = context.l10n;
      return SafeArea(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.smartAlarmOnboardingTitle(placeName),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<SmartAlarmMode>(
                    title: Text(l10n.smartAlarmOnboardingNo),
                    value: SmartAlarmMode.off,
                    groupValue: selected,
                    onChanged: (v) => setState(() => selected = v!),
                  ),
                  RadioListTile<SmartAlarmMode>(
                    title: Text(l10n.smartAlarmOnboardingSuggest),
                    value: SmartAlarmMode.suggest,
                    groupValue: selected,
                    onChanged: (v) => setState(() => selected = v!),
                  ),
                  RadioListTile<SmartAlarmMode>(
                    title: Text(l10n.smartAlarmOnboardingAutomatic),
                    value: SmartAlarmMode.automatic,
                    groupValue: selected,
                    onChanged: (v) => setState(() => selected = v!),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, selected),
                    child: Text(l10n.savedPlacesSave),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
