import 'package:sentinela/utils/result.dart';

abstract interface class AuthApiClient {

  Future<Result<dynamic>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Result<dynamic>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  /// Get the current user data from server
  Future<Result<dynamic>> getCurrentUserData();

  /// Refresh the authentication token using a refresh token
  Future<Result<dynamic>> refreshToken({required String refreshToken});
}

