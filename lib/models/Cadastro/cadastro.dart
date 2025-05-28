class CadastroRequest {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String birthdate;

  CadastroRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.birthdate,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'phone': phone,
    'birthdate': birthdate,
  };
}

class CadastroResponse {
  final bool success;
  final String message;

  CadastroResponse({required this.success, required this.message});

  factory CadastroResponse.fromJson(Map<String, dynamic> json) {
    final isError = json.containsKey('erro');
    return CadastroResponse(
      success: !isError,
      message:
          json['mensagem'] ??
          json['message'] ??
          json['erro'] ??
          'Erro desconhecido',
    );
  }
}
