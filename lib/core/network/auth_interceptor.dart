import 'package:dio/dio.dart';
import 'package:stark_vms_frontend/core/constants/api_constants.dart';
import 'package:stark_vms_frontend/core/storage/token_storage.dart';

/// Interceptor that attaches the Bearer token to authenticated requests.
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final void Function()? onUnauthorized;

  AuthInterceptor(this._tokenStorage, {this.onUnauthorized});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Avoid attaching token for public auth routes
    final path = options.path;
    final isPublicAuth = path.contains(ApiConstants.login) ||
        path.contains(ApiConstants.register);

    if (!isPublicAuth) {
      final token = await _tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix}$token';
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
    }
    return handler.next(err);
  }
}
