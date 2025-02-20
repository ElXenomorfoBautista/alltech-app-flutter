class ApiResponse<T> {
  final int statusCode;
  final String message;
  final T? data;
  final String? error;

  ApiResponse({
    required this.statusCode,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? fromJson(json['data']) : null,
      error: json['error'],
    );
  }
}
