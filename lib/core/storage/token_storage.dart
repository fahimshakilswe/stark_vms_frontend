import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stark_vms_frontend/core/constants/app_constants.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

/// Web-compatible secure token storage interface using FlutterSecureStorage.
class TokenStorage {
  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              webOptions: WebOptions(
                dbName: 'StarkVmsSecureStorage',
                publicKey: 'StarkVmsSecureKey',
              ),
            );

  /// Saves the JWT access token securely.
  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  /// Retrieves the stored JWT token.
  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  /// Checks if a valid token exists.
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Deletes the JWT token upon logout.
  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  /// Saves user metadata JSON string.
  Future<void> saveUserData(String userJson) async {
    await _storage.write(key: AppConstants.userKey, value: userJson);
  }

  /// Retrieves user metadata JSON string.
  Future<String?> getUserData() async {
    return await _storage.read(key: AppConstants.userKey);
  }

  /// Clears all authentication session data.
  Future<void> clearAuthSession() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }
}
