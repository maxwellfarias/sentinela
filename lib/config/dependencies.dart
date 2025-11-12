import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:w3_diploma/data/repositories/auth/auth_repository.dart';
import 'package:w3_diploma/data/repositories/auth/auth_repository_impl.dart';

import 'package:w3_diploma/data/repositories/endereco/endereco_repository.dart';
import 'package:w3_diploma/data/repositories/endereco/endereco_repository_impl.dart';

import 'package:w3_diploma/data/repositories/ies_registradora/ies_registradora_repository.dart';
import 'package:w3_diploma/data/repositories/ies_registradora/ies_registradora_repository_impl.dart';

import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client_impl.dart';
import 'package:w3_diploma/data/services/auth_service/auth_api_client.dart';
import 'package:w3_diploma/data/services/auth_service/auth_api_client_impl.dart';
import 'package:w3_diploma/data/services/auth_service/auth_interceptor.dart';
import 'package:w3_diploma/data/services/auth_service/secure_storage_service.dart';

List<SingleChildWidget> get providers {
  return [
    // Core providers - Dio com interceptor de autenticação
    Provider(create: (context) {
      final dio = Dio();
      final secureStorage = const FlutterSecureStorage();
      final storageService = SecureStorageService(secureStorage: secureStorage);

      // Adiciona o interceptor de autenticação ao Dio
      // Este interceptor irá:
      // 1. Adicionar o Bearer token automaticamente em todas as requisições
      // 2. Renovar o token automaticamente quando estiver próximo de expirar
      // 3. Tentar renovar o token em caso de erro 401 e refazer a requisição
      final authInterceptor = AuthInterceptor(
        storageService: storageService,
        dio: dio,
      );
      dio.interceptors.add(authInterceptor);

      return dio;
    }),
    Provider(create: (context) => const FlutterSecureStorage()),

    // Auth Service providers
    Provider(create: (context) => SecureStorageService(secureStorage: context.read())),
    Provider(create: (context) => AuthApiClientImpl(dio: context.read()) as AuthApiClient),

    // Auth Repository (ChangeNotifierProvider para notificar mudanças de autenticação)
    ChangeNotifierProvider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(
        authApiClient: context.read(),
secureStorageService: context.read(),
      ),
    ),

    // ApiClient providers
    Provider(create: (context) => ApiClientImpl(context.read(), context.read()) as ApiClient),

    // Repository providers
    ListenableProvider(
      create: (context) =>
          AuthRepositoryImpl(
                authApiClient: context.read(),
                secureStorageService: context.read(),
              )
              as AuthRepository,
    ),
    Provider(create: (context) => IESRegistradoraRepositoryImpl(apiClient: context.read()) as IESRegistradoraRepository),
    Provider(create: (context) => EnderecoRepositoryImpl(apiClient: context.read()) as EnderecoRepository),
    // UseCase providers
    // Provider(create: (context) => GerarXmlAcademicoUseCaseImpl() as GerarXmlAcademicoUseCase)
  ];
}
