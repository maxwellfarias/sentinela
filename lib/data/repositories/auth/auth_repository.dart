import 'package:flutter/material.dart';
import 'package:sentinela/data/datasources/auth/auth_remote_data_source_impl.dart';
import 'package:sentinela/domain/models/user/user_model.dart';
import 'package:sentinela/domain/models/auth/session_model.dart';
import 'package:sentinela/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;
  Future<Result<UserModel>> currentUser();
  CurrentSession? get currentSession;
  Future<Result<UserModel>> loginWithEmailPassword({required String email, required String password});
  Future<Result<void>> logout();
}