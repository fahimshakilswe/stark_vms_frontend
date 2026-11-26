import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stark_vms_frontend/core/router/route_names.dart';
import 'package:stark_vms_frontend/core/utils/toast_utils.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';
import 'package:stark_vms_frontend/core/widgets/confirm_dialog.dart';
import 'package:stark_vms_frontend/core/widgets/empty_state_view.dart';
import 'package:stark_vms_frontend/core/widgets/error_state_view.dart';
import 'package:stark_vms_frontend/core/widgets/page_header.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_filter_bar.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_mobile_card.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_skeleton.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_table.dart';

class VehicleListScreen extends ConsumerStatefulWidget {
  const VehicleListScreen({super.key});

  @override
  ConsumerState<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends ConsumerState<VehicleListScreen> {
  static const int _pageSize = 10;
  late final PagingController<int, VehicleEntity> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, VehicleEntity>(
      fetchPage: (int pageKey) async {
        final filter = ref.read(vehicleFilterProvider);
        final getVehiclesUseCase = ref.read(getVehiclesUseCaseProvider);

        final pageData = await getVehiclesUseCase(
          page: pageKey,
          size: _pageSize,
          sortBy: filter.sortBy,
          sortDir: filter.sortDir,
          search: filter.searchQuery,
          status: filter.statusFilter,
        );

        return pageData.vehicles;
      },
      getNextPageKey: (PagingState<int, VehicleEntity> state) {
        if (state.pages.isEmpty) return 0;
        final lastPage = state.pages.last;
        if (lastPage.length < _pageSize) return null;
        return (state.keys.lastOrNull ?? 0) + 1;
      },
    );
  }

  void _onFilterChanged() {
    _pagingController.refresh();
  }

  void _navigateToEdit(VehicleEntity vehicle) {
    context.go(AppRoutes.editVehiclePath(vehicle.id));
  }

  Future<void> _handleDelete(VehicleEntity vehicle) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Vehicle',
      message:
          'Are you sure you want to delete vehicle "${vehicle.vehicleNumber}" (${vehicle.company} - ${vehicle.brand} ${vehicle.model})? This action will permanently remove it from the system.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text('Deleting vehicle ${vehicle.vehicleNumber}...'),
            ],
          ),
        ),
      );

      final success = await ref
          .read(vehicleFormNotifierProvider.notifier)
          .deleteVehicle(vehicle.id);

      if (mounted) {
        if (success) {
          AppToast.showSuccess(
            context,
            'Vehicle ${vehicle.vehicleNumber} deleted successfully.',
          );
          // Remove from UI only after backend success
          _pagingController.refresh();
        } else {
          final error = ref.read(vehicleFormNotifierProvider).errorMessage ??
              'Failed to delete vehicle.';
          AppToast.showError(context, error);
        }
      }
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(vehicleFilterProvider);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Screen Header
          PageHeader(
            title: 'Vehicle Fleet',
            subtitle: 'Overview of all registered company vehicles, statuses, and fleet assignments.',
            breadcrumbs: const [
              BreadcrumbItem(label: 'Fleet Management'),
              BreadcrumbItem(label: 'Vehicles'),
            ],
            actions: [
              AppButton(
                label: 'Register Vehicle',
                icon: Icons.add_rounded,
                onPressed: () => context.go(AppRoutes.addVehicle),
              ),
            ],
          ),

          // Filters & Search Bar
          VehicleFilterBar(
            searchQuery: filterState.searchQuery,
            selectedStatus: filterState.statusFilter,
            onSearchChanged: (query) {
              ref.read(vehicleFilterProvider.notifier).setSearchQuery(query);
              _onFilterChanged();
            },
            onStatusChanged: (status) {
              ref.read(vehicleFilterProvider.notifier).setStatusFilter(status);
              _onFilterChanged();
            },
            onRefresh: () => _pagingController.refresh(),
            onClearFilters: () {
              ref.read(vehicleFilterProvider.notifier).resetFilters();
              _onFilterChanged();
            },
          ),
          const SizedBox(height: 20),

          // Infinite Scroll Paged Content with 6.0.0 PagingListener
          PagingListener<int, VehicleEntity>(
            controller: _pagingController,
            builder: (context, state, fetchNextPage) => PagedListView<int, VehicleEntity>(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              state: state,
              fetchNextPage: fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<VehicleEntity>(
                itemBuilder: (context, vehicle, index) {
                  if (!isDesktop) {
                    return VehicleMobileCard(
                      vehicle: vehicle,
                      onEdit: () => _navigateToEdit(vehicle),
                      onDelete: () => _handleDelete(vehicle),
                    );
                  }

                  // Render table for desktop on first index with all collected items
                  final isFirst = index == 0;
                  final allItems = state.items;

                  if (isFirst) {
                    return VehicleTable(
                      vehicles: allItems,
                      onEdit: _navigateToEdit,
                      onDelete: _handleDelete,
                    );
                  }

                  return const SizedBox.shrink();
                },
                firstPageProgressIndicatorBuilder: (_) => const VehicleTableSkeleton(),
                newPageProgressIndicatorBuilder: (_) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => EmptyStateView(
                  icon: Icons.directions_car_outlined,
                  title: 'No vehicles found',
                  description: filterState.searchQuery.isNotEmpty || filterState.statusFilter != null
                      ? 'No fleet records match your current filter criteria. Try adjusting or clearing filters.'
                      : 'Your vehicle fleet is currently empty. Register your first vehicle to get started.',
                  actionLabel: filterState.searchQuery.isNotEmpty || filterState.statusFilter != null
                      ? 'Clear Filters'
                      : 'Register Vehicle',
                  onAction: filterState.searchQuery.isNotEmpty || filterState.statusFilter != null
                      ? () {
                          ref.read(vehicleFilterProvider.notifier).resetFilters();
                          _onFilterChanged();
                        }
                      : () => context.go(AppRoutes.addVehicle),
                ),
                firstPageErrorIndicatorBuilder: (context, error) => ErrorStateView(
                  title: 'Failed to load vehicles',
                  message: error.toString(),
                  onRetry: () => _pagingController.refresh(),
                ),
                newPageErrorIndicatorBuilder: (context, error) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: AppButton(
                      label: 'Retry loading more',
                      variant: AppButtonVariant.outline,
                      size: AppButtonSize.sm,
                      icon: Icons.refresh,
                      onPressed: () => _pagingController.fetchNextPage(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
