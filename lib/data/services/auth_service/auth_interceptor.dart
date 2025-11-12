import 'package:dio/dio.dart';
import 'package:w3_diploma/data/services/auth_service/secure_storage_service.dart';
import 'package:w3_diploma/domain/models/auth/refresh_token_request.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import '../../../config/constants/urls.dart';

/// Interceptor do Dio para gerenciamento automático de autenticação
///
/// Este interceptor realiza três funções principais:
///
/// 1. **Injeção automática do token**: Adiciona o header Authorization
///    com o Bearer token em todas as requisições (exceto login e refresh)
///
/// 2. **Verificação de expiração**: Antes de cada requisição, verifica
///    se o token está próximo de expirar (menos de 5 minutos) e renova
///    automaticamente se necessário
///
/// 3. **Tratamento de erro 401**: Se uma requisição retornar 401 (não autorizado),
///    tenta renovar o token automaticamente e refaz a requisição original
///
/// **Exemplo de fluxo:**
/// ```
/// 1. App faz requisição GET /api/alunos
/// 2. Interceptor verifica: token expira em 3 minutos
/// 3. Interceptor renova o token automaticamente
/// 4. Interceptor adiciona novo token no header
/// 5. Requisição prossegue normalmente
/// ```
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;
  final Dio _dio;

  /// Flag para evitar loop infinito de refresh
  bool _isRefreshing = false;

  static const String _logTag = 'AuthInterceptor';

  AuthInterceptor({
    required SecureStorageService storageService,
    required Dio dio,
  })  : _storageService = storageService,
        _dio = dio;

  /// Chamado ANTES de cada requisição ser enviada
  ///
  /// Aqui fazemos:
  /// 1. Verificar se o token está próximo de expirar
  /// 2. Renovar o token se necessário
  /// 3. Adicionar o Bearer token no header
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final url = options.path;

    // Não adiciona token nas rotas de autenticação
    if (_isAuthenticationRoute(url)) {
      AppLogger.info(
        'Requisição para rota de autenticação, sem adicionar token',
        tag: _logTag,
      );
      return handler.next(options);
    }

    try {
      // Verifica se o token está próximo de expirar
      final isNearExpirationResult =
          await _storageService.isTokenNearExpiration();
      final isNearExpiration = isNearExpirationResult.getSuccessOrNull();

      // Se está próximo de expirar, renova o token
      if (isNearExpiration == true) {
        AppLogger.info(
          'Token próximo de expirar, renovando...',
          tag: _logTag,
        );
        await _refreshTokenIfNeeded();
      }

      // Obtém o token atual (renovado ou não)
      final tokenResult = await _storageService.getToken();
      final token = tokenResult.getSuccessOrNull();

      if (token != null) {
        // Adiciona o Bearer token no header
        options.headers['Authorization'] = 'Bearer $token';
        AppLogger.info('Token adicionado ao header da requisição', tag: _logTag);
      } else {
        AppLogger.warning('Nenhum token disponível para adicionar', tag: _logTag);
      }

      return handler.next(options);
    } catch (e) {
      AppLogger.error('Erro ao processar requisição: $e', tag: _logTag, error: e);
      return handler.next(options);
    }
  }

  /// Chamado quando uma requisição FALHA com erro
  ///
  /// Se o erro for 401 (não autorizado), tenta renovar o token
  /// e refazer a requisição original
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Se o erro for 401 (não autorizado) e não for rota de auth
    if (err.response?.statusCode == 401 &&
        !_isAuthenticationRoute(err.requestOptions.path)) {
      AppLogger.warning(
        'Erro 401 detectado, tentando renovar token...',
        tag: _logTag,
      );

      // Tenta renovar o token
      final refreshSuccess = await _refreshTokenIfNeeded();

      if (refreshSuccess) {
        // Token renovado com sucesso, refaz a requisição original
        try {
          AppLogger.info('Token renovado, refazendo requisição', tag: _logTag);

          // Obtém o novo token
          final tokenResult = await _storageService.getToken();
          final newToken = tokenResult.getSuccessOrNull();

          if (newToken != null) {
            // Atualiza o header com o novo token
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            // Refaz a requisição original
            final response = await _dio.fetch(err.requestOptions);
            return handler.resolve(response);
          }
        } catch (e) {
          AppLogger.error(
            'Erro ao refazer requisição após refresh: $e',
            tag: _logTag,
            error: e,
          );
          return handler.next(err);
        }
      } else {
        AppLogger.error(
          'Falha ao renovar token, retornando erro 401',
          tag: _logTag,
        );
      }
    }

    return handler.next(err);
  }

  /// Verifica se a URL é uma rota de autenticação
  ///
  /// Rotas de autenticação não devem ter o interceptor aplicado
  /// para evitar loops infinitos
  bool _isAuthenticationRoute(String url) {
    return url.contains('/login/') ||
        url.contains('/Refresh') ||
        url.contains('/Revoke');
  }

  /// Renova o token se necessário
  ///
  /// Usa uma flag `_isRefreshing` para evitar múltiplas renovações
  /// simultâneas (race condition)
  Future<bool> _refreshTokenIfNeeded() async {
    // Se já está renovando, aguarda
    if (_isRefreshing) {
      AppLogger.info('Refresh já em andamento, aguardando...', tag: _logTag);
      return false;
    }

    _isRefreshing = true;

    try {
      // Obtém o token e refresh token atuais
      final tokenResult = await _storageService.getToken();
      final refreshTokenResult = await _storageService.getRefreshToken();

      final token = tokenResult.getSuccessOrNull();
      final refreshToken = refreshTokenResult.getSuccessOrNull();

      if (token == null || refreshToken == null) {
        AppLogger.error('Token ou refresh token não disponível', tag: _logTag);
        return false;
      }

      // Cria a requisição de refresh
      final refreshRequest = RefreshTokenRequest(
        token: token,
        refreshToken: refreshToken,
      );

      AppLogger.info('Enviando requisição de refresh token', tag: _logTag);

      // Faz a requisição de refresh (sem o interceptor para evitar loop)
      final response = await _dio.post(
        Urls.refreshToken(),
        data: refreshRequest.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse da resposta
        final data = response.data as Map<String, dynamic>;

        // Salva os novos tokens e informações
        await _storageService.saveToken(data['token'] as String);
        await _storageService.saveRefreshToken(data['refreshToken'] as String);
        await _storageService.saveTokenExpires(data['expires'] as String);
        await _storageService.saveUsername(data['username'] as String);
        await _storageService.saveUserRole(data['role'] as String);
        await _storageService.saveNumeroBancoDados(data['numeroBancoDados'] as int);
        await _storageService.saveUserId(data['id'].toString());

        AppLogger.info('Token renovado com sucesso', tag: _logTag);
        return true;
      } else {
        AppLogger.error(
          'Falha ao renovar token: ${response.statusCode}',
          tag: _logTag,
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Erro ao renovar token: $e', tag: _logTag, error: e);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }
}
