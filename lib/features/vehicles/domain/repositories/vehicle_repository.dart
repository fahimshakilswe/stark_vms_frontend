import 'package:stark_vms_frontend/features/vehicles/domain/entities/dashboard_metrics_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_page_entity.dart';

abstract class VehicleRepository {
  Future<VehiclePageEntity> getVehicles({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    String? search,
    String? vehicleType,
    String? brand,
    String? model,
    String? fuelType,
    String? status,
  });

  Future<VehicleEntity> getVehicleById(int id);

  Future<VehicleEntity> createVehicle({
    required String vehicleNumber,
    required String vehicleType,
    required String brand,
    required String model,
    int? manufacturingYear,
    String? color,
    required String fuelType,
    int? seatingCapacity,
    String? driverName,
    String? driverPhone,
    required String status,
  });

  Future<VehicleEntity> updateVehicle({
    required int id,
    required String vehicleNumber,
    required String vehicleType,
    required String brand,
    required String model,
    int? manufacturingYear,
    String? color,
    required String fuelType,
    int? seatingCapacity,
    String? driverName,
    String? driverPhone,
    required String status,
  });

  Future<void> deleteVehicle(int id);

  Future<DashboardMetricsEntity> getDashboardMetrics();
}
