import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/features/about/presentation/licenses_screen.dart';
import 'package:nomad_alarm/shared/widgets/nomad_logo.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '…';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _version = info.version);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NomadScaffold(
      title: l10n.aboutTitle,
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
          Text(l10n.versionLabel(_version)),
          const SizedBox(height: 8),
          Text(l10n.developedBy),
          const SizedBox(height: 24),
          Text(
            l10n.aboutTagline,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LicensesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.article_outlined),
            label: Text(l10n.openSourceLicenses),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => launchUrl(Uri.parse(AppConstants.githubUrl)),
            icon: const Icon(Icons.code),
            label: Text(l10n.viewOnGitHub),
          ),
        ],
      ),
    );
  }
}
