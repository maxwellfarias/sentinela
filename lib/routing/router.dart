import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:w3_diploma/data/repositories/auth/auth_repository.dart';
import 'package:w3_diploma/routing/routes.dart';
import 'package:w3_diploma/ui/core/componentes_reutilizaveis/sidebar/viewmodel/sidebar_viewmodel.dart';
import 'package:w3_diploma/ui/core/componentes_reutilizaveis/sidebar/widgets/sidebar.dart';

// import 'package:w3_diploma/ui/curso_screen/viewmodel/curso_viewmodel.dart';
// import 'package:w3_diploma/ui/curso_screen/widget/curso_screen.dart';
// import 'package:w3_diploma/ui/disciplina_screen/viewmodel/disciplina_viewmodel.dart';
// import 'package:w3_diploma/ui/disciplina_screen/widget/disciplina_screen.dart';

import 'package:w3_diploma/ui/core/componentes_reutilizaveis/resposive_layout.dart';

import 'package:w3_diploma/ui/login/widget/login_screen.dart';
import 'package:w3_diploma/ui/login/widget/viewmodel/login_viewmodel.dart';


final _rootNavigationKey = GlobalKey<NavigatorState>();
final _mainShellNavigatorKey = GlobalKey<NavigatorState>();
final _sideBarIndex = ValueNotifier<int>(8);

GoRouter router(AuthRepository authRepository) => GoRouter(
  navigatorKey: _rootNavigationKey,
    // initialLocation: Routes.gerarXmlDocumentacaoAcademica,
    initialLocation: Routes.home,
  debugLogDiagnostics: true,
  redirect: (context, state) async {
    final loggedIn = await authRepository.isAuthenticated;
    final loggingIn = state.matchedLocation == Routes.login;

    // Se não estiver autenticado e não estiver na tela de login, redireciona para login
    if (!loggedIn && !loggingIn) {
      return Routes.login;
    }

    // Se estiver autenticado e na tela de login, redireciona para a tela de alunos
    if (loggedIn && loggingIn) {
      return Routes.aluno;
    }

    // Permite acesso a outras rotas
    return null;
  },
  refreshListenable: authRepository,
  errorBuilder: (_, _) => Center(child: SelectableText("Erro 404")),
  routes: [
    ShellRoute(
      navigatorKey: _mainShellNavigatorKey,
      pageBuilder: (context, state, child) {
        final sidebarViewModel = SidebarViewModel(
          // authRepository: context.read(),
        );
        return MaterialPage(child: LayoutResponsivo(
        sidebar: Sidebar(sideBarIndex: _sideBarIndex, viewModel: sidebarViewModel),
        child: child));
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => Center(child: Text("My home")),
        ),


      ],
    ),
    // GoRoute(
    //   path: Routes.login,
    //   builder: (context, state) => LoginScreen(viewModel: context.read())
    // ),
    // GoRoute(
    //   path: Routes.signup,
    //   builder:
    //       (context, state) => Scaffold(
    //         appBar: AppBar(title: SelectableText("signup")),
    //         body: Center(child: SelectableText("My signup")),
    //       ),
    // ), 

    GoRoute(
      path: Routes.login,
      builder: (context, state) => LoginScreen(
        viewModel: LoginViewmodel(authRepository: context.read()),
      ),
    ),
  ],
);

