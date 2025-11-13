import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentinela/data/model/login_response_api_model.dart';
import 'package:sentinela/data/services/api/auth_client/auth_api_client.dart';
import 'package:sentinela/data/services/api/endpoint_builder/endpoint_builder_impl.dart';
import 'package:sentinela/data/services/local/local_secure_storage/local_secure_storage.dart';
import 'package:sentinela/data/services/logger/logger.dart';
import 'package:sentinela/exceptions/app_exception.dart';
import 'package:sentinela/utils/network/connection_checker.dart';
import 'package:sentinela/utils/result.dart';

class AuthApiClientImpl implements AuthApiClient {
  final Dio _dio;
  final ConnectionChecker _connectionChecker;
  final LocalSecureStorage _storage;
  final Logger _logger;
  static const String _logTag = 'AuthApiClient';

  AuthApiClientImpl({
    required Dio dio,
    required ConnectionChecker connectionChecker,
    required LocalSecureStorage storage,
    required Logger logger,
  })  : _dio = dio,
        _connectionChecker = connectionChecker,
        _storage = storage,
        _logger = logger;

  @override
  Future<Result<dynamic>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await _connectionChecker.isConnected) {
        return Result.error(SemConexaoException());
      }

      final endpoint = EndpointBuilderImpl.signIn;
      final apiKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

      _logger.info('Attempting login for email: $email', tag: _logTag);

      final response = await _dio.post(
        endpoint.url,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'apikey': apiKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final loginResponse = LoginResponseApiModel.fromJson(response.data);
        _logger.info('User logged in: ${loginResponse.user.id}', tag: _logTag);
        return Result.ok(loginResponse);
      }

      _logger.error('Login failed: Invalid response', tag: _logTag);
      return Result.error(ErroInternoServidorException());
    } on DioException catch (e, s) {
      _logger.error('DioException during login: ${e.message}', tag: _logTag, error: e, stackTrace: s);

      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        return Result.error(UsuarioOuSenhaInvalidoException());
      }

      return Result.error(ErroInternoServidorException());
    } catch (e, s) {
      _logger.error('Unknown error during login', tag: _logTag, error: e, stackTrace: s);
      return Result.error(ErroInternoServidorException());
    }
  }

  @override
  Future<Result<dynamic>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (!await _connectionChecker.isConnected) {
        return Result.error(SemConexaoException());
      }

      final endpoint = EndpointBuilderImpl.signUp;
      final apiKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

      _logger.info('Attempting signup for email: $email', tag: _logTag);

      final response = await _dio.post(
        endpoint.url,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'apikey': apiKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final signUpResponse = LoginResponseApiModel.fromJson(response.data);
        _logger.info('User signed up: ${signUpResponse.user.id}', tag: _logTag);
        return Result.ok(signUpResponse);
      }

      _logger.error('Signup failed: Invalid response', tag: _logTag);
      return Result.error(ErroInternoServidorException());
    } on DioException catch (e, s) {
      _logger.error('DioException during signup: ${e.message}', tag: _logTag, error: e, stackTrace: s);
      return Result.error(ErroInternoServidorException());
    } catch (e, s) {
      _logger.error('Unknown error during signup', tag: _logTag, error: e, stackTrace: s);
      return Result.error(ErroInternoServidorException());
    }
  }

  @override
  Future<Result<dynamic>> getCurrentUserData() async {
    try {
      if (!await _connectionChecker.isConnected) {
        return Result.error(SemConexaoException());
      }

      // Get the current user session token
      final tokenResult = await _storage.read(key: 'bearer_token');
      final token = tokenResult.getSuccessOrNull();

      if (token == null || token.isEmpty) {
        _logger.error('No token available to fetch user data', tag: _logTag);
        return Result.error(SessaoExpiradaException());
      }

      final apiKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

      final response = await _dio.get(
        'https://hqvximqtoskulhfltzvr.supabase.co/rest/v1/profiles?select=*',
        options: Options(
          headers: {
            'apikey': apiKey,
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final userData = response.data;
        if (userData is List && userData.isNotEmpty) {
          return Result.ok(userData.first);
        }
        return Result.ok(null);
      }

      return Result.error(ErroInternoServidorException());
    } on DioException catch (e, s) {
      _logger.error('DioException fetching user data: ${e.message}', tag: _logTag, error: e, stackTrace: s);
      return Result.error(ErroInternoServidorException());
    } catch (e, s) {
      _logger.error('Error fetching user data', tag: _logTag, error: e, stackTrace: s);
      return Result.error(ErroInternoServidorException());
    }
  }

  @override
  Future<Result<dynamic>> refreshToken({required String refreshToken}) async {
    try {
      if (!await _connectionChecker.isConnected) {
        return Result.error(SemConexaoException());
      }

      final endpoint = EndpointBuilderImpl.refreshToken;
      final apiKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

      _logger.info('Attempting token refresh', tag: _logTag);

      final response = await _dio.post(
        endpoint.url,
        data: {
          'refresh_token': refreshToken,
        },
        options: Options(
          headers: {
            'apikey': apiKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final refreshResponse = LoginResponseApiModel.fromJson(response.data);
        _logger.info('Token refreshed successfully', tag: _logTag);
        return Result.ok(refreshResponse);
      }

      _logger.error('Token refresh failed: Invalid response', tag: _logTag);
      return Result.error(SessaoExpiradaException());
    } on DioException catch (e, s) {
      _logger.error('DioException during token refresh: ${e.message}',
          tag: _logTag, error: e, stackTrace: s);
      return Result.error(SessaoExpiradaException());
    } catch (e, s) {
      _logger.error('Unknown error during token refresh',
          tag: _logTag, error: e, stackTrace: s);
      return Result.error(ErroInternoServidorException());
    }
  }

  /// Logout the current user
  Future<Result<void>> logout({required String token}) async {
    try {
      if (!await _connectionChecker.isConnected) {
        return Result.error(SemConexaoException());
      }

      final endpoint = EndpointBuilderImpl.signOut;
      final apiKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

      _logger.info('Attempting logout', tag: _logTag);

      final response = await _dio.post(
        endpoint.url,
        options: Options(
          headers: {
            'apikey': apiKey,
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        _logger.info('Logout successful', tag: _logTag);
        return Result.ok(null);
      }

      _logger.error('Logout failed: Invalid response', tag: _logTag);
      return Result.error(ErroInternoServidorException());
    } on DioException catch (e, s) {
      _logger.error('DioException during logout: ${e.message}',
          tag: _logTag, error: e, stackTrace: s);
      return Result.error(ErroInternoServidorException());
    } catch (e, s) {
      _logger.error('Unknown error during logout',
          tag: _logTag, error: e, stackTrace: s);
      return Result.error(ErroInternoServidorException());
    }
  }
}
