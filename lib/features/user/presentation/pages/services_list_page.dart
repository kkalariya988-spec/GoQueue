import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/mock_user_data.dart';
import '../../data/models/popular_service.dart';
import '../widgets/popular_service_card.dart' show serviceIcon;

/// Customer panel "Services" tab.
///
/// Lists the service catalog as rows and filters it by category chip. Tapping
/// a row opens the service detail screen, which is the next one in the build.
class ServicesListPage extends StatefulWidget {
  const ServicesListPage({super.key});

  @override
  State<ServicesListPage> createState() => _ServicesListPageState();
}

class _ServicesListPageState extends State<ServicesListPage> {
  static const List<String> _categories = [
    'All',
    'Haircut',
    'Hair Styling',
    'Hair Coloring',
    'Makeup',
  ];

  String _selected = 'All';

  @override
  Widget build(BuildContext context) {
    final services = _selected == 'All'
        ? MockUserData.popularServices
        : MockUserData.popularServices
              .where((service) => service.name == _selected)
              .toList();

    return SafeArea(
      top: true,
      bottom: false,
      child: AppScaffold(
        title: 'Services',
        subtitle: 'Beauty & Care Services',
        body: LayoutBuilder(
          builder: (context, constraints) {
            final padding = AppSpacing.pagePadding(constraints.maxWidth);
            return ListView(
              padding: EdgeInsets.fromLTRB(padding, 8, padding, 12),
              children: [
                _CategoryChips(
                  categories: _categories,
                  selected: _selected,
                  onSelected: (category) =>
                      setState(() => _selected = category),
                ),
                const SizedBox(height: 12),
                SectionHeader(
                  title: _selected == 'All' ? 'All Services' : _selected,
                ),
                const SizedBox(height: 12),
                for (final service in services) _ServiceRow(service: service),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('service_category_chips'),
      children: [
        for (var index = 0; index < categories.length; index++) ...[
          if (index > 0) const SizedBox(width: 10),
          Expanded(
            child: _CategoryChip(
              label: categories[index],
              selected: categories[index] == selected,
              onTap: () => onSelected(categories[index]),
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = selected ? AppColors.primary : AppColors.softPink;
    final foreground = selected ? Colors.white : AppColors.primary;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: background,
        borderRadius: AppRadius.borderMd,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(serviceIcon(label), color: foreground, size: 22),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.service});

  final PopularService service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        elevation: 1,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg,
          side: BorderSide(color: AppColors.border.withValues(alpha: 0.65)),
        ),
        child: InkWell(
          excludeFromSemantics: true,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Service detail coming next.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: AppColors.softPink,
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Icon(
                    serviceIcon(service.name),
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        service.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${service.durationMin} mins',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatInr(service.startingPrice),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
