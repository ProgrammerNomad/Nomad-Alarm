import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/utils/provider_catalog.dart';

class SettingsPickerTile extends StatelessWidget {
  const SettingsPickerTile({
    required this.title,
    required this.valueLabel,
    required this.onTap,
    this.leading,
    super.key,
  });

  final String title;
  final String valueLabel;
  final VoidCallback onTap;
  final IconData? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading == null ? null : Icon(leading),
      title: Text(title),
      subtitle: Text(valueLabel),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

Future<T?> showSettingsPickerSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required T value,
  required String Function(T option) labelFor,
  required String cancelLabel,
  IconData? Function(T option)? iconFor,
  Widget? Function(T option)? trailingFor,
  void Function(T option)? onLongPressFor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: options.map((option) {
                  final selected = option == value;
                  final icon = iconFor?.call(option);
                  final trailing = trailingFor?.call(option);
                  return ListTile(
                    leading: icon == null ? null : Icon(icon),
                    title: Text(labelFor(option)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (trailing != null) ...[
                          trailing,
                          const SizedBox(width: 8),
                        ],
                        if (selected)
                          Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                    onTap: () => Navigator.pop(context, option),
                    onLongPress: onLongPressFor == null
                        ? null
                        : () {
                            Navigator.pop(context);
                            onLongPressFor(option);
                          },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(cancelLabel),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class SettingsSegmentedControl<T> extends StatelessWidget {
  const SettingsSegmentedControl({
    required this.options,
    required this.value,
    required this.labelFor,
    required this.onChanged,
    super.key,
  });

  final List<T> options;
  final T value;
  final String Function(T option) labelFor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<T>(
        segments: options
            .map(
              (option) => ButtonSegment<T>(
                value: option,
                label: Text(labelFor(option)),
              ),
            )
            .toList(),
        selected: {value},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) {
            onChanged(selection.first);
          }
        },
      ),
    );
  }
}

class SettingsRadioGroup<T> extends StatelessWidget {
  const SettingsRadioGroup({
    required this.title,
    required this.options,
    required this.value,
    required this.labelFor,
    required this.onChanged,
    this.subtitle,
    this.headerIcon,
    this.iconFor,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? headerIcon;
  final List<T> options;
  final T value;
  final String Function(T option) labelFor;
  final IconData? Function(T option)? iconFor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              if (headerIcon != null) ...[
                Icon(
                  headerIcon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.titleSmall),
              ),
            ],
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ...options.map(
          (option) {
            final icon = iconFor?.call(option);
            return RadioListTile<T>(
              title: Text(labelFor(option)),
              secondary: icon == null ? null : Icon(icon),
              value: option,
              groupValue: value,
              onChanged: (selected) {
                if (selected != null) {
                  onChanged(selected);
                }
              },
            );
          },
        ),
      ],
    );
  }
}

class SettingsChoiceChipRow extends StatelessWidget {
  const SettingsChoiceChipRow({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(options[i]),
                selected: selectedIndex == i,
                onSelected: (_) => onSelected(i),
              ),
            ),
        ],
      ),
    );
  }
}

class ProviderBadge extends StatelessWidget {
  const ProviderBadge({required this.kind, super.key});

  final ProviderBadgeKind kind;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (kind) {
      ProviderBadgeKind.free => ('FREE', Colors.green),
      ProviderBadgeKind.apiKeyRequired => ('API key', Colors.orange),
      ProviderBadgeKind.advanced => ('Advanced', Colors.blueGrey),
      ProviderBadgeKind.recommended => ('Recommended', Theme.of(context).colorScheme.primary),
    };

    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide(color: color.withValues(alpha: 0.5)),
      backgroundColor: color.withValues(alpha: 0.08),
    );
  }
}

class ProviderSummaryRow extends StatelessWidget {
  const ProviderSummaryRow({
    required this.title,
    required this.valueLabel,
    this.badge,
    super.key,
  });

  final String title;
  final String valueLabel;
  final ProviderBadgeKind? badge;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(valueLabel),
      trailing: badge == null ? null : ProviderBadge(kind: badge!),
    );
  }
}

class PendingChangesBar extends StatelessWidget {
  const PendingChangesBar({
    required this.hasChanges,
    required this.onSave,
    required this.saveLabel,
    super.key,
  });

  final bool hasChanges;
  final VoidCallback? onSave;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: hasChanges ? onSave : null,
          child: Text(saveLabel),
        ),
      ),
    );
  }
}
