import 'package:sentinela/utils/result.dart';

abstract interface class AuthApiClient {
  Future<Result<dynamic>> login({required String email, required String password});
}