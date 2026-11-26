import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';

enum AppButtonVariant {
  primary,
  secondary,
  destructive,
  outline,
  ghost,
}

enum AppButtonSize {
  sm,
  md,
  lg,
}

/// Professional button component adhering to shadcn UI aesthetics.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.isLoading = false,
    this.icon,
    this.trailingIcon,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = AppColors.primary;
        fg = AppColors.primaryForeground;
        border = AppColors.primary;
        break;
      case AppButtonVariant.secondary:
        bg = AppColors.surfaceSecondary;
        fg = AppColors.textPrimary;
        border = AppColors.border;
        break;
      case AppButtonVariant.destructive:
        bg = AppColors.destructive;
        fg = Colors.white;
        border = AppColors.destructive;
        break;
      case AppButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.textPrimary;
        border = AppColors.border;
        break;
      case AppButtonVariant.ghost:
        bg = Colors.transparent;
        fg = AppColors.textPrimary;
        border = Colors.transparent;
        break;
    }

    EdgeInsets padding;
    double fontSize;
    double iconSize;
    double height;

    switch (size) {
      case AppButtonSize.sm:
        padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
        fontSize = 12;
        iconSize = 14;
        height = 32;
        break;
      case AppButtonSize.lg:
        padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 12);
        fontSize = 15;
        iconSize = 18;
        height = 46;
        break;
      case AppButtonSize.md:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 9);
        fontSize = 13.5;
        iconSize = 16;
        height = 38;
        break;
    }

    final buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: iconSize, color: fg),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        if (trailingIcon != null && !isLoading) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: iconSize, color: fg),
        ],
      ],
    );

    return SizedBox(
      height: height,
      width: isFullWidth ? double.infinity : null,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: border, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: isLoading ? null : onPressed,
          hoverColor: fg.withValues(alpha: 0.08),
          splashColor: fg.withValues(alpha: 0.12),
          child: Padding(
            padding: padding,
            child: buttonContent,
          ),
        ),
      ),
    );
  }
}
