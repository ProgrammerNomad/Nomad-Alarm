import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NomadScaffold(
      title: l10n.privacyTitle,
      showBackButton: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.privacyHeading,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text('• ${l10n.privacyBullet1}'),
            const SizedBox(height: 8),
            Text('• ${l10n.privacyBullet2}'),
            const SizedBox(height: 8),
            Text('• ${l10n.privacyBullet3}'),
            const SizedBox(height: 8),
            Text('• ${l10n.privacyBullet4}'),
            const SizedBox(height: 8),
            Text('• ${l10n.privacyBullet5}'),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => launchUrl(
                Uri.parse(AppConstants.privacyPolicyUrl),
                mode: LaunchMode.externalApplication,
              ),
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.fullPrivacyPolicy),
            ),
          ],
        ),
      ),
    );
  }
}
