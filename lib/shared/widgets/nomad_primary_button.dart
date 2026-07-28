import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/constants/ui_constants.dart';

class NomadPrimaryButton extends StatelessWidget {
  const NomadPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: onPressed,
      child: Text(label),
    );
    if (!expanded) {
      return button;
    }
    return SizedBox(
      width: double.infinity,
      height: UiConstants.minTouchTarget,
      child: button,
    );
  }
}
