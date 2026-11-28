import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/repositories/vehicle_repository.dart';

class UpdateVehicleUseCase {
  final VehicleRepository _repository;

  UpdateVehicleUseCase(this._repository);

  Future<VehicleEntity> call({
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
  }) {
    return _repository.updateVehicle(
      id: id,
      vehicleNumber: vehicleNumber,
      vehicleType: vehicleType,
      brand: brand,
      model: model,
      manufacturingYear: manufacturingYear,
      color: color,
      fuelType: fuelType,
      seatingCapacity: seatingCapacity,
      driverName: driverName,
      driverPhone: driverPhone,
      status: status,
    );
  }
}
