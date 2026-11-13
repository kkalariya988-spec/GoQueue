import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_brand_header.dart';

/// Branded launch screen shown while the app bootstraps.
///
/// Displays the GoQueue identity for a short moment, then hands the user to
/// the login flow. There is intentionally no paging/onboarding here.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  static const Duration _holdDuration = Duration(milliseconds: 2400);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _scale = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _navigationTimer = Timer(_holdDuration, _goToLogin);
  }

  void _goToLogin() {
    if (!mounted) return;
    NavigationService.pushReplacementNamed(RouteNames.login);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _SplashBackdrop(),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxHeight < 560;
                    final horizontal = Responsive.horizontalPadding(context);
                    final wordmarkSize = Responsive.wordmarkSize(
                      context,
                      compact: compact,
                    );
                    final iconSize = compact
                        ? 68.0
                        : (Responsive.isMobile(context) ? 96.0 : 108.0);
                    final headerGap = compact ? AppSpacing.md : AppSpacing.xl;
                    final vertical = compact ? AppSpacing.lg : AppSpacing.xl;

                    // On very short screens the loader needs reserved room so
                    // the centred brand lock-up never sits underneath it.
                    final loaderReserve = compact ? 76.0 : 0.0;
                    final contentHeight =
                        (constraints.maxHeight - loaderReserve - vertical * 2)
                            .clamp(0.0, double.infinity);

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              horizontal,
                              vertical,
                              horizontal,
                              vertical + loaderReserve,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: contentHeight.toDouble(),
                              ),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 480,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _BrandMark(size: iconSize),
                                      SizedBox(height: headerGap),
                                      AppBrandHeader(
                                        wordmarkSize: wordmarkSize,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: compact ? 12 : AppSpacing.lg,
                          child: const _LoadingIndicator(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryLight, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(size * 0.29),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: size * 0.33,
            offset: Offset(0, size * 0.15),
          ),
        ],
      ),
      child: Icon(
        Icons.content_cut_rounded,
        color: Colors.white,
        size: size * 0.46,
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: AppColors.primary,
            backgroundColor: AppColors.inputBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Getting everything ready',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

/// Soft pink ambient shapes that echo the mockup background.
class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop();

  @override
  Widget build(BuildContext context) {
    // Ambient glows scale with the viewport so they stay proportional on
    // tablets and web instead of looking like tiny dots.
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
                colors: [Color(0xFFFDF4F8), AppColors.background],
                stops: [0.0, 0.55],
              ),
            ),
            child: SizedBox.expand(),
          ),
          Positioned(
            top: -120 * widthScale,
            right: -90 * widthScale,
            child: _BlurredCircle(
              size: 280 * widthScale,
              color: AppColors.primaryLight.withValues(alpha: 0.20),
            ),
          ),
          Positioned(
            bottom: -140 * widthScale,
            left: -110 * widthScale,
            child: _BlurredCircle(
              size: 320 * widthScale,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurredCircle extends StatelessWidget {
  const _BlurredCircle({required this.size, required this.color});

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
