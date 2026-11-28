import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/enums/vehicle_enums.dart';

class VehicleFilterBar extends StatefulWidget {
  final String searchQuery;
  final String? selectedStatus;
  final String? selectedVehicleType;
  final String? selectedFuelType;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onVehicleTypeChanged;
  final ValueChanged<String?> onFuelTypeChanged;
  final VoidCallback onRefresh;
  final VoidCallback onClearFilters;

  const VehicleFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedStatus,
    this.selectedVehicleType,
    this.selectedFuelType,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onStatusChanged,
    required this.onVehicleTypeChanged,
    required this.onFuelTypeChanged,
    required this.onRefresh,
    required this.onClearFilters,
  });

  @override
  State<VehicleFilterBar> createState() => _VehicleFilterBarState();
}

class _VehicleFilterBarState extends State<VehicleFilterBar> {
  late final TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _searchController.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    // Rebuild only to toggle clear button visibility cleanly
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant VehicleFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller when cleared externally (e.g. Reset Filters / Dashboard click)
    if (widget.searchQuery != oldWidget.searchQuery &&
        widget.searchQuery.isEmpty &&
        _searchController.text.isNotEmpty) {
      _searchController.clear();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onControllerChange);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter = widget.searchQuery.isNotEmpty ||
        _searchController.text.isNotEmpty ||
        (widget.selectedStatus != null && widget.selectedStatus != 'ALL') ||
        (widget.selectedVehicleType != null &&
            widget.selectedVehicleType != 'ALL') ||
        (widget.selectedFuelType != null && widget.selectedFuelType != 'ALL');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 820;

          final searchBox = ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWide ? 380 : double.infinity,
              minWidth: 240,
            ),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: widget.onSearchChanged,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.charcoal,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Search by vehicle number, brand, model or driver...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: AppColors.deepBlue,
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 38),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            size: 17,
                            color: AppColors.textSecondary,
                          ),
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            widget.onClearSearch();
                          },
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          );

          final filterControls = Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Status Filter Dropdown
              _buildDropdown(
                value: widget.selectedStatus ?? 'ALL',
                items: [
                  const DropdownMenuItem(
                    value: 'ALL',
                    child: Text('All Statuses'),
                  ),
                  ...VehicleStatus.values.map(
                    (s) => DropdownMenuItem(
                      value: s.name,
                      child: Text(s.displayName),
                    ),
                  ),
                ],
                onChanged: (val) =>
                    widget.onStatusChanged(val == 'ALL' ? null : val),
              ),

              // Vehicle Type Filter Dropdown
              _buildDropdown(
                value: widget.selectedVehicleType ?? 'ALL',
                items: [
                  const DropdownMenuItem(
                    value: 'ALL',
                    child: Text('All Types'),
                  ),
                  ...VehicleType.values.map(
                    (t) => DropdownMenuItem(
                      value: t.name,
                      child: Text(t.displayName),
                    ),
                  ),
                ],
                onChanged: (val) =>
                    widget.onVehicleTypeChanged(val == 'ALL' ? null : val),
              ),

              // Fuel Type Filter Dropdown
              _buildDropdown(
                value: widget.selectedFuelType ?? 'ALL',
                items: [
                  const DropdownMenuItem(
                    value: 'ALL',
                    child: Text('All Fuels'),
                  ),
                  ...FuelType.values.map(
                    (f) => DropdownMenuItem(
                      value: f.name,
                      child: Text(f.displayName),
                    ),
                  ),
                ],
                onChanged: (val) =>
                    widget.onFuelTypeChanged(val == 'ALL' ? null : val),
              ),

              // Refresh Button
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 19),
                  tooltip: 'Refresh list',
                  color: AppColors.deepBlue,
                  onPressed: widget.onRefresh,
                ),
              ),

              // Clear All Filters
              if (hasActiveFilter)
                TextButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    widget.onClearFilters();
                  },
                  icon: const Icon(Icons.filter_alt_off_rounded, size: 16),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
            ],
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(child: searchBox),
                const SizedBox(width: 12),
                filterControls,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchBox,
              const SizedBox(height: 12),
              filterControls,
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.any((i) => i.value == value) ? value : 'ALL',
          items: items,
          onChanged: onChanged,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.textSecondary,
            size: 20,
          ),
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
