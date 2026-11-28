// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleRequestModel _$VehicleRequestModelFromJson(Map<String, dynamic> json) =>
    VehicleRequestModel(
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
    );

Map<String, dynamic> _$VehicleRequestModelToJson(
  VehicleRequestModel instance,
) => <String, dynamic>{
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
};
