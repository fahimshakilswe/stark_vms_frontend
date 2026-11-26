// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleRequestModel _$VehicleRequestModelFromJson(Map<String, dynamic> json) =>
    VehicleRequestModel(
      vehicleNumber: json['vehicleNumber'] as String,
      company: json['company'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$VehicleRequestModelToJson(
  VehicleRequestModel instance,
) => <String, dynamic>{
  'vehicleNumber': instance.vehicleNumber,
  'company': instance.company,
  'type': instance.type,
  'brand': instance.brand,
  'model': instance.model,
  'status': instance.status,
};
