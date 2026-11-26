import 'package:stark_vms_frontend/core/network/error_response_dto.dart';

/// Clean Architecture Failure representation for domain & presentation layers.
abstract class Failure {
  final String message;
  final int? statusCode;
  final ErrorResponseDto? errorResponse;

  const Failure({
    required this.message,
    this.statusCode,
    this.errorResponse,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode;

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.errorResponse,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
    super.errorResponse,
  });
}

class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure({
    required super.message,
    this.errors = const {},
    super.statusCode = 400,
    super.errorResponse,
  });
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    required super.message,
    super.statusCode = 409,
    super.errorResponse,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.statusCode = 404,
    super.errorResponse,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Unable to connect to server. Please check your network.',
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to load local cached data.',
  });
}
