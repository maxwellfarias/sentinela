import 'package:sentinela/utils/result.dart';

abstract interface class AuthRepository {
  Future<bool> get isAuthenticated;
  Future<Result<dynamic>> login({
    required String email,
    required String password,
  });
}
