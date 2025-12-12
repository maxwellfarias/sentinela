import 'package:sentinela/data/model/login_response_api_model.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/data/services/api/auth_api_client/auth_api_client.dart';
import 'package:sentinela/data/services/logger/app_logger.dart';
import 'package:sentinela/data/services/secure_storage/secure_storage_service.dart';
import 'package:sentinela/utils/result.dart';

final class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient _authApiClient;
  final AppLogger _logger;
  final SecureStorageService _storageService;
  AuthRepositoryImpl({required AuthApiClient authApiClient, required AppLogger logger, required SecureStorageService storageService})
    : _authApiClient = authApiClient,
      _logger = logger,
      _storageService = storageService;

    UserApiModel? _currentUser;

  Future<Result<dynamic>> login({required String email, required String password}) async {
    final result = await _authApiClient.login(email: email, password: password)
    .map(LoginResponseApiModel.fromJson)
    .map((loginResponse) {
      _currentUser = loginResponse.user;
      _storageService.saveToken(loginResponse.accessToken);
      _storageService.saveRefreshToken(loginResponse.refreshToken);
      _storageService.saveTokenExpires(loginResponse.expiresAt.toString());
      return loginResponse;
    });
  return result;
  }
}


