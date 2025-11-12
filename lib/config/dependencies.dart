import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:w3_diploma/data/repositories/aluno/aluno_repository.dart';
import 'package:w3_diploma/data/repositories/aluno/aluno_repository_impl.dart';
import 'package:w3_diploma/data/repositories/atividade_complementar/atividade_complementar_repository.dart';
import 'package:w3_diploma/data/repositories/atividade_complementar/atividade_complementar_repository_impl.dart';
import 'package:w3_diploma/data/repositories/auth/auth_repository.dart';
import 'package:w3_diploma/data/repositories/auth/auth_repository_impl.dart';
import 'package:w3_diploma/data/repositories/consolidated_data/consolidated_data_repository.dart';
import 'package:w3_diploma/data/repositories/consolidated_data/consolidated_data_repository_impl.dart';
import 'package:w3_diploma/data/repositories/curso/curso_repository.dart';
import 'package:w3_diploma/data/repositories/curso/curso_repository_impl.dart';
// import 'package:w3_diploma/data/repositories/disciplina/disciplina_repository.dart';
// import 'package:w3_diploma/data/repositories/disciplina/disciplina_repository_impl.dart';
import 'package:w3_diploma/data/repositories/disciplina_historico/disciplina_historico_repository.dart';
import 'package:w3_diploma/data/repositories/disciplina_historico/disciplina_historico_repository_impl.dart';
import 'package:w3_diploma/data/repositories/docente/docente_repository.dart';
import 'package:w3_diploma/data/repositories/docente/docente_repository_impl.dart';
import 'package:w3_diploma/data/repositories/documentoBase64/documento_base64_repository.dart';
import 'package:w3_diploma/data/repositories/documentoBase64/documento_base64_repository_impl.dart';
import 'package:w3_diploma/data/repositories/endereco/endereco_repository.dart';
import 'package:w3_diploma/data/repositories/endereco/endereco_repository_impl.dart';
import 'package:w3_diploma/data/repositories/ies_emissora/ies_emissora_repository.dart';
import 'package:w3_diploma/data/repositories/ies_emissora/ies_emissora_repository_impl.dart';
import 'package:w3_diploma/data/repositories/ies_registradora/ies_registradora_repository.dart';
import 'package:w3_diploma/data/repositories/ies_registradora/ies_registradora_repository_impl.dart';
import 'package:w3_diploma/data/repositories/registro_diploma/registro_diploma_repository.dart';
import 'package:w3_diploma/data/repositories/registro_diploma/registro_diploma_repository_impl.dart';
import 'package:w3_diploma/data/repositories/turma/turma_repository.dart';
import 'package:w3_diploma/data/repositories/turma/turma_repository_impl.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client_impl.dart';
import 'package:w3_diploma/data/services/auth_service/auth_api_client.dart';
import 'package:w3_diploma/data/services/auth_service/auth_api_client_impl.dart';
import 'package:w3_diploma/data/services/auth_service/auth_interceptor.dart';
import 'package:w3_diploma/data/services/auth_service/secure_storage_service.dart';
import 'package:w3_diploma/domain/usecases/gerar_xml_academico/gerar_xml_academico_usecase.dart';
import 'package:w3_diploma/domain/usecases/gerar_xml_academico/gerar_xml_academico_usecase_impl.dart';

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
    Provider(create: (context) => AlunoRepositoryImpl(apiClient: context.read()) as AlunoRepository),
    Provider(create: (context) => AtividadeComplementarRepositoryImpl(apiClient: context.read()) as AtividadeComplementarRepository),
    Provider(create: (context) => CursoRepositoryImpl(apiClient: context.read()) as CursoRepository),
    Provider(create: (context) => TurmaRepositoryImpl(apiClient: context.read()) as TurmaRepository),
    Provider(create: (context) => IesEmissoraRepositoryImpl(apiClient: context.read()) as IesEmissoraRepository),
    Provider(create: (context) => IESRegistradoraRepositoryImpl(apiClient: context.read()) as IESRegistradoraRepository),
    Provider(create: (context) => EnderecoRepositoryImpl(apiClient: context.read()) as EnderecoRepository),
    // Provider(create: (context) => DisciplinaRepositoryImpl(apiClient: context.read()) as DisciplinaRepository),
    Provider(create: (context) => DisciplinaHistoricoRepositoryImpl(apiClient: context.read()) as DisciplinaHistoricoRepository),
    Provider(create: (context) => DocenteRepositoryImpl(apiClient: context.read()) as DocenteRepository),
    Provider(create: (context) => DocumentoBase64RepositoryImpl(apiClient: context.read()) as DocumentoBase64Repository),
    Provider(create: (context) => RegistroDiplomaRepositoryImpl(apiClient: context.read()) as RegistroDiplomaRepository),
    Provider(create: (context) => ConsolidatedDataRepositoryImpl(apiClient: context.read()) as ConsolidatedDataRepository),

    // UseCase providers
    // Provider(create: (context) => GerarXmlAcademicoUseCaseImpl() as GerarXmlAcademicoUseCase)
  ];
}
