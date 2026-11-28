import 'package:json_annotation/json_annotation.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  final int id;
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
  final String? createdAt;
  final String? updatedAt;

  const VehicleModel({
    required this.id,
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
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

  VehicleEntity toEntity() {
    return VehicleEntity(
      id: id,
      vehicleNumber: vehicleNumber,
      vehicleType: vehicleType,
      brand: brand,
      model: model,
      manufacturingYear: manufacturingYear,
      color: color,
      fuelType: fuelType,
      seatingCapacity: seatingCapacity,
      driverName: driverName,
      driverPhone: driverPhone,
      status: status,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }

  factory VehicleModel.fromEntity(VehicleEntity entity) {
    return VehicleModel(
      id: entity.id,
      vehicleNumber: entity.vehicleNumber,
      vehicleType: entity.vehicleType,
      brand: entity.brand,
      model: entity.model,
      manufacturingYear: entity.manufacturingYear,
      color: entity.color,
      fuelType: entity.fuelType,
      seatingCapacity: entity.seatingCapacity,
      driverName: entity.driverName,
      driverPhone: entity.driverPhone,
      status: entity.status,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }
}
