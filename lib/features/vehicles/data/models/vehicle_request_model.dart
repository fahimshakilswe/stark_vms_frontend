import 'package:json_annotation/json_annotation.dart';

part 'vehicle_request_model.g.dart';

@JsonSerializable()
class VehicleRequestModel {
  final String vehicleNumber;
  final String company;
  final String type;
  final String brand;
  final String model;
  final String status;

  const VehicleRequestModel({
    required this.vehicleNumber,
    required this.company,
    required this.type,
    required this.brand,
    required this.model,
    required this.status,
  });

  factory VehicleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleRequestModelToJson(this);
}
