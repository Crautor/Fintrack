import 'dart:convert';
import 'package:fintrack/models/Api/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RequestService {
  // static const String baseUrl = 'http://10.200.143.157:3004/api/';
  static const String baseUrl =
      'http://10.0.2.2:3000/api/'; // android studio fixo

  static Future<Map<String, String>> _defaultHeaders() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    final headers = {'Content-Type': 'application/json'};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<void> printAuthToken() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final refreshToken = await storage.read(key: 'refresh_token');

    print('[DEBUG] auth_token: $token');
    print('[DEBUG] refresh_token: $refreshToken');
  }

  static Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic body,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _defaultHeaders();

    print('[HTTP] → POST $url');
    print('[HTTP] Headers: $headers');
    print('[HTTP] Body: ${body.toJson()}');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body.toJson()),
    );

    print('[HTTP] ← Status: ${response.statusCode}');
    print('[HTTP] ← Body: ${response.body}');

    T data;

    if (T.toString() == 'void' ||
        response.statusCode == 204 ||
        response.body.isEmpty) {
      data = null as T;
    } else {
      final decoded = jsonDecode(response.body);
      data = fromJson(decoded);
    }

    return ApiResponse<T>(
      data: data,
      headers: response.headers,
      statusCode: response.statusCode,
    );
  }

  static Future<T> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _defaultHeaders();

    print('[HTTP] → GET $url');
    final response = await http.get(url, headers: headers);

    return _handleResponse(response, fromJson);
  }

  static Future<ApiResponse<T>> patch<T>(
    String endpoint,
    dynamic body,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _defaultHeaders();

    final response = await http.patch(
      url,
      headers: headers,
      body: jsonEncode(body.toJson()),
    );

    T data = _handleResponse(response, fromJson);

    return ApiResponse<T>(
      data: data,
      headers: response.headers,
      statusCode: response.statusCode,
    );
  }

  static Future<ApiResponse<T>> put<T>(
    String endpoint,
    dynamic body,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _defaultHeaders();

    print('[HTTP] → PUT $url');
    print('[HTTP] Headers: $headers');
    print('[HTTP] Body: ${body.toJson()}');

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body.toJson()),
    );

    print('[HTTP] ← Status: ${response.statusCode}');
    print('[HTTP] ← Body: ${response.body}');

    T data;

    if (T.toString() == 'void' ||
        response.statusCode == 204 ||
        response.body.isEmpty) {
      data = null as T;
    } else {
      final decoded = jsonDecode(response.body);
      data = fromJson(decoded);
    }

    return ApiResponse<T>(
      data: data,
      headers: response.headers,
      statusCode: response.statusCode,
    );
  }

  static Future<ApiResponse<T>> delete<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _defaultHeaders();

    final response = await http.delete(url, headers: headers);
    final data = _handleResponse(response, fromJson);

    return ApiResponse<T>(
      data: data,
      headers: response.headers,
      statusCode: response.statusCode,
    );
  }

  static T _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (T.toString() == "void" || response.statusCode == 204) {
      fromJson({});
      return null as T;
    }

    final decoded = jsonDecode(response.body);
    return fromJson(decoded);
  }
}
