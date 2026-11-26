import 'package:json_annotation/json_annotation.dart';
import 'package:stark_vms_frontend/features/auth/data/models/user_model.dart';
import 'package:stark_vms_frontend/features/auth/domain/entities/auth_session_entity.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final String token;
  final String tokenType;
  final UserModel user;

  const AuthResponseModel({
    required this.token,
    this.tokenType = 'Bearer',
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  AuthSessionEntity toEntity() {
    return AuthSessionEntity(
      token: token,
      tokenType: tokenType,
      user: user.toEntity(),
    );
  }
}
