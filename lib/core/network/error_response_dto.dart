import 'package:json_annotation/json_annotation.dart';

part 'error_response_dto.g.dart';

@JsonSerializable()
class ErrorResponseDto {
  final String? timestamp;
  final int status;
  final String? error;
  final String message;
  final String? path;
  final Map<String, String>? validationErrors;

  const ErrorResponseDto({
    this.timestamp,
    required this.status,
    this.error,
    required this.message,
    this.path,
    this.validationErrors,
  });

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseDtoToJson(this);
}
