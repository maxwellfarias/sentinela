import 'package:flutter/material.dart';

class MobileScaffold extends StatefulWidget {
  final Widget child;
  final Widget sidebar;
  const MobileScaffold({super.key, required this.child, required this.sidebar});

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  int indexAtualSidebar = 0;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
      ),
      drawer: Drawer(
        child: widget.sidebar,
      ),
      body: SafeArea(
        child: Center(child: widget.child),
      ),
    );
  }
}
