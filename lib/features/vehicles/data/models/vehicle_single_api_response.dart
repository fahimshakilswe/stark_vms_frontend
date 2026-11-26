import 'package:json_annotation/json_annotation.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_model.dart';

part 'vehicle_single_api_response.g.dart';

@JsonSerializable()
class VehicleSingleApiResponse {
  final bool success;
  final String? message;
  final VehicleModel? data;
  final String? timestamp;

  const VehicleSingleApiResponse({
    required this.success,
    this.message,
    this.data,
    this.timestamp,
  });

  factory VehicleSingleApiResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleSingleApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleSingleApiResponseToJson(this);
}
