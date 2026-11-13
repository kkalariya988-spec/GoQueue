import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/navigation_service.dart';

/// "← Back to Login" link pinned near the bottom of the recovery screens.
class AuthBackToLogin extends StatelessWidget {
  const AuthBackToLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        NavigationService.pushNamedAndRemoveUntil(
          RouteNames.login,
          (route) => false,
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(
        Icons.arrow_back_rounded,
        size: 18,
        color: AppColors.primary,
      ),
      label: const Text(
        'Back to Login',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
