import 'package:stark_vms_frontend/features/auth/domain/entities/auth_session_entity.dart';
import 'package:stark_vms_frontend/features/auth/domain/entities/user_entity.dart';

/// Contract for Authentication repository operations.
abstract class AuthRepository {
  /// Authenticates a user with email and password.
  Future<AuthSessionEntity> login({
    required String email,
    required String password,
  });

  /// Registers a new user account.
  Future<AuthSessionEntity> register({
    required String fullName,
    required String email,
    required String password,
  });

  /// Logs out the user and clears stored session tokens.
  Future<void> logout();

  /// Retrieves the currently cached user entity if session is active.
  Future<UserEntity?> getCurrentUser();

  /// Checks if an active JWT token exists in secure storage.
  Future<bool> hasActiveSession();
}
