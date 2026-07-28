import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/theme/app_colors.dart';

class NomadLogo extends StatelessWidget {
  const NomadLogo({
    super.key,
    this.size = 120,
    this.showBackground = true,
  });

  final double size;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      AppConstants.logoAsset,
      fit: BoxFit.contain,
    );

    if (!showBackground) {
      return SizedBox(
        width: size,
        height: size,
        child: logo,
      );
    }

    final padding = size * 0.18;
    final borderRadius = BorderRadius.circular(size * 0.22);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: size,
        height: size,
        color: AppColors.splashBackground,
        padding: EdgeInsets.all(padding),
        child: logo,
      ),
    );
  }
}
