import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
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
  final _googleController = TextEditingController();
  final _controllers = <ApiKeyId, TextEditingController>{};
  final _obscure = <String, bool>{'google': true};
  var _googleObscure = true;
  var _testingGoogle = false;
  ApiKeyId? _testingOther;

  @override
  void initState() {
    super.initState();
    for (final id in ApiKeyId.otherProviders) {
      _controllers[id] = TextEditingController();
      _obscure[id.storageKey] = true;
    }
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    final store = ref.read(apiKeyStoreProvider);
    final googleKey = await store.readGoogleApiKey();
    _googleController.text = googleKey ?? '';
    final keys = await store.readAll();
    for (final id in ApiKeyId.otherProviders) {
      _controllers[id]?.text = keys[id] ?? '';
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _saveGoogleKey() async {
    final l10n = context.l10n;
    final store = ref.read(apiKeyStoreProvider);
    await store.writeGoogleApiKey(_googleController.text);
    await GoogleMapsInit.applyKey(_googleController.text.trim());
    ref.invalidate(googleApiKeyProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.apiKeySaved)),
      );
    }
  }

  Future<void> _testGoogleKey() async {
    final l10n = context.l10n;
    setState(() => _testingGoogle = true);
    final ok = await ref.read(apiKeyStoreProvider).testGoogleApiKey();
    if (mounted) {
      setState(() => _testingGoogle = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? l10n.apiKeyTestSuccess : l10n.apiKeyTestFailure),
        ),
      );
    }
  }

  Future<void> _saveKey(ApiKeyId id) async {
    final l10n = context.l10n;
    await ref.read(apiKeyStoreProvider).write(id, _controllers[id]!.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.apiKeySaved)),
      );
    }
  }

  Future<void> _testKey(ApiKeyId id) async {
    final l10n = context.l10n;
    setState(() => _testingOther = id);
    final ok = await ref.read(apiKeyStoreProvider).testConnection(id);
    if (mounted) {
      setState(() => _testingOther = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? l10n.apiKeyTestSuccess : l10n.apiKeyTestFailure),
        ),
      );
    }
  }

  Future<void> _openSetupGuide() async {
    final uri = Uri.parse(AppConstants.settingsGuideGoogleSetupUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _googleController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NomadScaffold(
      title: l10n.apiKeysTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.apiKeysIntro, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Text(
            l10n.apiKeyGoogle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _googleController,
            obscureText: _googleObscure,
            decoration: InputDecoration(
              labelText: l10n.apiKeyGoogle,
              hintText: l10n.apiKeyGoogleHint,
              suffixIcon: IconButton(
                icon: Icon(
                  _googleObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _googleObscure = !_googleObscure),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _openSetupGuide,
              icon: const Icon(Icons.help_outline),
              label: Text(l10n.apiKeyGoogleHelp),
            ),
          ),
          Row(
            children: [
              FilledButton(
                onPressed: _saveGoogleKey,
                child: Text(l10n.saveKey),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _testingGoogle ? null : _testGoogleKey,
                child: _testingGoogle
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.apiKeyTest),
              ),
            ],
          ),
          const SizedBox(height: 32),
          for (final id in ApiKeyId.otherProviders) ...[
            TextField(
              controller: _controllers[id],
              obscureText: _obscure[id.storageKey] ?? true,
              decoration: InputDecoration(
                labelText: _label(l10n, id),
                hintText: _hint(l10n, id),
                suffixIcon: IconButton(
                  icon: Icon(
                    (_obscure[id.storageKey] ?? true)
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(
                    () => _obscure[id.storageKey] =
                        !(_obscure[id.storageKey] ?? true),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton(
                  onPressed: () => _saveKey(id),
                  child: Text(l10n.saveKey),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _testingOther == id ? null : () => _testKey(id),
                  child: _testingOther == id
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.apiKeyTest),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  String _label(dynamic l10n, ApiKeyId id) {
    return switch (id) {
      ApiKeyId.mapboxToken => l10n.apiKeyMapbox,
      ApiKeyId.hereApiKey => l10n.apiKeyHere,
      ApiKeyId.graphhopperKey => l10n.apiKeyGraphhopper,
      _ => id.storageKey,
    };
  }

  String _hint(dynamic l10n, ApiKeyId id) {
    return switch (id) {
      ApiKeyId.mapboxToken => l10n.apiKeyMapboxHint,
      ApiKeyId.hereApiKey => l10n.apiKeyHereHint,
      ApiKeyId.graphhopperKey => l10n.apiKeyGraphhopperHint,
      _ => '',
    };
  }
}
