import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stark_vms_frontend/core/error/failures.dart';
import 'package:stark_vms_frontend/core/network/dio_client.dart';
import 'package:stark_vms_frontend/core/storage/token_storage.dart';
import 'package:stark_vms_frontend/features/auth/data/datasources/auth_api_service.dart';
import 'package:stark_vms_frontend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:stark_vms_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stark_vms_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:stark_vms_frontend/features/auth/domain/usecases/login_usecase.dart';
import 'package:stark_vms_frontend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:stark_vms_frontend/features/auth/domain/usecases/register_usecase.dart';
import 'package:stark_vms_frontend/features/auth/presentation/providers/auth_state.dart';

// DI Providers
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref.watch(dioProvider));
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(authApiServiceProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

// Modern Riverpod Notifier Provider
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Check local session on initial provider build
    Future.microtask(() => checkAuthSession());
    return const AuthState();
  }

  /// Restores session from secure storage on app launch.
  Future<void> checkAuthSession() async {
    final repository = ref.read(authRepositoryProvider);
    final hasSession = await repository.hasActiveSession();
    if (hasSession) {
      final user = await repository.getCurrentUser();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Performs user login.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      clearError: true,
    );

    try {
      final loginUseCase = ref.read(loginUseCaseProvider);
      final session = await loginUseCase(
        email: email,
        password: password,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: session.user,
        clearError: true,
      );
      return true;
    } on Failure catch (f) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: f.message,
        validationErrors: f is ValidationFailure ? f.errors : null,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred during login.',
      );
      return false;
    }
  }

  /// Performs user registration.
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      clearError: true,
    );

    try {
      final registerUseCase = ref.read(registerUseCaseProvider);
      await registerUseCase(
        fullName: fullName,
        email: email,
        password: password,
      );

      state = state.copyWith(
        status: AuthStatus.registrationSuccess,
        clearError: true,
      );
      return true;
    } on Failure catch (f) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: f.message,
        validationErrors: f is ValidationFailure ? f.errors : null,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred during registration.',
      );
      return false;
    }
  }

  /// Clears active session.
  Future<void> logout() async {
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    await logoutUseCase();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Clears error messages.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
