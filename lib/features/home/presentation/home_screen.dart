import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/shared/widgets/nomad_empty_state.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NomadScaffold(
      title: 'Nomad Alarm',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/alarm/new'),
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Create Alarm'),
      ),
      body: NomadEmptyState(
        title: 'No active alarm',
        message: 'Set your first destination alarm to never miss your stop.',
        action: FilledButton(
          onPressed: () => context.push('/search'),
          child: const Text('Search destination'),
        ),
      ),
    );
  }
}
