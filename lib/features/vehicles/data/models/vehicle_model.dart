import 'package:json_annotation/json_annotation.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  final int id;
  final String vehicleNumber;
  final String company;
  final String type;
  final String brand;
  final String model;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  const VehicleModel({
    required this.id,
    required this.vehicleNumber,
    required this.company,
    required this.type,
    required this.brand,
    required this.model,
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
      company: company,
      type: type,
      brand: brand,
      model: model,
      status: status,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }

  factory VehicleModel.fromEntity(VehicleEntity entity) {
    return VehicleModel(
      id: entity.id,
      vehicleNumber: entity.vehicleNumber,
      company: entity.company,
      type: entity.type,
      brand: entity.brand,
      model: entity.model,
      status: entity.status,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }
}
