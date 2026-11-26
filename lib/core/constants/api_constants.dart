class ApiConstants {
  ApiConstants._();

  // Authentication endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // Vehicle endpoints
  static const String vehicles = '/vehicles';
  static String vehicleById(int id) => '/vehicles/$id';

  // HTTP Headers
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
}
