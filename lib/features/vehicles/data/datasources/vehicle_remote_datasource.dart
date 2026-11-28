import 'package:dio/dio.dart';
import 'package:stark_vms_frontend/core/network/dio_client.dart';
import 'package:stark_vms_frontend/features/vehicles/data/datasources/vehicle_api_service.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_model.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_page_response_model.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_request_model.dart';

abstract class VehicleRemoteDataSource {
  Future<VehiclePageResponseModel> getVehicles({
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

  Future<VehicleModel> getVehicleById(int id);
  Future<VehicleModel> createVehicle(VehicleRequestModel request);
  Future<VehicleModel> updateVehicle(int id, VehicleRequestModel request);
  Future<void> deleteVehicle(int id);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final VehicleApiService _apiService;

  VehicleRemoteDataSourceImpl(this._apiService);

  String? _cleanParam(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Compatibility mapping for older Spring Boot query parameter enum binding
  /// when `@RequestParam VehicleStatus status` expects PascalCase/legacy names.
  String? _legacyStatusAlias(String status) {
    switch (status.trim().toUpperCase()) {
      case 'AVAILABLE':
        return 'Available';
      case 'ACTIVE':
        return 'Active';
      case 'INACTIVE':
        return 'Inactive';
      case 'MAINTENANCE':
        return 'Maintence';
      default:
        return null;
    }
  }

  @override
  Future<VehiclePageResponseModel> getVehicles({
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
    final cleanSearch = _cleanParam(search);
    final cleanType = _cleanParam(vehicleType);
    final cleanBrand = _cleanParam(brand);
    final cleanModel = _cleanParam(model);
    final cleanFuel = _cleanParam(fuelType);
    final cleanStatus = _cleanParam(status);

    try {
      final response = await _apiService.getVehicles(
        page: page,
        size: size,
        sortBy: sortBy,
        sortDir: sortDir,
        search: cleanSearch,
        vehicleType: cleanType,
        brand: cleanBrand,
        model: cleanModel,
        fuelType: cleanFuel,
        status: cleanStatus,
      );

      if (response.data == null) {
        throw Exception(response.message ?? 'Vehicle list response is empty');
      }
      return response.data!;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && cleanStatus != null) {
        final alias = _legacyStatusAlias(cleanStatus);
        if (alias != null && alias != cleanStatus) {
          try {
            final retryResponse = await _apiService.getVehicles(
              page: page,
              size: size,
              sortBy: sortBy,
              sortDir: sortDir,
              search: cleanSearch,
              vehicleType: cleanType,
              brand: cleanBrand,
              model: cleanModel,
              fuelType: cleanFuel,
              status: alias,
            );
            if (retryResponse.data != null) {
              return retryResponse.data!;
            }
          } on DioException catch (retryError) {
            throw handleDioError(retryError);
          }
        }
      }
      throw handleDioError(e);
    }
  }

  @override
  Future<VehicleModel> getVehicleById(int id) async {
    try {
      final response = await _apiService.getVehicleById(id);
      if (response.data == null) {
        throw Exception(response.message ?? 'Vehicle details response is empty');
      }
      return response.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<VehicleModel> createVehicle(VehicleRequestModel request) async {
    try {
      final response = await _apiService.createVehicle(request);
      if (response.data == null) {
        throw Exception(response.message ?? 'Failed to create vehicle');
      }
      return response.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<VehicleModel> updateVehicle(int id, VehicleRequestModel request) async {
    try {
      final response = await _apiService.updateVehicle(id, request);
      if (response.data == null) {
        throw Exception(response.message ?? 'Failed to update vehicle');
      }
      return response.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<void> deleteVehicle(int id) async {
    try {
      await _apiService.deleteVehicle(id);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
