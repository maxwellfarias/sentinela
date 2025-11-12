/// Model para resposta do login
///
/// Contém todos os dados retornados pela API Supabase após autenticação bem-sucedida:
/// - Token JWT (access_token) para autenticação
/// - Refresh token para renovação
/// - Informações do usuário
class LoginResponse {
  /// Token JWT para autenticação nas requisições
  final String token;

  /// Refresh token para renovar o token quando expirar
  final String refreshToken;

  /// Data e hora de expiração do token (formato ISO 8601)
  final String expires;

  /// Número do banco de dados do usuário (opcional para compatibilidade)
  final int numeroBancoDados;

  /// Nome completo do usuário
  final String username;

  /// Papel/perfil do usuário (ex: "administrador", "usuario")
  final String role;

  /// ID do usuário
  final String id;

  /// Data de criação do usuário (formato ISO 8601)
  final String dataCriacao;

  /// Indica se o usuário está ativo
  final bool ativo;

  /// Email do usuário (do Supabase)
  final String email;

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
    required this.email,
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
      'email': email,
    };
  }

  /// Cria um objeto a partir do JSON retornado pela API Supabase
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Extrai informações do usuário
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final email = user['email'] as String? ?? '';
    final userId = user['id'] as String? ?? '';

    // Calcula a data de expiração do token
    final expiresIn = json['expires_in'] as int? ?? 3600;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn)).toIso8601String();

    return LoginResponse(
      token: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      expires: expiresAt,
      numeroBancoDados: 1, // Valor padrão
      username: email.split('@').first, // Usa parte do email como username
      role: user['role'] as String? ?? 'user',
      id: userId,
      dataCriacao: user['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ativo: true,
      email: email,
    );
  }
}
