// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_single_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleSingleApiResponse _$VehicleSingleApiResponseFromJson(
  Map<String, dynamic> json,
) => VehicleSingleApiResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : VehicleModel.fromJson(json['data'] as Map<String, dynamic>),
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$VehicleSingleApiResponseToJson(
  VehicleSingleApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'timestamp': instance.timestamp,
};
