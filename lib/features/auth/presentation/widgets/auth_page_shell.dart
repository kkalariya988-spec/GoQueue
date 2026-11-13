import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/auth_backdrop.dart';

/// Responsive scaffold shared by every auth screen.
///
/// Handles the pink backdrop, safe area, keyboard-aware scrolling and adaptive
/// gutters. The form column is measured at its final width (important on wide
/// windows, where the max width caps the form and text wraps more) and is given
/// the viewport height as a minimum so `Spacer`/`Expanded` pages pin their
/// footers correctly.
class AuthPageShell extends StatelessWidget {
  const AuthPageShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const AuthBackdrop(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = Responsive.horizontalPadding(context);
                final availableWidth = constraints.maxWidth - horizontal * 2;
                final contentWidth = availableWidth < Responsive.formMaxWidth
                    ? availableWidth
                    : Responsive.formMaxWidth;

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Center(
                    child: SizedBox(
                      width: contentWidth,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
