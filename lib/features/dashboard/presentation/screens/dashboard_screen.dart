import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stark_vms_frontend/core/router/route_names.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';
import 'package:stark_vms_frontend/core/widgets/error_state_view.dart';
import 'package:stark_vms_frontend/core/widgets/page_header.dart';
import 'package:stark_vms_frontend/features/dashboard/presentation/widgets/summary_metric_card.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/dashboard_metrics_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/enums/vehicle_enums.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _navigateToVehiclesWithFilter(
    BuildContext context,
    WidgetRef ref,
    String? status,
  ) {
    ref.read(vehicleListProvider.notifier).applyStatusFilter(status);
    context.go(AppRoutes.vehicles);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(dashboardMetricsProvider);
    final width = MediaQuery.of(context).size.width;
    final cachedMetrics = metricsAsync.asData?.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard Header
          PageHeader(
            title: 'Fleet Dashboard',
            subtitle:
                'Real-time overview of fleet statistics, vehicle operational statuses, and assignments.',
            breadcrumbs: const [
              BreadcrumbItem(label: 'Stark Group VMS'),
              BreadcrumbItem(label: 'Dashboard'),
            ],
            actions: [
              AppButton(
                label: 'Refresh',
                variant: AppButtonVariant.outline,
                icon: Icons.refresh_rounded,
                isLoading: metricsAsync.isLoading || metricsAsync.isRefreshing,
                onPressed: (metricsAsync.isLoading || metricsAsync.isRefreshing)
                    ? null
                    : () => ref.invalidate(dashboardMetricsProvider),
              ),
              const SizedBox(width: 8),
              AppButton(
                label: 'Register Vehicle',
                icon: Icons.add_rounded,
                onPressed: () => context.go(AppRoutes.addVehicle),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Summary Metrics Cards Grid — keep already displayed data smooth during refreshes
          if (cachedMetrics != null)
            _buildMetricsGrid(context, ref, cachedMetrics, width)
          else if (metricsAsync.isLoading)
            Skeletonizer(
              enabled: true,
              child: _buildMetricsGrid(
                context,
                ref,
                const DashboardMetricsEntity(
                  totalVehicles: 20,
                  availableVehicles: 11,
                  activeVehicles: 6,
                  inactiveVehicles: 1,
                  underMaintenance: 2,
                ),
                width,
              ),
            )
          else if (metricsAsync.hasError)
            ErrorStateView(
              title: 'Unable to load fleet summary metrics',
              message: metricsAsync.error.toString(),
              onRetry: () => ref.invalidate(dashboardMetricsProvider),
            ),

          const SizedBox(height: 32),

          // Quick Management Actions & Fleet Distribution
          _buildQuickOverview(context, ref, cachedMetrics, width),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(
    BuildContext context,
    WidgetRef ref,
    DashboardMetricsEntity metrics,
    double width,
  ) {
    // 5 Summary Cards:
    // 1. Total Vehicles (Deep Blue)
    // 2. Available Vehicles (Green) -> AVAILABLE
    // 3. Active Vehicles (Corporate Blue) -> ACTIVE
    // 4. Inactive Vehicles (Neutral Gray) -> INACTIVE
    // 5. Under Maintenance (Amber/Warning) -> MAINTENANCE
    final cards = [
      SummaryMetricCard(
        title: 'Total Vehicles',
        count: metrics.totalVehicles,
        subtitle: 'All registered vehicles',
        icon: Icons.directions_car_filled_rounded,
        accentColor: AppColors.deepBlue,
        iconBackground: const Color(0xFFE8F1F8),
        onTap: () => _navigateToVehiclesWithFilter(context, ref, null),
      ),
      SummaryMetricCard(
        title: 'Available Vehicles',
        count: metrics.availableVehicles,
        subtitle: 'Status: Available',
        icon: Icons.check_circle_rounded,
        accentColor: AppColors.green,
        iconBackground: AppColors.successBackground,
        onTap: () => _navigateToVehiclesWithFilter(
          context,
          ref,
          VehicleStatus.AVAILABLE.name,
        ),
      ),
      SummaryMetricCard(
        title: 'Active Vehicles',
        count: metrics.activeVehicles,
        subtitle: 'Status: Active',
        icon: Icons.commute_rounded,
        accentColor: AppColors.corporateBlue,
        iconBackground: const Color(0xFFEBF3FA),
        onTap: () => _navigateToVehiclesWithFilter(
          context,
          ref,
          VehicleStatus.ACTIVE.name,
        ),
      ),
      SummaryMetricCard(
        title: 'Inactive Vehicles',
        count: metrics.inactiveVehicles,
        subtitle: 'Status: Inactive',
        icon: Icons.pause_circle_outline_rounded,
        accentColor: const Color(0xFF6B7280),
        iconBackground: AppColors.surfaceSecondary,
        onTap: () => _navigateToVehiclesWithFilter(
          context,
          ref,
          VehicleStatus.INACTIVE.name,
        ),
      ),
      SummaryMetricCard(
        title: 'Under Maintenance',
        count: metrics.underMaintenance,
        subtitle: 'Status: Maintenance',
        icon: Icons.build_circle_outlined,
        accentColor: const Color(0xFFD97706),
        iconBackground: const Color(0xFFFEF3C7),
        onTap: () => _navigateToVehiclesWithFilter(
          context,
          ref,
          VehicleStatus.MAINTENANCE.name,
        ),
      ),
    ];

    int crossAxisCount;
    if (width >= 1200) {
      crossAxisCount = 5;
    } else if (width >= 768) {
      crossAxisCount = 3;
    } else if (width >= 540) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: crossAxisCount == 5 ? 1.38 : 1.75,
      children: cards,
    );
  }

  Widget _buildQuickOverview(
    BuildContext context,
    WidgetRef ref,
    DashboardMetricsEntity? metrics,
    double width,
  ) {
    final total = metrics?.totalVehicles ?? 0;
    final available = metrics?.availableVehicles ?? 0;
    final active = metrics?.activeVehicles ?? 0;
    final maint = metrics?.underMaintenance ?? 0;
    final inactive = metrics?.inactiveVehicles ?? 0;

    final availPct =
        total > 0 ? (available / total * 100).toStringAsFixed(1) : '0';
    final activePct =
        total > 0 ? (active / total * 100).toStringAsFixed(1) : '0';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Operational Fleet Overview',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepBlue,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fleet availability rate: $availPct% • Active deployment: $activePct%',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              AppButton(
                label: 'View All Vehicles',
                variant: AppButtonVariant.outline,
                size: AppButtonSize.sm,
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: () => context.go(AppRoutes.vehicles),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.border),
          const SizedBox(height: 20),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              _buildMetricStat('Available', available, AppColors.green),
              _buildMetricStat('Active', active, AppColors.corporateBlue),
              _buildMetricStat('Inactive', inactive, const Color(0xFF6B7280)),
              _buildMetricStat('Maintenance', maint, const Color(0xFFD97706)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricStat(String label, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.charcoal,
          ),
        ),
      ],
    );
  }
}
