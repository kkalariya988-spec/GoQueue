import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/mock_user_data.dart';
import '../../data/models/popular_service.dart';
import 'dashboard_layout.dart';
import 'home_hero.dart';
import 'popular_service_card.dart';
import 'salon_card.dart';

/// Scrollable home tab of the customer dashboard.
class DashboardHomeView extends StatelessWidget {
  const DashboardHomeView({
    super.key,
    required this.firstName,
    required this.initial,
    required this.onNotifications,
    required this.onProfile,
    required this.onLogout,
    required this.onBrowseSalons,
    required this.onBookAppointment,
    required this.onBrowseServices,
  });

  final String firstName;
  final String initial;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;
  final VoidCallback onLogout;
  final VoidCallback onBrowseSalons;
  final VoidCallback onBookAppointment;
  final VoidCallback onBrowseServices;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('dashboard_scroll'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeHero(
            firstName: firstName,
            initial: initial,
            onNotifications: onNotifications,
            onProfile: onProfile,
            onLogout: onLogout,
            onFindSalons: onBrowseSalons,
            onBookAppointment: onBookAppointment,
            onExploreSalons: onBrowseSalons,
          ),
          const SizedBox(height: 24),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: DashboardLayout.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PopularServicesSection(
                    onViewAll: onBrowseServices,
                    onServiceTap: (_) => onBrowseServices(),
                  ),
                  const SizedBox(height: 28),
                  _TopSalonsSection(
                    onViewAll: onBrowseSalons,
                    onSalonTap: onBrowseSalons,
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularServicesSection extends StatelessWidget {
  const _PopularServicesSection({
    required this.onViewAll,
    required this.onServiceTap,
  });

  final VoidCallback onViewAll;
  final ValueChanged<PopularService> onServiceTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = DashboardLayout.pagePadding(width);
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final grid = width >= 600 && textScale <= 1.5;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: _SectionHeader(
                title: 'Popular Services',
                onAction: onViewAll,
              ),
            ),
            const SizedBox(height: 12),
            if (grid)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (
                        var index = 0;
                        index < MockUserData.popularServices.length;
                        index++
                      ) ...[
                        if (index > 0) const SizedBox(width: 12),
                        Expanded(
                          child: PopularServiceCard(
                            service: MockUserData.popularServices[index],
                            compact: false,
                            onTap: () => onServiceTap(
                              MockUserData.popularServices[index],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: padding, right: padding),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (
                        var index = 0;
                        index < MockUserData.popularServices.length;
                        index++
                      ) ...[
                        if (index > 0) const SizedBox(width: 10),
                        SizedBox(
                          width: 152,
                          child: PopularServiceCard(
                            service: MockUserData.popularServices[index],
                            compact: true,
                            onTap: () => onServiceTap(
                              MockUserData.popularServices[index],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TopSalonsSection extends StatelessWidget {
  const _TopSalonsSection({required this.onViewAll, required this.onSalonTap});

  final VoidCallback onViewAll;
  final VoidCallback onSalonTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = DashboardLayout.pagePadding(width);
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final phone = width < 600;
        final contentWidth = width - padding * 2;

        if (phone) {
          final cardWidth = math.max(
            250.0,
            math.min(300.0, contentWidth * 0.78),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: _SectionHeader(
                  title: 'Top Salons Near You',
                  onAction: onViewAll,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: padding, right: padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (
                      var index = 0;
                      index < MockUserData.topSalons.length;
                      index++
                    ) ...[
                      if (index > 0) const SizedBox(width: 12),
                      SizedBox(
                        width: cardWidth,
                        child: _SalonCardAt(index: index, onTap: onSalonTap),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        }

        final columns = width >= 1000 && textScale <= 1.5
            ? 3
            : (textScale <= 1.5 ? 2 : 1);
        final gap = width >= 900 ? 18.0 : 16.0;
        final cardWidth = columns == 1
            ? contentWidth
            : (contentWidth - gap * (columns - 1)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: _SectionHeader(
                title: 'Top Salons Near You',
                onAction: onViewAll,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (
                    var index = 0;
                    index < MockUserData.topSalons.length;
                    index++
                  )
                    SizedBox(
                      width: cardWidth,
                      child: _SalonCardAt(index: index, onTap: onSalonTap),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SalonCardAt extends StatelessWidget {
  const _SalonCardAt({required this.index, required this.onTap});

  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SalonCard(
      salon: MockUserData.topSalons[index],
      paletteIndex: index,
      onView: onTap,
      onBook: onTap,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAction});

  final String title;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 2,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'View All',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 2),
              Icon(Icons.arrow_forward_rounded, size: 15),
            ],
          ),
        ),
      ],
    );
  }
}
