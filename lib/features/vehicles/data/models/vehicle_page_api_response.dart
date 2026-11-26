import 'package:json_annotation/json_annotation.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_page_response_model.dart';

part 'vehicle_page_api_response.g.dart';

@JsonSerializable()
class VehiclePageApiResponse {
  final bool success;
  final String? message;
  final VehiclePageResponseModel? data;
  final String? timestamp;

  const VehiclePageApiResponse({
    required this.success,
    this.message,
    this.data,
    this.timestamp,
  });

  factory VehiclePageApiResponse.fromJson(Map<String, dynamic> json) =>
      _$VehiclePageApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VehiclePageApiResponseToJson(this);
}
