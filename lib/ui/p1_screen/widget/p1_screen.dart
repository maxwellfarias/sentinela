import 'package:flutter/material.dart';

final class P1Screen extends StatefulWidget {

  const P1Screen({Key? key}) : super(key: key);

  @override
  State<P1Screen> createState() => _P1ScreenState();
}

class _P1ScreenState extends State<P1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P1 Screen'),
      ),
      body: Center(
        child: Text('Welcome to P1 Screen!'),
      ),
    );
  }
}