import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/constants/ui_constants.dart';

class NomadCard extends StatelessWidget {
  const NomadCard({
    required this.child,
    super.key,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.screenPadding),
        child: child,
      ),
    );
    if (onTap == null) {
      return card;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(UiConstants.cardRadius),
      child: card,
    );
  }
}
