/// Model para resposta do refresh token
///
/// Contém os mesmos dados retornados no login:
/// - Novo token JWT
/// - Novo refresh token
/// - Data de expiração
/// - Informações do usuário
class RefreshTokenResponse {
  /// Novo token JWT para autenticação
  final String token;

  /// Novo refresh token para próxima renovação
  final String refreshToken;

  /// Data e hora de expiração do token (formato ISO 8601)
  final String expires;

  /// Número do banco de dados do usuário
  final int numeroBancoDados;

  /// Nome completo do usuário
  final String username;

  /// Papel/perfil do usuário (ex: "administrador", "usuario")
  final String role;

  /// ID do usuário
  final int id;

  /// Data de criação do usuário (formato ISO 8601)
  final String dataCriacao;

  /// Indica se o usuário está ativo
  final bool ativo;

  RefreshTokenResponse({
    required this.token,
    required this.refreshToken,
    required this.expires,
    required this.numeroBancoDados,
    required this.username,
    required this.role,
    required this.id,
    required this.dataCriacao,
    required this.ativo,
  });

  /// Converte o objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expires': expires,
      'numeroBancoDados': numeroBancoDados,
      'username': username,
      'role': role,
      'id': id,
      'dataCriacao': dataCriacao,
      'ativo': ativo,
    };
  }

  /// Cria um objeto a partir do JSON retornado pela API
  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      expires: json['expires'] as String,
      numeroBancoDados: json['numeroBancoDados'] as int,
      username: json['username'] as String,
      role: json['role'] as String,
      id: json['id'] as int,
      dataCriacao: json['dataCriacao'] as String,
      ativo: json['ativo'] as bool,
    );
  }
}
