class LoginRequest {
  /// Email ou CPF do usuário (mantido como cpf para compatibilidade)
  final String cpf;
  final String password;

  LoginRequest({
    required this.cpf,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': cpf, // Envia como email para API do Supabase
      'password': password,
    };
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      cpf: json['cpf'] as String? ?? json['email'] as String,
      password: json['password'] as String,
    );
  }
}
