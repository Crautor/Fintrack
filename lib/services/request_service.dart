import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fintrack/models/Api/api.dart';
import 'package:http/http.dart' as http;

class RequestService {
  static const String baseUrl = 'http://192.168.1.11:3000/api/';
  static final storage = FlutterSecureStorage();

  static Future<Map<String, String>> _defaultHeaders() async {
    final token = await storage.read(key: 'auth_token');
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<void> printAuthToken() async {
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
    return _requestWithRetry<T>(
      method: 'POST',
      endpoint: endpoint,
      body: body,
      fromJson: fromJson,
    );
  }

  static Future<T> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await _requestWithRetry<T>(
      method: 'GET',
      endpoint: endpoint,
      fromJson: fromJson,
    );
    return response.data;
  }

  static Future<ApiResponse<T>> put<T>(
    String endpoint,
    dynamic body,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return _requestWithRetry<T>(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      fromJson: fromJson,
    );
  }

  static Future<ApiResponse<T>> patch<T>(
    String endpoint,
    dynamic body,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return _requestWithRetry<T>(
      method: 'PATCH',
      endpoint: endpoint,
      body: body,
      fromJson: fromJson,
    );
  }

  static Future<ApiResponse<T>> delete<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return _requestWithRetry<T>(
      method: 'DELETE',
      endpoint: endpoint,
      fromJson: fromJson,
    );
  }

  static Future<ApiResponse<T>> _requestWithRetry<T>({
    required String method,
    required String endpoint,
    dynamic body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    var headers = await _defaultHeaders();

    http.Response response = await _send(method, url, headers, body);

    if (response.statusCode == 401 || response.statusCode == 403) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        headers = await _defaultHeaders();
        response = await _send(method, url, headers, body);
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      T data;

      if (T.toString() == 'void' || response.body.isEmpty) {
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
    } else {
      throw Exception(_extractErrorMessage(response));
    }
  }

  static Future<http.Response> _send(
    String method,
    Uri url,
    Map<String, String> headers,
    dynamic body,
  ) {
    dynamic encodedBody;

    if (body == null) {
      encodedBody = null;
    } else if (body is Map<String, dynamic> || body is Map<String, String>) {
      encodedBody = jsonEncode(body);
    } else {
      encodedBody = jsonEncode(body.toJson());
    }

    print('📤 [HTTP $method] $url');
    print('🧾 Body enviado: $encodedBody');
    print('🧵 Headers: $headers');

    switch (method) {
      case 'POST':
        return http.post(url, headers: headers, body: encodedBody);
      case 'PUT':
        return http.put(url, headers: headers, body: encodedBody);
      case 'PATCH':
        return http.patch(url, headers: headers, body: encodedBody);
      case 'DELETE':
        return http.delete(url, headers: headers);
      case 'GET':
      default:
        return http.get(url, headers: headers);
    }
  }

  static String _extractErrorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded['erro'] ?? decoded['message'] ?? 'Erro desconhecido';
      }
    } catch (_) {}
    return 'Erro desconhecido';
  }

  static Future<bool> _refreshToken() async {
    final refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken == null) return false;

    final url = Uri.parse('${baseUrl}auth/token');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final newAccessToken = decoded['accessToken'] ?? decoded['token'];
        final newRefreshToken = decoded['refreshToken'];

        if (newAccessToken != null) {
          await storage.write(key: 'auth_token', value: newAccessToken);
        }
        if (newRefreshToken != null) {
          await storage.write(key: 'refresh_token', value: newRefreshToken);
        }

        print('[AUTH] Token atualizado com sucesso');
        return true;
      } else {
        print('[AUTH] Falha ao atualizar token: ${response.body}');
      }
    } catch (e) {
      print('[AUTH] Erro ao atualizar token: $e');
    }

    return false;
  }
}
