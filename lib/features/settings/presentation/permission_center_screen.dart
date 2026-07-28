import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/permission_service.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
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
    return NomadScaffold(
      title: 'Permission Center',
      showBackButton: true,
      body: _statuses == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: PermissionService.permissionSteps.map((info) {
                final status = _statuses![info.type] ?? PermissionStatus.denied;
                return ListTile(
                  title: Text(info.title),
                  subtitle: Text(_statusLabel(status)),
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
                          child: const Text('Fix'),
                        ),
                );
              }).toList(),
            ),
    );
  }

  String _statusLabel(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => 'Granted',
      PermissionStatus.denied => 'Denied',
      PermissionStatus.permanentlyDenied =>
        'Permanently denied - open settings',
      PermissionStatus.restricted => 'Restricted',
      PermissionStatus.limited => 'Limited',
      PermissionStatus.provisional => 'Provisional',
    };
  }
}
