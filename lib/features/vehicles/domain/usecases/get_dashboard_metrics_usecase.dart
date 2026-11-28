import 'package:stark_vms_frontend/features/vehicles/domain/entities/dashboard_metrics_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetDashboardMetricsUseCase {
  final VehicleRepository _repository;

  GetDashboardMetricsUseCase(this._repository);

  Future<DashboardMetricsEntity> call() {
    return _repository.getDashboardMetrics();
  }
}
