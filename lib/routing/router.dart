import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinela/routing/routes.dart';
import 'package:sentinela/ui/core/componentes_reutilizaveis/resposive_layout.dart';
import 'package:sentinela/ui/core/componentes_reutilizaveis/sidebar/viewmodel/sidebar_viewmodel.dart';
import 'package:sentinela/ui/core/componentes_reutilizaveis/sidebar/widgets/sidebar.dart';
import 'package:sentinela/ui/kabam/widget/kabam.dart';
import 'package:sentinela/ui/login/widget/login_screen.dart';
import 'package:sentinela/ui/login/widget/viewmodel/login_viewmodel.dart';
import 'package:sentinela/ui/p1_screen/widget/p1_screen.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>();
final _mainShellNavigatorKey = GlobalKey<NavigatorState>();
final _sideBarIndex = ValueNotifier<int>(8);

GoRouter router() => GoRouter(
  navigatorKey: _rootNavigationKey,
  // initialLocation: Routes.gerarXmlDocumentacaoAcademica,
  initialLocation: Routes.login,
  debugLogDiagnostics: true,
  redirect: (context, state) async {
    // final loggedIn = await authRepository.isAuthenticated();
    // final loggingIn = state.matchedLocation == Routes.login;

    // // Se não estiver autenticado e não estiver na tela de login, redireciona para login
    // if (!loggedIn && !loggingIn) {
    //   return Routes.login;
    // }

    // // Se estiver autenticado e na tela de login, redireciona para a tela de alunos
    // if (loggedIn && loggingIn) {
    //   return Routes.p1;
    // }
    // Permite acesso a outras rotas
    return null;
  },
  // refreshListenable: authRepository,
  errorBuilder: (_, _) => Center(child: SelectableText("Erro 404")),
  routes: [
    ShellRoute(
      navigatorKey: _mainShellNavigatorKey,
      pageBuilder: (context, state, child) {
        final sidebarViewModel = SidebarViewModel(
          // authRepository: context.read(),
        );
        return MaterialPage(
          child: LayoutResponsivo(
            sidebar: Sidebar(
              sideBarIndex: _sideBarIndex,
              viewModel: sidebarViewModel,
            ),
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(path: Routes.p1, builder: (context, state) => P1Screen()),
        GoRoute(path: Routes.kabam, builder: (context, state) => Kabam()),
      ],
    ),

    GoRoute(
      path: Routes.login,
      builder: (context, state) => LoginScreen(viewModel: LoginViewmodel()),
    ),
  ],
);
