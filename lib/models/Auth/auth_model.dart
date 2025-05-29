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
  final String? token;

  LoginResponse({this.message, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? json['mensagem'] ?? json['erro'],
      token: json['token'],
    );
  }
}
