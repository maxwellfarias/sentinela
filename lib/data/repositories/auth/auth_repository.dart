
import 'package:flutter/material.dart';
import 'package:sentinela/domain/models/aluno/user_model.dart';
import 'package:sentinela/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier{
  
  Future<Result<dynamic>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Result<dynamic>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<UserModel>> currentUser();

  Future<bool> isAuthenticated();

  Future<Result<void>> logout();
}