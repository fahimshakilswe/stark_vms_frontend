import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetVehicleByIdUseCase {
  final VehicleRepository _repository;

  GetVehicleByIdUseCase(this._repository);

  Future<VehicleEntity> call(int id) {
    return _repository.getVehicleById(id);
  }
}
