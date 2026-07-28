import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/ui_constants.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/services/permission_service.dart';
import 'package:nomad_alarm/shared/widgets/nomad_primary_button.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  int _step = 0;

  PermissionInfo get _current => PermissionService.permissionSteps[_step];

  Future<void> _grant() async {
    final service = ref.read(permissionServiceProvider);
    final status = await service.request(_current.permission);
    if (!mounted) {
      return;
    }
    if (status.isPermanentlyDenied) {
      await service.openSettings();
      return;
    }
    _next();
  }

  void _skip() => _next();

  Future<void> _next() async {
    if (_step < PermissionService.permissionSteps.length - 1) {
      setState(() => _step++);
      return;
    }
    await ref.read(settingsControllerProvider.notifier).completePermissions();
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permissions (${_step + 1}/${PermissionService.permissionSteps.length})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(UiConstants.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_step + 1) / PermissionService.permissionSteps.length,
            ),
            const SizedBox(height: 32),
            Icon(
              _iconFor(_current.type),
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              _current.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              _current.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            NomadPrimaryButton(label: 'Grant', onPressed: _grant),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: UiConstants.minTouchTarget,
              child: TextButton(
                onPressed: _skip,
                child: const Text('Skip for now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(NomadPermissionType type) {
    return switch (type) {
      NomadPermissionType.location => Icons.location_on_outlined,
      NomadPermissionType.notification => Icons.notifications_outlined,
      NomadPermissionType.backgroundLocation => Icons.my_location_outlined,
    };
  }
}
