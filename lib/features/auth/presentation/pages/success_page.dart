import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_brand_block.dart';
import '../widgets/auth_page_shell.dart';

/// Route payload for [SuccessPage] so the same layout can confirm a sign-up,
/// a password reset or any other completed auth step.
class SuccessArgs {
  const SuccessArgs({
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  final String title;
  final String subtitle;
  final String buttonText;
}

class SuccessPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  /// Leading icon for the action button. Pass `null` for a text-only button.
  final IconData? buttonIcon;

  const SuccessPage({
    super.key,
    this.title = 'Password reset successful!',
    this.subtitle = 'Your password has been reset successfully.',
    this.buttonText = 'Back to Login',
    this.onButtonPressed,
    this.buttonIcon = Icons.arrow_back_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final tight = MediaQuery.sizeOf(context).height < 720;

    return AuthPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthBrandBlock(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: buttonText,
                    icon: buttonIcon,
                    onPressed:
                        onButtonPressed ??
                        () {
                          NavigationService.pushNamedAndRemoveUntil(
                            RouteNames.login,
                            (route) => false,
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tight ? 16 : 56),
        ],
      ),
    );
  }
}
