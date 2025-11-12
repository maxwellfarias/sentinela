/// Model para requisição de refresh token
///
/// Formato Supabase: envia apenas o refresh_token para obter
/// um novo par de tokens (access_token e refresh_token).
class RefreshTokenRequest {
  /// Token JWT atual (mantido para compatibilidade, mas Supabase não usa)
  final String? token;

  /// Refresh token obtido no login - usado pelo Supabase
  final String refreshToken;

  RefreshTokenRequest({
    this.token,
    required this.refreshToken,
  });

  /// Converte o objeto para JSON no formato Supabase
  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken, // Formato Supabase
    };
  }

  /// Cria um objeto a partir do JSON
  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) {
    return RefreshTokenRequest(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String? ?? json['refresh_token'] as String,
    );
  }
}
