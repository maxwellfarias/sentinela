import 'package:sentinela/data/datasources/auth/auth_remote_data_source.dart';
import 'package:sentinela/data/datasources/auth/user_model.dart';
import 'package:sentinela/exceptions/app_exception.dart';
import 'package:sentinela/utils/network/connection_checker.dart';
import 'package:sentinela/utils/result.dart';

class AuthRepositoryImpl {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Result<UserModel>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return Result.error(SessaoExpiradaException());
        }

        return Result.ok(UserModel(id: session.user.id, email: session.user.email ?? '', name: ''),
        );
      }
      final user = await remoteDataSource.getCurrentUserData()
      .map((user) {
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
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  // @override
  // Future<Either<Failure, User>> signUpWithEmailPassword({
  //   required String name,
  //   required String email,
  //   required String password,
  // }) async {
  //   return _getUser(
  //     () async => await remoteDataSource.signUpWithEmailPassword(
  //       name: name,
  //       email: email,
  //       password: password,
  //     ),
  //   );
  // }

  Future<Result<UserModel>> _getUser(Future<Result<UserModel>> Function() fn) async {
      if (!await (connectionChecker.isConnected)) {
        return Result.error(SemConexaoException());
      }
      final user = await fn();
      return user;
  }
}