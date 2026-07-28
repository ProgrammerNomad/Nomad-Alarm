import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/shared/widgets/nomad_logo.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NomadScaffold(
      title: 'About',
      showBackButton: true,
      body: Column(
        children: [
          const NomadLogo(size: 80),
          const SizedBox(height: 16),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Version 1.0.0'),
          const SizedBox(height: 8),
          const Text('Developed by ProgrammerNomad'),
          const SizedBox(height: 24),
          const Text(
            'A privacy-first location alarm. Free forever. No ads. No tracking.',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () => launchUrl(Uri.parse(AppConstants.githubUrl)),
            icon: const Icon(Icons.code),
            label: const Text('View on GitHub'),
          ),
        ],
      ),
    );
  }
}
