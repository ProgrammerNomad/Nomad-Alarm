import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/ui_constants.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/shared/widgets/nomad_logo.dart';
import 'package:nomad_alarm/shared/widgets/nomad_primary_button.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(UiConstants.screenPadding),
          child: Column(
            children: [
              const Spacer(),
              const NomadLogo(size: 140),
              const SizedBox(height: 32),
              Text(
                'Never miss your stop again',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const _Bullet(text: '100% free - no ads, no subscriptions'),
              const _Bullet(text: 'Privacy first - no login, no tracking'),
              const _Bullet(text: 'Works offline for active alarms'),
              const Spacer(),
              NomadPrimaryButton(
                label: 'Get Started',
                onPressed: () async {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .completeWelcome();
                  if (context.mounted) {
                    context.go('/permissions');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
