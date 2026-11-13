import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/salon.dart';

/// Salon result card with a generated cover, rating summary and booking actions.
class SalonCard extends StatelessWidget {
  const SalonCard({
    super.key,
    required this.salon,
    required this.paletteIndex,
    required this.onView,
    required this.onBook,
  });

  final Salon salon;
  final int paletteIndex;
  final VoidCallback onView;
  final VoidCallback onBook;

  static const List<List<Color>> _coverPalettes = [
    [Color(0xFFB1326A), Color(0xFFFF9BBC)],
    [Color(0xFF7C2351), Color(0xFFE8789F)],
    [Color(0xFF553A78), Color(0xFFC59BDD)],
    [Color(0xFF8A3A5A), Color(0xFFF2A7B8)],
  ];

  @override
  Widget build(BuildContext context) {
    final palette = _coverPalettes[paletteIndex % _coverPalettes.length];

    return Material(
      color: Colors.white,
      elevation: 1.5,
      shadowColor: AppColors.primary.withValues(alpha: 0.10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderXl,
        side: BorderSide(color: AppColors.border.withValues(alpha: 0.65)),
      ),
      child: InkWell(
        excludeFromSemantics: true,
        onTap: onView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SalonCover(salon: salon, palette: palette),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    salon.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 3,
                    spacing: 5,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: AppColors.rating,
                      ),
                      Text(
                        salon.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '(${formatCompactCount(salon.reviewCount)} reviews)',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                        ),
                      ),
                      const _Dot(),
                      Text(
                        '${formatDistance(salon.distanceKm)} km',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          salon.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Popular services: ${salon.popularServices.join(', ')}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 2,
                    children: [
                      const Text(
                        'Starting from',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        formatInr(salon.startingPrice),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SalonActions(onView: onView, onBook: onBook),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalonCover extends StatelessWidget {
  const _SalonCover({required this.salon, required this.palette});

  final Salon salon;
  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.62,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: palette,
              ),
            ),
          ),
          Positioned(
            right: -28,
            top: -30,
            child: _SoftCircle(
              size: 120,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            left: -22,
            bottom: -34,
            child: _SoftCircle(
              size: 100,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Center(
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.34)),
              ),
              alignment: Alignment.center,
              child: Text(
                salon.initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: AppRadius.borderPill,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: salon.isOpen
                          ? AppColors.success
                          : AppColors.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    salon.isOpen ? 'Open now' : 'Closed',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SalonActions extends StatelessWidget {
  const _SalonActions({required this.onView, required this.onBook});

  final VoidCallback onView;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaledLabel = MediaQuery.textScalerOf(context).scale(12);
        final stack = constraints.maxWidth < 210 || scaledLabel > 16;

        if (stack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _SalonButton(label: 'View salon', onPressed: onView),
              const SizedBox(height: 8),
              _SalonButton(label: 'Book Now', onPressed: onBook, filled: true),
            ],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SalonButton(label: 'View salon', onPressed: onView),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SalonButton(
                  label: 'Book Now',
                  onPressed: onBook,
                  filled: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SalonButton extends StatelessWidget {
  const _SalonButton({
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(9),
    );
    final text = Text(
      label,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: TextStyle(
        color: filled ? Colors.white : AppColors.primary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.15,
      ),
    );
    const padding = EdgeInsets.symmetric(horizontal: 8, vertical: 8);

    if (filled) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: padding,
          minimumSize: const Size(0, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: shape,
        ),
        child: text,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: padding,
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: shape,
      ),
      child: text,
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: AppColors.textMuted,
        shape: BoxShape.circle,
      ),
    );
  }
}
