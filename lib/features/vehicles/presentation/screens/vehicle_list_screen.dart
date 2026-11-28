import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stark_vms_frontend/core/router/route_names.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/utils/toast_utils.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';
import 'package:stark_vms_frontend/core/widgets/confirm_dialog.dart';
import 'package:stark_vms_frontend/core/widgets/empty_state_view.dart';
import 'package:stark_vms_frontend/core/widgets/error_state_view.dart';
import 'package:stark_vms_frontend/core/widgets/page_header.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_list_state.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_filter_bar.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_mobile_card.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_pagination_bar.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_skeleton.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_table.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  void _navigateToEdit(BuildContext context, VehicleEntity vehicle) {
    context.go(AppRoutes.editVehiclePath(vehicle.id));
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    VehicleEntity vehicle,
  ) async {
    final result = await ConfirmDialog.showDeleteVehicle(
      context,
      vehicleNumber: vehicle.vehicleNumber,
      onConfirmDelete: () => ref
          .read(vehicleFormNotifierProvider.notifier)
          .deleteVehicle(vehicle.id),
    );

    if (!context.mounted || result == null) return;

    if (result == true) {
      AppToast.showSuccess(
        context,
        'Vehicle ${vehicle.vehicleNumber} deleted successfully.',
      );
    } else {
      final error = ref.read(vehicleFormNotifierProvider).errorMessage;
      if (error != null && error.isNotEmpty) {
        AppToast.showError(context, error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(vehicleListProvider);
    final listNotifier = ref.read(vehicleListProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 850;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Screen Header
          PageHeader(
            title: 'Vehicle Fleet',
            subtitle:
                'Overview of all registered company vehicles, technical specifications, and operational assignments.',
            breadcrumbs: const [
              BreadcrumbItem(label: 'Stark Group VMS'),
              BreadcrumbItem(label: 'Vehicle Fleet'),
            ],
            actions: [
              AppButton(
                label: 'Add Vehicle',
                icon: Icons.add_rounded,
                onPressed: () => context.go(AppRoutes.addVehicle),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Search and Filters Bar
          VehicleFilterBar(
            searchQuery: listState.searchQuery,
            selectedStatus: listState.statusFilter,
            selectedVehicleType: listState.vehicleTypeFilter,
            selectedFuelType: listState.fuelTypeFilter,
            onSearchChanged: listNotifier.onSearchChanged,
            onClearSearch: listNotifier.clearSearch,
            onStatusChanged: listNotifier.setStatusFilter,
            onVehicleTypeChanged: listNotifier.setVehicleTypeFilter,
            onFuelTypeChanged: listNotifier.setFuelTypeFilter,
            onRefresh: listNotifier.refresh,
            onClearFilters: listNotifier.resetFilters,
          ),

          const SizedBox(height: 20),

          // Main Content Area
          _buildContent(context, ref, listState, listNotifier, isDesktop),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    VehicleListState state,
    VehicleListNotifier notifier,
    bool isDesktop,
  ) {
    // 1. Initial load skeleton
    if (state.isInitialLoading) {
      return const VehicleTableSkeleton();
    }

    // 2. Full error view when no cached items exist
    if (state.errorMessage != null && state.vehicles.isEmpty) {
      return ErrorStateView(
        title: 'Failed to load vehicles',
        message: state.errorMessage!,
        onRetry: notifier.refresh,
      );
    }

    // 3. Empty state (no vehicles or no search/filter matches)
    if (state.hasLoadedOnce && state.vehicles.isEmpty) {
      return EmptyStateView(
        icon: Icons.directions_car_outlined,
        title: 'No vehicles found',
        description: state.hasActiveFilters
            ? 'No vehicle records match your search or filter criteria. Try clearing filters.'
            : 'Your fleet inventory is empty. Click "Add Vehicle" to register the first vehicle.',
        actionLabel: state.hasActiveFilters ? 'Clear Filters' : 'Add Vehicle',
        onAction: state.hasActiveFilters
            ? notifier.resetFilters
            : () => context.go(AppRoutes.addVehicle),
      );
    }

    // 4. Data table / mobile cards + Pagination footer
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Inline error banner if refresh/page change failed while keeping existing data visible
        if (state.errorMessage != null) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.destructiveBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.destructiveBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.red,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(
                      color: AppColors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: notifier.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],

        // Subtle controlled progress bar during page transitions / debounced search
        if (state.isPageLoading)
          const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: AppColors.surfaceSecondary,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.corporateBlue),
            ),
          ),

        // Vehicle Data View (Responsive Table vs Mobile Cards)
        AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: state.isPageLoading ? 0.65 : 1.0,
          child: isDesktop
              ? VehicleTable(
                  vehicles: state.vehicles,
                  onEdit: (v) => _navigateToEdit(context, v),
                  onDelete: (v) => _handleDelete(context, ref, v),
                )
              : Column(
                  children: state.vehicles
                      .map(
                        (v) => VehicleMobileCard(
                          vehicle: v,
                          onEdit: () => _navigateToEdit(context, v),
                          onDelete: () => _handleDelete(context, ref, v),
                        ),
                      )
                      .toList(),
                ),
        ),

        const SizedBox(height: 16),

        // Numbered Page-Based Pagination Footer
        VehiclePaginationBar(
          startItem: state.startItem,
          endItem: state.endItem,
          totalElements: state.totalElements,
          displayPage: state.displayPage,
          displayTotalPages: state.displayTotalPages,
          canGoPrevious: state.canGoPrevious,
          canGoNext: state.canGoNext,
          isLoading: state.isPageLoading,
          onPrevious: notifier.previousPage,
          onNext: notifier.nextPage,
        ),
      ],
    );
  }
}
