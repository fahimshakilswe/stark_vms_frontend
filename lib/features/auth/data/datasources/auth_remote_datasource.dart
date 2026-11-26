import 'package:dio/dio.dart';
import 'package:stark_vms_frontend/core/network/dio_client.dart';
import 'package:stark_vms_frontend/features/auth/data/datasources/auth_api_service.dart';
import 'package:stark_vms_frontend/features/auth/data/models/auth_response_model.dart';
import 'package:stark_vms_frontend/features/auth/data/models/login_request_model.dart';
import 'package:stark_vms_frontend/features/auth/data/models/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<AuthResponseModel> register(RegisterRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiService.login(request);
      if (response.data == null) {
        throw Exception(response.message ?? 'Login response data is empty');
      }
      return response.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _apiService.register(request);
      if (response.data == null) {
        throw Exception(response.message ?? 'Register response data is empty');
      }
      return response.data!;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
