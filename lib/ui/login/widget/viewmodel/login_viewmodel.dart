import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/data/datasources/logger/app_logger.dart';
import 'package:sentinela/utils/command.dart';
import 'package:sentinela/utils/result.dart';

final class LoginViewmodel {
  final AuthRepository _authRepository;
  final AppLogger _logger;
  LoginViewmodel({required AuthRepository authRepository, required AppLogger logger})
    : _authRepository = authRepository,
      _logger = logger {
    login = Command1<dynamic,({String email, String password})>(_login);
    }

  late final Command1<dynamic, ({String email, String password})> login;

  Future<Result<dynamic>> _login(({String email, String password}) params) async {
    final result = await _authRepository.login(email: params.email, password: params.password);
    return result;
  }
}
