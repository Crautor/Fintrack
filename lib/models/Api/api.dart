class ApiResponse<T> {
  final T data;
  final Map<String, String> headers;
  final int statusCode;

  ApiResponse({
    required this.data,
    required this.headers,
    required this.statusCode,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
