import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentinela/config/dependencies.dart';
import 'package:sentinela/routing/router.dart';
import 'package:sentinela/ui/core/themes/theme.dart';

Future<void> main() async {
  // Carrega variáveis de ambiente
  await dotenv.load(fileName: '.env');

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sentinel Shield',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router( authRepository: context.read()),
    );
  }
}
