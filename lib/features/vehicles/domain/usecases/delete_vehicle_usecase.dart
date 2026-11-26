import 'package:stark_vms_frontend/features/vehicles/domain/repositories/vehicle_repository.dart';

class DeleteVehicleUseCase {
  final VehicleRepository _repository;

  DeleteVehicleUseCase(this._repository);

  Future<void> call(int id) {
    return _repository.deleteVehicle(id);
  }
}
