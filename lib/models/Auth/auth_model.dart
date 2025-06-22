class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class LoginResponse {
  final String? message;
  final String? accessToken;
  final String? refreshToken;

  LoginResponse({this.message, this.accessToken, this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? json['mensagem'] ?? json['erro'],
      accessToken: json['accessToken'] ?? json['token'],
      refreshToken: json['refreshToken'],
    );
  }
}
