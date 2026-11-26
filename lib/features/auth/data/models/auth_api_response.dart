import 'package:json_annotation/json_annotation.dart';
import 'package:stark_vms_frontend/features/auth/data/models/auth_response_model.dart';

part 'auth_api_response.g.dart';

@JsonSerializable()
class AuthApiResponse {
  final bool success;
  final String? message;
  final AuthResponseModel? data;
  final String? timestamp;

  const AuthApiResponse({
    required this.success,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AuthApiResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiResponseToJson(this);
}
