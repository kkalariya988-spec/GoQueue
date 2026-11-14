import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_wordmark.dart';
import 'dashboard_layout.dart';

/// Branded, responsive hero for the customer dashboard.
///
/// The mockup uses a portrait illustration on the right. The app ships without
/// that artwork, so a hand-built beauty composition is used instead.
class HomeHero extends StatefulWidget {
  const HomeHero({
    super.key,
    required this.firstName,
    required this.initial,
    required this.onNotifications,
    required this.onProfile,
    required this.onLogout,
    required this.onFindSalons,
    required this.onBookAppointment,
    required this.onExploreSalons,
  });

  final String firstName;
  final String initial;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;
  final VoidCallback onLogout;
  final VoidCallback onFindSalons;
  final VoidCallback onBookAppointment;
  final VoidCallback onExploreSalons;

  @override
  State<HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<HomeHero> {
  final _serviceController = TextEditingController();
  final _locationController = TextEditingController();
  final _serviceFocus = FocusNode();
  final _locationFocus = FocusNode();

  @override
  void dispose() {
    _serviceController.dispose();
    _locationController.dispose();
    _serviceFocus.dispose();
    _locationFocus.dispose();
    super.dispose();
  }

  void _findSalons() {
    FocusScope.of(context).unfocus();
    widget.onFindSalons();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pagePadding = AppSpacing.pagePadding(constraints.maxWidth);
        final outerWidth = math.min(
          constraints.maxWidth,
          DashboardLayout.maxContentWidth,
        );
        final contentWidth = outerWidth - pagePadding * 2;
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final wide = contentWidth >= 700 && textScale <= 1.4;
        final showArtwork = contentWidth >= 330 && textScale <= 1.75;
        final artworkWidth = (contentWidth * 0.27)
            .clamp(88.0, 112.0)
            .toDouble();
        final copyWidth = showArtwork
            ? contentWidth - artworkWidth - 12
            : contentWidth;
        final wideCopyWidth = math.min((contentWidth - 48) * 5 / 9, 500.0);

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(34),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.heroStart, AppColors.heroEnd],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -110,
                  right: -50,
                  child: IgnorePointer(
                    child: _Glow(
                      size: 260,
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -90,
                  left: -70,
                  child: IgnorePointer(
                    child: _Glow(
                      size: 240,
                      color: AppColors.primary.withValues(alpha: 0.045),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: DashboardLayout.maxContentWidth,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          pagePadding,
                          4,
                          pagePadding,
                          wide ? 40 : 28,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Header(
                              initial: widget.initial,
                              onNotifications: widget.onNotifications,
                              onProfile: widget.onProfile,
                              onLogout: widget.onLogout,
                            ),
                            SizedBox(height: wide ? 30 : 18),
                            if (wide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 500,
                                        ),
                                        child: _buildCopyAndSearch(
                                          context,
                                          availableWidth: wideCopyWidth,
                                          wide: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 48),
                                  Expanded(
                                    flex: 4,
                                    child: _HeroArtwork(
                                      compact: false,
                                      height: 420,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildCopyAndSearch(
                                      context,
                                      availableWidth: copyWidth,
                                      wide: false,
                                    ),
                                  ),
                                  if (showArtwork) ...[
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: artworkWidth,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 22),
                                        child: _HeroArtwork(
                                          compact: true,
                                          height: 296,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCopyAndSearch(
    BuildContext context, {
    required double availableWidth,
    required bool wide,
  }) {
    final headlineSize = wide
        ? (availableWidth / 11.5).clamp(30.0, 44.0).toDouble()
        : (availableWidth / 11.5).clamp(20.0, 27.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hi, ${widget.firstName}',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: wide ? 15 : 12.5,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'BOOK  •  BEAUTY  •  RELAX',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: wide ? 11 : 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your Style, Your Time,\nYour Queue.',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: headlineSize,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            height: 1.12,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Discover the best salons near you and book your appointment in '
          'just a few clicks.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: wide ? 15 : 12.5,
            height: 1.5,
          ),
        ),
        SizedBox(height: wide ? 24 : 16),
        _HeroSearchField(
          controller: _serviceController,
          focusNode: _serviceFocus,
          hint: 'Search salon or service',
          icon: Icons.search_rounded,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _locationFocus.requestFocus(),
        ),
        const SizedBox(height: 8),
        _HeroSearchField(
          controller: _locationController,
          focusNode: _locationFocus,
          hint: 'Enter your location',
          icon: Icons.location_on_outlined,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _findSalons(),
        ),
        SizedBox(height: wide ? 14 : 10),
        AppButton(
          text: 'Find Salons',
          icon: Icons.search_rounded,
          height: wide ? 50 : 46,
          onPressed: _findSalons,
        ),
        SizedBox(height: wide ? 12 : 8),
        _QuickActions(
          onBookAppointment: widget.onBookAppointment,
          onExploreSalons: widget.onExploreSalons,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.initial,
    required this.onNotifications,
    required this.onProfile,
    required this.onLogout,
  });

  final String initial;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.22),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.content_cut_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AppWordmark(fontSize: 24),
          ),
        ),
        _CircleIconButton(
          icon: Icons.notifications_none_rounded,
          tooltip: 'Notifications',
          onPressed: onNotifications,
          badge: true,
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          tooltip: 'Account menu',
          offset: const Offset(0, 46),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
          onSelected: (value) {
            if (value == 'profile') {
              onProfile();
            } else if (value == 'logout') {
              onLogout();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline_rounded, size: 20),
                  SizedBox(width: 10),
                  Text('Profile'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout_rounded, size: 20),
                  SizedBox(width: 10),
                  Text('Log out'),
                ],
              ),
            ),
          ],
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.badge = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: Material(
          color: Colors.white.withValues(alpha: 0.62),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              width: 38,
              height: 38,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, color: AppColors.textPrimary, size: 21),
                  if (badge)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
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

class _HeroSearchField extends StatelessWidget {
  const _HeroSearchField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.icon,
    required this.textInputAction,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final IconData icon;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: AppRadius.borderMd,
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.68)),
    );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      autocorrect: false,
      cursorColor: AppColors.primary,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.inputBackground,
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 19),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onBookAppointment,
    required this.onExploreSalons,
  });

  final VoidCallback onBookAppointment;
  final VoidCallback onExploreSalons;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaled = MediaQuery.textScalerOf(context).scale(12.5);
        final stack = constraints.maxWidth < 230 || scaled > 16.5;

        if (stack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeroActionButton(
                label: 'Book an Appointment',
                onPressed: onBookAppointment,
                filled: true,
              ),
              const SizedBox(height: 8),
              _HeroActionButton(
                label: 'Explore Salons',
                onPressed: onExploreSalons,
              ),
            ],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _HeroActionButton(
                  label: 'Book an Appointment',
                  onPressed: onBookAppointment,
                  filled: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroActionButton(
                  label: 'Explore Salons',
                  onPressed: onExploreSalons,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
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
      borderRadius: BorderRadius.circular(11),
    );
    final text = Text(
      label,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: TextStyle(
        color: filled ? Colors.white : AppColors.primary,
        fontSize: 12.5,
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
          minimumSize: const Size(0, 42),
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
        backgroundColor: Colors.white.withValues(alpha: 0.35),
        side: const BorderSide(color: AppColors.primary),
        padding: padding,
        minimumSize: const Size(0, 42),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: shape,
      ),
      child: text,
    );
  }
}

class _HeroArtwork extends StatelessWidget {
  const _HeroArtwork({required this.compact, required this.height});

  final bool compact;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final archWidth = compact
                ? width
                : (width * 0.68).clamp(190.0, 270.0);
            final portraitSize = compact
                ? (width * 0.66).clamp(54.0, 70.0)
                : (archWidth * 0.56).clamp(110.0, 150.0);
            final archHeight = compact ? height : height - 10;

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: archWidth,
                    height: archHeight,
                    child: _Arch(compact: compact, portraitSize: portraitSize),
                  ),
                ),
                if (!compact) ...[
                  Positioned(
                    left: 0,
                    top: 8,
                    child: const _InfoCard(
                      icon: Icons.star_rounded,
                      iconColor: AppColors.rating,
                      value: '4.8',
                      label: 'Top rated',
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 8,
                    child: const _InfoCard(
                      icon: Icons.storefront_rounded,
                      iconColor: AppColors.primary,
                      value: '500+',
                      label: 'Salons',
                    ),
                  ),
                ] else ...[
                  Positioned(
                    top: 4,
                    right: -2,
                    child: _FloatingIcon(
                      icon: Icons.auto_awesome_rounded,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    top: height * 0.42,
                    left: -8,
                    child: _FloatingIcon(
                      icon: Icons.local_florist_rounded,
                      size: 22,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Arch extends StatelessWidget {
  const _Arch({required this.compact, required this.portraitSize});

  final bool compact;
  final double portraitSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.62),
            AppColors.primary.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(compact ? 60 : 160),
          bottom: Radius.circular(compact ? 18 : 28),
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: compact ? 24 : 42,
            left: 0,
            right: 0,
            child: Center(
              child: _Portrait(size: portraitSize, compact: compact),
            ),
          ),
          Positioned(
            left: compact ? 4 : 18,
            right: compact ? 4 : 18,
            bottom: compact ? 16 : 22,
            child: _RatingPill(compact: compact),
          ),
        ],
      ),
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait({required this.size, required this.compact});

  final double size;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFFFE5EF)],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: compact ? 2 : 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.face_retouching_natural_rounded,
            color: AppColors.primary,
            size: size * 0.56,
          ),
        ),
        Positioned(
          right: -size * 0.06,
          bottom: -size * 0.04,
          child: Container(
            width: size * 0.28,
            height: size * 0.28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              Icons.local_florist_rounded,
              color: Colors.white,
              size: size * 0.16,
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 12,
        vertical: compact ? 5 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: AppRadius.borderPill,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: AppColors.rating, size: 14),
            const SizedBox(width: 3),
            Text(
              '4.8',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: compact ? 10.5 : 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (!compact) ...[
              const SizedBox(width: 5),
              const Text(
                'Top rated',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon({
    required this.icon,
    required this.size,
    required this.color,
  });

  final IconData icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size * 0.55),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9.5,
                  height: 1.2,
                ),
              ),
            ],
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
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
