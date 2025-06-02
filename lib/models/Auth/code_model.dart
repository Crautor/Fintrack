class ConfirmarCodigoRequest {
  final String email;
  final String code;

  ConfirmarCodigoRequest({required this.email, required this.code});

  Map<String, dynamic> toJson() => {'email': email, 'code': code};
}

class ConfirmarCodigoResponse {
  final String message;

  ConfirmarCodigoResponse({required this.message});

  factory ConfirmarCodigoResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmarCodigoResponse(
      message:
          json['message'] ??
          json['mensagem'] ??
          json['erro'] ??
          'Erro desconhecido',
    );
  }
}
