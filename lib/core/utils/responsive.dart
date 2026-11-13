import 'package:flutter/material.dart';

/// Helpers for building layouts that adapt to the surface size, orientation
/// and accessibility text scale.
///
/// Breakpoints follow Material guidance: phones below 600 dp, tablets between
/// 600 and 900 dp, and desktop/web from 900 dp upwards.
class Responsive {
  Responsive._();

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  /// Keeps single-column forms readable on tablets and web instead of letting
  /// fields stretch across the whole window.
  static const double formMaxWidth = 440;

  static Size sizeOf(BuildContext context) => MediaQuery.sizeOf(context);

  static bool isMobile(BuildContext context) =>
      sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      sizeOf(context).width >= tabletBreakpoint;

  /// True when vertical space is tight (small phones, landscape).
  static bool isCompactHeight(BuildContext context, {double threshold = 560}) =>
      sizeOf(context).height < threshold;

  /// Horizontal gutter that grows with the viewport.
  static double horizontalPadding(BuildContext context) {
    final width = sizeOf(context).width;
    if (width >= tabletBreakpoint) return 40;
    if (width >= mobileBreakpoint) return 32;
    if (width < 360) return 20;
    return 32;
  }

  /// A vertical gap proportional to the viewport height, clamped so it stays
  /// sensible on short phones and tall tablets.
  static double verticalGap(
    BuildContext context, {
    required double fraction,
    required double min,
    required double max,
  }) {
    return (sizeOf(context).height * fraction).clamp(min, max).toDouble();
  }

  /// Wordmark size that keeps the brand lock-up balanced at every width.
  static double wordmarkSize(BuildContext context, {bool compact = false}) {
    if (compact) return 30;
    final width = sizeOf(context).width;
    if (width >= tabletBreakpoint) return 46;
    if (width >= mobileBreakpoint) return 42;
    return 38;
  }
}
