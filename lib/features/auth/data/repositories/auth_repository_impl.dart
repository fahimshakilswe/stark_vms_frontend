import 'dart:convert';
import 'package:stark_vms_frontend/core/error/exceptions.dart';
import 'package:stark_vms_frontend/core/error/failures.dart';
import 'package:stark_vms_frontend/core/storage/token_storage.dart';
import 'package:stark_vms_frontend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:stark_vms_frontend/features/auth/data/models/login_request_model.dart';
import 'package:stark_vms_frontend/features/auth/data/models/register_request_model.dart';
import 'package:stark_vms_frontend/features/auth/data/models/user_model.dart';
import 'package:stark_vms_frontend/features/auth/domain/entities/auth_session_entity.dart';
import 'package:stark_vms_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:stark_vms_frontend/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._tokenStorage,
  );

  @override
  Future<AuthSessionEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        LoginRequestModel(email: email, password: password),
      );

      // Securely store the JWT token and user profile
      await _tokenStorage.saveToken(response.token);
      await _tokenStorage.saveUserData(jsonEncode(response.user.toJson()));

      return response.toEntity();
    } on AppException catch (e) {
      throw _mapAppExceptionToFailure(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<AuthSessionEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        RegisterRequestModel(
          fullName: fullName,
          email: email,
          password: password,
        ),
      );

      return response.toEntity();
    } on AppException catch (e) {
      throw _mapAppExceptionToFailure(e);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearAuthSession();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final userJson = await _tokenStorage.getUserData();
      if (userJson != null && userJson.isNotEmpty) {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(map).toEntity();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> hasActiveSession() async {
    return await _tokenStorage.hasToken();
  }

  Failure _mapAppExceptionToFailure(AppException e) {
    if (e is ValidationException) {
      return ValidationFailure(
        message: e.message,
        errors: e.errors,
        errorResponse: e.errorResponse,
      );
    } else if (e is ConflictException) {
      return ConflictFailure(
        message: e.message,
        errorResponse: e.errorResponse,
      );
    } else if (e is UnauthorizedException) {
      return AuthFailure(
        message: e.message,
        errorResponse: e.errorResponse,
      );
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    } else {
      return ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorResponse: e.errorResponse,
      );
    }
  }
}
