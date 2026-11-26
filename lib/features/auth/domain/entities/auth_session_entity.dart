import 'package:stark_vms_frontend/features/auth/domain/entities/user_entity.dart';

/// Domain entity representing a validated authentication session.
class AuthSessionEntity {
  final String token;
  final String tokenType;
  final UserEntity user;

  const AuthSessionEntity({
    required this.token,
    this.tokenType = 'Bearer',
    required this.user,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSessionEntity &&
          runtimeType == other.runtimeType &&
          token == other.token;

  @override
  int get hashCode => token.hashCode;
}
