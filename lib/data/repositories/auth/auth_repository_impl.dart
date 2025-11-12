import 'package:w3_diploma/data/services/auth_service/auth_api_client.dart';

import '../../../domain/models/auth/login_request.dart';
import '../../../domain/models/auth/refresh_token_request.dart';
import '../../../domain/models/auth/user_model.dart';
import '../../../exceptions/app_exception.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/result.dart';
import '../../services/auth_service/auth_api_client_impl.dart';
import '../../services/auth_service/secure_storage_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthApiClient _authApiClient;
  final SecureStorageService _secureStorageService;

  static const String _logTag = 'AuthRepository';

  bool? _isAuthenticated;
  String? _authToken;
  UserModel? _currentUser;

  AuthRepositoryImpl({
    required AuthApiClient authApiClient,
    required SecureStorageService secureStorageService,
  })  : _authApiClient = authApiClient,
        _secureStorageService = secureStorageService {
    _initialize();
  }

  /// Inicializa o repositório carregando o token armazenado
  Future<void> _initialize() async {
    await _loadStoredToken();
  }

  /// Carrega o token armazenado do secure storage
  Future<void> _loadStoredToken() async {
    final result = await _secureStorageService.getToken();
    switch (result) {
      case Ok<String?>():
        _authToken = result.value;
        _isAuthenticated = result.value != null;
        AppLogger.info(
          'Token carregado: ${_authToken != null ? "Presente" : "Ausente"}',
          tag: _logTag,
        );
      case Error<String?>():
        AppLogger.error(
          'Erro ao carregar token: ${result.error}',
          tag: _logTag,
          error: result.error,
        );
        _isAuthenticated = false;
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    // Status já foi carregado
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }

    // Ainda não carregou, tenta carregar do storage
    await _loadStoredToken();
    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> login({
    required String cpf,
    required String password,
  }) async {
    try {
      AppLogger.info('Tentando fazer login com CPF: $cpf', tag: _logTag);

      final loginRequest = LoginRequest(
        cpf: cpf,
        password: password,
      );

      final result = await _authApiClient.login(loginRequest);

      switch (result) {
        case Ok():
          final loginResponse = result.value;
          AppLogger.info('Login bem-sucedido', tag: _logTag);

          // Armazena o token JWT
          _authToken = loginResponse.token;
          await _secureStorageService.saveToken(loginResponse.token);

          // Armazena o refresh token
          await _secureStorageService.saveRefreshToken(loginResponse.refreshToken);

          // Armazena a data de expiração
          await _secureStorageService.saveTokenExpires(loginResponse.expires);

          // Armazena informações do usuário
          await _secureStorageService.saveUserId(loginResponse.id.toString());
          await _secureStorageService.saveUsername(loginResponse.username);
          await _secureStorageService.saveUserRole(loginResponse.role);
          await _secureStorageService.saveNumeroBancoDados(loginResponse.numeroBancoDados);

          // Cria um UserModel simplificado (compatível com o modelo antigo)
          // Nota: A API não retorna mais um objeto 'user', mas campos diretos
          _currentUser = UserModel(
            id: loginResponse.id.toString(),
            nome: loginResponse.username,
            cpf: cpf, // Usa o CPF fornecido no login
            email: null, // A API não retorna email
          );

          // Atualiza o status de autenticação
          _isAuthenticated = true;

          // Notifica os listeners
          notifyListeners();

          AppLogger.info(
            'Dados do usuário salvos: ID=${loginResponse.id}, Role=${loginResponse.role}',
            tag: _logTag,
          );

          return const Result.ok(null);

        case Error():
          AppLogger.warning('Erro no login: ${result.error}', tag: _logTag);
          _isAuthenticated = false;
          return Result.error(result.error);
      }
    } catch (e) {
      AppLogger.error('Erro inesperado no login: $e', tag: _logTag, error: e);
      _isAuthenticated = false;
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<void>> refreshToken() async {
    try {
      AppLogger.info('Renovando token', tag: _logTag);

      // Obtém o token e refresh token atuais
      final tokenResult = await _secureStorageService.getToken();
      final refreshTokenResult = await _secureStorageService.getRefreshToken();

      final token = tokenResult.getSuccessOrNull();
      final refreshToken = refreshTokenResult.getSuccessOrNull();

      if (token == null || refreshToken == null) {
        AppLogger.error('Token ou refresh token não disponível', tag: _logTag);
        return Result.error(SessaoExpiradaException());
      }

      // Cria a requisição de refresh
      final refreshRequest = RefreshTokenRequest(
        token: token,
        refreshToken: refreshToken,
      );

      // Chama a API para renovar o token
      final result = await _authApiClient.refreshToken(refreshRequest);

      switch (result) {
        case Ok():
          final refreshResponse = result.value;
          AppLogger.info('Refresh token bem-sucedido', tag: _logTag);

          // Atualiza o token JWT em memória
          _authToken = refreshResponse.token;

          // Salva os novos tokens e informações
          await _secureStorageService.saveToken(refreshResponse.token);
          await _secureStorageService.saveRefreshToken(refreshResponse.refreshToken);
          await _secureStorageService.saveTokenExpires(refreshResponse.expires);
          await _secureStorageService.saveUsername(refreshResponse.username);
          await _secureStorageService.saveUserRole(refreshResponse.role);
          await _secureStorageService.saveNumeroBancoDados(refreshResponse.numeroBancoDados);
          await _secureStorageService.saveUserId(refreshResponse.id.toString());

          // Atualiza o usuário em memória se necessário
          if (_currentUser != null) {
            _currentUser = UserModel(
              id: refreshResponse.id.toString(),
              nome: refreshResponse.username,
              cpf: _currentUser!.cpf, // Mantém o CPF original
              email: _currentUser!.email, // Mantém o email original
            );
          }

          // Mantém o status de autenticação
          _isAuthenticated = true;

          // Notifica os listeners
          notifyListeners();

          AppLogger.info('Token renovado com sucesso', tag: _logTag);
          return const Result.ok(null);

        case Error():
          AppLogger.error('Erro ao renovar token: ${result.error}', tag: _logTag);
          // Se o refresh falhou, o usuário precisa fazer login novamente
          _isAuthenticated = false;
          notifyListeners();
          return Result.error(result.error);
      }
    } catch (e) {
      AppLogger.error('Erro inesperado ao renovar token: $e', tag: _logTag, error: e);
      _isAuthenticated = false;
      notifyListeners();
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      AppLogger.info('Fazendo logout', tag: _logTag);

      // Tenta fazer logout no servidor se houver token
      if (_authToken != null) {
        await _authApiClient.logout(_authToken!);
      }

      // Limpa os dados armazenados
      final clearResult = await _secureStorageService.clearAll();

      if (clearResult is Error) {
        AppLogger.error(
          'Erro ao limpar dados: ${clearResult.error}',
          tag: _logTag,
          error: clearResult.error,
        );
      }

      // Limpa o estado local
      _authToken = null;
      _currentUser = null;
      _isAuthenticated = false;

      // Notifica os listeners
      notifyListeners();

      AppLogger.info('Logout concluído', tag: _logTag);
      return const Result.ok(null);
    } catch (e) {
      AppLogger.error('Erro inesperado no logout: $e', tag: _logTag, error: e);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<String?> get currentToken async {
    if (_authToken != null) {
      return _authToken;
    }

    // Tenta carregar do storage
    final result = await _secureStorageService.getToken();
    if (result is Ok<String?>) {
      _authToken = result.value;
      return result.value;
    }

    return null;
  }

  @override
  Future<String?> get currentRefreshToken async {
    final result = await _secureStorageService.getRefreshToken();
    return result.getSuccessOrNull();
  }

  @override
  Future<String?> get currentUserRole async {
    final result = await _secureStorageService.getUserRole();
    return result.getSuccessOrNull();
  }

  @override
  Future<int?> get currentNumeroBancoDados async {
    final result = await _secureStorageService.getNumeroBancoDados();
    return result.getSuccessOrNull();
  }
}
