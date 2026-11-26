import 'package:stark_vms_frontend/core/error/exceptions.dart';
import 'package:stark_vms_frontend/core/error/failures.dart';
import 'package:stark_vms_frontend/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_request_model.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_page_entity.dart';
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
    String? company,
    String? type,
    String? brand,
    String? model,
    String? status,
  }) async {
    try {
      final pageModel = await _remoteDataSource.getVehicles(
        page: page,
        size: size,
        sortBy: sortBy,
        sortDir: sortDir,
        search: search,
        company: company,
        type: type,
        brand: brand,
        model: model,
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
    required String company,
    required String type,
    required String brand,
    required String model,
    required String status,
  }) async {
    try {
      final request = VehicleRequestModel(
        vehicleNumber: vehicleNumber,
        company: company,
        type: type,
        brand: brand,
        model: model,
        status: status,
      );
      final createdModel = await _remoteDataSource.createVehicle(request);
      return createdModel.toEntity();
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
    required String company,
    required String type,
    required String brand,
    required String model,
    required String status,
  }) async {
    try {
      final request = VehicleRequestModel(
        vehicleNumber: vehicleNumber,
        company: company,
        type: type,
        brand: brand,
        model: model,
        status: status,
      );
      final updatedModel = await _remoteDataSource.updateVehicle(id, request);
      return updatedModel.toEntity();
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

  Failure _mapAppExceptionToFailure(AppException e) {
    if (e is ValidationException) {
      return ValidationFailure(
        message: e.message,
        errors: e.errors,
        errorResponse: e.errorResponse,
      );
    } else if (e is ConflictException) {
      return ConflictFailure(
        message: e.message,
        errorResponse: e.errorResponse,
      );
    } else if (e is NotFoundException) {
      return NotFoundFailure(
        message: e.message,
        errorResponse: e.errorResponse,
      );
    } else if (e is UnauthorizedException) {
      return AuthFailure(
        message: e.message,
        errorResponse: e.errorResponse,
      );
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    } else {
      return ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorResponse: e.errorResponse,
      );
    }
  }
}
