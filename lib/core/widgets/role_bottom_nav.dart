import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Bottom tab bar for all three panels.
///
/// `variant` controls which second tab is rendered — it is role-driven so an
/// admin panel can still show "Manager" as its second slot without touching
/// the customer shell.
class RoleBottomNav extends StatelessWidget {
  const RoleBottomNav({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    this.variant = BottomNavVariant.customer,
  });

  final List<BottomNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final BottomNavVariant variant;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 72,
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: List.generate(destinations.length, (index) {
            final destination = destinations[index];
            final selected = selectedIndex == index;
            return Expanded(
              child: _NavItem(
                destination: destination,
                selected: selected,
                variant: variant,
                onTap: () => onSelected(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

enum BottomNavVariant { customer, manager, admin }

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.variant,
    required this.onTap,
  });

  final BottomNavDestination destination;
  final bool selected;
  final BottomNavVariant variant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAdmin = variant == BottomNavVariant.admin;
    final label = destination.label(isAdmin);

    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: SizedBox(
        height: double.infinity,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? destination.selectedIcon : destination.icon,
                size: 22,
                color: color,
              ),
              const SizedBox(height: 3),
              Text(
                label,
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

class BottomNavDestination {
  const BottomNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String Function(bool admin) label;
}
