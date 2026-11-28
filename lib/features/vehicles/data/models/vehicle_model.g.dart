// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
  id: (json['id'] as num).toInt(),
  vehicleNumber: json['vehicleNumber'] as String,
  vehicleType: json['vehicleType'] as String,
  brand: json['brand'] as String,
  model: json['model'] as String,
  manufacturingYear: (json['manufacturingYear'] as num?)?.toInt(),
  color: json['color'] as String?,
  fuelType: json['fuelType'] as String,
  seatingCapacity: (json['seatingCapacity'] as num?)?.toInt(),
  driverName: json['driverName'] as String?,
  driverPhone: json['driverPhone'] as String?,
  status: json['status'] as String,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleNumber': instance.vehicleNumber,
      'vehicleType': instance.vehicleType,
      'brand': instance.brand,
      'model': instance.model,
      'manufacturingYear': instance.manufacturingYear,
      'color': instance.color,
      'fuelType': instance.fuelType,
      'seatingCapacity': instance.seatingCapacity,
      'driverName': instance.driverName,
      'driverPhone': instance.driverPhone,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
