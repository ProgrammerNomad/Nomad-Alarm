import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/api_key_store.dart';
import 'package:nomad_alarm/services/google_maps_init.dart';
import 'package:url_launcher/url_launcher.dart';

/// Inline credential flow when selecting a map provider.
Future<bool> showMapProviderCredentialSheet(
  BuildContext context,
  WidgetRef ref, {
  required MapProviderType provider,
}) async {
  return switch (provider) {
    MapProviderType.google => _showGoogleCredentialSheet(context, ref),
    MapProviderType.mapbox => _showSingleKeyCredentialSheet(
        context,
        ref,
        provider: provider,
        title: context.l10n.credentialMapboxTitle,
        body: context.l10n.credentialMapboxBody,
        hint: context.l10n.apiKeyMapboxHint,
        apiKeyId: ApiKeyId.mapboxToken,
      ),
    MapProviderType.here => _showSingleKeyCredentialSheet(
        context,
        ref,
        provider: provider,
        title: context.l10n.credentialHereTitle,
        body: context.l10n.credentialHereBody,
        hint: context.l10n.apiKeyHereHint,
        apiKeyId: ApiKeyId.hereApiKey,
      ),
    MapProviderType.osm || MapProviderType.apple => Future.value(true),
  };
}

/// Manage credentials for a configured map provider.
Future<void> showManageProviderCredentialsSheet(
  BuildContext context,
  WidgetRef ref, {
  required MapProviderType provider,
}) async {
  final l10n = context.l10n;
  final providerLabel = _mapProviderLabel(l10n, provider);

  await showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                providerLabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(l10n.providerConfigured),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.editCredentials),
              onTap: () async {
                Navigator.pop(context);
                await showMapProviderCredentialSheet(
                  context,
                  ref,
                  provider: provider,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.wifi_tethering),
              title: Text(l10n.testConnection),
              onTap: () async {
                Navigator.pop(context);
                await _runProviderConnectionTest(context, ref, provider);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                l10n.removeCredentials,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _confirmRemoveCredentials(context, ref, provider);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _confirmRemoveCredentials(
  BuildContext context,
  WidgetRef ref,
  MapProviderType provider,
) async {
  final l10n = context.l10n;
  final providerLabel = _mapProviderLabel(l10n, provider);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.removeCredentials),
      content: Text(l10n.removeCredentialsConfirm(providerLabel)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.removeCredentials),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) {
    return;
  }

  final store = ref.read(apiKeyStoreProvider);
  switch (provider) {
    case MapProviderType.google:
      await store.clearGoogleApiKey();
      ref.invalidate(googleApiKeyProvider);
    case MapProviderType.mapbox:
      await store.clear(ApiKeyId.mapboxToken);
    case MapProviderType.here:
      await store.clear(ApiKeyId.hereApiKey);
    case MapProviderType.osm:
    case MapProviderType.apple:
      break;
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.removeCredentials)),
    );
  }
}

Future<void> _runProviderConnectionTest(
  BuildContext context,
  WidgetRef ref,
  MapProviderType provider,
) async {
  final l10n = context.l10n;
  final store = ref.read(apiKeyStoreProvider);
  var passed = false;

  switch (provider) {
    case MapProviderType.google:
      final status = await store.testGoogleApiKeyStatus();
      passed = status.maps;
    case MapProviderType.mapbox:
      passed = await store.testConnection(ApiKeyId.mapboxToken);
    case MapProviderType.here:
      passed = await store.testConnection(ApiKeyId.hereApiKey);
    case MapProviderType.osm:
    case MapProviderType.apple:
      passed = true;
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(passed ? l10n.testPassed : l10n.testFailed)),
    );
  }
}

/// Prompts for missing API credentials on Save. Returns true when keys were saved.
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
    return _showGoogleCredentialSheet(context, ref);
  }

  final requirement = requirements.first;
  return switch (requirement.kind) {
    CredentialKind.mapbox => _showSingleKeyCredentialSheet(
        context,
        ref,
        provider: MapProviderType.mapbox,
        title: context.l10n.credentialMapboxTitle,
        body: context.l10n.credentialMapboxBody,
        hint: context.l10n.apiKeyMapboxHint,
        apiKeyId: ApiKeyId.mapboxToken,
      ),
    CredentialKind.here => _showSingleKeyCredentialSheet(
        context,
        ref,
        provider: MapProviderType.here,
        title: context.l10n.credentialHereTitle,
        body: context.l10n.credentialHereBody,
        hint: context.l10n.apiKeyHereHint,
        apiKeyId: ApiKeyId.hereApiKey,
      ),
    CredentialKind.graphhopper => _showSingleKeyCredentialSheet(
        context,
        ref,
        provider: null,
        title: context.l10n.credentialGraphhopperTitle,
        body: context.l10n.credentialGraphhopperBody,
        hint: context.l10n.apiKeyGraphhopperHint,
        apiKeyId: ApiKeyId.graphhopperKey,
        saveLabel: context.l10n.configureAndSave,
      ),
    _ => false,
  };
}

Future<bool> _showGoogleCredentialSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _GoogleCredentialSheet(ref: ref),
  );
  return result ?? false;
}

Future<bool> _showSingleKeyCredentialSheet(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String body,
  required String hint,
  required ApiKeyId apiKeyId,
  MapProviderType? provider,
  String? saveLabel,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _SingleKeyCredentialSheet(
      ref: ref,
      title: title,
      body: body,
      hint: hint,
      apiKeyId: apiKeyId,
      provider: provider,
      saveLabel: saveLabel,
    ),
  );
  return result ?? false;
}

String _mapProviderLabel(dynamic l10n, MapProviderType type) {
  return switch (type) {
    MapProviderType.osm => l10n.mapProviderOsm,
    MapProviderType.google => l10n.mapProviderGoogle,
    MapProviderType.mapbox => l10n.mapProviderMapbox,
    MapProviderType.here => l10n.mapProviderHere,
    MapProviderType.apple => l10n.mapProviderApple,
  };
}

class _GoogleCredentialSheet extends ConsumerStatefulWidget {
  const _GoogleCredentialSheet({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_GoogleCredentialSheet> createState() =>
      _GoogleCredentialSheetState();
}

class _GoogleCredentialSheetState extends ConsumerState<_GoogleCredentialSheet> {
  late final TextEditingController _controller = TextEditingController();
  var _obscure = true;
  var _testing = false;
  GoogleApiKeyTestStatus? _testStatus;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final existing =
        await widget.ref.read(apiKeyStoreProvider).readGoogleApiKey() ?? '';
    if (mounted) {
      _controller.text = existing;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSave {
    final key = _controller.text.trim();
    return key.isNotEmpty && _testStatus?.maps == true;
  }

  Future<void> _test() async {
    final key = _controller.text.trim();
    if (key.isEmpty) {
      return;
    }
    setState(() {
      _testing = true;
      _testStatus = null;
    });
    final store = widget.ref.read(apiKeyStoreProvider);
    final status = await store.testGoogleApiKeyStatus(
      mapsKey: key,
      placesKey: key,
      directionsKey: key,
    );
    if (mounted) {
      setState(() {
        _testing = false;
        _testStatus = status;
      });
    }
  }

  Future<void> _save() async {
    if (!_canSave) {
      return;
    }
    final key = _controller.text.trim();
    final store = widget.ref.read(apiKeyStoreProvider);
    await store.writeGoogleApiKey(key);
    await GoogleMapsInit.applyKey(key);
    widget.ref.invalidate(googleApiKeyProvider);
    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  String _serviceTestLabel(dynamic l10n, String service, bool passed) {
    return passed
        ? l10n.googleTestResultOk(service)
        : l10n.googleTestResultFailed(service);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.credentialGoogleMapsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(l10n.credentialGoogleMapsBody),
          const SizedBox(height: 8),
          Text(l10n.credentialRequired, style: _labelStyle(context)),
          Text('• ${l10n.googleServiceMaps}'),
          Text('• ${l10n.googleServicePlaces}'),
          Text('• ${l10n.googleServiceDirections}'),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            obscureText: _obscure,
            onChanged: (_) => setState(() => _testStatus = null),
            decoration: InputDecoration(
              labelText: l10n.apiKeyGoogle,
              hintText: l10n.apiKeyGoogleHint,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
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
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _testing ? null : _test,
            child: _testing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.apiKeyTest),
          ),
          if (_testStatus != null) ...[
            const SizedBox(height: 8),
            Text(
              [
                _serviceTestLabel(l10n, l10n.googleServiceMaps, _testStatus!.maps),
                _serviceTestLabel(
                  l10n,
                  l10n.googleServicePlaces,
                  _testStatus!.places,
                ),
                _serviceTestLabel(
                  l10n,
                  l10n.googleServiceDirections,
                  _testStatus!.directions,
                ),
              ].join(' · '),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _canSave ? _save : null,
            child: Text(l10n.saveAndUseProvider(l10n.mapProviderGoogle)),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  TextStyle? _labelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
  }
}

class _SingleKeyCredentialSheet extends ConsumerStatefulWidget {
  const _SingleKeyCredentialSheet({
    required this.ref,
    required this.title,
    required this.body,
    required this.hint,
    required this.apiKeyId,
    this.provider,
    this.saveLabel,
  });

  final WidgetRef ref;
  final String title;
  final String body;
  final String hint;
  final ApiKeyId apiKeyId;
  final MapProviderType? provider;
  final String? saveLabel;

  @override
  ConsumerState<_SingleKeyCredentialSheet> createState() =>
      _SingleKeyCredentialSheetState();
}

class _SingleKeyCredentialSheetState
    extends ConsumerState<_SingleKeyCredentialSheet> {
  late final TextEditingController _controller = TextEditingController();
  var _obscure = true;
  var _testing = false;
  bool? _testPassed;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final existing =
        await widget.ref.read(apiKeyStoreProvider).read(widget.apiKeyId) ?? '';
    if (mounted) {
      _controller.text = existing;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSave {
    final value = _controller.text.trim();
    return value.isNotEmpty && _testPassed == true;
  }

  Future<void> _test() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return;
    }
    setState(() {
      _testing = true;
      _testPassed = null;
    });
    final store = widget.ref.read(apiKeyStoreProvider);
    await store.write(widget.apiKeyId, value);
    final passed = await store.testConnection(widget.apiKeyId);
    if (mounted) {
      setState(() {
        _testing = false;
        _testPassed = passed;
      });
    }
  }

  Future<void> _save() async {
    if (!_canSave) {
      return;
    }
    final value = _controller.text.trim();
    await widget.ref.read(apiKeyStoreProvider).write(widget.apiKeyId, value);
    if (widget.apiKeyId == ApiKeyId.googleMaps) {
      await GoogleMapsInit.applyKey(value);
      widget.ref.invalidate(googleApiKeyProvider);
    }
    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  String _saveButtonLabel(dynamic l10n) {
    if (widget.saveLabel != null) {
      return widget.saveLabel!;
    }
    if (widget.provider != null) {
      return l10n.saveAndUseProvider(
        _mapProviderLabel(l10n, widget.provider!),
      );
    }
    return l10n.configureAndSave;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(widget.body),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            obscureText: _obscure,
            onChanged: (_) => setState(() => _testPassed = null),
            decoration: InputDecoration(
              hintText: widget.hint,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _testing ? null : _test,
            child: _testing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.apiKeyTest),
          ),
          if (_testPassed != null) ...[
            const SizedBox(height: 8),
            Text(
              _testPassed! ? l10n.testPassed : l10n.testFailed,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _testPassed!
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _canSave ? _save : null,
            child: Text(_saveButtonLabel(l10n)),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}
