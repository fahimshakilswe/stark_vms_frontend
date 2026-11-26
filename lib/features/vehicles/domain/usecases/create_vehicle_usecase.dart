import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/repositories/vehicle_repository.dart';

class CreateVehicleUseCase {
  final VehicleRepository _repository;

  CreateVehicleUseCase(this._repository);

  Future<VehicleEntity> call({
    required String vehicleNumber,
    required String company,
    required String type,
    required String brand,
    required String model,
    required String status,
  }) {
    return _repository.createVehicle(
      vehicleNumber: vehicleNumber,
      company: company,
      type: type,
      brand: brand,
      model: model,
      status: status,
    );
  }
}
