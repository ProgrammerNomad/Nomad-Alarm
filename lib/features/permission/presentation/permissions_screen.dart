import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/ui_constants.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/l10n/permission_l10n.dart';
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

  List<PermissionInfo> get _steps => localizedPermissionSteps(context.l10n);

  PermissionInfo get _current => _steps[_step];

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
    if (_step < _steps.length - 1) {
      setState(() => _step++);
      return;
    }
    await ref.read(settingsControllerProvider.notifier).completePermissions();
    if (mounted) {
      context.go('/alarms');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = _steps;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.permissionsTitle(_step + 1, steps.length)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(UiConstants.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_step + 1) / steps.length,
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
            NomadPrimaryButton(label: l10n.grant, onPressed: _grant),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: UiConstants.minTouchTarget,
              child: TextButton(
                onPressed: _current.skippable ? _skip : null,
                child: Text(_current.skippable ? l10n.skipForNow : l10n.required),
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
      NomadPermissionType.exactAlarm => Icons.alarm_outlined,
      NomadPermissionType.batteryOptimization => Icons.battery_charging_full_outlined,
    };
  }
}
