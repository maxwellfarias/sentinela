import 'package:sentinela/data/model/login_response_api_model.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/data/datasources/api/auth_api_client/auth_api_client.dart';
import 'package:sentinela/data/datasources/logger/app_logger.dart';
import 'package:sentinela/data/datasources/secure_storage/secure_storage_service.dart';
import 'package:sentinela/exceptions/app_exception.dart';
import 'package:sentinela/utils/result.dart';

final class AuthRepositoryImpl extends AuthRepository {
  final AuthApiClient _authApiClient;
  final AppLogger _logger;
  final SecureStorageService _storageService;
  AuthRepositoryImpl({
    required AuthApiClient authApiClient,
    required AppLogger logger,
    required SecureStorageService storageService,
  }) : _authApiClient = authApiClient,
       _logger = logger,
       _storageService = storageService;

  UserApiModel? _currentUser;

  @override
  Future<Result<dynamic>> login({required String email, required String password}) async {
    try{
    final result = await _authApiClient
        .login(email: email, password: password)
        .map(LoginResponseApiModel.fromJson)
        .flatMapAsync((loginResponse) => _storageService.saveToken(loginResponse.accessToken)
            .flatMapAsync((_) => _storageService.saveRefreshToken(loginResponse.refreshToken))
            .flatMapAsync((_) => _storageService.saveTokenExpires(loginResponse.expiresAt.toString())));

    return result;
    } catch (e, s) {
      _logger.error('Erro ao serealizar dados: $e', stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
  
  @override
  Future<bool> get isAuthenticated async => true;
}
