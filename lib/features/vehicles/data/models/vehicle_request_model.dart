import 'package:json_annotation/json_annotation.dart';

part 'vehicle_request_model.g.dart';

@JsonSerializable()
class VehicleRequestModel {
  final String vehicleNumber;
  final String vehicleType;
  final String brand;
  final String model;
  final int? manufacturingYear;
  final String? color;
  final String fuelType;
  final int? seatingCapacity;
  final String? driverName;
  final String? driverPhone;
  final String status;

  const VehicleRequestModel({
    required this.vehicleNumber,
    required this.vehicleType,
    required this.brand,
    required this.model,
    this.manufacturingYear,
    this.color,
    required this.fuelType,
    this.seatingCapacity,
    this.driverName,
    this.driverPhone,
    required this.status,
  });

  factory VehicleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleRequestModelToJson(this);
}
