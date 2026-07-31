import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/models/enums.dart';

class AlarmSourceBadge extends StatelessWidget {
  const AlarmSourceBadge({
    required this.createdBy,
    super.key,
  });

  final AlarmCreatedBy createdBy;

  @override
  Widget build(BuildContext context) {
    if (createdBy != AlarmCreatedBy.smart) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        context.l10n.alarmSourceAuto,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
