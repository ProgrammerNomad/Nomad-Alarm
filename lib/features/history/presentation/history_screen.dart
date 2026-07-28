import 'package:flutter/material.dart';
import 'package:nomad_alarm/shared/widgets/nomad_empty_state.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NomadScaffold(
      title: 'History',
      body: NomadEmptyState(
        title: 'No history yet',
        message: 'Completed and missed alarms will be logged here.',
      ),
    );
  }
}
