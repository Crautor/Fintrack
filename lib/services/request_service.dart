import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestService {
  static const String baseUrl = 'https://seu-backend.com/api'; // Troca para sua baseURL real

  static Map<String, String> _defaultHeaders() {
    final headers = {
      'Content-Type': 'application/json',
    };

    // qnado for usar Authorization futuramente, já colocar aqui:
    // final token = await SecureStorage.getToken(); (exemplo de onde buscar o token)
    // if (token != null) {
    //   headers['Authorization'] = 'Bearer $token';
    // }

    return headers;
  }

  static Future<T> get<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: _defaultHeaders());
    return _handleResponse(response, fromJson);
  }

  static Future<T> post<T>(String endpoint, dynamic body, T Function(Map<String, dynamic>) fromJson) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: _defaultHeaders(),
      body: jsonEncode(body.toJson()),
    );
    return _handleResponse(response, fromJson);
  }

  static Future<T> patch<T>(String endpoint, dynamic body, T Function(Map<String, dynamic>) fromJson) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.patch(
      url,
      headers: _defaultHeaders(),
      body: jsonEncode(body.toJson()),
    );
    return _handleResponse(response, fromJson);
  }

  static Future<T> delete<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: _defaultHeaders());
    return _handleResponse(response, fromJson);
  }

  static T _handleResponse<T>(http.Response response, T Function(Map<String, dynamic>) fromJson) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return fromJson(decoded);
    } else {
      throw Exception('Erro ${response.statusCode}: ${decoded['message'] ?? 'Erro desconhecido.'}');
    }
  }
}
