import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';

/// Traditional numbered page-based pagination footer matching enterprise admin table design.
class VehiclePaginationBar extends StatelessWidget {
  final int startItem;
  final int endItem;
  final int totalElements;
  final int displayPage;
  final int displayTotalPages;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool isLoading;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const VehiclePaginationBar({
    super.key,
    required this.startItem,
    required this.endItem,
    required this.totalElements,
    required this.displayPage,
    required this.displayTotalPages,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.isLoading,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final unit = totalElements == 1 ? 'vehicle' : 'vehicles';
    final rangeText = totalElements == 0
        ? 'Showing 0 of 0 vehicles'
        : 'Showing $startItem\u2013$endItem of $totalElements $unit';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 12,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  rangeText,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if (isLoading) ...[
                const SizedBox(width: 10),
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.corporateBlue),
                  ),
                ),
              ],
            ],
          ),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _PaginationButton(
                label: 'Previous',
                icon: Icons.chevron_left_rounded,
                iconLeading: true,
                enabled: canGoPrevious,
                onPressed: onPrevious,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.softGray,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'Page $displayPage of $displayTotalPages',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepBlue,
                  ),
                ),
              ),
              _PaginationButton(
                label: 'Next',
                icon: Icons.chevron_right_rounded,
                iconLeading: false,
                enabled: canGoNext,
                onPressed: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool iconLeading;
  final bool enabled;
  final VoidCallback onPressed;

  const _PaginationButton({
    required this.label,
    required this.icon,
    required this.iconLeading,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final fg = enabled ? AppColors.charcoal : AppColors.textMuted;

    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.charcoal,
        disabledForegroundColor: AppColors.textMuted,
        backgroundColor: enabled ? AppColors.white : AppColors.softGray,
        side: BorderSide(
          color: enabled ? AppColors.border : AppColors.borderSubtle,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(0, 34),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconLeading) ...[
            Icon(icon, size: 17, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
          if (!iconLeading) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 17, color: fg),
          ],
        ],
      ),
    );
  }
}
