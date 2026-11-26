import 'package:stark_vms_frontend/features/auth/domain/entities/auth_session_entity.dart';
import 'package:stark_vms_frontend/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthSessionEntity> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
