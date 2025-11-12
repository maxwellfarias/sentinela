import 'package:dio/dio.dart';
import 'package:w3_diploma/data/services/auth_service/auth_api_client.dart';
import '../../../config/constants/urls.dart';
import '../../../domain/models/auth/login_request.dart';
import '../../../domain/models/auth/login_response.dart';
import '../../../domain/models/auth/refresh_token_request.dart';
import '../../../domain/models/auth/refresh_token_response.dart';
import '../../../exceptions/app_exception.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/result.dart';



class AuthApiClientImpl implements AuthApiClient {
  final Dio _dio;
  static const String _logTag = 'AuthApiClient';

  AuthApiClientImpl({required Dio dio}) : _dio = dio;

  final Duration timeOutDuration = const Duration(seconds: 10);

  /// Realiza login e retorna token e dados do usuário
  @override
  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    final url = Urls.login();
    final headers = {
      'Content-Type': 'application/json',
      'apikey': Urls.supabaseApiKey,
    };

    Response? response;
    try {
      final requestData = loginRequest.toJson();
      AppLogger.info(
        'Login - Iniciando requisição\n'
        'URL: $url\n'
        'Headers: $headers\n'
        'Body: ${requestData.toString().replaceAll(RegExp(r'"password":"[^"]*"'), '"password":"***"')}',
        tag: _logTag,
      );

      response = await _dio.post(
        url,
        options: Options(
          headers: headers,
          sendTimeout: timeOutDuration,
          receiveTimeout: timeOutDuration,
        ),
        data: requestData,
      );

      AppLogger.info(
        'Login - Resposta recebida\n'
        'Status: ${response.statusCode}\n'
        'Body: ${response.data.toString().substring(0, response.data.toString().length > 200 ? 200 : response.data.toString().length)}...',
        tag: _logTag,
      );

      return _handleLoginResponse(response);
    } on DioException catch (error) {
      AppLogger.error('Erro de rede ao fazer login: ${error.message}', tag: _logTag, error: error);

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return Result.error(TimeoutDeRequisicaoException());
      }

      if (error.response != null) {
        return _handleLoginResponse(error.response!);
      }

      return Result.error(SemConexaoException());
    } catch (error) {
      AppLogger.error('Erro inesperado ao fazer login: $error', tag: _logTag, error: error);
      return Result.error(UnknownErrorException());
    }
  }

  /// Renova o token de autenticação usando refresh token do Supabase
  @override
  Future<Result<RefreshTokenResponse>> refreshToken(
    RefreshTokenRequest refreshTokenRequest,
  ) async {
    final url = Urls.refreshToken();
    final headers = {
      'Content-Type': 'application/json',
      'apikey': Urls.supabaseApiKey,
    };

    Response? response;
    try {
      AppLogger.info('Renovando token - URL: $url', tag: _logTag);

      response = await _dio.post(
        url,
        options: Options(
          headers: headers,
          sendTimeout: timeOutDuration,
          receiveTimeout: timeOutDuration,
        ),
        data: refreshTokenRequest.toJson(),
      );

      AppLogger.info(
        'Refresh Token - Resposta recebida\n'
        'Status: ${response.statusCode}',
        tag: _logTag,
      );

      return _handleRefreshTokenResponse(response);
    } on DioException catch (error) {
      AppLogger.error(
        'Erro de rede ao renovar token: ${error.message}',
        tag: _logTag,
        error: error,
      );

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return Result.error(TimeoutDeRequisicaoException());
      }

      if (error.response != null) {
        return _handleRefreshTokenResponse(error.response!);
      }

      return Result.error(SemConexaoException());
    } catch (error) {
      AppLogger.error(
        'Erro inesperado ao renovar token: $error',
        tag: _logTag,
        error: error,
      );
      return Result.error(UnknownErrorException());
    }
  }

  /// Realiza logout no servidor Supabase (revoga o refresh token)
  @override
  Future<Result<void>> logout(String token) async {
    final url = Urls.logout();
    final headers = {
      'Content-Type': 'application/json',
      'apikey': Urls.supabaseApiKey,
      'Authorization': 'Bearer $token',
    };

    try {
      AppLogger.info('Logout - URL: $url', tag: _logTag);

      await _dio.post(
        url,
        options: Options(
          headers: headers,
          sendTimeout: timeOutDuration,
          receiveTimeout: timeOutDuration,
        ),
      );

      AppLogger.info('Logout realizado com sucesso no Supabase', tag: _logTag);
      return const Result.ok(null);
    } catch (error) {
      AppLogger.error('Erro ao fazer logout: $error', tag: _logTag, error: error);
      // Mesmo com erro, consideramos logout local como sucesso
      // Isso garante que o usuário seja deslogado localmente
      return const Result.ok(null);
    }
  }

  /// Trata a resposta HTTP do login
  Result<LoginResponse> _handleLoginResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        AppLogger.info('Login bem-sucedido: ${response.statusCode}', tag: _logTag);
        try {
          final loginResponse = LoginResponse.fromJson(response.data as Map<String, dynamic>);
          return Result.ok(loginResponse);
        } catch (e) {
          AppLogger.error('Erro ao parsear resposta de login: $e', tag: _logTag, error: e);
          return Result.error(UnknownErrorException());
        }
      case 400:
        AppLogger.error('Requisição de login inválida: ${response.statusCode}', tag: _logTag);
        return Result.error(RequisicaoInvalidaException());
      case 401:
        AppLogger.error('Credenciais inválidas: ${response.statusCode}', tag: _logTag);
        return Result.error(UsuarioOuSenhaInvalidoException());
      case 403:
        AppLogger.error('Acesso negado: ${response.statusCode}', tag: _logTag);
        return Result.error(AcessoNegadoException());
      case 404:
        AppLogger.error('Endpoint de login não encontrado: ${response.statusCode}', tag: _logTag);
        return Result.error(RecursoNaoEncontradoException());
      case 500:
        AppLogger.error('Erro interno do servidor: ${response.statusCode}', tag: _logTag);
        return Result.error(ErroInternoServidorException());
      case 503:
        AppLogger.error('Servidor indisponível: ${response.statusCode}', tag: _logTag);
        return Result.error(ServidorIndisponivelException());
      default:
        AppLogger.error('Erro inesperado no login: ${response.statusCode}', tag: _logTag);
        return Result.error(UnknownErrorException());
    }
  }

  /// Trata a resposta HTTP do refresh token
  Result<RefreshTokenResponse> _handleRefreshTokenResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        AppLogger.info('Refresh token bem-sucedido: ${response.statusCode}', tag: _logTag);
        try {
          final refreshResponse = RefreshTokenResponse.fromJson(
            response.data as Map<String, dynamic>,
          );
          return Result.ok(refreshResponse);
        } catch (e) {
          AppLogger.error(
            'Erro ao parsear resposta de refresh token: $e',
            tag: _logTag,
            error: e,
          );
          return Result.error(UnknownErrorException());
        }
      case 400:
        AppLogger.error(
          'Requisição de refresh token inválida: ${response.statusCode}',
          tag: _logTag,
        );
        return Result.error(RequisicaoInvalidaException());
      case 401:
        AppLogger.error(
          'Refresh token inválido ou expirado: ${response.statusCode}',
          tag: _logTag,
        );
        return Result.error(SessaoExpiradaException());
      case 403:
        AppLogger.error('Acesso negado: ${response.statusCode}', tag: _logTag);
        return Result.error(AcessoNegadoException());
      case 404:
        AppLogger.error(
          'Endpoint de refresh token não encontrado: ${response.statusCode}',
          tag: _logTag,
        );
        return Result.error(RecursoNaoEncontradoException());
      case 500:
        AppLogger.error(
          'Erro interno do servidor: ${response.statusCode}',
          tag: _logTag,
        );
        return Result.error(ErroInternoServidorException());
      case 503:
        AppLogger.error(
          'Servidor indisponível: ${response.statusCode}',
          tag: _logTag,
        );
        return Result.error(ServidorIndisponivelException());
      default:
        AppLogger.error(
          'Erro inesperado no refresh token: ${response.statusCode}',
          tag: _logTag,
        );
        return Result.error(UnknownErrorException());
    }
  }
}
