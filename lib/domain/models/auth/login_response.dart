/// Model para resposta do login
///
/// Contém todos os dados retornados pela API após autenticação bem-sucedida:
/// - Token JWT para autenticação
/// - Refresh token para renovação
/// - Informações do usuário e permissões
class LoginResponse {
  /// Token JWT para autenticação nas requisições
  final String token;

  /// Refresh token para renovar o token quando expirar
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

  LoginResponse({
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
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
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
