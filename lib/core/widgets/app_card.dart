import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Generic card used by every panel for list items and detail groupings.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.elevation = 1.5,
    this.shadowColor,
    this.borderRadius = AppRadius.xl,
    this.border,
  });

  final Widget child;
  final double elevation;
  final Color? shadowColor;
  final double borderRadius;
  final BorderSide? border;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
