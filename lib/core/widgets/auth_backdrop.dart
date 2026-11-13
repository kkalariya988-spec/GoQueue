import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Soft pink wash with ambient glows used behind every auth screen.
class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    // Keep the glows proportional on tablets and web instead of pinning them
    // to phone-sized values.
    final widthScale = (MediaQuery.sizeOf(context).width / 402)
        .clamp(0.8, 2.0)
        .toDouble();

    return IgnorePointer(
      child: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFDF3F8), AppColors.background],
                stops: [0.0, 0.5],
              ),
            ),
            child: SizedBox.expand(),
          ),
          Positioned(
            top: -150 * widthScale,
            left: -130 * widthScale,
            child: _Glow(
              size: 380 * widthScale,
              color: AppColors.primaryLight.withValues(alpha: 0.20),
            ),
          ),
          Positioned(
            top: -90 * widthScale,
            right: -140 * widthScale,
            child: _Glow(
              size: 320 * widthScale,
              color: AppColors.primary.withValues(alpha: 0.07),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}
