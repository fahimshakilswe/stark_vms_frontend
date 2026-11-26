import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:stark_vms_frontend/core/constants/api_constants.dart';
import 'package:stark_vms_frontend/features/auth/data/models/auth_api_response.dart';
import 'package:stark_vms_frontend/features/auth/data/models/login_request_model.dart';
import 'package:stark_vms_frontend/features/auth/data/models/register_request_model.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST(ApiConstants.register)
  Future<AuthApiResponse> register(
    @Body() RegisterRequestModel request,
  );

  @POST(ApiConstants.login)
  Future<AuthApiResponse> login(
    @Body() LoginRequestModel request,
  );
}
