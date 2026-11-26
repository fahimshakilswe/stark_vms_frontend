import 'package:json_annotation/json_annotation.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_model.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_page_entity.dart';

part 'vehicle_page_response_model.g.dart';

@JsonSerializable()
class VehiclePageResponseModel {
  final List<VehicleModel> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool last;

  const VehiclePageResponseModel({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory VehiclePageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VehiclePageResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehiclePageResponseModelToJson(this);

  VehiclePageEntity toEntity() {
    return VehiclePageEntity(
      vehicles: content.map((m) => m.toEntity()).toList(),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: last,
    );
  }
}
