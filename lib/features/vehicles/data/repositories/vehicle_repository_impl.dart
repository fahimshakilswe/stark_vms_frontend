import 'package:stark_vms_frontend/core/error/exceptions.dart';
import 'package:stark_vms_frontend/core/error/failures.dart';
import 'package:stark_vms_frontend/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_request_model.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/dashboard_metrics_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_page_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/enums/vehicle_enums.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource _remoteDataSource;

  VehicleRepositoryImpl(this._remoteDataSource);

  @override
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
  }) async {
    try {
      final pageModel = await _remoteDataSource.getVehicles(
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
      return pageModel.toEntity();
    } on AppException catch (e) {
      throw _mapAppExceptionToFailure(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<VehicleEntity> getVehicleById(int id) async {
    try {
      final model = await _remoteDataSource.getVehicleById(id);
      return model.toEntity();
    } on AppException catch (e) {
      throw _mapAppExceptionToFailure(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
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
  }) async {
    try {
      final request = VehicleRequestModel(
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
      final created = await _remoteDataSource.createVehicle(request);
      return created.toEntity();
    } on AppException catch (e) {
      throw _mapAppExceptionToFailure(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
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
  }) async {
    try {
      final request = VehicleRequestModel(
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
      final updated = await _remoteDataSource.updateVehicle(id, request);
      return updated.toEntity();
    } on AppException catch (e) {
      throw _mapAppExceptionToFailure(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteVehicle(int id) async {
    try {
      await _remoteDataSource.deleteVehicle(id);
    } on AppException catch (e) {
      throw _mapAppExceptionToFailure(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<DashboardMetricsEntity> getDashboardMetrics() async {
    try {
      // Aggregate counts across the complete backend dataset (pages of size 100)
      // so all four normalized statuses add up accurately to totalVehicles even
      // across enum spelling/case variations (e.g. MAINTENANCE vs Maintence).
      int page = 0;
      const int batchSize = 100;
      int totalVehicles = 0;
      int available = 0;
      int active = 0;
      int inactive = 0;
      int maintenance = 0;

      while (true) {
        final pageResponse = await _remoteDataSource.getVehicles(
          page: page,
          size: batchSize,
        );

        if (page == 0) {
          totalVehicles = pageResponse.totalElements;
        }

        for (final vehicle in pageResponse.content) {
          final parsedStatus = VehicleStatus.fromString(vehicle.status);
          switch (parsedStatus) {
            case VehicleStatus.AVAILABLE:
              available++;
              break;
            case VehicleStatus.ACTIVE:
              active++;
              break;
            case VehicleStatus.INACTIVE:
              inactive++;
              break;
            case VehicleStatus.MAINTENANCE:
              maintenance++;
              break;
            case null:
              break;
          }
        }

        if (pageResponse.last || pageResponse.content.isEmpty) {
          break;
        }
        page++;
      }

      return DashboardMetricsEntity(
        totalVehicles: totalVehicles,
        availableVehicles: available,
        activeVehicles: active,
        inactiveVehicles: inactive,
        underMaintenance: maintenance,
      );
    } on AppException catch (e) {
      throw _mapAppExceptionToFailure(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Failure _mapAppExceptionToFailure(AppException e) {
    if (e is ValidationException) {
      return ValidationFailure(
        message: e.message,
        errors: e.errors,
        statusCode: e.statusCode,
        errorResponse: e.errorResponse,
      );
    } else if (e is ConflictException) {
      return ConflictFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorResponse: e.errorResponse,
      );
    } else if (e is NotFoundException) {
      return NotFoundFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorResponse: e.errorResponse,
      );
    } else if (e is UnauthorizedException) {
      return AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorResponse: e.errorResponse,
      );
    } else if (e is NetworkException) {
      return NetworkFailure(
        message: e.message,
        statusCode: e.statusCode,
      );
    }
    return ServerFailure(
      message: e.message,
      statusCode: e.statusCode,
      errorResponse: e.errorResponse,
    );
  }
}
