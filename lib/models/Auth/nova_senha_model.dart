class NovaSenhaRequest {
  final String email;
  final String codigo;
  final String novapassword;

  NovaSenhaRequest({
    required this.email,
    required this.codigo,
    required this.novapassword,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'codigo': codigo,
    'novapassword': novapassword,
  };
}

class NovaSenhaResponse {
  final String message;

  NovaSenhaResponse({required this.message});

  factory NovaSenhaResponse.fromJson(Map<String, dynamic> json) {
    return NovaSenhaResponse(
      message:
          json['message'] ??
          json['mensagem'] ??
          json['erro'] ??
          'Erro desconhecido',
    );
  }
}
