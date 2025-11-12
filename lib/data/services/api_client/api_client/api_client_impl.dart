import 'package:dio/dio.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/data/services/auth_service/secure_storage_service.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import 'package:w3_diploma/utils/result.dart';

final class ApiClientImpl implements ApiClient {
  final Dio _dio;
  final SecureStorageService _secureStorageService;
  static const String _logTag = 'ApiClient';

  ApiClientImpl(this._dio, this._secureStorageService);

  final timeOutDuration = Duration(seconds: 10);

  @override
  Future<Result<dynamic>> request({required String url, required MetodoHttp metodo, Map? body, Map? headers}) async {
    // Carrega o token do secure storage
    final tokenResult = await _secureStorageService.getToken();
    String? token;

    if (tokenResult is Ok<String?>) {
      token = tokenResult.value;
    }

    final defaultHeaders = headers?.cast<String, String>() ?? <String, String>{};

    // Adiciona headers padrão
    defaultHeaders.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // Adiciona token de autorização se disponível
    if (token != null) {
      defaultHeaders['Authorization'] = 'Bearer $token';
    } 

    Response? response;
    try {
      AppLogger.info('Requisição HTTP - URL: $url, Método: $metodo, Body: $body, Headers: $defaultHeaders', tag: _logTag);
        if (metodo == MetodoHttp.post) {
        response = await _dio.post(url, options: Options(headers: defaultHeaders), data: body);
      } else if (metodo == MetodoHttp.get) {
        response = await _dio.get(url, options: Options(headers: defaultHeaders));
      } else if (metodo == MetodoHttp.put) {
        response = await _dio.put(url, options: Options(headers: defaultHeaders), data: body);
      } else if (metodo == MetodoHttp.delete) {
        response = await _dio.delete(url, options: Options(headers: defaultHeaders));
      } else {
        AppLogger.error('Método HTTP não suportado: $metodo', tag: _logTag);
        throw UnsupportedError('Unsupported HTTP method');
      }
    } catch (error) {
      AppLogger.error('Erro na requisição HTTP: $error', tag: _logTag, error: error);
      return Result.error(ServidorIndisponivelException());
    }
    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200 || 201:
        AppLogger.info('Requisição bem sucedida: ${response.statusCode}', tag: _logTag);
        return Result.ok(response.data);
      case 204:
        AppLogger.info('Requisição bem sucedida com no content: ${response.statusCode}', tag: _logTag);
        return Result.ok(null);
      case 400:
        AppLogger.error('Requisição inválida: ${response.statusCode}', tag: _logTag);
        return Result.error(RequisicaoInvalidaException());
      case 401:
        AppLogger.error('Não autorizado: ${response.statusCode}', tag: _logTag);
        return Result.error(NaoAutorizadoException());
      case 403:
        AppLogger.error('Acesso proibido: ${response.statusCode}', tag: _logTag);
        return Result.error(AcessoProibidoException());
      case 404:
        AppLogger.error('Recurso não encontrado: ${response.statusCode}', tag: _logTag);
        return Result.error(RecursoNaoEncontradoException());
      default:
        AppLogger.error('Erro no servidor: ${response.statusCode}', tag: _logTag);
        return Result.error(ServidorIndisponivelException());
    }
  }
}
