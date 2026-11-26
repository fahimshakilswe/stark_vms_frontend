// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_action_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleActionResponse _$VehicleActionResponseFromJson(
  Map<String, dynamic> json,
) => VehicleActionResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$VehicleActionResponseToJson(
  VehicleActionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'timestamp': instance.timestamp,
};
