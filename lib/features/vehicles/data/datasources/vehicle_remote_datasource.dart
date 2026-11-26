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
    String? company,
    String? type,
    String? brand,
    String? model,
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

  @override
  Future<VehiclePageResponseModel> getVehicles({
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
      final response = await _apiService.getVehicles(
        page: page,
        size: size,
        sortBy: sortBy,
        sortDir: sortDir,
        search: search != null && search.trim().isNotEmpty ? search.trim() : null,
        company: company != null && company.trim().isNotEmpty ? company.trim() : null,
        type: type != null && type.trim().isNotEmpty ? type.trim() : null,
        brand: brand != null && brand.trim().isNotEmpty ? brand.trim() : null,
        model: model != null && model.trim().isNotEmpty ? model.trim() : null,
        status: status != null && status.trim().isNotEmpty ? status.trim() : null,
      );

      if (response.data == null) {
        throw Exception(response.message ?? 'Vehicle list response is empty');
      }
      return response.data!;
    } on DioException catch (e) {
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
