/// Model para requisição de refresh token
///
/// Envia o token JWT atual e o refresh token para obter
/// um novo par de tokens antes que o token atual expire.
class RefreshTokenRequest {
  /// Token JWT atual (pode estar expirado ou próximo de expirar)
  final String token;

  /// Refresh token obtido no login
  final String refreshToken;

  RefreshTokenRequest({
    required this.token,
    required this.refreshToken,
  });

  /// Converte o objeto para JSON para enviar na requisição
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }

  /// Cria um objeto a partir do JSON
  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) {
    return RefreshTokenRequest(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
