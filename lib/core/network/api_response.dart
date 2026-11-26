/// Generic API response envelope matching Spring Boot `ApiResponse<T>`.
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? timestamp;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': toJsonT(data as T),
      if (timestamp != null) 'timestamp': timestamp,
    };
  }
}
