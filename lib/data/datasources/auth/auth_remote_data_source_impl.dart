import 'package:sentinela/data/datasources/auth/auth_remote_data_source.dart';
import 'package:sentinela/domain/models/user/user_model.dart';
import 'package:sentinela/data/datasources/logger/app_logger.dart';
import 'package:sentinela/domain/models/auth/session_model.dart';
import 'package:sentinela/exceptions/app_exception.dart';
import 'package:sentinela/utils/result.dart';
import 'package:supabase/supabase.dart';


class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final AppLogger _logger;
  AuthRemoteDataSourceImpl({
    required SupabaseClient supabaseClient,
    required AppLogger logger,
  }) : _supabaseClient = supabaseClient,
       _logger = logger;

  final _tag = 'AuthRemoteDataSourceImpl';

  @override
  Session? get currentUser => _supabaseClient.auth.currentSession;

  @override
  CurrentSession? get session {
    final session = _supabaseClient.auth.currentSession;
    if (session != null) {
      return CurrentSession(
        accessToken: session.accessToken,
        expiresAt: session.expiresAt ?? 0,
        refreshToken: session.refreshToken ?? '',
      );
    }
    return null;
  }

  @override
  Future<Result<UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null)
        return Result.error(RequisicaoInvalidaException());
      return Result.ok(UserModel.fromJson(response.user!.toJson()));
    } on AuthException catch (e, stackTrace) {
      _logger.error(
        'AuthException ao realizar login: ${e.message}',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return Result.error(UsuarioOuSenhaInvalidoException());
    } catch (e) {
      return Result.error(ServidorIndisponivelException());
    }
  }

  // @override
  // Future<Result<UserModel>> signUpWithEmailPassword({
  //   required String name,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await _supabaseClient.auth.signUp(
  //       password: password,
  //       email: email,
  //       data: {
  //         'name': name,
  //       },
  //     );
  //     if (response.user == null) {
  //       throw const ServerException('User is null!');
  //     }
  //     return UserModel.fromJson(response.user!.toJson());
  //   } on AuthException catch (e) {
  //     throw ServerException(e.message);
  //   } catch (e) {
  //     throw ServerException(e.toString());
  //   }
  // }

  @override
  Future<Result<UserModel?>> getCurrentUserData() async {
    try {
      if (currentUser != null) {
        final userData = await _supabaseClient
            .from('users')
            .select()
            .eq('id', currentUser!.user.id);
        return Result.ok(
          UserModel.fromJson(
            userData.first,
          ).copyWith(email: currentUser!.user.email),
        );
      }

      return Result.ok(null);
    } catch (e) {
      return Result.error(ServidorIndisponivelException());
    }
  }

  @override
  Future<Result<void>> logout() {
    try {
      _supabaseClient.auth.signOut();
      return Future.value(Result.ok(null));
    } catch (e) {
      return Future.value(Result.error(ServidorIndisponivelException()));
    }
  }
}
