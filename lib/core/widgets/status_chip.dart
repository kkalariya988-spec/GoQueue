import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Small pill chip used across the app for status, category and filter labels.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.textColor,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? AppColors.softPink,
        borderRadius: AppRadius.borderPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor ?? AppColors.primary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor ?? AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Generic status chip that picks its colour from a status vocabulary.
class StatusChipStatus extends StatelessWidget {
  const StatusChipStatus({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = <String, Color>{
      'Confirmed': AppColors.success,
      'Pending': AppColors.warning,
      'In Progress': AppColors.info,
      'Completed': AppColors.success,
      'Cancelled': AppColors.error,
      'Active': AppColors.success,
      'On Leave': AppColors.warning,
      'Inactive': AppColors.textMuted,
    };
    final color = colors[status] ?? AppColors.textSecondary;
    return StatusChip(label: status, color: color);
  }
}
