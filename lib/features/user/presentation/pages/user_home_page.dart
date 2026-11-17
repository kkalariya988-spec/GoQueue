import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_wordmark.dart';
import '../../../../features/user/presentation/pages/services_list_page.dart';
import '../../../../features/user/presentation/pages/salons_list_page.dart';
import '../../../auth/data/auth_service.dart';
import '../widgets/dashboard_home_view.dart';

/// Customer panel shell with a bottom bar on phones and a rail on wider screens.
class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;

  static const _destinations = [
    _NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _NavDestination(
      label: 'Salons',
      icon: Icons.storefront_outlined,
      selectedIcon: Icons.storefront_rounded,
    ),
    _NavDestination(
      label: 'Services',
      icon: Icons.spa_outlined,
      selectedIcon: Icons.spa_rounded,
    ),
    _NavDestination(
      label: 'Bookings',
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
    ),
    _NavDestination(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  void _selectTab(int index) {
    if (_selectedIndex == index) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _selectedIndex = index);
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
        ),
      );
  }

  void _handleLogout() {
    AuthService.instance.logout();
    NavigationService.pushNamedAndRemoveUntil(
      RouteNames.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final displayName = user?.name.trim() ?? '';
    final firstName = displayName.isEmpty
        ? 'there'
        : displayName.split(' ').first;
    final initial = displayName.isEmpty ? 'G' : displayName[0].toUpperCase();
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final useRail = size.width >= 900 && size.height >= 480;
    final extendedRail = size.width >= 1100 || textScale > 1.25;

    final pages = <Widget>[
      DashboardHomeView(
        firstName: firstName,
        initial: initial,
        onNotifications: () => _showMessage('No new notifications right now.'),
        onProfile: () => _selectTab(4),
        onLogout: _handleLogout,
        onBrowseSalons: () => _selectTab(1),
        onBookAppointment: () {
          _selectTab(1);
          _showMessage('Pick a salon to start your appointment.');
        },
        onBrowseServices: () => _selectTab(2),
      ),
      const SalonsListPage(),
      const ServicesListPage(),
      _ComingSoonTab(
        title: 'Bookings',
        description:
            'Your upcoming, completed and cancelled appointments will live '
            'here. This screen is next in the build.',
        icon: Icons.calendar_month_rounded,
        onBackHome: () => _selectTab(0),
      ),
      _ProfileTab(
        name: user?.name ?? 'Guest',
        email: user?.email ?? 'Not signed in',
        initial: initial,
        onLogout: _handleLogout,
      ),
    ];

    final body = IndexedStack(index: _selectedIndex, children: pages);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: useRail
            ? Row(
                children: [
                  _DashboardRail(
                    destinations: _destinations,
                    selectedIndex: _selectedIndex,
                    extended: extendedRail,
                    onSelected: _selectTab,
                    onLogout: _handleLogout,
                  ),
                  Expanded(child: body),
                ],
              )
            : body,
        bottomNavigationBar: useRail
            ? null
            : _DashboardBottomBar(
                destinations: _destinations,
                selectedIndex: _selectedIndex,
                onSelected: _selectTab,
              ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _DashboardBottomBar extends StatelessWidget {
  const _DashboardBottomBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_NavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Row(
            children: [
              for (var index = 0; index < destinations.length; index++)
                Expanded(
                  child: _BottomNavItem(
                    key: Key('bottom_nav_$index'),
                    destination: destinations[index],
                    selected: selectedIndex == index,
                    onTap: () => onSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? destination.selectedIcon : destination.icon,
                size: 22,
                color: color,
              ),
              const SizedBox(height: 3),
              Text(
                destination.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 10.5,
                  height: 1.15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardRail extends StatelessWidget {
  const _DashboardRail({
    required this.destinations,
    required this.selectedIndex,
    required this.extended,
    required this.onSelected,
    required this.onLogout,
  });

  final List<_NavDestination> destinations;
  final int selectedIndex;
  final bool extended;
  final ValueChanged<int> onSelected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final width = extended ? 248.0 : 104.0;

    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        right: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: extended ? 18 : 10,
              vertical: 18,
            ),
            child: Column(
              crossAxisAlignment: extended
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.center,
              children: [
                _RailBrand(extended: extended, onTap: () => onSelected(0)),
                const SizedBox(height: 26),
                for (var index = 0; index < destinations.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _RailItem(
                      key: Key('rail_nav_$index'),
                      destination: destinations[index],
                      selected: selectedIndex == index,
                      extended: extended,
                      onTap: () => onSelected(index),
                    ),
                  ),
                const SizedBox(height: 14),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 12),
                _RailLogout(extended: extended, onTap: onLogout),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RailBrand extends StatelessWidget {
  const _RailBrand({required this.extended, required this.onTap});

  final bool extended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.content_cut_rounded,
        color: Colors.white,
        size: 20,
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: extended
            ? Row(
                children: [
                  mark,
                  const SizedBox(width: 9),
                  const Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: AppWordmark(fontSize: 22),
                    ),
                  ),
                ],
              )
            : Center(child: mark),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.extended,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    final icon = Icon(
      selected ? destination.selectedIcon : destination.icon,
      size: 22,
      color: color,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.09)
            : Colors.transparent,
        borderRadius: AppRadius.borderMd,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: extended ? 12 : 6,
              vertical: extended ? 12 : 10,
            ),
            child: extended
                ? Row(
                    children: [
                      icon,
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          destination.label,
                          style: TextStyle(
                            color: color,
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon,
                      const SizedBox(height: 4),
                      Text(
                        destination.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontSize: 9.5,
                          height: 1.15,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _RailLogout extends StatelessWidget {
  const _RailLogout({required this.extended, required this.onTap});

  final bool extended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Log out',
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: extended ? 12 : 6,
            vertical: 10,
          ),
          child: extended
              ? const Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 21,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Log out',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 21,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Log out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab({
    required this.title,
    required this.description,
    required this.icon,
    required this.onBackHome,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = AppSpacing.pagePadding(constraints.maxWidth);

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _TabBrandHeader(),
                    const SizedBox(height: 36),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.borderXl,
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: AppColors.softPink,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.iconPink),
                            ),
                            child: Icon(
                              icon,
                              color: AppColors.primary,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            text: 'Back to Home',
                            onPressed: onBackHome,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
    required this.name,
    required this.email,
    required this.initial,
    required this.onLogout,
  });

  final String name;
  final String email;
  final String initial;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = AppSpacing.pagePadding(constraints.maxWidth);

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _TabBrandHeader(),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.borderXl,
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.softPink,
                              borderRadius: AppRadius.borderPill,
                            ),
                            child: const Text(
                              'Customer',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          const Divider(color: AppColors.divider, height: 1),
                          const SizedBox(height: 18),
                          const Text(
                            'Full profile settings, saved addresses and '
                            'preferences are coming next.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 22),
                          AppButton(
                            text: 'Log Out',
                            icon: Icons.logout_rounded,
                            isOutlined: true,
                            onPressed: onLogout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabBrandHeader extends StatelessWidget {
  const _TabBrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.content_cut_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        const Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AppWordmark(fontSize: 22),
          ),
        ),
      ],
    );
  }
}
