import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/componentes_reutilizaveis/sidebar/widgets/sidebar.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';

class DesktopScaffold extends StatefulWidget {
  final Widget child;
  final Widget sidebar;
  const DesktopScaffold({super.key, required this.child, required this.sidebar});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorTheme.bgBrand,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            widget.sidebar,
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}