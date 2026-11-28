import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stark_vms_frontend/core/router/route_names.dart';
import 'package:stark_vms_frontend/core/utils/toast_utils.dart';
import 'package:stark_vms_frontend/core/widgets/page_header.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_form.dart';

class VehicleAddScreen extends ConsumerStatefulWidget {
  const VehicleAddScreen({super.key});

  @override
  ConsumerState<VehicleAddScreen> createState() => _VehicleAddScreenState();
}

class _VehicleAddScreenState extends ConsumerState<VehicleAddScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleFormNotifierProvider.notifier).reset();
    });
  }

  Future<void> _handleSubmit(VehicleFormData data) async {
    final success = await ref.read(vehicleFormNotifierProvider.notifier).createVehicle(
          vehicleNumber: data.vehicleNumber,
          vehicleType: data.vehicleType,
          brand: data.brand,
          model: data.model,
          manufacturingYear: data.manufacturingYear,
          color: data.color,
          fuelType: data.fuelType,
          seatingCapacity: data.seatingCapacity,
          driverName: data.driverName,
          driverPhone: data.driverPhone,
          status: data.status,
        );

    if (success && mounted) {
      AppToast.showSuccess(context, 'Vehicle registered successfully!');
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
            title: 'Register Vehicle',
            subtitle: 'Add a new vehicle record to the enterprise fleet inventory.',
            breadcrumbs: [
              BreadcrumbItem(
                label: 'Vehicles',
                onTap: () => context.go(AppRoutes.vehicles),
              ),
              const BreadcrumbItem(label: 'Register Vehicle'),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Back to vehicles',
              onPressed: () => context.go(AppRoutes.vehicles),
            ),
          ),
          VehicleForm(
            isSaving: formState.isSaving,
            errorMessage: formState.errorMessage,
            vehicleNumberError: formState.vehicleNumberError,
            onSubmit: _handleSubmit,
            onCancel: () => context.go(AppRoutes.vehicles),
          ),
        ],
      ),
    );
  }
}
