import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';

class VehicleFilterBar extends StatefulWidget {
  final String searchQuery;
  final String? selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onRefresh;
  final VoidCallback onClearFilters;

  const VehicleFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onRefresh,
    required this.onClearFilters,
  });

  @override
  State<VehicleFilterBar> createState() => _VehicleFilterBarState();
}

class _VehicleFilterBarState extends State<VehicleFilterBar> {
  late final TextEditingController _searchController;

  static const List<String> statusOptions = [
    'ALL',
    'ACTIVE',
    'MAINTENANCE',
    'INACTIVE',
    'RETIRED',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant VehicleFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != _searchController.text) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter = widget.searchQuery.isNotEmpty ||
        (widget.selectedStatus != null && widget.selectedStatus != 'ALL');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Search Box
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320, minWidth: 220),
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearchChanged,
                style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search vehicle number...',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 36),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearchChanged('');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: AppColors.borderFocus, width: 1.5),
                  ),
                ),
              ),
            ),
          ),

          // Status Filter Buttons / Dropdown
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Status: ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.selectedStatus ?? 'ALL',
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    items: statusOptions.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: widget.onStatusChanged,
                  ),
                ),
              ),
            ],
          ),

          // Action buttons: Clear & Refresh
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasActiveFilter) ...[
                AppButton(
                  label: 'Clear Filters',
                  variant: AppButtonVariant.ghost,
                  size: AppButtonSize.sm,
                  icon: Icons.filter_alt_off_outlined,
                  onPressed: () {
                    _searchController.clear();
                    widget.onClearFilters();
                  },
                ),
                const SizedBox(width: 8),
              ],
              AppButton(
                label: 'Refresh',
                variant: AppButtonVariant.outline,
                size: AppButtonSize.sm,
                icon: Icons.refresh_rounded,
                onPressed: widget.onRefresh,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
