// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehiclePageResponseModel _$VehiclePageResponseModelFromJson(
  Map<String, dynamic> json,
) => VehiclePageResponseModel(
  content: (json['content'] as List<dynamic>)
      .map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  last: json['last'] as bool,
);

Map<String, dynamic> _$VehiclePageResponseModelToJson(
  VehiclePageResponseModel instance,
) => <String, dynamic>{
  'content': instance.content,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'last': instance.last,
};
