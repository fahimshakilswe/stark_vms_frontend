// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_page_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehiclePageApiResponse _$VehiclePageApiResponseFromJson(
  Map<String, dynamic> json,
) => VehiclePageApiResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : VehiclePageResponseModel.fromJson(json['data'] as Map<String, dynamic>),
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$VehiclePageApiResponseToJson(
  VehiclePageApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'timestamp': instance.timestamp,
};
