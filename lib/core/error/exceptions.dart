import 'package:stark_vms_frontend/core/network/error_response_dto.dart';

/// Base custom exception for all Stark VMS errors.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final ErrorResponseDto? errorResponse;

  const AppException({
    required this.message,
    this.statusCode,
    this.errorResponse,
  });

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.errorResponse,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized: Please log in again.',
    super.statusCode = 401,
    super.errorResponse,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Access forbidden: Insufficient permissions.',
    super.statusCode = 403,
    super.errorResponse,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found.',
    super.statusCode = 404,
    super.errorResponse,
  });
}

class ConflictException extends AppException {
  const ConflictException({
    required super.message,
    super.statusCode = 409,
    super.errorResponse,
  });
}

class ValidationException extends AppException {
  final Map<String, String> errors;

  const ValidationException({
    required super.message,
    this.errors = const {},
    super.statusCode = 400,
    super.errorResponse,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Unable to connect to the server. Please check your connection and try again.',
    super.statusCode,
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Failed to read or write local storage.',
  });
}
