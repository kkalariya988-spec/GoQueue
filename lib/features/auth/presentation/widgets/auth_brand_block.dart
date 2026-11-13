import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_brand_header.dart';
import '../../../../core/widgets/app_wordmark.dart';

/// Brand header block used at the top of auth screens.
///
/// Wraps the brand lock-up with responsive top/brand gaps and shrinks (or
/// hides the tagline) on short screens so the form keeps breathing room.
class AuthBrandBlock extends StatelessWidget {
  const AuthBrandBlock({
    super.key,
    this.showTagline = true,
    this.showMark = false,
    this.topGapFraction = 0.14,
    this.brandGapFraction = 0.065,
    this.compactTopGap = 32,
    this.compactBrandGap = 24,
  });

  final bool showTagline;

  /// Shows the scissors mark next to the wordmark (used by Create Account).
  final bool showMark;

  final double topGapFraction;
  final double brandGapFraction;
  final double compactTopGap;
  final double compactBrandGap;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 720;

    final topGap = compact
        ? compactTopGap
        : Responsive.verticalGap(
            context,
            fraction: topGapFraction,
            min: 32,
            max: 140,
          );
    final brandGap = compact
        ? compactBrandGap
        : Responsive.verticalGap(
            context,
            fraction: brandGapFraction,
            min: 20,
            max: 56,
          );
    final wordmarkSize = Responsive.wordmarkSize(context, compact: compact);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: topGap),
        if (showMark)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.content_cut_rounded,
                color: AppColors.primary,
                size: wordmarkSize * 0.82,
              ),
              const SizedBox(width: 10),
              AppWordmark(fontSize: wordmarkSize),
            ],
          )
        else
          AppBrandHeader(
            showTagline: showTagline && !compact,
            wordmarkSize: wordmarkSize,
          ),
        SizedBox(height: brandGap),
      ],
    );
  }
}
