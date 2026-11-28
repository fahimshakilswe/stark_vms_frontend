import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';

enum BadgeVariant {
  defaultVariant,
  secondary,
  success,
  warning,
  destructive,
  outline,
}

/// A compact, elegant status badge widget following shadcn design patterns.
class AppBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final bool showDot;
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.defaultVariant,
    this.showDot = false,
    this.icon,
  });

  /// Factory helper that automatically picks color/variant according to vehicle status.
  factory AppBadge.fromStatus(String status) {
    BadgeVariant variant;
    String displayLabel = status;
    final clean = status.trim().toUpperCase();

    switch (clean) {
      case 'AVAILABLE':
        variant = BadgeVariant.success;
        displayLabel = 'Available';
        break;
      case 'ACTIVE':
        variant = BadgeVariant.defaultVariant;
        displayLabel = 'Active';
        break;
      case 'MAINTENCE':
      case 'MAINTENANCE':
        variant = BadgeVariant.warning;
        displayLabel = 'Maintenance';
        break;
      case 'INACTIVE':
      default:
        variant = BadgeVariant.secondary;
        displayLabel = 'Inactive';
        break;
    }
    return AppBadge(
      label: displayLabel,
      variant: variant,
      showDot: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;

    switch (variant) {
      case BadgeVariant.success:
        bg = AppColors.successBackground;
        fg = const Color(0xFF065F46); // emerald-800
        border = AppColors.successBorder;
        break;
      case BadgeVariant.warning:
        bg = AppColors.warningBackground;
        fg = const Color(0xFF92400E); // amber-800
        border = AppColors.warningBorder;
        break;
      case BadgeVariant.destructive:
        bg = AppColors.destructiveBackground;
        fg = const Color(0xFF991B1B); // red-800
        border = AppColors.destructiveBorder;
        break;
      case BadgeVariant.secondary:
        bg = AppColors.surfaceSecondary;
        fg = AppColors.textSecondary;
        border = AppColors.border;
        break;
      case BadgeVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.textPrimary;
        border = AppColors.border;
        break;
      case BadgeVariant.defaultVariant:
        bg = const Color(0xFFE8F1F8);
        fg = AppColors.deepBlue;
        border = const Color(0xFFB3D4EE);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: fg,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
