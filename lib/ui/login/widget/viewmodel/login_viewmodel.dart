import '../../../../data/repositories/auth/auth_repository.dart';
import '../../../../utils/app_logger.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

final class LoginViewmodel {
  final AuthRepository _authRepository;
  static const String _logTag = 'LoginViewModel';

  late final Command1<void, ({String cpf, String password})> loginCommand;

  LoginViewmodel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    loginCommand = Command1(_login);
  }

  Future<Result<void>> _login(({String cpf, String password}) credentials) async {
    AppLogger.info('Tentando fazer login', tag: _logTag);

    final result = await _authRepository.login(
      cpf: credentials.cpf,
      password: credentials.password,
    );

    switch (result) {
      case Ok<void>():
        AppLogger.info('Login realizado com sucesso', tag: _logTag);
        return const Result.ok(null);
      case Error<void>():
        AppLogger.warning('Erro no login: ${result.error}', tag: _logTag);
        return Result.error(result.error);
    }
  }
}