class RegisterTokenRequest {
  final String token;

  RegisterTokenRequest({required this.token});

  Map<String, dynamic> toJson() => {'token': token};
}
