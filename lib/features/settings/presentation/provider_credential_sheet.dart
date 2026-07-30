import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import 'package:nomad_alarm/services/google_maps_init.dart';
import 'package:url_launcher/url_launcher.dart';

/// Prompts for missing API credentials. Returns true when keys were saved.
Future<bool> showProviderCredentialSheet(
  BuildContext context,
  WidgetRef ref, {
  required List<CredentialRequirement> requirements,
}) async {
  if (requirements.isEmpty) {
    return true;
  }

  final googleKinds = requirements
      .where((r) => r.apiKeyId == ApiKeyId.googleMaps)
      .map((r) => r.kind)
      .toSet();
  if (googleKinds.isNotEmpty) {
    return _showGoogleSheet(context, ref, kinds: googleKinds);
  }

  final requirement = requirements.first;
  return switch (requirement.kind) {
    CredentialKind.mapbox => _showSingleKeySheet(
        context,
        ref,
        title: context.l10n.credentialMapboxTitle,
        body: context.l10n.credentialMapboxBody,
        hint: context.l10n.apiKeyMapboxHint,
        onSave: (value) => ref.read(apiKeyStoreProvider).write(
              ApiKeyId.mapboxToken,
              value,
            ),
      ),
    CredentialKind.here => _showSingleKeySheet(
        context,
        ref,
        title: context.l10n.credentialHereTitle,
        body: context.l10n.credentialHereBody,
        hint: context.l10n.apiKeyHereHint,
        onSave: (value) => ref.read(apiKeyStoreProvider).write(
              ApiKeyId.hereApiKey,
              value,
            ),
      ),
    CredentialKind.graphhopper => _showSingleKeySheet(
        context,
        ref,
        title: context.l10n.credentialGraphhopperTitle,
        body: context.l10n.credentialGraphhopperBody,
        hint: context.l10n.apiKeyGraphhopperHint,
        onSave: (value) => ref.read(apiKeyStoreProvider).write(
              ApiKeyId.graphhopperKey,
              value,
            ),
      ),
    _ => false,
  };
}

Future<bool> _showGoogleSheet(
  BuildContext context,
  WidgetRef ref, {
  required Set<CredentialKind> kinds,
}) async {
  final l10n = context.l10n;
  final controller = TextEditingController();
  var obscure = true;

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  kinds.contains(CredentialKind.googleMaps)
                      ? l10n.credentialGoogleMapsTitle
                      : l10n.credentialGoogleServicesTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(l10n.credentialGoogleMapsBody),
                const SizedBox(height: 12),
                if (kinds.contains(CredentialKind.googleMaps))
                  Text('• ${l10n.googleServiceMaps}'),
                if (kinds.contains(CredentialKind.googlePlaces))
                  Text('• ${l10n.googleServicePlaces}'),
                if (kinds.contains(CredentialKind.googleDirections))
                  Text('• ${l10n.googleServiceDirections}'),
                const SizedBox(height: 8),
                Text(
                  l10n.googleServiceAlsoUsed,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: l10n.apiKeyGoogle,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(AppConstants.settingsGuideGoogleSetupUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.help_outline),
                  label: Text(l10n.apiKeyGoogleHelp),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final value = controller.text.trim();
                          if (value.isEmpty) {
                            return;
                          }
                          final store = ref.read(apiKeyStoreProvider);
                          await store.writeGoogleApiKey(value);
                          await GoogleMapsInit.applyKey(value);
                          ref.invalidate(googleApiKeyProvider);
                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text(l10n.configureAndSave),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );

  controller.dispose();
  return result ?? false;
}

Future<bool> _showSingleKeySheet(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String body,
  required String hint,
  required Future<void> Function(String value) onSave,
}) async {
  final l10n = context.l10n;
  final controller = TextEditingController();
  var obscure = true;

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(body),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    hintText: hint,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final value = controller.text.trim();
                          if (value.isEmpty) {
                            return;
                          }
                          await onSave(value);
                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text(l10n.configureAndSave),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );

  controller.dispose();
  return result ?? false;
}
