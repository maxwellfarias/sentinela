import 'package:dio/dio.dart';
import 'package:sentinela/data/datasources/auth/user_model.dart';
import 'package:sentinela/data/datasources/logger/app_logger.dart';
import 'package:sentinela/data/datasources/secure_storage/secure_storage_service.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/utils/result.dart';
import 'package:supabase/supabase.dart';

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
  final Dio _dio;
  final AppLogger _logger;
  final AuthRepository _authRepository;
  final String _urlRefresh;
  final String _apiKey;

  /// Flag para evitar loop infinito de refresh
  bool _isRefreshing = false;

  /// Completer para aguardar refresh em andamento
  Future<bool>? _refreshFuture;

  static const String _logTag = 'AuthInterceptor';

  AuthInterceptor({
    required SecureStorageService storageService,
    required Dio dio,
    required AppLogger logger,
    required AuthRepository authRepository,
    required String urlRefresh,
    required String apiKey,
  }) :
       _dio = dio,
       _authRepository = authRepository,
        _urlRefresh = urlRefresh,
        _apiKey = apiKey,
       _logger = logger;

  /// Chamado ANTES de cada requisição ser enviada
  ///
  /// Aqui fazemos:
  /// 1. Verificar se o token está próximo de expirar
  /// 2. Renovar o token se necessário
  /// 3. Adiciona o Bearer token no header
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final url = options.path;

    // Não adiciona token nas rotas de autenticação
    if (_isAuthenticationRoute(url)) {
      _logger.info(
        'Requisição para rota de autenticação, sem adicionar token',
        tag: _logTag,
      );
      // Ignora o token e prossegue
      return handler.next(options);
    }

    try {
      UserModel? user;
      await _authRepository.currentUser().map((u) => user = u);

      if (user == null) {
       await  _authRepository.logout();
        return handler.next(options);
      }

      // Se está próximo de expirar, renova o token
      if (_isTokenNearExpiration(expiresAt: user!.expiresAt)) {
        _logger.info('Token próximo de expirar, renovando...', tag: _logTag);
        await _refreshTokenIfNeeded();
        await _authRepository.currentUser().map((u) => user = u);
      }
      options.headers['Authorization'] = 'Bearer $user.token';
      return handler.next(options);
    } catch (e) {
      _logger.error('Erro ao processar requisição: $e', tag: _logTag, error: e);
      return handler.next(options);
    }
  }

  bool _isTokenNearExpiration({required int expiresAt}) {
    // Converte o expiresAt (timestamp em segundos) para DateTime. É necessário multiplicar por 1000 para converter para milissegundos
    final expiresDate = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
    final now = DateTime.now();
    final difference = expiresDate.difference(now);
    return difference.inMinutes < 5;
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
      _logger.warning('Erro 401 detectado, tentando renovar token...', tag: _logTag);

      // Tenta renovar o token
      final refreshSuccess = await _refreshTokenIfNeeded();

      if (refreshSuccess) {
        // Token renovado com sucesso, refaz a requisição original
        try {
          _logger.info('Token renovado, refazendo requisição', tag: _logTag);


          UserModel? user;
          await _authRepository.currentUser().map((u) => user = u);
          if (user == null) {
            _logger.error('Usuário não autenticado após refresh', tag: _logTag);
            await _authRepository.logout();
            return handler.next(err);
          }

            // Atualiza o header com o novo token
            err.requestOptions.headers['Authorization'] = 'Bearer $user.token';

            // Refaz a requisição original
            final response = await _dio.fetch(err.requestOptions);
            return handler.resolve(response);
          
        } catch (e) {
          _logger.error(
            'Erro ao refazer requisição após refresh: $e',
            tag: _logTag,
            error: e,
          );
          return handler.next(err);
        }
      } else {
        _logger.error(
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
  /// Usa uma flag `_isRefreshing` e um Future compartilhado para evitar
  /// múltiplas renovações simultâneas (race condition).
  /// Se um refresh já está em andamento, aguarda o resultado dele.
  Future<bool> _refreshTokenIfNeeded() async {
    // Se já está renovando, aguarda o resultado do refresh em andamento
    if (_isRefreshing && _refreshFuture != null) {
      _logger.info(
        'Refresh já em andamento, aguardando resultado...',
        tag: _logTag,
      );
      return await _refreshFuture!;
    }

    _isRefreshing = true;

    // Cria o Future compartilhado que outras chamadas podem aguardar
    _refreshFuture = _performRefresh();

    try {
      return await _refreshFuture!;
    } finally {
      _isRefreshing = false;
      _refreshFuture = null;
    }
  }

  /// Executa a renovação do token
  Future<bool> _performRefresh() async {
    try {

      UserModel? user;
      await _authRepository.currentUser().map((u) => user = u);

      if(user == null) {
        _logger.error('Usuário não autenticado, não é possível renovar token', tag: _logTag);
        await _authRepository.logout();
        return false;
      }

      // // Obtém o token e refresh token atuais
      // final tokenResult = await _storageService.getToken();
      // final refreshTokenResult = await _storageService.getRefreshToken();

      // final token = tokenResult.getSuccessOrNull();
      // final refreshToken = refreshTokenResult.getSuccessOrNull();

      // if (token == null || refreshToken == null) {
      //   _logger.error('Token ou refresh token não disponível', tag: _logTag);
      //   await _clearAuthData();
      //   return false;
      // }

      // Cria a requisição de refresh
      final refreshRequest = <String, dynamic>{'refresh_token': user!.refreshToken};

      _logger.info('Enviando requisição de refresh token', tag: _logTag);

      // Faz a requisição de refresh (sem o interceptor para evitar loop)
      final response = await _dio.post(
        _urlRefresh,
        data: refreshRequest,
        options: Options(
          headers: {'apikey': _apiKey},
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        // Refresh token também expirou ou é inválido
        _logger.error(
          'Refresh token inválido ou expirado (401). Limpando dados de autenticação.',
          tag: _logTag,
        );
        await _authRepository.logout();
        return false;
      } else if (response.statusCode == 400) {
        // Dados inválidos na requisição
        _logger.error(
          'Requisição de refresh inválida (400). Limpando dados de autenticação.',
          tag: _logTag,
        );
        await _authRepository.logout();
        return false;
      } else {
        _logger.error(
          'Falha ao renovar token: ${response.statusCode}',
          tag: _logTag,
        );
        // Em outros erros, não limpa os dados (pode ser temporário)
        return false;
      }
    } on DioException catch (e) {
      _logger.error(
        'Erro de rede ao renovar token: ${e.message}',
        tag: _logTag,
        error: e,
      );

      // Se o erro for 401, limpa os dados
      if (e.response?.statusCode == 401) {
        _logger.error(
          'Refresh token inválido ou expirado (DioException 401). Limpando dados.',
          tag: _logTag,
        );
        await _authRepository.logout();
      }

      return false;
    } catch (e) {
      _logger.error(
        'Erro inesperado ao renovar token: $e',
        tag: _logTag,
        error: e,
      );
      return false;
    }
  }
}
