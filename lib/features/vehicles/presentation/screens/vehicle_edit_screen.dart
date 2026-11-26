import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stark_vms_frontend/core/router/route_names.dart';
import 'package:stark_vms_frontend/core/utils/toast_utils.dart';
import 'package:stark_vms_frontend/core/widgets/error_state_view.dart';
import 'package:stark_vms_frontend/core/widgets/page_header.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_form.dart';

class VehicleEditScreen extends ConsumerStatefulWidget {
  final int vehicleId;

  const VehicleEditScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  ConsumerState<VehicleEditScreen> createState() => _VehicleEditScreenState();
}

class _VehicleEditScreenState extends ConsumerState<VehicleEditScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleFormNotifierProvider.notifier).loadVehicle(widget.vehicleId);
    });
  }

  Future<void> _handleSubmit(VehicleFormData data) async {
    final success = await ref.read(vehicleFormNotifierProvider.notifier).updateVehicle(
          id: widget.vehicleId,
          vehicleNumber: data.vehicleNumber,
          company: data.company,
          type: data.type,
          brand: data.brand,
          model: data.model,
          status: data.status,
        );

    if (success && mounted) {
      AppToast.showSuccess(context, 'Vehicle updated successfully!');
      context.go(AppRoutes.vehicles);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(vehicleFormNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Edit Vehicle #${widget.vehicleId}',
            subtitle: 'Update fleet specifications and operational status.',
            breadcrumbs: [
              BreadcrumbItem(
                label: 'Vehicles',
                onTap: () => context.go(AppRoutes.vehicles),
              ),
              BreadcrumbItem(label: 'Edit #${widget.vehicleId}'),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Back to vehicles',
              onPressed: () => context.go(AppRoutes.vehicles),
            ),
          ),

          // Loading skeleton state
          if (formState.isLoading)
            Skeletonizer(
              enabled: true,
              child: VehicleForm(
                initialVehicle: VehicleEntity(
                  id: widget.vehicleId,
                  vehicleNumber: 'DHAKA-METRO-GA-1234',
                  company: 'Acme Logistics',
                  type: 'Sedan',
                  brand: 'Toyota',
                  model: 'Corolla',
                  status: 'ACTIVE',
                ),
                onSubmit: (_) {},
                onCancel: () => context.go(AppRoutes.vehicles),
              ),
            )
          // Error loading vehicle
          else if (formState.errorMessage != null && formState.vehicle == null)
            ErrorStateView(
              title: 'Failed to load vehicle details',
              message: formState.errorMessage!,
              onRetry: () => ref
                  .read(vehicleFormNotifierProvider.notifier)
                  .loadVehicle(widget.vehicleId),
            )
          // Form with loaded vehicle data
          else if (formState.vehicle != null)
            VehicleForm(
              initialVehicle: formState.vehicle,
              isSaving: formState.isSaving,
              errorMessage: formState.errorMessage,
              onSubmit: _handleSubmit,
              onCancel: () => context.go(AppRoutes.vehicles),
            ),
        ],
      ),
    );
  }
}
