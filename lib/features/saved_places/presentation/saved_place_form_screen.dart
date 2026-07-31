import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/core/utils/favorite_category_utils.dart';
import 'package:nomad_alarm/features/saved_places/presentation/smart_alarm_onboarding_sheet.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class SavedPlaceFormScreen extends ConsumerStatefulWidget {
  const SavedPlaceFormScreen({this.placeId, super.key});

  final int? placeId;

  bool get isEditing => placeId != null;

  @override
  ConsumerState<SavedPlaceFormScreen> createState() =>
      _SavedPlaceFormScreenState();
}

class _SavedPlaceFormScreenState extends ConsumerState<SavedPlaceFormScreen> {
  final _nameController = TextEditingController();
  FavoriteCategory _category = FavoriteCategory.home;
  SmartAlarmMode _smartMode = SmartAlarmMode.off;
  double _triggerDistance = 500;
  double? _latitude;
  double? _longitude;
  String? _address;
  String? _locationLabel;
  bool _loading = true;
  bool _saving = false;
  bool _locating = false;
  Favorite? _existing;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadExisting();
    } else {
      _loading = false;
    }
  }

  Future<void> _loadExisting() async {
    final place =
        await ref.read(favoriteRepositoryProvider).getById(widget.placeId!);
    if (!mounted) {
      return;
    }
    if (place != null) {
      _existing = place;
      _nameController.text = place.name;
      _address = place.address;
      _locationLabel = place.address ?? place.name;
      _category = FavoriteCategoryUtils.normalize(place.category);
      _smartMode = place.smartAlarmMode;
      _triggerDistance = place.triggerDistanceMeters;
      _latitude = place.latitude;
      _longitude = place.longitude;
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final picked = await context.push<DestinationArgs>('/search?pick=place');
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _latitude = picked.latitude;
      _longitude = picked.longitude;
      _address = picked.address;
      _locationLabel = picked.address ?? picked.name;
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = picked.name;
      }
    });
  }

  Future<void> _useCurrentLocation() async {
    final l10n = context.l10n;
    setState(() => _locating = true);
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _address = null;
        _locationLabel =
            '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.currentLocationLabel)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPrefix(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _locating = false);
      }
    }
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final name = _nameController.text.trim();
    if (name.isEmpty || _latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectDestinationFirst)),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      var smartMode = _smartMode;
      if (!widget.isEditing &&
          (_category == FavoriteCategory.home ||
              _category == FavoriteCategory.school)) {
        final picked = await showSmartAlarmOnboardingSheet(
          context,
          placeName: name,
          initial: _smartMode == SmartAlarmMode.off
              ? SmartAlarmMode.automatic
              : _smartMode,
        );
        if (picked != null) {
          smartMode = picked;
        }
      }

      final repo = ref.read(favoriteRepositoryProvider);
      if (widget.isEditing && _existing != null) {
        final updated = _existing!
          ..name = name
          ..address = _address
          ..category = _category
          ..latitude = _latitude!
          ..longitude = _longitude!
          ..smartAlarmMode = smartMode
          ..triggerDistanceMeters = _triggerDistance;
        await repo.update(updated);
      } else {
        await repo.saveNew(
          name: name,
          latitude: _latitude!,
          longitude: _longitude!,
          address: _address,
          category: _category,
          smartAlarmMode: smartMode,
          triggerDistanceMeters: _triggerDistance,
        );
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPrefix(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _delete() async {
    if (_existing == null) {
      return;
    }
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.savedPlacesDelete),
        content: Text(_existing!.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await ref.read(favoriteRepositoryProvider).delete(_existing!.id);
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final useMetric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? true;
    final distanceLabel =
        formatDistance(_triggerDistance, useMetric: useMetric);

    if (_loading) {
      return NomadScaffold(
        title: widget.isEditing ? l10n.savedPlacesEdit : l10n.savedPlacesAdd,
        showBackButton: true,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return NomadScaffold(
      title: widget.isEditing ? l10n.savedPlacesEdit : l10n.savedPlacesAdd,
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.savedPlaceName),
          ),
          const SizedBox(height: 12),
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickLocation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _locationLabel ?? l10n.savedPlaceLocationHint,
                        style: TextStyle(
                          color: _locationLabel != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _locating ? null : _useCurrentLocation,
            icon: _locating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location_outlined),
            label: Text(l10n.currentLocationLabel),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.savedPlaceCategory,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FavoriteCategoryUtils.pickerCategories.map((category) {
              final selected = _category == category;
              final visual = FavoriteCategoryUtils.visual(category);
              final colorScheme = Theme.of(context).colorScheme;
              return ChoiceChip(
                avatar: CircleAvatar(
                  radius: 12,
                  backgroundColor: visual.backgroundFor(colorScheme),
                  child: Icon(
                    visual.icon,
                    size: 18,
                    color: visual.color,
                  ),
                ),
                label: Text(FavoriteCategoryUtils.label(l10n, category)),
                selected: selected,
                onSelected: (_) => setState(() => _category = category),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(l10n.smartAlarm, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<SmartAlarmMode>(
            segments: [
              ButtonSegment(
                value: SmartAlarmMode.off,
                label: Text(l10n.smartAlarmOff),
              ),
              ButtonSegment(
                value: SmartAlarmMode.suggest,
                label: Text(l10n.smartAlarmSuggest),
              ),
              ButtonSegment(
                value: SmartAlarmMode.automatic,
                label: Text(l10n.smartAlarmAutomatic),
              ),
            ],
            selected: {_smartMode},
            onSelectionChanged: (values) {
              setState(() => _smartMode = values.first);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.savedPlacesSmartAlarmHelp,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.defaultAlertDistance,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            distanceLabel,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Slider(
            value: _triggerDistance,
            min: 200,
            max: 2000,
            divisions: 9,
            label: distanceLabel,
            onChanged: (v) => setState(() => _triggerDistance = v),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.savedPlacesSave),
          ),
          if (widget.isEditing) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _delete,
              child: Text(l10n.savedPlacesDelete),
            ),
          ],
        ],
      ),
    );
  }
}
