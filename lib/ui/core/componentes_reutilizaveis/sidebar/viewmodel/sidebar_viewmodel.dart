import 'package:flutter/widgets.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/domain/models/aluno/user_model.dart';
import 'package:sentinela/utils/command.dart';
import 'package:sentinela/utils/result.dart';


final class SidebarViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  SidebarViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository {
    logout = Command0(_logout);
  }

  /// Comando para realizar logout
  late final Command0<void> logout;

  /// Obtém o usuário atual
  Future<Result<UserModel>> get user async => await _authRepository.currentUser();

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
