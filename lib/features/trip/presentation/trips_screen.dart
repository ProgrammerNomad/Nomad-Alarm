import 'package:nomad_alarm/shared/widgets/nomad_empty_state.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
import 'package:flutter/material.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NomadScaffold(
      title: 'Trips',
      body: NomadEmptyState(
        title: 'No trips yet',
        message: 'Your completed journeys will appear here.',
      ),
    );
  }
}
