import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_mobile_card.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_table.dart';

class VehicleTableSkeleton extends StatelessWidget {
  const VehicleTableSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    final dummyVehicles = List.generate(
      6,
      (i) => VehicleEntity(
        id: i,
        vehicleNumber: 'DHAKA-METRO-GA-123$i',
        company: 'Logistics Enterprise Fleet',
        type: 'Delivery Van',
        brand: 'Mercedes-Benz',
        model: 'Sprinter Cargo',
        status: 'ACTIVE',
      ),
    );

    if (!isDesktop) {
      return Skeletonizer(
        enabled: true,
        child: Column(
          children: dummyVehicles
              .map(
                (v) => VehicleMobileCard(
                  vehicle: v,
                  onEdit: () {},
                  onDelete: () {},
                ),
              )
              .toList(),
        ),
      );
    }

    return Skeletonizer(
      enabled: true,
      child: VehicleTable(
        vehicles: dummyVehicles,
        onEdit: (_) {},
        onDelete: (_) {},
      ),
    );
  }
}
