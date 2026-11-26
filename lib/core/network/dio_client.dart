import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stark_vms_frontend/core/config/env_config.dart';
import 'package:stark_vms_frontend/core/constants/api_constants.dart';
import 'package:stark_vms_frontend/core/error/exceptions.dart';
import 'package:stark_vms_frontend/core/network/auth_interceptor.dart';
import 'package:stark_vms_frontend/core/network/error_response_dto.dart';
import 'package:stark_vms_frontend/core/storage/token_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return createDioClient(
    tokenStorage,
    onUnauthorized: () {
      tokenStorage.clearAuthSession();
    },
  );
});

Dio createDioClient(
  TokenStorage tokenStorage, {
  void Function()? onUnauthorized,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: EnvConfig.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: EnvConfig.receiveTimeoutMs),
      sendTimeout: const Duration(milliseconds: EnvConfig.connectTimeoutMs),
      headers: {
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
        'Accept': ApiConstants.applicationJson,
      },
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage,
      onUnauthorized: onUnauthorized,
    ),
  );

  // Logging Interceptor for development visibility
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        developer.log(
          '--> ${options.method} ${options.baseUrl}${options.path}',
          name: 'DioClient',
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        developer.log(
          '<-- ${response.statusCode} ${response.requestOptions.path}',
          name: 'DioClient',
        );
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        developer.log(
          '<-- ERROR ${e.response?.statusCode} ${e.requestOptions.path}: ${e.message}',
          name: 'DioClient',
          error: e.error,
        );
        return handler.next(e);
      },
    ),
  );

  return dio;
}

/// Helper method to convert DioException to domain AppException
AppException handleDioError(DioException error) {
  final response = error.response;
  if (response == null) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkException(
        message: 'Connection timed out. Please check server availability.',
      );
    }
    return const NetworkException(
      message: 'Network error. Please check your internet connection.',
    );
  }

  final statusCode = response.statusCode ?? 500;
  ErrorResponseDto? errorResponse;

  if (response.data is Map<String, dynamic>) {
    try {
      errorResponse = ErrorResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (_) {
      // Data might be non-standard error structure
    }
  }

  final message = errorResponse?.message ??
      (response.data is Map && response.data['message'] != null
          ? response.data['message'].toString()
          : 'An unexpected server error occurred.');

  switch (statusCode) {
    case 400:
      return ValidationException(
        message: message,
        errors: errorResponse?.validationErrors ?? {},
        statusCode: 400,
        errorResponse: errorResponse,
      );
    case 401:
      return UnauthorizedException(
        message: message,
        statusCode: 401,
        errorResponse: errorResponse,
      );
    case 403:
      return ForbiddenException(
        message: message,
        statusCode: 403,
        errorResponse: errorResponse,
      );
    case 404:
      return NotFoundException(
        message: message,
        statusCode: 404,
        errorResponse: errorResponse,
      );
    case 409:
      return ConflictException(
        message: message,
        statusCode: 409,
        errorResponse: errorResponse,
      );
    default:
      return ServerException(
        message: message,
        statusCode: statusCode,
        errorResponse: errorResponse,
      );
  }
}
