import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:stark_vms_frontend/core/constants/api_constants.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_action_response.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_page_api_response.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_request_model.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_single_api_response.dart';

part 'vehicle_api_service.g.dart';

@RestApi()
abstract class VehicleApiService {
  factory VehicleApiService(Dio dio, {String baseUrl}) = _VehicleApiService;

  @GET(ApiConstants.vehicles)
  Future<VehiclePageApiResponse> getVehicles({
    @Query('page') int page = 0,
    @Query('size') int size = 10,
    @Query('sortBy') String sortBy = 'createdAt',
    @Query('sortDir') String sortDir = 'desc',
    @Query('search') String? search,
    @Query('company') String? company,
    @Query('type') String? type,
    @Query('brand') String? brand,
    @Query('model') String? model,
    @Query('status') String? status,
  });

  @GET('${ApiConstants.vehicles}/{id}')
  Future<VehicleSingleApiResponse> getVehicleById(@Path('id') int id);

  @POST(ApiConstants.vehicles)
  Future<VehicleSingleApiResponse> createVehicle(
    @Body() VehicleRequestModel request,
  );

  @PUT('${ApiConstants.vehicles}/{id}')
  Future<VehicleSingleApiResponse> updateVehicle(
    @Path('id') int id,
    @Body() VehicleRequestModel request,
  );

  @DELETE('${ApiConstants.vehicles}/{id}')
  Future<VehicleActionResponse> deleteVehicle(@Path('id') int id);
}
