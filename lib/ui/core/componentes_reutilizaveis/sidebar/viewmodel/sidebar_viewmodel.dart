import 'package:flutter/widgets.dart';
import 'package:w3_diploma/data/repositories/auth/auth_repository.dart';
import 'package:w3_diploma/domain/models/auth/user_model.dart';
import 'package:w3_diploma/utils/command.dart';
import 'package:w3_diploma/utils/result.dart';

final class SidebarViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  SidebarViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository {
    logout = Command0(_logout);
  }

  /// Comando para realizar logout
  late final Command0<void> logout;

  /// Obtém o usuário atual
  UserModel? get user => _authRepository.currentUser;

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
