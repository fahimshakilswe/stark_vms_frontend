import 'package:json_annotation/json_annotation.dart';

part 'vehicle_action_response.g.dart';

@JsonSerializable()
class VehicleActionResponse {
  final bool success;
  final String? message;
  final String? timestamp;

  const VehicleActionResponse({
    required this.success,
    this.message,
    this.timestamp,
  });

  factory VehicleActionResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleActionResponseToJson(this);
}
