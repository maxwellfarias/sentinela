import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/data/repositories/auth/auth_repository_impl.dart';
import 'package:sentinela/data/services/api/auth_api_client/auth_api_client.dart';
import 'package:sentinela/data/services/api/auth_api_client/auth_api_client_impl.dart';
import 'package:sentinela/data/services/auth/interceptor/dio_interceptor.dart';
import 'package:sentinela/data/services/logger/app_logger.dart';
import 'package:sentinela/data/services/logger/app_logger_impl.dart';
import 'package:sentinela/data/services/secure_storage/secure_storage_service.dart';

List<SingleChildWidget> get providers {
  final urlBaseAuthClient = 'https://fkwbaagyzxafgaphidfb.supabase.co/auth/v1/';
  final urlBaseClient = ''; // Defina a URL base para o AuthApiClient aqui

  return [
    Provider(create: (_) => FlutterSecureStorage() ),
    Provider(create: (context) => SecureStorageServiceImpl(secureStorage: context.read()) as SecureStorageService),
    // Core providers - Dio com interceptor de autenticação
    Provider(
      create: (context) {
        final dio = Dio();
        final authInterceptor = AuthInterceptor(
          storageService: context.read(),
          dio: dio,
          logger: context.read(),
        );
        dio.interceptors.add(authInterceptor);

        return dio;
      },
    ),
    Provider(create: (_) => AppLoggerImpl() as AppLogger),

    // API Clients
    Provider(
      create: (context) =>
          AuthApiClientImpl(
                url: urlBaseAuthClient,
                dio: context.read(),
                logger: context.read(),
              )
              as AuthApiClient,
    ),

    //Repositories
    Provider(
      create: (context) =>
          AuthRepositoryImpl(
                authApiClient: context.read(),
                logger: context.read(),
              )
              as AuthRepository,
    ),
  ];
}
