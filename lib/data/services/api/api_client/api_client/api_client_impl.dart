import 'package:dio/dio.dart';
import 'package:sentinela/config/constants/http_types.dart';
import 'package:sentinela/data/services/api/api_client/api_client/api_client.dart';
import 'package:sentinela/data/services/logger/logger.dart';
import 'package:sentinela/exceptions/app_exception.dart';
import 'package:sentinela/utils/network/connection_checker.dart';
import 'package:sentinela/utils/result.dart';

/// Cliente HTTP que gerencia requisições da API
///
/// Responsabilidades:
/// - Verificar conectividade antes das requisições
/// - Executar requisições HTTP (GET, POST, PATCH, DELETE)
/// - Tratar erros e converter em exceções específicas
/// - Logar operações para debug
final class ApiClientImpl implements ApiClient {
  final Dio _dio;
  final ConnectionChecker _connectionChecker;
  final HeaderBuilder _headerService;
  final Logger _logger;
  static const String _logTag = 'ApiClient';

  ApiClientImpl({
    required Dio dio,
    required ConnectionChecker connectionChecker,
    required HeaderBuilder headerService,
    required Logger logger,
  })  : _dio = dio,
        _connectionChecker = connectionChecker,
        _headerService = headerService,
        _logger = logger;

  @override
  Future<Result<dynamic>> request({
    required ({String url, HttpMethod method}) endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _makeRequest(
      endpoint: endpoint,
      body: body,
      headers: headers,
      isPaginated: false,
    );
  }

  @override
  Future<Result<PaginatedRequestResponse>> paginatedRequest({
    required ({String url, HttpMethod method}) endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _makeRequest(
      endpoint: endpoint,
      body: body,
      headers: headers,
      isPaginated: true,
    );
  }

  /// Executa uma requisição HTTP (paginada ou não)
  Future<Result<T>> _makeRequest<T>({
    required ({String url, HttpMethod method}) endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    required bool isPaginated,
  }) async {
    // Verificar conexão
    if (!await _connectionChecker.isConnected) {
      return Result.error(SemConexaoException());
    }

    try {
      final response = await _executeRequest(
        endpoint: endpoint,
        body: body,
        headers: headers,
      );

      return _handleResponse(response, isPaginated: isPaginated);
    } on DioException catch (e) {
      return _handleDioException(e, isPaginated: isPaginated);
    } catch (error) {
      _logger.error('Erro inesperado: $error', tag: _logTag, error: error);
      return Result.error(UnknownErrorException());
    }
  }

  /// Executa a requisição HTTP de acordo com o método
  Future<Response> _executeRequest({
    required ({String url, HttpMethod method}) endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final requestHeaders = headers ?? await _headerService.getHeaders();
    final options = Options(headers: requestHeaders);

    _logger.info(
      'Requisição: ${endpoint.method.name.toUpperCase()} ${endpoint.url}',
      tag: _logTag,
    );

    return switch (endpoint.method) {
      HttpMethod.get => await _dio.get(endpoint.url, options: options),
      HttpMethod.post => await _dio.post(endpoint.url, options: options, data: body),
      HttpMethod.patch => await _dio.patch(endpoint.url, options: options, data: body),
      HttpMethod.delete => await _dio.delete(endpoint.url, options: options),
    };
  }

  /// Processa a resposta HTTP e converte em Result
  Result<T> _handleResponse<T>(Response response, {required bool isPaginated}) {
    final statusCode = response.statusCode ?? 0;
    final exception = _getExceptionForStatusCode(statusCode);

    // Resposta com erro
    if (exception != null) {
      _logger.error('Erro HTTP $statusCode', tag: _logTag);
      return Result.error(exception);
    }

    // Resposta sem conteúdo
    if (statusCode == 204) {
      _logger.info('Sucesso (sem conteúdo)', tag: _logTag);
      return isPaginated
          ? Result.ok((data: null, headers: response.headers.map) as T)
          : Result.ok(null as T);
    }

    // Resposta com sucesso
    _logger.info('Sucesso: $statusCode', tag: _logTag);
    return isPaginated
        ? Result.ok((data: response.data, headers: response.headers.map) as T)
        : Result.ok(response.data as T);
  }

  /// Trata erros do Dio e converte em Result
  Result<T> _handleDioException<T>(DioException e, {required bool isPaginated}) {
    _logger.error('DioException: ${e.type}', tag: _logTag, error: e);

    // Se há resposta do servidor, processar status code
    if (e.response != null) {
      return _handleResponse(e.response!, isPaginated: isPaginated);
    }

    // Erros de timeout
    if (_isTimeoutError(e.type)) {
      return Result.error(TimeoutDeRequisicaoException());
    }

    // Erros de conexão
    if (e.type == DioExceptionType.connectionError) {
      return Result.error(SemConexaoException());
    }

    // Outros erros
    return Result.error(ServidorIndisponivelException());
  }

  /// Retorna a exceção apropriada para cada status code
  AppException? _getExceptionForStatusCode(int statusCode) {
    return switch (statusCode) {
      200 || 201 || 204 || 206 => null, // Sucesso
      400 => RequisicaoInvalidaException(),
      401 => NaoAutorizadoException(),
      403 => AcessoProibidoException(),
      404 => RecursoNaoEncontradoException(),
      500 => ErroInternoServidorException(),
      503 => ServidorIndisponivelException(),
      _ => ServidorIndisponivelException(),
    };
  }

  /// Verifica se é erro de timeout
  bool _isTimeoutError(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout;
  }
}

class HeaderBuilder {
}