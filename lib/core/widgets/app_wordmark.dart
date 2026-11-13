import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../constants/app_constants.dart';

/// Two-tone "GoQueue" wordmark used across the app's branded headers.
class AppWordmark extends StatelessWidget {
  const AppWordmark({super.key, this.fontSize = 38});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppConstants.appName,
      excludeSemantics: true,
      child: Text.rich(
        const TextSpan(
          children: [
            TextSpan(
              text: 'Go',
              style: TextStyle(color: AppColors.primary),
            ),
            TextSpan(
              text: 'Queue',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -fontSize * 0.032,
          height: 1.1,
        ),
      ),
    );
  }
}
