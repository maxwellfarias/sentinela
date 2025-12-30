import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sentinela/data/datasources/auth/auth_remote_data_source.dart';
import 'package:sentinela/data/datasources/auth/auth_remote_data_source_impl.dart';
import 'package:sentinela/data/datasources/interceptor/dio_interceptor.dart';
import 'package:sentinela/data/datasources/logger/app_logger.dart';
import 'package:sentinela/data/datasources/logger/app_logger_impl.dart';
import 'package:sentinela/data/datasources/secure_storage/secure_storage_service.dart';
import 'package:sentinela/data/repositories/auth/auth_repository.dart';
import 'package:sentinela/data/repositories/auth/auth_repository_impl.dart';
import 'package:sentinela/utils/network/connection_checker.dart';
import 'package:sentinela/utils/network/connection_checker_impl.dart';
import 'package:supabase/supabase.dart';

List<SingleChildWidget> get providers {
  final urlBaseAuth = 'https://dqsbpsifdyujbbvbzjdq.supabase.co/auth/v1/';
  final urlBase = 'https://dqsbpsifdyujbbvbzjdq.supabase.co/rest/v1/';
  final supabseUrl = 'https://fkwbaagyzxafgaphidfb.supabase.co';
  final supabaseKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

  return [
    Provider(create: (context) => AppLoggerImpl() as AppLogger),
    Provider(create: (_) => FlutterSecureStorage()),
    Provider(create: (_)=> SupabaseClient(supabseUrl, supabaseKey)),
    Provider(create: (_) => InternetConnection()),
    Provider<ConnectionChecker>(create: (context)=> ConnectionCheckerImpl(context.read())),

    Provider<AuthRemoteDataSource>(create: (context) => AuthRemoteDataSourceImpl(supabaseClient: context.read(), logger: context.read())),
    //Repositories
    ChangeNotifierProvider<AuthRepository>(create: (context) => AuthRepositoryImpl(context.read(), context.read())),


    ChangeNotifierProvider<SecureStorageService>(create: (context) => SecureStorageServiceImpl(secureStorage: context.read()) as SecureStorageService),
    Provider(
      create: (context) {
        final dio = Dio();
        final authInterceptor = AuthInterceptor(
          storageService: context.read(),
          dio: dio,
          logger: context.read(),
          authRepository: context.read(),
          urlRefresh: '${urlBaseAuth}token?grant_type=refresh_token',
          apiKey: supabaseKey,
        );
        dio.interceptors.add(authInterceptor);

        return dio;
      },
    ),

    // API Clients
   
  ];
}
