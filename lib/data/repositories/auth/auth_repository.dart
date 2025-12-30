import 'package:flutter/material.dart';
import 'package:sentinela/data/datasources/auth/user_model.dart';
import 'package:sentinela/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;
  Future<Result<UserModel>> currentUser();
  Future<Result<UserModel>> loginWithEmailPassword({required String email, required String password});
  Future<Result<void>> logout();
}