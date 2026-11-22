import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/popular_service.dart';

/// Soft pink service tile used by the "Popular Services" strip.
class PopularServiceCard extends StatelessWidget {
  const PopularServiceCard({
    super.key,
    required this.service,
    required this.compact,
    this.onTap,
  });

  final PopularService service;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final padding = compact ? 12.0 : 16.0;
    final iconBox = compact ? 42.0 : 48.0;
    final iconSize = compact ? 21.0 : 24.0;
    final titleSize = compact ? 13.5 : 15.0;
    final taglineSize = compact ? 10.5 : 11.5;
    final priceSize = compact ? 13.5 : 15.0;

    return Semantics(
      button: onTap != null,
      label:
          '${service.name}. ${service.tagline}. '
          'Starting from ${formatInr(service.startingPrice)}.',
      child: ExcludeSemantics(
        child: Material(
          color: AppColors.softPink,
          borderRadius: AppRadius.borderLg,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: iconBox,
                    height: iconBox,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.78),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Icon(
                      serviceIcon(service.name),
                      color: AppColors.primary,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(height: compact ? 10 : 12),
                  Text(
                    service.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    service.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: taglineSize,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: compact ? 9 : 12),
                  Text(
                    'Starting from',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: compact ? 9 : 10,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatInr(service.startingPrice),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: priceSize,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon for a catalog entry, including the "All" filter chip.
IconData serviceIcon(String name) {
  switch (name) {
    case 'All':
      return Icons.grid_view_rounded;
    case 'Haircut':
      return Icons.content_cut_rounded;
    case 'Hair Styling':
      return Icons.auto_awesome_rounded;
    case 'Hair Coloring':
      return Icons.palette_rounded;
    case 'Makeup':
      return Icons.face_retouching_natural_rounded;
    case 'Hair Spa':
      return Icons.spa_rounded;
    case 'Facial':
      return Icons.face_rounded;
    case 'Nails':
      return Icons.brush_rounded;
    case 'Manicure':
      return Icons.water_drop_rounded;
    default:
      return Icons.spa_rounded;
  }
}
