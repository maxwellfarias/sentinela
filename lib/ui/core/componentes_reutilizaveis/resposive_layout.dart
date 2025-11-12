import 'package:flutter/material.dart';
import 'package:w3_diploma/ui/core/componentes_reutilizaveis/desktop_scarffold.dart';
import 'package:w3_diploma/ui/core/componentes_reutilizaveis/mobile_scaffold.dart';

class LayoutResponsivo extends StatelessWidget {
  final Widget child;
  final Widget sidebar;

  const LayoutResponsivo({
    super.key,
    required this.child,
    required this.sidebar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth < 1024) {
          return MobileScaffold(sidebar: sidebar, child: child);
        } else {
          return DesktopScaffold(sidebar: sidebar, child: child);
        }
      },
    );
  }
}
