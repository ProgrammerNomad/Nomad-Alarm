import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';

class NomadLogo extends StatelessWidget {
  const NomadLogo({
    super.key,
    this.size = 120,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppConstants.logoAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
