import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'app_wordmark.dart';

/// Brand lock-up used at the top of auth and splash screens:
/// the [AppWordmark] with the optional "ONLINE SALON BOOKING" tagline.
class AppBrandHeader extends StatelessWidget {
  const AppBrandHeader({
    super.key,
    this.showTagline = true,
    this.wordmarkSize = 38,
  });

  final bool showTagline;
  final double wordmarkSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppWordmark(fontSize: wordmarkSize),
        if (showTagline) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'ONLINE SALON BOOKING',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              color: AppColors.primary.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Book. Relax. Enjoy.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ],
    );
  }
}
