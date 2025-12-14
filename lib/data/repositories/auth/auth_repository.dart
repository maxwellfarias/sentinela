import 'package:flutter/material.dart';
import 'package:sentinela/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  bool get isLoggedIn;
  Future<Result<dynamic>> login({required String email, required String password});
}