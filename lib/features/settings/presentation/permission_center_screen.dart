import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/l10n/permission_l10n.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/permission_service.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionCenterScreen extends ConsumerStatefulWidget {
  const PermissionCenterScreen({super.key});

  @override
  ConsumerState<PermissionCenterScreen> createState() =>
      _PermissionCenterScreenState();
}

class _PermissionCenterScreenState extends ConsumerState<PermissionCenterScreen> {
  Map<NomadPermissionType, PermissionStatus>? _statuses;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final statuses =
        await ref.read(permissionServiceProvider).getAllStatuses();
    if (mounted) {
      setState(() => _statuses = statuses);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = localizedPermissionSteps(l10n);

    return NomadScaffold(
      title: l10n.permCenterTitle,
      showBackButton: true,
      body: _statuses == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: steps.map((info) {
                final status = _statuses![info.type] ?? PermissionStatus.denied;
                return ListTile(
                  title: Text(info.title),
                  subtitle: Text(_statusLabel(l10n, status)),
                  trailing: status.isGranted
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : TextButton(
                          onPressed: () async {
                            final service =
                                ref.read(permissionServiceProvider);
                            final result =
                                await service.request(info.permission);
                            if (result.isPermanentlyDenied) {
                              await service.openSettings();
                            }
                            await _load();
                          },
                          child: Text(l10n.permFix),
                        ),
                );
              }).toList(),
            ),
    );
  }

  String _statusLabel(AppLocalizations l10n, PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => l10n.permGranted,
      PermissionStatus.denied => l10n.permDenied,
      PermissionStatus.permanentlyDenied => l10n.permPermanentlyDenied,
      PermissionStatus.restricted => 'Restricted',
      PermissionStatus.limited => 'Limited',
      PermissionStatus.provisional => 'Provisional',
    };
  }
}
