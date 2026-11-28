import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}

/// Enterprise SaaS page header with title, subtitle, breadcrumb, and primary actions.
class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final List<BreadcrumbItem>? breadcrumbs;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.breadcrumbs,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 600;

    final headerTitleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breadcrumbs != null && breadcrumbs!.isNotEmpty) ...[
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              for (int i = 0; i < breadcrumbs!.length; i++) ...[
                if (i > 0)
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                if (breadcrumbs![i].onTap != null)
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: breadcrumbs![i].onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      child: Text(
                        breadcrumbs![i].label,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    breadcrumbs![i].label,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 6),
        ],
        Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlue,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerTitleSection,
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: actions!,
                  ),
                ],
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: headerTitleSection),
                if (actions != null && actions!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!
                        .map((action) => Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: action,
                            ))
                        .toList(),
                  ),
              ],
            ),
    );
  }
}
