class EnvConfig {
  EnvConfig._();

  /// Default API base URL pointing to the local Spring Boot backend.
  /// Can be overridden at build or run time via:
  /// `flutter run -d chrome --dart-define=API_BASE_URL=https://api.yourdomain.com/api/v1`
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  /// Default connect timeout in milliseconds (15 seconds).
  static const int connectTimeoutMs = 15000;

  /// Default receive timeout in milliseconds (15 seconds).
  static const int receiveTimeoutMs = 15000;

  /// Default page size for pagination.
  static const int defaultPageSize = 10;

  /// Application Name.
  static const String appName = 'Stark VMS';
}
