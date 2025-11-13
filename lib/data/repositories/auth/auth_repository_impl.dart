
import 'package:sentinela/data/model/login_response_api_model.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/data/services/api/auth_client/auth_api_client.dart';
import 'package:sentinela/data/services/api/auth_client/auth_api_client_impl.dart';
import 'package:sentinela/data/services/local/local_secure_storage/local_secure_storage.dart';
import 'package:sentinela/data/services/logger/logger.dart';
import 'package:sentinela/domain/models/aluno/user_model.dart';
import 'package:sentinela/exceptions/app_exception.dart';
import 'package:sentinela/utils/network/connection_checker.dart';
import 'package:sentinela/utils/result.dart';

final class AuthRepositoryImpl extends AuthRepository {
  final AuthApiClient _authApiClient;
  final LocalSecureStorage _storage;
  final Logger _logger;
  static const String _logTag = 'AuthRepository';

  AuthRepositoryImpl({
    required AuthApiClient apiClient,
    required ConnectionChecker connectionChecker,
    required LocalSecureStorage storage,
    required Logger logger,
  })  : _authApiClient = apiClient,
        _storage = storage,
        _logger = logger;

  @override
  Future<Result<UserModel>> currentUser() async {
    try {
  
      // Check if user is authenticated
      final isAuth = await isAuthenticated();
      if (!isAuth) {
        return Result.error(SessaoExpiradaException());
      }

      // Get current user data from API
      return await _authApiClient.getCurrentUserData().map((userData) {
        if (userData == null) {
          throw Exception('No user data returned');
        }
        return UserModel.fromJson(userData);
      });
    } catch (e, s) {
      _logger.error('Error getting current user', error: e, stackTrace: s, tag: _logTag);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> loginWithEmailPassword({required String email, required String password}) async {
    try {
      return await _authApiClient.loginWithEmailPassword(email: email, password: password)
          .flatMapAsync((response) async {
        // Response is already a LoginResponseModel from AuthApiClient
        final loginModel = response as LoginResponseApiModel;

        // Calculate expires_at from expires_in if not provided
        final expiresAt = loginModel.expiresAt != 0
            ? loginModel.expiresAt
            : (DateTime.now().millisecondsSinceEpoch ~/ 1000) + loginModel.expiresIn;

        // Save bearer token, refresh token, and expiration time to secure storage
        await _storage.write(key: 'bearer_token', value: loginModel.accessToken);
        await _storage.write(key: 'refresh_token', value: loginModel.refreshToken);
        await _storage.write(key: 'token_expires_at', value: expiresAt.toString());

        _logger.info('Tokens saved successfully', tag: _logTag);

        return Result.ok(loginModel);
      });
    } catch (e, s) {
      _logger.error('Error loginWithEmailPassword', error: e, stackTrace: s, tag: _logTag);
      return Result.error(UnknownErrorException());
    } finally {
      // Notify listeners that authentication state may have changed
      notifyListeners();
    }
  }

  @override
  Future<Result> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) {
    // TODO: implement signUpWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // Read token expiration time from secure storage
      final expiresAtResult = await _storage.read(key: 'token_expires_at');
      final tokenResult = await _storage.read(key: 'bearer_token');

      // If either token or expiration time doesn't exist, user is not authenticated
      final expiresAtString = expiresAtResult.getSuccessOrNull();
      final token = tokenResult.getSuccessOrNull();

      if (expiresAtString == null || token == null) {
        _logger.info('No token or expiration time found', tag: _logTag);
        return false;
      }

      // Parse expiration time
      final expiresAt = int.tryParse(expiresAtString);
      if (expiresAt == null) {
        _logger.error('Invalid expiration time format', tag: _logTag);
        return false;
      }

      // Check if token is still valid (compare with current timestamp)
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final isValid = currentTimestamp < expiresAt;

      if (!isValid) {
        _logger.info('Token has expired', tag: _logTag);
      }

      return isValid;
    } catch (e, s) {
      _logger.error('Error checking authentication', error: e, stackTrace: s, tag: _logTag);
      return false;
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Get the current token to send in logout request
      final tokenResult = await _storage.read(key: 'bearer_token');
      final token = tokenResult.getSuccessOrNull();

      // Call logout API if we have a token
      if (token != null && token.isNotEmpty) {
        if (_authApiClient case AuthApiClientImpl apiClient) {
          await apiClient.logout(token: token);
        }
      }

      // Clear all authentication data from secure storage
      await _storage.delete(key: 'bearer_token');
      await _storage.delete(key: 'refresh_token');
      await _storage.delete(key: 'token_expires_at');

      _logger.info('User logged out successfully', tag: _logTag);

      return Result.ok(null);
    } catch (e, s) {
      _logger.error('Error during logout', error: e, stackTrace: s, tag: _logTag);
      // Even if API call fails, clear local tokens
      await _storage.delete(key: 'bearer_token');
      await _storage.delete(key: 'refresh_token');
      await _storage.delete(key: 'token_expires_at');
      return Result.error(UnknownErrorException());
    } finally {
      // Notify listeners that authentication state has changed
      notifyListeners();
    }
  }
}
