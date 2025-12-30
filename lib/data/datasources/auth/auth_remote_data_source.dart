import 'package:sentinela/data/datasources/auth/auth_remote_data_source_impl.dart';
import 'package:sentinela/data/datasources/auth/user_model.dart';
import 'package:sentinela/utils/result.dart';
import 'package:supabase/supabase.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUser;
  // Future<Result<UserModel>> signUpWithEmailPassword({
  //   required String name,
  //   required String email,
  //   required String password,
  // });
  Future<Result<UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Result<UserModel?>> getCurrentUserData();
  CurrentSession? get session;

  Future<Result<void>> logout();
}
