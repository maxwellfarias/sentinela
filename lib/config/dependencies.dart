import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/data/repositories/auth/auth_repository_impl.dart';
import 'package:sentinela/data/services/api/auth_api_client/auth_api_client.dart';
import 'package:sentinela/data/services/api/auth_api_client/auth_api_client_impl.dart';
import 'package:sentinela/data/services/logger/app_logger.dart';
import 'package:sentinela/data/services/logger/app_logger_impl.dart';

List<SingleChildWidget> get providers {
  final urlBaseAuthClient = 'https://fkwbaagyzxafgaphidfb.supabase.co/auth/v1/'; 
  final urlBaseClient = ''; // Defina a URL base para o AuthApiClient aqui


  return [
    // Core providers - Dio com interceptor de autenticação
   Provider(create:  (_) => Dio()), 
   Provider(create: (_) => AppLoggerImpl() as AppLogger),
    
    // API Clients
   Provider(create: (context) => AuthApiClientImpl(url: urlBaseAuthClient, dio: context.read(), logger: context.read())),

   //Repositories
   Provider(create: (context) => AuthRepositoryImpl(authApiClient: context.read(), logger: context.read()) as AuthRepository),
  ];
}
