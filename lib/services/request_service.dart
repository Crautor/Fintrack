import 'dart:convert';
import 'package:fintrack/models/Api/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RequestService {
  // static const String baseUrl = 'http://10.200.143.157:3004/api/';
  static const String baseUrl =
      'http://10.0.2.2:3004/api/'; // android studio fixo

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

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body.toJson()),
    );

    print('[DEBUG] STATUS CODE: ${response.statusCode}');
    print('[DEBUG] RAW BODY: ${response.body}');

    final decoded = jsonDecode(response.body);
    final data = fromJson(decoded);

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
    final response = await http.get(url, headers: headers);
    return _handleResponse(response, fromJson);
  }

  static Future<T> patch<T>(
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
    return _handleResponse(response, fromJson);
  }

  static Future<T> delete<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _defaultHeaders();

    final response = await http.delete(url, headers: headers);
    return _handleResponse(response, fromJson);
  }

  static T _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final decoded = jsonDecode(response.body);
    return fromJson(decoded);
  }
}
