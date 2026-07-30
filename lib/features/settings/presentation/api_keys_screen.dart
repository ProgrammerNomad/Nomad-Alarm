import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import 'package:nomad_alarm/services/google_maps_init.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiKeysScreen extends ConsumerStatefulWidget {
  const ApiKeysScreen({super.key});

  @override
  ConsumerState<ApiKeysScreen> createState() => _ApiKeysScreenState();
}

class _ApiKeysScreenState extends ConsumerState<ApiKeysScreen> {
  GoogleApiKeyTestStatus? _googleStatus;
  final _configured = <ApiKeyId, bool>{};
  var _loading = true;
  var _testingAll = false;
  ApiKeyId? _busyProvider;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final store = ref.read(apiKeyStoreProvider);
    final googleKey = await store.readGoogleApiKey();
    GoogleApiKeyTestStatus? googleStatus;
    if (googleKey != null && googleKey.isNotEmpty) {
      googleStatus = await store.testGoogleApiKeyStatus();
    }
    final configured = <ApiKeyId, bool>{};
    for (final id in ApiKeyId.otherProviders) {
      final value = await store.read(id);
      configured[id] = value != null && value.isNotEmpty;
    }
    if (mounted) {
      setState(() {
        _googleStatus = googleStatus;
        _configured
          ..clear()
          ..addAll(configured);
        _loading = false;
      });
    }
  }

  Future<void> _testAll() async {
    final l10n = context.l10n;
    setState(() => _testingAll = true);
    await ref.read(apiKeyStoreProvider).testAllConfiguredKeys();
    await _refresh();
    if (mounted) {
      setState(() => _testingAll = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.apiKeyTestSuccess)),
      );
    }
  }

  Future<void> _editGoogle() async {
    final l10n = context.l10n;
    final store = ref.read(apiKeyStoreProvider);
    final existing = await store.readGoogleApiKey() ?? '';
    final controller = TextEditingController(text: existing);
    var obscure = true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.apiKeyGoogle),
          content: StatefulBuilder(
            builder: (context, setState) {
              return TextField(
                controller: controller,
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: l10n.apiKeyGoogleHint,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.saveKey),
            ),
          ],
        );
      },
    );
    if (saved != true) {
      controller.dispose();
      return;
    }
    await store.writeGoogleApiKey(controller.text);
    await GoogleMapsInit.applyKey(controller.text.trim());
    ref.invalidate(googleApiKeyProvider);
    controller.dispose();
    await _refresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.apiKeySaved)),
      );
    }
  }

  Future<void> _editOther(ApiKeyId id) async {
    final l10n = context.l10n;
    final store = ref.read(apiKeyStoreProvider);
    final existing = await store.read(id) ?? '';
    final controller = TextEditingController(text: existing);
    var obscure = true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_providerTitle(l10n, id)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return TextField(
                controller: controller,
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: _providerHint(l10n, id),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.saveKey),
            ),
          ],
        );
      },
    );
    if (saved != true) {
      controller.dispose();
      return;
    }
    await store.write(id, controller.text);
    controller.dispose();
    await _refresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.apiKeySaved)),
      );
    }
  }

  Future<void> _testGoogle() async {
    final l10n = context.l10n;
    setState(() => _busyProvider = ApiKeyId.googleMaps);
    final status = await ref.read(apiKeyStoreProvider).testGoogleApiKeyStatus();
    if (mounted) {
      setState(() {
        _googleStatus = status;
        _busyProvider = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status.allPassed ? l10n.apiKeyTestSuccess : l10n.apiKeyTestFailure,
          ),
        ),
      );
    }
  }

  Future<void> _testOther(ApiKeyId id) async {
    final l10n = context.l10n;
    setState(() => _busyProvider = id);
    final ok = await ref.read(apiKeyStoreProvider).testConnection(id);
    if (mounted) {
      setState(() => _busyProvider = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? l10n.apiKeyTestSuccess : l10n.apiKeyTestFailure),
        ),
      );
    }
  }

  Future<void> _clearGoogle() async {
    await ref.read(apiKeyStoreProvider).clearGoogleApiKey();
    ref.invalidate(googleApiKeyProvider);
    await _refresh();
  }

  Future<void> _clearOther(ApiKeyId id) async {
    await ref.read(apiKeyStoreProvider).clear(id);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NomadScaffold(
      title: l10n.advancedApiKeys,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.apiKeysIntro,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                _ProviderCard(
                  title: l10n.mapProviderGoogle,
                  configured: _googleStatus != null,
                  children: [
                    _ServiceStatusRow(
                      label: l10n.googleServiceMaps,
                      ok: _googleStatus?.maps,
                    ),
                    _ServiceStatusRow(
                      label: l10n.googleServicePlaces,
                      ok: _googleStatus?.places,
                    ),
                    _ServiceStatusRow(
                      label: l10n.googleServiceDirections,
                      ok: _googleStatus?.directions,
                    ),
                  ],
                  onUpdate: _editGoogle,
                  onTest: _googleStatus != null ? _testGoogle : null,
                  onClear: _googleStatus != null ? _clearGoogle : null,
                  busy: _busyProvider == ApiKeyId.googleMaps,
                  updateLabel: _googleStatus != null
                      ? l10n.apiKeyUpdate
                      : l10n.apiKeyAdd,
                  testLabel: l10n.apiKeyTest,
                  clearLabel: l10n.apiKeyClear,
                ),
                _ProviderCard(
                  title: l10n.mapProviderMapbox,
                  configured: _configured[ApiKeyId.mapboxToken] ?? false,
                  children: [
                    Text(
                      (_configured[ApiKeyId.mapboxToken] ?? false)
                          ? l10n.apiKeyStatusConfigured
                          : l10n.apiKeyStatusNotConfigured,
                    ),
                  ],
                  onUpdate: () => _editOther(ApiKeyId.mapboxToken),
                  onTest: (_configured[ApiKeyId.mapboxToken] ?? false)
                      ? () => _testOther(ApiKeyId.mapboxToken)
                      : null,
                  onClear: (_configured[ApiKeyId.mapboxToken] ?? false)
                      ? () => _clearOther(ApiKeyId.mapboxToken)
                      : null,
                  busy: _busyProvider == ApiKeyId.mapboxToken,
                  updateLabel: (_configured[ApiKeyId.mapboxToken] ?? false)
                      ? l10n.apiKeyUpdate
                      : l10n.apiKeyAdd,
                  testLabel: l10n.apiKeyTest,
                  clearLabel: l10n.apiKeyClear,
                ),
                _ProviderCard(
                  title: l10n.mapProviderHere,
                  configured: _configured[ApiKeyId.hereApiKey] ?? false,
                  children: [
                    Text(
                      (_configured[ApiKeyId.hereApiKey] ?? false)
                          ? l10n.apiKeyStatusConfigured
                          : l10n.apiKeyStatusNotConfigured,
                    ),
                  ],
                  onUpdate: () => _editOther(ApiKeyId.hereApiKey),
                  onTest: (_configured[ApiKeyId.hereApiKey] ?? false)
                      ? () => _testOther(ApiKeyId.hereApiKey)
                      : null,
                  onClear: (_configured[ApiKeyId.hereApiKey] ?? false)
                      ? () => _clearOther(ApiKeyId.hereApiKey)
                      : null,
                  busy: _busyProvider == ApiKeyId.hereApiKey,
                  updateLabel: (_configured[ApiKeyId.hereApiKey] ?? false)
                      ? l10n.apiKeyUpdate
                      : l10n.apiKeyAdd,
                  testLabel: l10n.apiKeyTest,
                  clearLabel: l10n.apiKeyClear,
                ),
                _ProviderCard(
                  title: l10n.routeProviderGraphhopper,
                  configured: _configured[ApiKeyId.graphhopperKey] ?? false,
                  children: [
                    Text(
                      (_configured[ApiKeyId.graphhopperKey] ?? false)
                          ? l10n.apiKeyStatusConfigured
                          : l10n.apiKeyStatusNotConfigured,
                    ),
                  ],
                  onUpdate: () => _editOther(ApiKeyId.graphhopperKey),
                  onTest: (_configured[ApiKeyId.graphhopperKey] ?? false)
                      ? () => _testOther(ApiKeyId.graphhopperKey)
                      : null,
                  onClear: (_configured[ApiKeyId.graphhopperKey] ?? false)
                      ? () => _clearOther(ApiKeyId.graphhopperKey)
                      : null,
                  busy: _busyProvider == ApiKeyId.graphhopperKey,
                  updateLabel:
                      (_configured[ApiKeyId.graphhopperKey] ?? false)
                      ? l10n.apiKeyUpdate
                      : l10n.apiKeyAdd,
                  testLabel: l10n.apiKeyTest,
                  clearLabel: l10n.apiKeyClear,
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _testingAll ? null : _testAll,
                  icon: _testingAll
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.fact_check_outlined),
                  label: Text(l10n.testAllConfiguredKeys),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.apiKeysSecurityFooter),
                  dense: true,
                ),
                TextButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(AppConstants.settingsGuideUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.menu_book_outlined),
                  label: Text(l10n.apiKeyGoogleHelp),
                ),
              ],
            ),
    );
  }

  String _providerTitle(dynamic l10n, ApiKeyId id) {
    return switch (id) {
      ApiKeyId.mapboxToken => l10n.apiKeyMapbox,
      ApiKeyId.hereApiKey => l10n.apiKeyHere,
      ApiKeyId.graphhopperKey => l10n.apiKeyGraphhopper,
      _ => id.storageKey,
    };
  }

  String _providerHint(dynamic l10n, ApiKeyId id) {
    return switch (id) {
      ApiKeyId.mapboxToken => l10n.apiKeyMapboxHint,
      ApiKeyId.hereApiKey => l10n.apiKeyHereHint,
      ApiKeyId.graphhopperKey => l10n.apiKeyGraphhopperHint,
      _ => '',
    };
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    required this.title,
    required this.configured,
    required this.children,
    required this.onUpdate,
    required this.updateLabel,
    required this.testLabel,
    required this.clearLabel,
    this.onTest,
    this.onClear,
    this.busy = false,
  });

  final String title;
  final bool configured;
  final List<Widget> children;
  final VoidCallback onUpdate;
  final VoidCallback? onTest;
  final VoidCallback? onClear;
  final String updateLabel;
  final String testLabel;
  final String clearLabel;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...children,
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: onUpdate,
                  child: Text(updateLabel),
                ),
                if (onTest != null)
                  OutlinedButton(
                    onPressed: busy ? null : onTest,
                    child: busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(testLabel),
                  ),
                if (onClear != null)
                  TextButton(
                    onPressed: onClear,
                    child: Text(clearLabel),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceStatusRow extends StatelessWidget {
  const _ServiceStatusRow({required this.label, this.ok});

  final String label;
  final bool? ok;

  @override
  Widget build(BuildContext context) {
    final icon = ok == null
        ? Icons.help_outline
        : ok!
            ? Icons.check_circle
            : Icons.cancel;
    final color = ok == null
        ? Theme.of(context).colorScheme.outline
        : ok!
            ? Colors.green
            : Theme.of(context).colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
