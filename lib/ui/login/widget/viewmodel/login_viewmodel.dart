import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/utils/command.dart';
import 'package:sentinela/utils/result.dart';

final class LoginViewmodel {
  final AuthRepository _authRepository;
  LoginViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    login = Command1<dynamic,({String email, String password})>(_login);
    }

  late final Command1<dynamic, ({String email, String password})> login;

  Future<Result<dynamic>> _login(({String email, String password}) params) async {
    return _authRepository.login(email: params.email, password: params.password);
  }
}
