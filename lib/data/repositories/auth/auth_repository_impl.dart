import 'package:sentinela/data/model/login_response_api_model.dart';
import 'package:sentinela/data/services/api/auth_api_client/auth_api_client.dart';
import 'package:sentinela/data/services/logger/app_logger.dart';
import 'package:sentinela/utils/result.dart';

final class AuthRepositoryImpl {
  final AuthApiClient _authApiClient;
  final AppLogger _logger;
  AuthRepositoryImpl({required AuthApiClient authApiClient, required AppLogger logger})
    : _authApiClient = authApiClient,
      _logger = logger;

    UserApiModel? _currentUser;

  Future<Result<dynamic>> login({required String email, required String password}) async {
    final result = await _authApiClient.login(email: email, password: password)
    .map(LoginResponseApiModel.fromJson)
    .map((loginResponse) {
      _currentUser = loginResponse.user;
      return loginResponse;
    });
    return Result.ok(null);
  }
}


