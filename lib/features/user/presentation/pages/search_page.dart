import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../widgets/popular_service_card.dart' show serviceIcon;

/// Customer search screen.
///
/// Shows recent, popular and suggested queries. There is no results view yet,
/// so picking any entry fills the query field.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const List<String> _popular = [
    'Haircut',
    'Hair Spa',
    'Facial',
    'Nails',
    'Makeup',
    'Manicure',
  ];
  static const List<String> _suggestions = [
    'Best salons near me',
    'Hair color',
    'Bridal makeup',
    "Men's grooming",
    'Spa and massage',
  ];

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _recent = const ['Glow Studio', 'Style Lounge', 'Hair & Beauty'];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _useQuery(String query) {
    _controller.text = query;
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = AppSpacing.pagePadding(constraints.maxWidth);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(padding, 4, padding, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: NavigationService.pop,
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: AppColors.primary,
                        tooltip: 'Back',
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Search Salon',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(padding, 4, padding, 16),
                    children: [
                      _SearchBar(
                        controller: _controller,
                        focusNode: _focusNode,
                        onFiltered: () => _showMessage('Filters coming next.'),
                      ),
                      const SizedBox(height: 22),
                      if (_recent.isNotEmpty) ...[
                        _RecentSearches(
                          recent: _recent,
                          onSelected: _useQuery,
                          onCleared: () => setState(() => _recent = const []),
                        ),
                        const SizedBox(height: 22),
                      ],
                      _PopularSearches(onSelected: _useQuery),
                      const SizedBox(height: 22),
                      _Suggestions(onSelected: _useQuery),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onFiltered,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onFiltered;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSearchField(
            controller: controller,
            focusNode: focusNode,
            hint: 'Search salons or services',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 48,
          height: 48,
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderMd,
              side: const BorderSide(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onFiltered,
              child: const Icon(
                Icons.filter_list_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.recent,
    required this.onSelected,
    required this.onCleared,
  });

  final List<String> recent;
  final ValueChanged<String> onSelected;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Recent Searches',
                style: _sectionTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: onCleared,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Clear All',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final label in recent)
              _RecentPill(label: label, onTap: () => onSelected(label)),
          ],
        ),
      ],
    );
  }
}

class _RecentPill extends StatelessWidget {
  const _RecentPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softPink,
      borderRadius: AppRadius.borderPill,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.history_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopularSearches extends StatelessWidget {
  const _PopularSearches({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Popular Searches', style: _sectionTitle),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.05,
          children: [
            for (final label in _SearchPageState._popular)
              _PopularTile(label: label, onTap: () => onSelected(label)),
          ],
        ),
      ],
    );
  }
}

class _PopularTile extends StatelessWidget {
  const _PopularTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softPink,
      borderRadius: AppRadius.borderMd,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(serviceIcon(label), color: AppColors.primary, size: 22),
              const SizedBox(height: 7),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search Suggestions', style: _sectionTitle),
        const SizedBox(height: 10),
        for (final label in _SearchPageState._suggestions)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SuggestionRow(label: label, onTap: () => onSelected(label)),
          ),
      ],
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softPink,
      borderRadius: AppRadius.borderMd,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const TextStyle _sectionTitle = TextStyle(
  color: AppColors.textPrimary,
  fontSize: 16,
  fontWeight: FontWeight.w800,
  letterSpacing: -0.2,
);
