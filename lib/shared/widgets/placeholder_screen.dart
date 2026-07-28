import 'package:flutter/material.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return NomadScaffold(
      title: title,
      showBackButton: true,
      body: Center(
        child: Text(
          '$title - coming in a future release',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
