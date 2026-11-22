import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Top-of-screen brand header used by every panel.
///
/// Wraps the wordmark with an optional title and subtitle, exactly like the
/// `AppScaffold` shell in the Figma spec. Panels pass their own title set.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.children,
    this.body,
    this.footer,
    this.titleTextStyle,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? children;
  final Widget? body;
  final List<Widget>? footer;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BrandHeader(
              title: title,
              subtitle: subtitle,
              titleTextStyle: titleTextStyle,
            ),
            if (children != null && children!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: children!,
                ),
              ),
            if (subtitle != null || children != null)
              const SizedBox(height: AppSpacing.sm),
            if (body != null) Expanded(child: body!) else const SizedBox(),
            ...?footer,
          ],
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.title, this.subtitle, this.titleTextStyle});

  final String title;
  final String? subtitle;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding(constraints.maxWidth),
          ),
          child: Row(
            children: [
              if (canPop) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.textPrimary,
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Back',
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 4),
              ],
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadius.borderMd,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style:
                          titleTextStyle ??
                          TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle ?? '',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
