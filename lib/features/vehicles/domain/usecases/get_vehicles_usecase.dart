import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_page_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  final VehicleRepository _repository;

  GetVehiclesUseCase(this._repository);

  Future<VehiclePageEntity> call({
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
  }) {
    return _repository.getVehicles(
      page: page,
      size: size,
      sortBy: sortBy,
      sortDir: sortDir,
      search: search,
      vehicleType: vehicleType,
      brand: brand,
      model: model,
      fuelType: fuelType,
      status: status,
    );
  }
}
