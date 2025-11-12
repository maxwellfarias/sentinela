class LoginRequest {
  final String cpf;
  final String password;

  LoginRequest({
    required this.cpf,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'password': password,
    };
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      cpf: json['cpf'] as String,
      password: json['password'] as String,
    );
  }
}
