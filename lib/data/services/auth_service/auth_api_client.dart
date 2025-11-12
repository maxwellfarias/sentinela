import 'package:w3_diploma/domain/models/auth/login_request.dart';
import 'package:w3_diploma/domain/models/auth/login_response.dart';
import 'package:w3_diploma/domain/models/auth/refresh_token_request.dart';
import 'package:w3_diploma/domain/models/auth/refresh_token_response.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface para operações de autenticação com a API
///
/// Define os contratos para:
/// - Login (obter token e refresh token)
/// - Refresh token (renovar token expirado)
/// - Logout (revogar refresh token)
abstract interface class AuthApiClient {
  /// Realiza login com CPF e senha
  ///
  /// Retorna os tokens de autenticação e informações do usuário
  Future<Result<LoginResponse>> login(LoginRequest loginRequest);

  /// Renova o token de autenticação usando o refresh token
  ///
  /// Deve ser chamado quando o token JWT estiver expirado ou próximo de expirar
  Future<Result<RefreshTokenResponse>> refreshToken(
    RefreshTokenRequest refreshTokenRequest,
  );

  /// Realiza logout revogando o refresh token no servidor
  ///
  /// Após o logout, o refresh token não poderá mais ser usado
  Future<Result<void>> logout(String token);
}