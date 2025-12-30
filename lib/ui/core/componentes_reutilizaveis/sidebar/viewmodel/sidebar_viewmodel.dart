import 'package:flutter/widgets.dart';
import 'package:sentinela/data/datasources/auth/user_model.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/utils/command.dart';
import 'package:sentinela/utils/result.dart';


final class SidebarViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  SidebarViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository {
    logout = Command0(_logout);
    user = Command0(_user);
  }

  /// Comando para realizar logout
  late final Command0<void> logout;
  late final Command0<UserModel> user;

  /// Obtém o usuário atual
  Future<Result<UserModel>> _user() async {
    final result = await _authRepository.currentUser();
    return result;
  }

  /// Realiza logout do usuário
  Future<Result<void>> _logout() async {
    final result = await _authRepository.logout();
    notifyListeners();
    return result;
  }

  @override
  void dispose() {
    logout.dispose();
    super.dispose();
  }
}
