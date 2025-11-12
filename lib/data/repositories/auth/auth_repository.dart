import 'package:flutter/foundation.dart';
import '../../../utils/result.dart';
import '../../../domain/models/auth/user_model.dart';

/// Interface do repositório de autenticação
///
/// Extends ChangeNotifier para notificar mudanças no estado de autenticação.
/// Responsável por gerenciar o ciclo de vida completo da autenticação:
/// - Login (obter tokens)
/// - Refresh token (renovar tokens expirados)
/// - Logout (limpar sessão)
abstract class AuthRepository extends ChangeNotifier {
  /// Verifica se o usuário está autenticado
  Future<bool> get isAuthenticated;

  /// Realiza login com CPF e senha
  ///
  /// Salva o token JWT, refresh token e informações do usuário
  Future<Result<void>> login({
    required String cpf,
    required String password,
  });

  /// Renova o token de autenticação usando o refresh token
  ///
  /// Deve ser chamado quando o token estiver expirado ou próximo de expirar.
  /// O interceptor já faz isso automaticamente, mas pode ser útil chamar
  /// manualmente em situações específicas.
  Future<Result<void>> refreshToken();

  /// Realiza logout do usuário
  ///
  /// Revoga o refresh token no servidor e limpa todos os dados locais
  Future<Result<void>> logout();

  /// Obtém o usuário atual
  UserModel? get currentUser;

  /// Obtém o token JWT atual
  Future<String?> get currentToken;

  /// Obtém o refresh token atual
  Future<String?> get currentRefreshToken;

  /// Obtém o papel/perfil do usuário (ex: "administrador")
  Future<String?> get currentUserRole;

  /// Obtém o número do banco de dados do usuário
  Future<int?> get currentNumeroBancoDados;
}
