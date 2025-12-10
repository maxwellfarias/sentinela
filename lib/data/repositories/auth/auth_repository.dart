import 'package:sentinela/utils/result.dart';

abstract interface class AuthRepository {
  Future<Result<dynamic>> login({required String email, required String password});
}