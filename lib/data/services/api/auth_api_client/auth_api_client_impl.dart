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
  AuthApiClientImpl({required Dio dio,required String url, required AppLogger logger}) : _dio = dio,
       baseUrl = url,
       _logger = logger;

  final apiKey = "sb_publishable_yehVgeZN4iWGS4nrEGRb2w_-A9MQt6K";

  @override
  Future<Result<dynamic>> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('${baseUrl}token?grant_type=password', data: {'email': email, 'password': password}, options: Options(headers: {'apiKey': apiKey}));
      return _handleResponse(response);
    } on DioException catch (e, s) {
      _logger.error('DioError ao realizar login: ${e.message}', tag: _tag, error: e, stackTrace: s);
      if (e.response != null) {
        return _handleResponse(e.response!);
      } else {
        return Result.error(UnknownErrorException());
      }
    }
  }

  Result<dynamic> _handleResponse(Response response) {
    _logger.debug('Response received: ${response.statusCode}', tag: _tag);
    switch (response.statusCode) {
      case 200:
        {
          if (response.data == null || response.data.toString().isEmpty) {
            return Result.ok(null);
          }
          return Result.ok(response.data);
        }
      case 201:
        return Result.ok(response.data);
      case 204:
        return Result.ok(null);
      case 400:
        return Result.error(RequisicaoInvalidaException());
      case 401:
        return Result.error(NaoAutorizadoException());
      case 403:
        return Result.error(AcessoProibidoException());
      case 404:
        return Result.error(RecursoNaoEncontradoException());
      case 500:
        return Result.error(ErroInternoServidorException());
      case 503:
        return Result.error(ServidorIndisponivelException());
      default:
        _logger.warning(
          'Código de status não tratado: ${response.statusCode}',
          tag: _tag,
        );
        return Result.error(UnknownErrorException());
    }
  }
}
