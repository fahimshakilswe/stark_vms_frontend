import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';

/// Domain entity representing a paginated page of vehicles.
class VehiclePageEntity {
  final List<VehicleEntity> vehicles;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;

  const VehiclePageEntity({
    required this.vehicles,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });
}
