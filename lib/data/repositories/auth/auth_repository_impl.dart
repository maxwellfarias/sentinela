import 'package:sentinela/data/datasources/auth/auth_remote_data_source.dart';
import 'package:sentinela/data/datasources/auth/auth_remote_data_source_impl.dart';
import 'package:sentinela/data/datasources/auth/user_model.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/exceptions/app_exception.dart';
import 'package:sentinela/utils/network/connection_checker.dart';
import 'package:sentinela/utils/result.dart';
import 'package:supabase/supabase.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final ConnectionChecker _connectionChecker;
  AuthRepositoryImpl(this._remoteDataSource, this._connectionChecker);

  @override
  Future<bool> get isAuthenticated async => currentUser().then((result) => result.isOk);

  @override
  CurrentSession? get currentSession => _remoteDataSource.session;

  @override
  Future<Result<UserModel>> currentUser() async {
    try {
      if (!await (_connectionChecker.isConnected)) {
        final session = _remoteDataSource.currentUser;

        if (session == null) {
          return Result.error(SessaoExpiradaException());
        }
        final userResponse = UserModel(
          id: session.user.id,
          email: session.user.email ?? '',
          name: session.user.userMetadata?['name'] ?? '',
        );
        return Result.ok(userResponse);
      }
      final user = await _remoteDataSource.getCurrentUserData().map((user) {
        if (user == null) {
          throw SessaoExpiradaException();
        }
        return user;
      });

      return user;
    } on SessaoExpiradaException {
      return Result.error(SessaoExpiradaException());
    } catch (e) {
      return Result.error(ErroInternoServidorException());
    }
  }

  @override
  Future<Result<UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (!await (_connectionChecker.isConnected))
      return Result.error(SemConexaoException());
    final loginResponse = await _remoteDataSource.loginWithEmailPassword(
      email: email,
      password: password,
    );
    notifyListeners();
    return loginResponse;
  }

  @override
  Future<Result<void>> logout() async => _remoteDataSource.logout();
}
