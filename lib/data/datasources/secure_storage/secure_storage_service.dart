import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../exceptions/app_exception.dart';
import '../../../utils/result.dart';

abstract class SecureStorageService extends ChangeNotifier {
  Future<Result<void>> saveToken(String? token);
  Future<Result<String?>> getToken();
  Future<Result<void>> saveRefreshToken(String? refreshToken);
  Future<Result<String?>> getRefreshToken();
  Future<Result<void>> saveTokenExpires(String? expires);
  Future<Result<String?>> getTokenExpires();
  Future<Result<bool?>> isTokenNearExpiration();
  Future<Result<void>> clearAll();
}

class SecureStorageServiceImpl extends SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  // Chaves para armazenamento
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiresKey = 'token_expires';

  SecureStorageServiceImpl({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  /// Salva o token de autenticação
  @override
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
  @override
  Future<Result<String?>> getToken() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      return Result.ok(token);
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Salva o refresh token
  @override
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
  @override
  Future<Result<String?>> getRefreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      return Result.ok(refreshToken);
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Salva a data de expiração do token (formato ISO 8601)
  @override
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
  @override
  Future<Result<String?>> getTokenExpires() async {
    try {
      final expires = await _secureStorage.read(key: _tokenExpiresKey);
      return Result.ok(expires);
    } catch (e) {
      return Result.error(ErroAoRecuperarTokenException());
    }
  }

  /// Verifica se o token está próximo de expirar (menos de 5 minutos)
  ///
  /// Retorna true se faltar menos de 5 minutos para expirar,
  /// false caso contrário, ou null se não houver data de expiração salva
  @override
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
  @override
  Future<Result<void>> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      notifyListeners();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(ErroAoLimparDadosException());
    }
  }
}
