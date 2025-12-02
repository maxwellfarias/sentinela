import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentinela/routing/routes.dart';
import 'package:sentinela/ui/core/componentes_reutilizaveis/sidebar/viewmodel/sidebar_viewmodel.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/colors.dart';


final myDefaultBackground = Colors.grey[300];

class Sidebar extends StatefulWidget {
  final ValueNotifier<int> sideBarIndex;
  final SidebarViewModel viewModel;
  const Sidebar({
    super.key,
    required this.sideBarIndex,
    required this.viewModel,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  /// Manipula o logout do usuário
  Future<void> _handleLogout(BuildContext context) async {
    // Captura o messenger e navigator antes do async gap
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final colorTheme = context.customColorTheme;

    await widget.viewModel.logout.execute();

    if (!mounted) return;

    // Verifica se houve erro no logout
    if (widget.viewModel.logout.error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao fazer logout: ${widget.viewModel.logout.errorMessage ?? 'Erro desconhecido'}',
          ),
          backgroundColor: colorTheme.destructive,
        ),
      );
    } else if (widget.viewModel.logout.completed) {
      // Logout bem-sucedido - navega para tela de login
      router.go(Routes.login);

      messenger.showSnackBar(
        SnackBar(
          content: Text('Logout realizado com sucesso'),
          backgroundColor: colorTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.sideBarIndex,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: context.customColorTheme.sidebarBackground,
            border: Border(
              right: BorderSide(
                color: context.customColorTheme.accent,
                width: 1,
              ),
            ),
          ),
          //width deve ser temporario
          width: 296,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 60,
                ),
                child: Text(
                  "Sentinela",
                  style: context.customTextTheme.textLgSemibold,
                ),
              ),
              HoverableListTile(
                title: 'P1',
                indexGlobalSideBar: widget.sideBarIndex,
                itemId: 0,
                rotaParaNavegacao: Routes.p1,
              ),
              // CustomExpansionTile(
              //   title: 'Geral',
              //   children: [
              //     HoverableListTile(
              //       title: 'Alunos',
              //       indexGlobalSideBar: widget.sideBarIndex,
              //       itemId: 0,
              //       rotaParaNavegacao: Routes.aluno,
              //     ),
              //   ],
              // ),
              Spacer(),
              // ValueListenableBuilder(
              //   valueListenable: widget.viewModel.user,
              //   builder: (context, user, child) {
              //     if (user == null) return SizedBox.shrink();
              //     return Container(
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //           color: context.customColorTheme.borderSecondary,
              //           width: 1,
              //         ),
              //         borderRadius: BorderRadius.circular(AppRadius.radiusXL),
              //       ),
              //       padding: EdgeInsets.all(12),
              //       child: Row(
              //         spacing: 8,
              //         children: [
              //           Container(
              //             padding: EdgeInsets.all(8),
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: context.customColorTheme.bgOverlay,
              //             ),
              //             child: Text(
              //               _criarAbreviacaoNome(widget.viewModel.user.value?.nome ?? 'Usuário Desconhecido'),
              //               style: context.customTextTheme.textSmSemibold.copyWith(color: Colors.white),
              //             ),
              //           ),
              //           Flexible(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   widget.viewModel.user.value?.nome ?? 'Usuário Desconhecido',
              //                   style: context.customTextTheme.textSmSemibold,
              //                 ),
              //                 Text(
              //                   widget.viewModel.user.value?.email ?? 'Email Desconhecido',
              //                   style: context.customTextTheme.textSm.copyWith(
              //                     color: context.customColorTheme.textTertiary,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // ),
              // SizedBox(height: 8),
              ListenableBuilder(
                listenable: widget.viewModel.logout,
                builder: (context, child) {
                  return TextButton(
                    onPressed: widget.viewModel.logout.running
                        ? null
                        : () => _handleLogout(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: context.customColorTheme.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          if (widget.viewModel.logout.running)
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  context.customColorTheme.accent,
                                ),
                              ),
                            )
                          else
                            Icon(
                              Icons.logout,
                              color:
                                  context.customColorTheme.secondaryForeground,
                            ),
                          Text(
                            widget.viewModel.logout.running
                                ? 'Saindo...'
                                : 'Sair',
                            style: context.customTextTheme.textSmSemibold
                                .copyWith(
                                  color: context
                                      .customColorTheme
                                      .secondaryForeground,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 14),
            ],
          ),
        );
      },
    );
  }

  String _criarAbreviacaoNome(String nomeCompleto) {
    final nomes = nomeCompleto.split(' ');
    //Se o nome tiver menos de 2 partes, retorna as duas primeiras letras maiúsculas
    if (nomes.length < 2) return nomeCompleto.substring(0, 2).toUpperCase();
    //Retorna a primeira letra do primeiro e do último nome em maiúsculo
    return '${nomes[0][0].toUpperCase()}${nomes[1][0].toUpperCase()}';
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<HoverableListTile> children;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Color _textColor; // Cor padrão
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    //cria o controlador de animação
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    //Cria a animação de expansão
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textColor = context.customColorTheme.accent;
  }

  //Função para alternar a expansão e disparar a animação
  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          onEnter: (event) => setState(
            () => _textColor = AppColors.primaryDark,
          ), // Cor ao passar o mouse
          onExit: (event) => setState(
            () => _textColor = context.customColorTheme.accent,
          ), // Volta à cor padrão
          child: InkWell(
            onTap: _toggleExpansion,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.folder,
                  color: context.customColorTheme.accent,
                  size: 20,
                ),
                SizedBox(width: 10), // Espaçamento entre o ícone e o texto
                Expanded(
                  child: Text(
                    widget.title,
                    style: context.customTextTheme.textSmSemibold.copyWith(
                      color: _textColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.remove : Icons.add,
                    color: context.customColorTheme.accent,
                    size: 20,
                  ),
                  onPressed: _toggleExpansion,
                ),
              ],
            ),
          ),
        ),
        //Cria um widget que faz a animação de expansão
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: 1, // Alinha a expansão para baixo
          child: Stack(
            children: [
              Column(
                spacing: 2,
                children: widget.children.map((child) {
                  return child;
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HoverableListTile extends StatefulWidget {
  final ValueNotifier<int> indexGlobalSideBar;
  final int itemId;
  final String title;
  final String rotaParaNavegacao;

  /// O itemId é usado para identificar o item na barra lateral, ele precisa ter um número único
  /// para que o estado de seleção funcione corretamente.
  const HoverableListTile({
    super.key,
    required this.indexGlobalSideBar,
    required this.itemId,
    required this.title,
    required this.rotaParaNavegacao,
  });

  @override
  State<HoverableListTile> createState() => _HoverableListTileState();
}

class _HoverableListTileState extends State<HoverableListTile> {
  bool get isSelected {
    return widget.indexGlobalSideBar.value == widget.itemId;
  }

  bool _isHovering = false;
  Color _backgroundColor = Colors.transparent; // Cor padrão

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        _isHovering = true;
        _backgroundColor =
            context.customColorTheme.accent; // Cor ao passar o mouse
      }),
      onExit: (event) => setState(() {
        _isHovering = false;
        _backgroundColor = Colors.transparent; // Volta à cor padrão
      }),
      child: GestureDetector(
        onTap: () {
          context.go(widget.rotaParaNavegacao);
          Scaffold.of(context).closeDrawer();
          widget.indexGlobalSideBar.value = widget.itemId;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected
                ? context.customColorTheme.accent
                : _backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 28),
            width: double.infinity,
            child: Text(
              widget.title,
              style: context.customTextTheme.textSmMedium.copyWith(
                color: (_isHovering || isSelected)
                    ? AppColors.primaryDark
                    : context.customColorTheme.sidebarForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
