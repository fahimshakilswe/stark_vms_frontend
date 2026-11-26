import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_page_entity.dart';

abstract class VehicleRepository {
  Future<VehiclePageEntity> getVehicles({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    String? search,
    String? company,
    String? type,
    String? brand,
    String? model,
    String? status,
  });

  Future<VehicleEntity> getVehicleById(int id);

  Future<VehicleEntity> createVehicle({
    required String vehicleNumber,
    required String company,
    required String type,
    required String brand,
    required String model,
    required String status,
  });

  Future<VehicleEntity> updateVehicle({
    required int id,
    required String vehicleNumber,
    required String company,
    required String type,
    required String brand,
    required String model,
    required String status,
  });

  Future<void> deleteVehicle(int id);
}
