import 'package:flutter/widgets.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/domain/models/aluno/user_model.dart';
import 'package:sentinela/utils/command.dart';
import 'package:sentinela/utils/result.dart';


final class SidebarViewModel extends ChangeNotifier {
  // final AuthRepository _authRepository;

  SidebarViewModel()
      {
    logout = Command0(_logout);
  }

  /// Comando para realizar logout
  late final Command0<void> logout;

  /// Obtém o usuário atual
  Future<UserModel> get user async => UserModel(aud: '', id: '', role: '', email: '', phone: '', isAnonymous: true);

  /// Realiza logout do usuário
  Future<Result<void>> _logout() async {
    final result = UserModel(aud: '', id: '', role: '', email: '', phone: '', isAnonymous: true);
    notifyListeners();
    return Result.ok(null);
  }

  @override
  void dispose() {
    logout.dispose();
    super.dispose();
  }
}
