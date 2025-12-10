import 'package:dio/dio.dart';
import 'package:sentinela/data/services/api/auth_api_client/auth_api_client.dart';
import 'package:sentinela/data/services/logger/app_logger.dart';
import 'package:sentinela/exceptions/app_exception.dart';
import 'package:sentinela/utils/result.dart';

final class AuthApiClientImpl implements AuthApiClient {
  Dio _dio;
  String baseUrl;
  AppLogger _logger;
  String _tag = 'AuthApiClientImpl';
  AuthApiClientImpl({required Dio dio, required String url, required AppLogger logger})
    : _dio = dio,
      baseUrl = url,
      _logger = logger;

  @override
  Future<Result<dynamic>> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('$baseUrl/token?grant_type=password', data: {
        'email': email,
        'password': password,
      });
      return _handleResponse(response);
    } catch (e, s) {
      _logger.error('Erro ao realizar login', tag: _tag, error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200: {
        if (response.data.isEmpty) return null;
        return response.data;
      }
      case 204: return null;
      case 400: Result.error(RequisicaoInvalidaException());
      case 401: Result.error(NaoAutorizadoException());
      case 403: Result.error(AcessoProibidoException());
      case 404: Result.error(RecursoNaoEncontradoException());
      case 500: Result.error(ErroInternoServidorException());
      default: return Result.error(UnknownErrorException());
    }
  }
}