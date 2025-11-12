import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../exceptions/app_exception.dart';
import '../../../utils/result.dart';

/// Serviço para armazenamento seguro de dados sensíveis
///
/// Utiliza FlutterSecureStorage para criptografar e armazenar:
/// - Tokens de autenticação (JWT e refresh token)
/// - Informações do usuário
/// - Configurações sensíveis
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  // Chaves para armazenamento
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiresKey = 'token_expires';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _userRoleKey = 'user_role';
  static const String _numeroBancoDadosKey = 'numero_banco_dados';

  SecureStorageService({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Salva o token de autenticação
  Future<Result<void>> saveToken(String? token) async {
    try {
      if (token == null) {
        await _secureStorage.delete(key: _tokenKey);
      } else {
        await _secureStorage.write(key: _tokenKey, value: token);
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.error(ErroAoSalvarTokenException());
    }
  }

  /// Recupera o token de autenticação
  Future<Result<String?>> getToken() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      return Result.ok(token);
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Salva o ID do usuário
  Future<Result<void>> saveUserId(String? userId) async {
    try {
      if (userId == null) {
        await _secureStorage.delete(key: _userIdKey);
      } else {
        await _secureStorage.write(key: _userIdKey, value: userId);
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.error(ErroAoSalvarTokenException());
    }
  }

  /// Recupera o ID do usuário
  Future<Result<String?>> getUserId() async {
    try {
      final userId = await _secureStorage.read(key: _userIdKey);
      return Result.ok(userId);
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Salva o refresh token
  Future<Result<void>> saveRefreshToken(String? refreshToken) async {
    try {
      if (refreshToken == null) {
        await _secureStorage.delete(key: _refreshTokenKey);
      } else {
        await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.error(ErroAoSalvarTokenException());
    }
  }

  /// Recupera o refresh token
  Future<Result<String?>> getRefreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      return Result.ok(refreshToken);
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Salva a data de expiração do token (formato ISO 8601)
  Future<Result<void>> saveTokenExpires(String? expires) async {
    try {
      if (expires == null) {
        await _secureStorage.delete(key: _tokenExpiresKey);
      } else {
        await _secureStorage.write(key: _tokenExpiresKey, value: expires);
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.error(ErroAoSalvarTokenException());
    }
  }

  /// Recupera a data de expiração do token
  Future<Result<String?>> getTokenExpires() async {
    try {
      final expires = await _secureStorage.read(key: _tokenExpiresKey);
      return Result.ok(expires);
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Salva o nome do usuário
  Future<Result<void>> saveUsername(String? username) async {
    try {
      if (username == null) {
        await _secureStorage.delete(key: _usernameKey);
      } else {
        await _secureStorage.write(key: _usernameKey, value: username);
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.error(ErroAoSalvarTokenException());
    }
  }

  /// Recupera o nome do usuário
  Future<Result<String?>> getUsername() async {
    try {
      final username = await _secureStorage.read(key: _usernameKey);
      return Result.ok(username);
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Salva o papel/perfil do usuário (ex: "administrador")
  Future<Result<void>> saveUserRole(String? role) async {
    try {
      if (role == null) {
        await _secureStorage.delete(key: _userRoleKey);
      } else {
        await _secureStorage.write(key: _userRoleKey, value: role);
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.error(ErroAoSalvarTokenException());
    }
  }

  /// Recupera o papel/perfil do usuário
  Future<Result<String?>> getUserRole() async {
    try {
      final role = await _secureStorage.read(key: _userRoleKey);
      return Result.ok(role);
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Salva o número do banco de dados
  Future<Result<void>> saveNumeroBancoDados(int? numero) async {
    try {
      if (numero == null) {
        await _secureStorage.delete(key: _numeroBancoDadosKey);
      } else {
        await _secureStorage.write(
          key: _numeroBancoDadosKey,
          value: numero.toString(),
        );
      }
      return const Result.ok(null);
    } catch (e) {
      return Result.error(ErroAoSalvarTokenException());
    }
  }

  /// Recupera o número do banco de dados
  Future<Result<int?>> getNumeroBancoDados() async {
    try {
      final numero = await _secureStorage.read(key: _numeroBancoDadosKey);
      if (numero == null) {
        return const Result.ok(null);
      }
      return Result.ok(int.tryParse(numero));
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Verifica se o token está próximo de expirar (menos de 5 minutos)
  ///
  /// Retorna true se faltar menos de 5 minutos para expirar,
  /// false caso contrário, ou null se não houver data de expiração salva
  Future<Result<bool?>> isTokenNearExpiration() async {
    try {
      final expiresResult = await getTokenExpires();
      final expiresValue = expiresResult.getSuccessOrNull();

      if (expiresValue == null) {
        return const Result.ok(null);
      }

      final expiresDate = DateTime.parse(expiresValue);
      final now = DateTime.now();
      final difference = expiresDate.difference(now);

      // Considera "próximo de expirar" se faltar menos de 5 minutos
      return Result.ok(difference.inMinutes < 5);
    } catch (e) {
      return const Result.ok(null);
    }
  }

  /// Limpa todos os dados armazenados
  Future<Result<void>> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(ErroAoLimparDadosException());
    }
  }
}
