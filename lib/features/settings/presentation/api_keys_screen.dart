import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class ApiKeysScreen extends ConsumerStatefulWidget {
  const ApiKeysScreen({super.key});

  @override
  ConsumerState<ApiKeysScreen> createState() => _ApiKeysScreenState();
}

class _ApiKeysScreenState extends ConsumerState<ApiKeysScreen> {
  final _controllers = <ApiKeyId, TextEditingController>{};
  final _obscure = <ApiKeyId, bool>{};
  ApiKeyId? _testing;

  @override
  void initState() {
    super.initState();
    for (final id in ApiKeyId.values) {
      _controllers[id] = TextEditingController();
      _obscure[id] = true;
    }
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    final store = ref.read(apiKeyStoreProvider);
    final keys = await store.readAll();
    for (final entry in keys.entries) {
      _controllers[entry.key]?.text = entry.value ?? '';
    }
    if (mounted) {
      setState(() {});
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
    setState(() => _testing = id);
    final ok = await ref.read(apiKeyStoreProvider).testConnection(id);
    if (mounted) {
      setState(() => _testing = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? l10n.apiKeyTestSuccess : l10n.apiKeyTestFailure),
        ),
      );
    }
  }

  @override
  void dispose() {
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
          for (final id in ApiKeyId.values) ...[
            TextField(
              controller: _controllers[id],
              obscureText: _obscure[id] ?? true,
              decoration: InputDecoration(
                labelText: _label(l10n, id),
                hintText: _hint(l10n, id),
                suffixIcon: IconButton(
                  icon: Icon(
                    (_obscure[id] ?? true)
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscure[id] = !(_obscure[id] ?? true)),
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
                  onPressed: _testing == id ? null : () => _testKey(id),
                  child: _testing == id
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
      ApiKeyId.googleMaps => l10n.apiKeyGoogleMaps,
      ApiKeyId.googlePlaces => l10n.apiKeyGooglePlaces,
      ApiKeyId.googleDirections => l10n.apiKeyGoogleDirections,
      ApiKeyId.mapboxToken => l10n.apiKeyMapbox,
      ApiKeyId.hereApiKey => l10n.apiKeyHere,
      ApiKeyId.graphhopperKey => l10n.apiKeyGraphhopper,
    };
  }

  String _hint(dynamic l10n, ApiKeyId id) {
    return switch (id) {
      ApiKeyId.googleMaps => l10n.apiKeyGoogleMapsHint,
      ApiKeyId.googlePlaces => l10n.apiKeyGooglePlacesHint,
      ApiKeyId.googleDirections => l10n.apiKeyGoogleDirectionsHint,
      ApiKeyId.mapboxToken => l10n.apiKeyMapboxHint,
      ApiKeyId.hereApiKey => l10n.apiKeyHereHint,
      ApiKeyId.graphhopperKey => l10n.apiKeyGraphhopperHint,
    };
  }
}
