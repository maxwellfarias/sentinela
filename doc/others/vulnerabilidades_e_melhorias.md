# 🔒 Análise de Vulnerabilidades e Melhorias - Palliative Care Mobile

> **Documento de Referência**: `react_to_flutter.md`
> **Data de Análise**: 2025-10-29
> **Objetivo**: Identificar vulnerabilidades de segurança, problemas arquiteturais e pontos de melhoria no projeto

---

## 📑 Índice

1. [Vulnerabilidades Críticas](#-vulnerabilidades-críticas)
2. [Problemas Arquiteturais](#️-problemas-arquiteturais)
3. [Problemas de Código](#-problemas-de-código)
4. [Problemas de UX/UI](#-problemas-de-uxui)
5. [Falta de Observabilidade](#-falta-de-observabilidade)
6. [Falta de Testabilidade](#-falta-de-testabilidade)
7. [Checklist de Melhorias Prioritárias](#-checklist-de-melhorias-prioritárias)
8. [Recomendações Finais](#-recomendações-finais)

---

## 🚨 VULNERABILIDADES CRÍTICAS

### 1. Segurança de Dados Sensíveis

**Problema**: Não há menção a criptografia ou proteção de dados sensíveis
- ❌ Nenhuma validação de entrada nos métodos `fromJson`
- ❌ Dados médicos (sinais vitais, medicamentos) trafegam sem menção a criptografia
- ❌ Não há sanitização de dados antes de enviar para API
- ❌ Possível injeção de dados maliciosos via JSON

**Impacto**:
- Dados sensíveis de saúde podem ser comprometidos
- Violação da LGPD/HIPAA
- Vulnerabilidade a ataques de injeção

**Recomendação**:

```dart
// lib/core/utils/json_validator.dart
class JsonValidator {
  static String validateString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is! String) throw FormatException('Expected String, got ${value.runtimeType}');
    return value.trim();
  }

  static int validateInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    throw FormatException('Expected int, got ${value.runtimeType}');
  }

  static String sanitizeString(String input) {
    // Remove caracteres perigosos
    return input
        .replaceAll(RegExp(r'[<>"\']'), '')
        .trim();
  }
}

// Aplicar no Model
factory TaskModel.fromJson(dynamic json) {
  if (json == null || json is! Map<String, dynamic>) {
    throw FormatException('Invalid JSON format for TaskModel');
  }

  try {
    return TaskModel(
      id: JsonValidator.validateString(json['id']),
      title: JsonValidator.sanitizeString(
        JsonValidator.validateString(json['title'])
      ),
      description: JsonValidator.sanitizeString(
        JsonValidator.validateString(json['description'])
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  } catch (e, s) {
    throw FormatException('Failed to parse TaskModel: $e');
  }
}
```

**Adicionar Criptografia para Dados Sensíveis**:

```dart
// lib/core/security/encryption_service.dart
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyName = 'encryption_key';

  late final Encrypter _encrypter;
  late final IV _iv;

  Future<void> initialize() async {
    String? keyString = await _storage.read(key: _keyName);

    if (keyString == null) {
      final key = Key.fromSecureRandom(32);
      keyString = key.base64;
      await _storage.write(key: _keyName, value: keyString);
    }

    final key = Key.fromBase64(keyString);
    _encrypter = Encrypter(AES(key));
    _iv = IV.fromSecureRandom(16);
  }

  String encrypt(String plainText) {
    return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  String decrypt(String encrypted) {
    return _encrypter.decrypt64(encrypted, iv: _iv);
  }
}

// Uso no Model de dados sensíveis
class VitalSignModel {
  final String id;
  final String patientId;
  final String _encryptedValue; // Dados criptografados

  // Getter descriptografa sob demanda
  String get value => _encryptionService.decrypt(_encryptedValue);

  factory VitalSignModel.fromJson(Map<String, dynamic> json) {
    return VitalSignModel(
      id: json['id'],
      patientId: json['patient_id'],
      _encryptedValue: json['value'], // Já vem criptografado do backend
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'value': _encryptedValue, // Envia criptografado
    };
  }
}
```

---

### 2. Exposição de URLs e Tokens

**Problema**: URL base hardcoded expõe endpoint Supabase

```dart
// ❌ ATUAL - Exposto no código
static const String baseUrl = 'https://hqvximqtoskulhfltzvr.supabase.co';
```

**Impacto**:
- URLs expostas em código-fonte versionado
- Facilita ataques direcionados
- Dificulta mudança de ambiente

**Recomendação**:

```dart
// 1. Criar arquivo .env (NÃO commitar - adicionar ao .gitignore)
// .env
SUPABASE_URL=https://hqvximqtoskulhfltzvr.supabase.co
SUPABASE_PUBLISHABLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
API_TIMEOUT_SECONDS=30
ENABLE_ANALYTICS=true

// 2. Adicionar ao pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0
  flutter_secure_storage: ^9.0.0

// 3. Carregar no main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

// 4. Criar classe de configuração segura
// lib/config/constants/app_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('SUPABASE_URL not configured');
    }
    return url;
  }

  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('SUPABASE_PUBLISHABLE_KEY not configured');
    }
    return key;
  }

  static Duration get apiTimeout {
    final seconds = int.tryParse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '30');
    return Duration(seconds: seconds ?? 30);
  }

  static bool get enableAnalytics {
    return dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
  }
}

// 5. Usar no código
class Urls {
  static String get baseUrl => AppConfig.supabaseUrl;
  // ...
}

// 6. Adicionar ao .gitignore
.env
.env.*
!.env.example

// 7. Criar template
// .env.example
SUPABASE_URL=your_supabase_url_here
SUPABASE_PUBLISHABLE_KEY=your_anon_key_here
API_TIMEOUT_SECONDS=30
ENABLE_ANALYTICS=false
```

**Implementar Certificate Pinning** (Proteção contra MITM):

```dart
// lib/core/network/certificate_pinning.dart
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class CertificatePinningInterceptor extends Interceptor {
  // SHA-256 fingerprint do certificado do servidor
  static const String _certificateFingerprint =
      'AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Configurar validação de certificado
    options.extra['security_context'] = _createSecurityContext();
    handler.next(options);
  }

  SecurityContext _createSecurityContext() {
    final context = SecurityContext(withTrustedRoots: false);
    // Adicionar certificado confiável
    // context.setTrustedCertificatesBytes(certBytes);
    return context;
  }
}

// Aplicar no Dio
final dio = Dio()
  ..interceptors.add(CertificatePinningInterceptor());
```

---

### 3. Ausência de Tratamento de Timeout

**Problema**: Não há configuração de timeout nas requisições
- ❌ Requisições podem travar indefinidamente
- ❌ Sem retry logic para falhas de rede
- ❌ Sem tratamento de conexão lenta

**Impacto**:
- App trava em conexões ruins
- Experiência ruim do usuário
- Consumo excessivo de bateria

**Recomendação**:

```dart
// lib/core/network/api_client.dart
class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio() {
    _dio.options = BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Adicionar interceptor de retry
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      maxRetries: 3,
      retryDelays: [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 4),
      ],
    ));
  }

  Future<Result<T>> request<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? data,
    Duration? timeout,
  }) async {
    try {
      final response = await _dio.request(
        endpoint,
        data: data,
        options: Options(
          method: method.name,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );

      return Result.ok(response.data as T);
    } on DioException catch (e) {
      return Result.error(_handleDioError(e));
    } catch (e) {
      return Result.error(UnknownErrorException(cause: e));
    }
  }
}

// lib/core/network/retry_interceptor.dart
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    List<Duration>? retryDelays,
  }) : retryDelays = retryDelays ?? [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
  ];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = err.requestOptions.extra['retry_attempt'] as int? ?? 0;

    // Só faz retry para erros de rede/timeout
    final shouldRetry = _shouldRetry(err) && attempt < maxRetries;

    if (!shouldRetry) {
      return handler.next(err);
    }

    AppLogger.warning(
      'Retrying request (attempt ${attempt + 1}/$maxRetries)',
      tag: 'RetryInterceptor',
    );

    await Future.delayed(retryDelays[attempt]);

    try {
      final options = err.requestOptions;
      options.extra['retry_attempt'] = attempt + 1;

      final response = await dio.fetch(options);
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        return onError(e, handler);
      }
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode ?? 0) >= 500;
  }
}
```

---

## ⚠️ PROBLEMAS ARQUITETURAIS

### 4. God Object na ViewModel

**Problema**: ViewModel acumula muitas responsabilidades
- ❌ Gerencia estado, lógica de negócio E comunicação com repository
- ❌ Violação do Single Responsibility Principle
- ❌ Dificulta testes e manutenção

**Recomendação - Implementar Clean Architecture**:

```dart
// ============================================
// DOMAIN LAYER - Regras de Negócio Puras
// ============================================

// lib/domain/entities/task.dart
class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  // Lógica de negócio no domínio
  bool get isCompleted => status == TaskStatus.completed;
  bool get isOverdue => !isCompleted && createdAt.isBefore(DateTime.now());

  Task markAsCompleted() {
    return Task(
      id: id,
      title: title,
      description: description,
      status: TaskStatus.completed,
      createdAt: createdAt,
    );
  }
}

// lib/domain/repositories/task_repository.dart
abstract interface class TaskRepository {
  Future<Result<List<Task>>> getAllTasks({required String databaseId});
  Future<Result<Task>> createTask({required Task task});
  Future<Result<Task>> updateTask({required Task task});
  Future<Result<void>> deleteTask({required String id});
}

// lib/domain/usecases/get_all_tasks_usecase.dart
class GetAllTasksUseCase {
  final TaskRepository _repository;

  GetAllTasksUseCase(this._repository);

  Future<Result<List<Task>>> execute({
    required String databaseId,
    TaskFilter? filter,
  }) async {
    final result = await _repository.getAllTasks(databaseId: databaseId);

    return result.when(
      ok: (tasks) {
        // Lógica de negócio: filtrar, ordenar
        var filteredTasks = tasks;

        if (filter?.showOnlyPending == true) {
          filteredTasks = tasks.where((t) => !t.isCompleted).toList();
        }

        if (filter?.sortBy == SortBy.date) {
          filteredTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }

        return Result.ok(filteredTasks);
      },
      error: (e) => Result.error(e),
    );
  }
}

// lib/domain/usecases/create_task_usecase.dart
class CreateTaskUseCase {
  final TaskRepository _repository;

  CreateTaskUseCase(this._repository);

  Future<Result<Task>> execute({
    required String title,
    required String description,
  }) async {
    // Validações de negócio
    if (title.trim().isEmpty) {
      return Result.error(
        ValidationException(message: 'Título não pode ser vazio'),
      );
    }

    if (title.length > 100) {
      return Result.error(
        ValidationException(message: 'Título deve ter no máximo 100 caracteres'),
      );
    }

    final task = Task(
      id: '', // Será gerado no backend
      title: title.trim(),
      description: description.trim(),
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    );

    return await _repository.createTask(task: task);
  }
}

// ============================================
// DATA LAYER - Implementações
// ============================================

// lib/data/models/task_model.dart
class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String createdAt;

  // Converter para entidade de domínio
  Task toDomain() {
    return Task(
      id: id,
      title: title,
      description: description,
      status: TaskStatus.values.firstWhere((e) => e.name == status),
      createdAt: DateTime.parse(createdAt),
    );
  }

  // Criar a partir de entidade de domínio
  factory TaskModel.fromDomain(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status.name,
      createdAt: task.createdAt.toIso8601String(),
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}

// lib/data/repositories/task_repository_impl.dart
class TaskRepositoryImpl implements TaskRepository {
  final ApiClient _apiClient;
  final TaskLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  TaskRepositoryImpl({
    required ApiClient apiClient,
    required TaskLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _apiClient = apiClient,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Result<List<Task>>> getAllTasks({
    required String databaseId,
  }) async {
    // Offline-first: tenta cache local primeiro
    if (!await _networkInfo.isConnected) {
      return _getTasksFromLocal(databaseId);
    }

    try {
      // Busca da API
      final result = await _apiClient.request<List<dynamic>>(
        endpoint: Urls.getAll(endpoint: Endpoint.task),
        method: HttpMethod.get,
      );

      return result.when(
        ok: (data) async {
          final models = data.map((json) => TaskModel.fromJson(json)).toList();
          final tasks = models.map((m) => m.toDomain()).toList();

          // Salva em cache
          await _localDataSource.saveTasks(tasks);

          return Result.ok(tasks);
        },
        error: (e) => Result.error(e),
      );
    } catch (e) {
      // Se falhar, retorna cache
      return _getTasksFromLocal(databaseId);
    }
  }

  Future<Result<List<Task>>> _getTasksFromLocal(String databaseId) async {
    try {
      final tasks = await _localDataSource.getTasks(databaseId);
      return Result.ok(tasks);
    } catch (e) {
      return Result.error(CacheException(cause: e));
    }
  }
}

// ============================================
// PRESENTATION LAYER - UI
// ============================================

// lib/presentation/viewmodels/task_viewmodel.dart
class TaskViewModel extends ChangeNotifier {
  final GetAllTasksUseCase _getAllTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  TaskViewModel({
    required GetAllTasksUseCase getAllTasksUseCase,
    required CreateTaskUseCase createTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
  }) : _getAllTasksUseCase = getAllTasksUseCase,
       _createTaskUseCase = createTaskUseCase,
       _updateTaskUseCase = updateTaskUseCase,
       _deleteTaskUseCase = deleteTaskUseCase;

  // ViewModel só coordena e gerencia estado
  late final getAllTasks = Command0(_getAllTasks);
  late final createTask = Command1<Task, Task>(_createTask);

  Future<Result<List<Task>>> _getAllTasks() async {
    return await _getAllTasksUseCase.execute(
      databaseId: 'default',
      filter: TaskFilter(showOnlyPending: true),
    );
  }

  Future<Result<Task>> _createTask(Task task) async {
    return await _createTaskUseCase.execute(
      title: task.title,
      description: task.description,
    );
  }
}
```

---

### 5. Falta de Camada de Domain/UseCases

**Problema**: Lógica de negócio misturada com infraestrutura
- ❌ ViewModel chama Repository diretamente
- ❌ Regras de negócio podem estar espalhadas
- ❌ Dificulta reuso de lógica

**Arquitetura Recomendada**:

```
lib/
├── core/                         # Funcionalidades compartilhadas
│   ├── error/                    # Exceções customizadas
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                  # Configurações de rede
│   │   ├── api_client.dart
│   │   ├── network_info.dart
│   │   └── retry_interceptor.dart
│   ├── security/                 # Segurança
│   │   ├── encryption_service.dart
│   │   └── certificate_pinning.dart
│   └── utils/                    # Utilitários
│       ├── logger.dart
│       └── json_validator.dart
│
├── domain/                       # Lógica de Negócio Pura
│   ├── entities/                 # Modelos de domínio (sem dependências)
│   │   ├── task.dart
│   │   ├── medication.dart
│   │   └── vital_sign.dart
│   ├── repositories/             # Contratos (interfaces)
│   │   ├── task_repository.dart
│   │   ├── medication_repository.dart
│   │   └── vital_sign_repository.dart
│   └── usecases/                 # Casos de uso (1 ação = 1 classe)
│       ├── task/
│       │   ├── get_all_tasks_usecase.dart
│       │   ├── create_task_usecase.dart
│       │   ├── update_task_usecase.dart
│       │   └── delete_task_usecase.dart
│       └── medication/
│           ├── get_medications_usecase.dart
│           └── add_medication_usecase.dart
│
├── data/                         # Implementações de Dados
│   ├── models/                   # DTOs (Data Transfer Objects)
│   │   ├── task_model.dart
│   │   ├── medication_model.dart
│   │   └── vital_sign_model.dart
│   ├── repositories/             # Implementações dos contratos
│   │   ├── task_repository_impl.dart
│   │   ├── medication_repository_impl.dart
│   │   └── vital_sign_repository_impl.dart
│   └── datasources/              # Fontes de dados
│       ├── remote/               # APIs externas
│       │   ├── task_remote_datasource.dart
│       │   └── supabase_client.dart
│       └── local/                # Banco de dados local
│           ├── task_local_datasource.dart
│           └── database_helper.dart
│
├── presentation/                 # Camada de UI
│   ├── viewmodels/               # ViewModels (gerenciam estado)
│   │   ├── task_viewmodel.dart
│   │   └── medication_viewmodel.dart
│   ├── screens/                  # Telas completas
│   │   ├── task/
│   │   │   ├── task_list_screen.dart
│   │   │   └── task_form_screen.dart
│   │   └── medication/
│   │       └── medication_screen.dart
│   └── widgets/                  # Widgets reutilizáveis
│       ├── task_card.dart
│       └── loading_indicator.dart
│
└── config/                       # Configurações
    ├── constants/
    │   ├── app_config.dart
    │   └── urls.dart
    ├── theme/
    │   └── app_theme.dart
    └── routes/
        └── app_routes.dart
```

**Benefícios**:
- ✅ Separação clara de responsabilidades
- ✅ Testabilidade (cada camada pode ser testada isoladamente)
- ✅ Independência de frameworks (domínio não conhece Flutter)
- ✅ Facilita manutenção e escalabilidade

---

### 6. Tight Coupling com Supabase

**Problema**: Arquitetura fortemente acoplada ao Supabase
- ❌ Se migrar para Firebase/AWS, precisa reescrever tudo
- ❌ `Endpoint` enum está vinculado a tabelas Supabase
- ❌ Dificulta testes com mock

**Recomendação - Abstrair DataSource**:

```dart
// lib/core/network/data_source.dart
abstract interface class DataSource {
  Future<Result<T>> get<T>(String path, {Map<String, dynamic>? queryParams});
  Future<Result<T>> post<T>(String path, Map<String, dynamic> data);
  Future<Result<T>> put<T>(String path, Map<String, dynamic> data);
  Future<Result<void>> delete(String path);

  // Métodos específicos para diferentes provedores
  Future<Result<List<T>>> query<T>({
    required String table,
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });
}

// lib/data/datasources/remote/supabase_datasource.dart
class SupabaseDataSource implements DataSource {
  final SupabaseClient _client;

  SupabaseDataSource(this._client);

  @override
  Future<Result<List<T>>> query<T>({
    required String table,
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      var query = _client.from(table).select();

      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      if (orderBy != null) {
        query = query.order(orderBy);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return Result.ok(response as T);
    } catch (e) {
      return Result.error(DataSourceException(cause: e));
    }
  }
}

// lib/data/datasources/remote/firebase_datasource.dart
class FirebaseDataSource implements DataSource {
  final FirebaseFirestore _firestore;

  FirebaseDataSource(this._firestore);

  @override
  Future<Result<List<T>>> query<T>({
    required String table,
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      var query = _firestore.collection(table);

      if (filters != null) {
        filters.forEach((key, value) {
          query = query.where(key, isEqualTo: value) as CollectionReference<Map<String, dynamic>>;
        });
      }

      if (orderBy != null) {
        query = query.orderBy(orderBy) as CollectionReference<Map<String, dynamic>>;
      }

      if (limit != null) {
        query = query.limit(limit) as CollectionReference<Map<String, dynamic>>;
      }

      final snapshot = await query.get();
      final data = snapshot.docs.map((doc) => doc.data()).toList();
      return Result.ok(data as T);
    } catch (e) {
      return Result.error(DataSourceException(cause: e));
    }
  }
}

// lib/data/repositories/task_repository_impl.dart
class TaskRepositoryImpl implements TaskRepository {
  final DataSource _remoteDataSource; // Abstração genérica
  final TaskLocalDataSource _localDataSource;

  TaskRepositoryImpl({
    required DataSource remoteDataSource,
    required TaskLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Result<List<Task>>> getAllTasks({
    required String databaseId,
  }) async {
    final result = await _remoteDataSource.query<List<dynamic>>(
      table: 'tasks', // Tabela genérica
      filters: {'database_id': databaseId},
      orderBy: 'created_at',
    );

    return result.when(
      ok: (data) {
        final tasks = data
            .map((json) => TaskModel.fromJson(json))
            .map((model) => model.toDomain())
            .toList();
        return Result.ok(tasks);
      },
      error: (e) => Result.error(e),
    );
  }
}

// lib/config/di/injection.dart
void configureDependencies() {
  // Pode trocar facilmente entre provedores
  final dataSource = _useSupabase
      ? SupabaseDataSource(supabaseClient)
      : FirebaseDataSource(firestore);

  getIt.registerSingleton<DataSource>(dataSource);

  getIt.registerFactory<TaskRepository>(
    () => TaskRepositoryImpl(
      remoteDataSource: getIt<DataSource>(),
      localDataSource: getIt<TaskLocalDataSource>(),
    ),
  );
}
```

---

## 🐛 PROBLEMAS DE CÓDIGO

### 7. Error Handling Genérico Demais

**Problema**: Todos os erros retornam `UnknownErrorException()`

```dart
catch (e, s) {
  AppLogger.error('Serializing tasks', error: e, stackTrace: s);
  return Result.error(UnknownErrorException()); // ❌ Perde contexto
}
```

**Impacto**:
- Mensagens de erro não informativas para o usuário
- Dificulta debugging
- Não permite tratamento específico

**Recomendação - Criar Hierarquia de Exceções**:

```dart
// lib/core/error/exceptions.dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic cause;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

// Exceções de rede
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

class TimeoutException extends NetworkException {
  const TimeoutException({
    super.message = 'A requisição excedeu o tempo limite',
    super.code = 'TIMEOUT',
    super.cause,
    super.stackTrace,
  });
}

class NoInternetException extends NetworkException {
  const NoInternetException({
    super.message = 'Sem conexão com a internet',
    super.code = 'NO_INTERNET',
    super.cause,
    super.stackTrace,
  });
}

class ServerException extends NetworkException {
  final int? statusCode;

  const ServerException({
    required super.message,
    this.statusCode,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

// Exceções de dados
class DataException extends AppException {
  const DataException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

class DataParsingException extends DataException {
  const DataParsingException({
    super.message = 'Erro ao processar dados',
    super.code = 'PARSING_ERROR',
    super.cause,
    super.stackTrace,
  });
}

class ValidationException extends DataException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code = 'VALIDATION_ERROR',
    super.cause,
    super.stackTrace,
  });
}

// Exceções de cache/banco local
class CacheException extends AppException {
  const CacheException({
    super.message = 'Erro ao acessar cache local',
    super.code = 'CACHE_ERROR',
    super.cause,
    super.stackTrace,
  });
}

// Exceções de autenticação
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException({
    super.message = 'Acesso não autorizado',
    super.code = 'UNAUTHORIZED',
    super.cause,
    super.stackTrace,
  });
}

// Exceção genérica (último recurso)
class UnknownErrorException extends AppException {
  const UnknownErrorException({
    super.message = 'Erro inesperado',
    super.code = 'UNKNOWN',
    super.cause,
    super.stackTrace,
  });
}

// lib/core/error/error_handler.dart
class ErrorHandler {
  static AppException handleError(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return error;
    }

    // DioException (requisições HTTP)
    if (error is DioException) {
      return _handleDioError(error);
    }

    // FormatException (parsing de JSON)
    if (error is FormatException) {
      return DataParsingException(
        message: 'Dados em formato inválido: ${error.message}',
        cause: error,
        stackTrace: stackTrace,
      );
    }

    // TypeError (problemas de tipo)
    if (error is TypeError) {
      return DataParsingException(
        message: 'Erro de tipo de dado: ${error}',
        cause: error,
        stackTrace: stackTrace,
      );
    }

    // SocketException (problemas de rede)
    if (error is SocketException) {
      return NoInternetException(
        cause: error,
        stackTrace: stackTrace,
      );
    }

    // Exceção genérica
    return UnknownErrorException(
      message: error.toString(),
      cause: error,
      stackTrace: stackTrace,
    );
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          cause: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.connectionError:
        return NoInternetException(
          cause: error,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        if (statusCode == 401) {
          return UnauthorizedException(
            cause: error,
            stackTrace: error.stackTrace,
          );
        }

        if (statusCode == 403) {
          return AuthException(
            message: 'Você não tem permissão para esta ação',
            code: 'FORBIDDEN',
            cause: error,
            stackTrace: error.stackTrace,
          );
        }

        if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: 'Erro no servidor. Tente novamente mais tarde.',
            statusCode: statusCode,
            cause: error,
            stackTrace: error.stackTrace,
          );
        }

        return ServerException(
          message: error.response?.data?['message'] ?? 'Erro na requisição',
          statusCode: statusCode,
          cause: error,
          stackTrace: error.stackTrace,
        );

      default:
        return NetworkException(
          message: 'Erro de rede desconhecido',
          cause: error,
          stackTrace: error.stackTrace,
        );
    }
  }

  // Converte exceção para mensagem amigável
  static String getUserMessage(AppException exception) {
    // Mensagens customizadas por tipo
    if (exception is NoInternetException) {
      return 'Verifique sua conexão com a internet e tente novamente';
    }

    if (exception is TimeoutException) {
      return 'A operação demorou muito. Tente novamente';
    }

    if (exception is UnauthorizedException) {
      return 'Sua sessão expirou. Faça login novamente';
    }

    if (exception is ValidationException) {
      return exception.message;
    }

    if (exception is ServerException) {
      if (exception.statusCode != null && exception.statusCode! >= 500) {
        return 'Erro no servidor. Tente novamente em alguns minutos';
      }
      return exception.message;
    }

    // Mensagem genérica
    return 'Ocorreu um erro. Tente novamente';
  }
}

// Usar no Repository
class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<Result<List<Task>>> getAllTasks({
    required String databaseId,
  }) async {
    try {
      final response = await _apiClient.request<List<dynamic>>(
        endpoint: Urls.getAll(endpoint: Endpoint.task),
        method: HttpMethod.get,
      );

      return response.when(
        ok: (data) {
          try {
            final tasks = data
                .map((json) => TaskModel.fromJson(json))
                .map((model) => model.toDomain())
                .toList();
            return Result.ok(tasks);
          } catch (e, s) {
            // Erro específico de parsing
            return Result.error(
              ErrorHandler.handleError(e, s),
            );
          }
        },
        error: (e) => Result.error(e),
      );
    } catch (e, s) {
      return Result.error(
        ErrorHandler.handleError(e, s),
      );
    }
  }
}

// Usar na UI
class TaskListScreen extends StatelessWidget {
  void _onError(AppException error) {
    final message = ErrorHandler.getUserMessage(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _getColorForError(error),
        action: _shouldShowRetry(error)
            ? SnackBarAction(
                label: 'Tentar novamente',
                onPressed: () => _retry(),
              )
            : null,
      ),
    );
  }

  Color _getColorForError(AppException error) {
    if (error is NoInternetException || error is TimeoutException) {
      return Colors.orange;
    }
    if (error is ValidationException) {
      return Colors.blue;
    }
    return Colors.red;
  }

  bool _shouldShowRetry(AppException error) {
    return error is NetworkException || error is ServerException;
  }
}
```

---

### 8. Listeners Não Removidos Corretamente

**Problema**: Listeners podem causar memory leaks

```dart
void dispose() {
  // ❌ Cria nova função anônima, não remove a original
  widget.viewModel.updateTask.removeListener(() => _onResult(...));
}
```

**Impacto**:
- Memory leaks
- Callbacks executados após dispose
- Crashes inesperados

**Recomendação**:

```dart
// ❌ ERRADO - Cria nova função a cada vez
class TaskFormScreen extends StatefulWidget {
  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  @override
  void initState() {
    super.initState();
    // Cada chamada cria uma NOVA função anônima
    widget.viewModel.updateTask.addListener(() => _onResult());
  }

  @override
  void dispose() {
    // Esta é uma NOVA função, não remove a anterior
    widget.viewModel.updateTask.removeListener(() => _onResult()); // ❌
    super.dispose();
  }
}

// ✅ CORRETO - Armazena referência da função
class _TaskFormScreenState extends State<TaskFormScreen> {
  late final VoidCallback _updateListener;
  late final VoidCallback _deleteListener;
  late final VoidCallback _createListener;

  @override
  void initState() {
    super.initState();

    // Armazena referências das funções
    _updateListener = () => _onResult(command: widget.viewModel.updateTask);
    _deleteListener = () => _onResult(command: widget.viewModel.deleteTask);
    _createListener = () => _onResult(command: widget.viewModel.createTask);

    // Adiciona listeners
    widget.viewModel.updateTask.addListener(_updateListener);
    widget.viewModel.deleteTask.addListener(_deleteListener);
    widget.viewModel.createTask.addListener(_createListener);
  }

  @override
  void dispose() {
    // Remove listeners usando as referências armazenadas
    widget.viewModel.updateTask.removeListener(_updateListener);
    widget.viewModel.deleteTask.removeListener(_deleteListener);
    widget.viewModel.createTask.removeListener(_createListener);

    super.dispose();
  }

  void _onResult({required Command command}) {
    if (!mounted) return; // Verifica se widget ainda está montado

    command.result?.when(
      ok: (task) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Operação realizada com sucesso')),
        );
        Navigator.of(context).pop();
      },
      error: (error) {
        if (error is AppException) {
          final message = ErrorHandler.getUserMessage(error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
    );
  }
}

// Alternativa: Usar StreamSubscription
class _TaskFormScreenState extends State<TaskFormScreen> {
  StreamSubscription<Result>? _updateSubscription;

  @override
  void initState() {
    super.initState();

    // Se Command tiver Stream
    _updateSubscription = widget.viewModel.updateTask.stream.listen(
      (result) => _onResult(result),
      onError: (error) => _onError(error),
    );
  }

  @override
  void dispose() {
    _updateSubscription?.cancel(); // Cancela subscription
    super.dispose();
  }
}
```

---

### 9. Falta de Paginação

**Problema**: `getAllTasks()` carrega todos os dados de uma vez
- ❌ Pode sobrecarregar memória com muitos registros
- ❌ UX ruim em conexões lentas
- ❌ Desperdício de dados móveis

**Recomendação - Implementar Paginação**:

```dart
// lib/domain/repositories/task_repository.dart
abstract interface class TaskRepository {
  Future<Result<PaginatedList<Task>>> getAllTasks({
    required String databaseId,
    int page = 1,
    int pageSize = 20,
  });
}

// lib/domain/entities/paginated_list.dart
class PaginatedList<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedList({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  }) : hasNextPage = currentPage < totalPages,
       hasPreviousPage = currentPage > 1;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}

// lib/data/repositories/task_repository_impl.dart
class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<Result<PaginatedList<Task>>> getAllTasks({
    required String databaseId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final offset = (page - 1) * pageSize;

      // Requisição com paginação
      final response = await _apiClient.request<Map<String, dynamic>>(
        endpoint: '${Urls.getAll(endpoint: Endpoint.task)}'
                  '?limit=$pageSize&offset=$offset'
                  '&database_id=$databaseId',
        method: HttpMethod.get,
      );

      return response.when(
        ok: (data) {
          final items = (data['items'] as List)
              .map((json) => TaskModel.fromJson(json))
              .map((model) => model.toDomain())
              .toList();

          final totalItems = data['total'] as int;
          final totalPages = (totalItems / pageSize).ceil();

          return Result.ok(
            PaginatedList<Task>(
              items: items,
              currentPage: page,
              totalPages: totalPages,
              totalItems: totalItems,
            ),
          );
        },
        error: (e) => Result.error(e),
      );
    } catch (e, s) {
      return Result.error(ErrorHandler.handleError(e, s));
    }
  }
}

// lib/domain/usecases/get_all_tasks_usecase.dart
class GetAllTasksUseCase {
  final TaskRepository _repository;

  GetAllTasksUseCase(this._repository);

  Future<Result<PaginatedList<Task>>> execute({
    required String databaseId,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (page < 1) {
      return Result.error(
        ValidationException(message: 'Página deve ser maior que 0'),
      );
    }

    if (pageSize < 1 || pageSize > 100) {
      return Result.error(
        ValidationException(message: 'Tamanho de página deve estar entre 1 e 100'),
      );
    }

    return await _repository.getAllTasks(
      databaseId: databaseId,
      page: page,
      pageSize: pageSize,
    );
  }
}

// lib/presentation/viewmodels/task_viewmodel.dart
class TaskViewModel extends ChangeNotifier {
  final GetAllTasksUseCase _getAllTasksUseCase;

  List<Task> _tasks = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMorePages = false;
  bool _isLoadingMore = false;

  List<Task> get tasks => _tasks;
  bool get hasMorePages => _hasMorePages;
  bool get isLoadingMore => _isLoadingMore;

  late final loadTasks = Command0(_loadTasks);
  late final loadMoreTasks = Command0(_loadMoreTasks);
  late final refreshTasks = Command0(_refreshTasks);

  Future<Result<PaginatedList<Task>>> _loadTasks() async {
    final result = await _getAllTasksUseCase.execute(
      databaseId: 'default',
      page: _currentPage,
      pageSize: 20,
    );

    result.when(
      ok: (paginatedList) {
        _tasks = paginatedList.items;
        _currentPage = paginatedList.currentPage;
        _totalPages = paginatedList.totalPages;
        _hasMorePages = paginatedList.hasNextPage;
        notifyListeners();
      },
      error: (_) {},
    );

    return result;
  }

  Future<Result<PaginatedList<Task>>> _loadMoreTasks() async {
    if (!_hasMorePages || _isLoadingMore) {
      return Result.ok(
        PaginatedList(
          items: [],
          currentPage: _currentPage,
          totalPages: _totalPages,
          totalItems: _tasks.length,
        ),
      );
    }

    _isLoadingMore = true;
    notifyListeners();

    final nextPage = _currentPage + 1;
    final result = await _getAllTasksUseCase.execute(
      databaseId: 'default',
      page: nextPage,
      pageSize: 20,
    );

    result.when(
      ok: (paginatedList) {
        _tasks.addAll(paginatedList.items);
        _currentPage = paginatedList.currentPage;
        _totalPages = paginatedList.totalPages;
        _hasMorePages = paginatedList.hasNextPage;
      },
      error: (_) {},
    );

    _isLoadingMore = false;
    notifyListeners();

    return result;
  }

  Future<Result<PaginatedList<Task>>> _refreshTasks() async {
    _currentPage = 1;
    return await _loadTasks();
  }
}

// lib/presentation/screens/task_list_screen.dart
class TaskListScreen extends StatefulWidget {
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Detecta quando usuário chega no fim da lista
    _scrollController.addListener(_onScroll);

    widget.viewModel.loadTasks.execute();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Carrega mais quando chegar em 80% do scroll
      if (widget.viewModel.hasMorePages && !widget.viewModel.isLoadingMore) {
        widget.viewModel.loadMoreTasks.execute();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await widget.viewModel.refreshTasks.execute();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.viewModel.tasks.length +
                     (widget.viewModel.hasMorePages ? 1 : 0),
          itemBuilder: (context, index) {
            // Mostra loading no final da lista
            if (index == widget.viewModel.tasks.length) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final task = widget.viewModel.tasks[index];
            return TaskCard(task: task);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

---

## 🎨 PROBLEMAS DE UX/UI

### 10. Ausência de Estados Intermediários

**Problema**: Não há feedback para operações longas
- ❌ Botão não desabilita durante loading
- ❌ Não há skeleton loading
- ❌ Pull-to-refresh ausente

**Recomendação**:

```dart
// lib/presentation/widgets/async_button.dart
class AsyncButton extends StatelessWidget {
  final Command command;
  final String label;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  const AsyncButton({
    required this.command,
    required this.label,
    this.onPressed,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: command,
      builder: (context, _) {
        final isLoading = command.running;

        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : Text(label),
        );
      },
    );
  }
}

// Uso
AsyncButton(
  command: widget.viewModel.createTask,
  label: 'Salvar',
  onPressed: _handleSubmit,
)

// lib/presentation/widgets/skeleton_loading.dart
class SkeletonLoading extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoading({
    this.width,
    this.height = 16,
    this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
      child: _buildShimmer(),
    );
  }

  Widget _buildShimmer() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: [
                value - 0.3,
                value,
                value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: Container(color: Colors.white),
        );
      },
      onEnd: () {
        // Reinicia animação
      },
    );
  }
}

// lib/presentation/widgets/task_card_skeleton.dart
class TaskCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoading(width: 200, height: 20),
            SizedBox(height: 8),
            SkeletonLoading(width: double.infinity, height: 16),
            SizedBox(height: 4),
            SkeletonLoading(width: 150, height: 16),
            SizedBox(height: 12),
            Row(
              children: [
                SkeletonLoading(width: 80, height: 24, borderRadius: BorderRadius.circular(12)),
                Spacer(),
                SkeletonLoading(width: 100, height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// lib/presentation/screens/task_list_screen.dart
class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.viewModel.getAllTasks,
        builder: (context, _) {
          final command = widget.viewModel.getAllTasks;

          // Loading inicial
          if (command.running && widget.viewModel.tasks.isEmpty) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => TaskCardSkeleton(),
            );
          }

          // Erro
          if (command.error && widget.viewModel.tasks.isEmpty) {
            return _buildErrorState(command.result!.error);
          }

          // Lista vazia
          if (widget.viewModel.tasks.isEmpty) {
            return _buildEmptyState();
          }

          // Lista com dados
          return RefreshIndicator(
            onRefresh: () async {
              await widget.viewModel.refreshTasks.execute();
            },
            child: ListView.builder(
              itemCount: widget.viewModel.tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(task: widget.viewModel.tasks[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Nenhuma tarefa encontrada'),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _navigateToCreateTask(),
            child: Text('Criar primeira tarefa'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppException error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(ErrorHandler.getUserMessage(error)),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.viewModel.getAllTasks.execute(),
            child: Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
```

---

### 11. Falta de Offline-First

**Problema**: App não funciona sem internet
- ❌ Nenhuma menção a cache local
- ❌ Não sincroniza quando voltar online
- ❌ Usuário não pode trabalhar offline

**Recomendação - Implementar Offline-First com Drift**:

```dart
// pubspec.yaml
dependencies:
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.0
  connectivity_plus: ^5.0.0

dev_dependencies:
  drift_dev: ^2.14.0
  build_runner: ^2.4.0

// lib/data/datasources/local/database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// Definir tabela
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get syncedWithServer => boolean().withDefault(Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD local
  Future<List<Task>> getAllTasks() => select(tasks).get();

  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Future<int> insertTask(TasksCompanion task) =>
      into(tasks).insert(task);

  Future<bool> updateTask(TasksCompanion task) =>
      update(tasks).replace(task);

  Future<int> deleteTask(String id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  // Buscar tasks não sincronizadas
  Future<List<Task>> getUnsyncedTasks() =>
      (select(tasks)..where((t) => t.syncedWithServer.equals(false))).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}

// lib/core/network/network_info.dart
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }
}

// lib/data/repositories/task_repository_impl.dart
class TaskRepositoryImpl implements TaskRepository {
  final ApiClient _apiClient;
  final AppDatabase _database;
  final NetworkInfo _networkInfo;

  TaskRepositoryImpl({
    required ApiClient apiClient,
    required AppDatabase database,
    required NetworkInfo networkInfo,
  }) : _apiClient = apiClient,
       _database = database,
       _networkInfo = networkInfo {
    // Observa mudanças de conectividade para sincronizar
    _networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        _syncWithServer();
      }
    });
  }

  @override
  Future<Result<List<Task>>> getAllTasks({
    required String databaseId,
  }) async {
    try {
      // 1. Retorna cache local imediatamente
      final localTasks = await _database.getAllTasks();

      // 2. Se online, busca do servidor em background
      if (await _networkInfo.isConnected) {
        _fetchAndUpdateCache(databaseId);
      }

      // 3. Retorna dados locais (podem ser atualizados depois)
      return Result.ok(
        localTasks.map((t) => _taskFromDrift(t)).toList(),
      );
    } catch (e, s) {
      return Result.error(ErrorHandler.handleError(e, s));
    }
  }

  Future<void> _fetchAndUpdateCache(String databaseId) async {
    try {
      final response = await _apiClient.request<List<dynamic>>(
        endpoint: Urls.getAll(endpoint: Endpoint.task),
        method: HttpMethod.get,
      );

      response.when(
        ok: (data) async {
          // Atualiza cache local
          for (final json in data) {
            final model = TaskModel.fromJson(json);
            await _database.insertTask(
              TasksCompanion.insert(
                id: model.id,
                title: model.title,
                description: model.description,
                status: model.status,
                createdAt: DateTime.parse(model.createdAt),
                syncedWithServer: Value(true),
              ),
            );
          }
        },
        error: (_) {
          // Falha silenciosa - usuário já tem dados locais
          AppLogger.warning('Failed to sync with server');
        },
      );
    } catch (e) {
      AppLogger.warning('Failed to sync with server: $e');
    }
  }

  @override
  Future<Result<Task>> createTask({required Task task}) async {
    try {
      // 1. Salva localmente PRIMEIRO
      final localId = Uuid().v4();
      await _database.insertTask(
        TasksCompanion.insert(
          id: localId,
          title: task.title,
          description: task.description,
          status: task.status.name,
          createdAt: task.createdAt,
          syncedWithServer: Value(false), // Marca como não sincronizado
        ),
      );

      final savedTask = task.copyWith(id: localId);

      // 2. Se online, sincroniza com servidor
      if (await _networkInfo.isConnected) {
        _syncTaskWithServer(savedTask);
      }

      return Result.ok(savedTask);
    } catch (e, s) {
      return Result.error(ErrorHandler.handleError(e, s));
    }
  }

  Future<void> _syncTaskWithServer(Task task) async {
    try {
      final response = await _apiClient.request<Map<String, dynamic>>(
        endpoint: Urls.create(endpoint: Endpoint.task),
        method: HttpMethod.post,
        data: TaskModel.fromDomain(task).toJson(),
      );

      response.when(
        ok: (data) async {
          final serverTask = TaskModel.fromJson(data).toDomain();

          // Atualiza com ID do servidor
          await _database.updateTask(
            TasksCompanion(
              id: Value(serverTask.id),
              syncedWithServer: Value(true),
            ),
          );
        },
        error: (_) {
          // Mantém na fila de sincronização
          AppLogger.warning('Failed to sync task with server');
        },
      );
    } catch (e) {
      AppLogger.warning('Failed to sync task: $e');
    }
  }

  // Sincroniza todas as tasks pendentes
  Future<void> _syncWithServer() async {
    try {
      final unsyncedTasks = await _database.getUnsyncedTasks();

      for (final task in unsyncedTasks) {
        await _syncTaskWithServer(_taskFromDrift(task));
      }
    } catch (e) {
      AppLogger.error('Sync failed', error: e);
    }
  }

  Task _taskFromDrift(TaskData task) {
    return Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: TaskStatus.values.firstWhere((e) => e.name == task.status),
      createdAt: task.createdAt,
    );
  }
}

// lib/presentation/widgets/sync_indicator.dart
class SyncIndicator extends StatelessWidget {
  final NetworkInfo networkInfo;
  final TaskRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: networkInfo.onConnectivityChanged,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? false;

        if (!isOnline) {
          return Container(
            padding: EdgeInsets.all(8),
            color: Colors.orange,
            child: Row(
              children: [
                Icon(Icons.cloud_off, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Modo offline - Alterações serão sincronizadas',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
```

---

## 📊 FALTA DE OBSERVABILIDADE

### 12. Logging Insuficiente

**Problema**: Só loga erros, não loga sucessos ou métricas
- ❌ Dificulta debugging em produção
- ❌ Não rastreia performance
- ❌ Não sabe onde usuários estão tendo problemas

**Recomendação - Logging Estruturado**:

```dart
// lib/core/logging/app_logger.dart
import 'package:logger/logger.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static final List<LogObserver> _observers = [];

  static void addObserver(LogObserver observer) {
    _observers.add(observer);
  }

  static void debug(
    String message, {
    String? tag,
    Map<String, dynamic>? metadata,
  }) {
    _log(LogLevel.debug, message, tag: tag, metadata: metadata);
    _logger.d('[$tag] $message', metadata);
  }

  static void info(
    String message, {
    String? tag,
    Map<String, dynamic>? metadata,
  }) {
    _log(LogLevel.info, message, tag: tag, metadata: metadata);
    _logger.i('[$tag] $message', metadata);
  }

  static void warning(
    String message, {
    String? tag,
    Map<String, dynamic>? metadata,
    dynamic error,
  }) {
    _log(LogLevel.warning, message, tag: tag, metadata: metadata, error: error);
    _logger.w('[$tag] $message', error, metadata);
  }

  static void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
    _logger.e('[$tag] $message', error, stackTrace);
  }

  static void fatal(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    _log(
      LogLevel.fatal,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
    _logger.f('[$tag] $message', error, stackTrace);
  }

  // Performance logging
  static void logPerformance(
    String operation, {
    required Duration duration,
    String? tag,
    Map<String, dynamic>? metadata,
  }) {
    final enrichedMetadata = {
      ...?metadata,
      'duration_ms': duration.inMilliseconds,
      'operation': operation,
    };

    info(
      'Performance: $operation completed in ${duration.inMilliseconds}ms',
      tag: tag ?? 'Performance',
      metadata: enrichedMetadata,
    );
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    final logEntry = LogEntry(
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
      timestamp: DateTime.now(),
    );

    for (final observer in _observers) {
      observer.onLog(logEntry);
    }
  }
}

class LogEntry {
  final LogLevel level;
  final String message;
  final String? tag;
  final dynamic error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  LogEntry({
    required this.level,
    required this.message,
    this.tag,
    this.error,
    this.stackTrace,
    this.metadata,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level.name,
      'message': message,
      'tag': tag,
      'error': error?.toString(),
      'stackTrace': stackTrace?.toString(),
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

abstract interface class LogObserver {
  void onLog(LogEntry entry);
}

// lib/core/logging/firebase_log_observer.dart
class FirebaseLogObserver implements LogObserver {
  @override
  void onLog(LogEntry entry) {
    // Envia para Firebase Crashlytics apenas erros
    if (entry.level == LogLevel.error || entry.level == LogLevel.fatal) {
      FirebaseCrashlytics.instance.recordError(
        entry.error,
        entry.stackTrace,
        reason: entry.message,
        information: [entry.metadata ?? {}],
      );
    }
  }
}

// lib/core/logging/file_log_observer.dart
class FileLogObserver implements LogObserver {
  final File _logFile;

  FileLogObserver(this._logFile);

  @override
  void onLog(LogEntry entry) {
    // Salva logs em arquivo para debug
    _logFile.writeAsStringSync(
      '${jsonEncode(entry.toJson())}\n',
      mode: FileMode.append,
    );
  }
}

// Usar no Repository com métricas de performance
class TaskRepositoryImpl implements TaskRepository {
  static const _tag = 'TaskRepository';

  @override
  Future<Result<List<Task>>> getAllTasks({
    required String databaseId,
  }) async {
    final stopwatch = Stopwatch()..start();

    AppLogger.info(
      'Fetching tasks',
      tag: _tag,
      metadata: {'database_id': databaseId},
    );

    try {
      final result = await _apiClient.request<List<dynamic>>(
        endpoint: Urls.getAll(endpoint: Endpoint.task),
        method: HttpMethod.get,
      );

      stopwatch.stop();

      return result.when(
        ok: (data) {
          final tasks = data
              .map((json) => TaskModel.fromJson(json))
              .map((model) => model.toDomain())
              .toList();

          AppLogger.logPerformance(
            'getAllTasks',
            duration: stopwatch.elapsed,
            tag: _tag,
            metadata: {
              'database_id': databaseId,
              'task_count': tasks.length,
            },
          );

          AppLogger.info(
            'Successfully fetched ${tasks.length} tasks',
            tag: _tag,
            metadata: {
              'database_id': databaseId,
              'count': tasks.length,
            },
          );

          return Result.ok(tasks);
        },
        error: (e) {
          AppLogger.error(
            'Failed to fetch tasks',
            tag: _tag,
            error: e,
            metadata: {
              'database_id': databaseId,
              'duration_ms': stopwatch.elapsedMilliseconds,
            },
          );

          return Result.error(e);
        },
      );
    } catch (e, s) {
      stopwatch.stop();

      AppLogger.error(
        'Unexpected error fetching tasks',
        tag: _tag,
        error: e,
        stackTrace: s,
        metadata: {
          'database_id': databaseId,
          'duration_ms': stopwatch.elapsedMilliseconds,
        },
      );

      return Result.error(ErrorHandler.handleError(e, s));
    }
  }
}
```

---

### 13. Ausência de Analytics

**Problema**: Não rastreia comportamento do usuário
- ❌ Não sabe quais features são mais usadas
- ❌ Não rastreia erros em produção
- ❌ Dificulta priorização de melhorias

**Recomendação - Implementar Analytics**:

```dart
// pubspec.yaml
dependencies:
  firebase_analytics: ^10.7.0
  firebase_crashlytics: ^3.4.0

// lib/core/analytics/analytics_service.dart
abstract interface class AnalyticsService {
  void logEvent(String name, Map<String, dynamic>? parameters);
  void logScreenView(String screenName);
  void setUserId(String userId);
  void setUserProperty(String name, String value);
  void logError(Exception error, StackTrace stackTrace, {bool fatal = false});
}

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;

  FirebaseAnalyticsService({
    required FirebaseAnalytics analytics,
    required FirebaseCrashlytics crashlytics,
  }) : _analytics = analytics,
       _crashlytics = crashlytics;

  @override
  void logEvent(String name, Map<String, dynamic>? parameters) {
    _analytics.logEvent(
      name: name,
      parameters: parameters,
    );

    AppLogger.debug(
      'Analytics event: $name',
      tag: 'Analytics',
      metadata: parameters,
    );
  }

  @override
  void logScreenView(String screenName) {
    _analytics.logScreenView(screenName: screenName);

    AppLogger.debug(
      'Screen view: $screenName',
      tag: 'Analytics',
    );
  }

  @override
  void setUserId(String userId) {
    _analytics.setUserId(id: userId);
    _crashlytics.setUserIdentifier(userId);
  }

  @override
  void setUserProperty(String name, String value) {
    _analytics.setUserProperty(name: name, value: value);
  }

  @override
  void logError(
    Exception error,
    StackTrace stackTrace, {
    bool fatal = false,
  }) {
    _crashlytics.recordError(
      error,
      stackTrace,
      fatal: fatal,
    );
  }
}

// lib/core/analytics/analytics_events.dart
class AnalyticsEvents {
  // Task events
  static const taskCreated = 'task_created';
  static const taskUpdated = 'task_updated';
  static const taskDeleted = 'task_deleted';
  static const taskCompleted = 'task_completed';
  static const taskListViewed = 'task_list_viewed';

  // Medication events
  static const medicationAdded = 'medication_added';
  static const medicationTaken = 'medication_taken';
  static const medicationSkipped = 'medication_skipped';

  // User events
  static const userLoggedIn = 'user_logged_in';
  static const userLoggedOut = 'user_logged_out';
  static const userSignedUp = 'user_signed_up';

  // Error events
  static const errorOccurred = 'error_occurred';
  static const networkErrorOccurred = 'network_error_occurred';
}

// Usar no UseCase
class CreateTaskUseCase {
  final TaskRepository _repository;
  final AnalyticsService _analytics;

  CreateTaskUseCase({
    required TaskRepository repository,
    required AnalyticsService analytics,
  }) : _repository = repository,
       _analytics = analytics;

  Future<Result<Task>> execute({
    required String title,
    required String description,
  }) async {
    final stopwatch = Stopwatch()..start();

    // Validações...

    final result = await _repository.createTask(task: task);

    stopwatch.stop();

    result.when(
      ok: (createdTask) {
        // Log sucesso
        _analytics.logEvent(
          AnalyticsEvents.taskCreated,
          {
            'title_length': title.length,
            'description_length': description.length,
            'duration_ms': stopwatch.elapsedMilliseconds,
          },
        );
      },
      error: (error) {
        // Log erro
        _analytics.logEvent(
          AnalyticsEvents.errorOccurred,
          {
            'operation': 'create_task',
            'error_type': error.runtimeType.toString(),
            'error_code': error is AppException ? error.code : null,
            'duration_ms': stopwatch.elapsedMilliseconds,
          },
        );

        if (error is Exception) {
          _analytics.logError(
            error as Exception,
            StackTrace.current,
            fatal: false,
          );
        }
      },
    );

    return result;
  }
}

// Usar nas Screens
class TaskListScreen extends StatefulWidget {
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();

    // Log screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.analytics.logScreenView('task_list');
    });
  }

  void _onTaskTap(Task task) {
    widget.analytics.logEvent(
      'task_tapped',
      {
        'task_id': task.id,
        'status': task.status.name,
      },
    );

    Navigator.push(...);
  }
}

// lib/core/analytics/route_observer.dart
class AnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final AnalyticsService _analytics;

  AnalyticsRouteObserver(this._analytics);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is PageRoute) {
      _analytics.logScreenView(route.settings.name ?? 'unknown');
    }
  }
}

// Usar no MaterialApp
MaterialApp(
  navigatorObservers: [
    AnalyticsRouteObserver(getIt<AnalyticsService>()),
  ],
  // ...
)
```

---

## 🧪 FALTA DE TESTABILIDADE

### 14. Dificuldade de Testar ViewModels

**Problema**: ViewModels dependem de implementações concretas
- ❌ Dificulta mock em testes unitários
- ❌ Testes lentos (dependem de I/O real)

**Recomendação - Injeção de Dependências com GetIt**:

```dart
// pubspec.yaml
dev_dependencies:
  mockito: ^5.4.0
  build_runner: ^2.4.0

// lib/config/di/injection.dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Core
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );
  getIt.registerLazySingleton<AnalyticsService>(
    () => FirebaseAnalyticsService(
      analytics: FirebaseAnalytics.instance,
      crashlytics: FirebaseCrashlytics.instance,
    ),
  );

  // Data sources
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<DataSource>(
    () => SupabaseDataSource(getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      remoteDataSource: getIt<DataSource>(),
      localDataSource: getIt<AppDatabase>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use cases
  getIt.registerFactory<GetAllTasksUseCase>(
    () => GetAllTasksUseCase(getIt<TaskRepository>()),
  );
  getIt.registerFactory<CreateTaskUseCase>(
    () => CreateTaskUseCase(
      repository: getIt<TaskRepository>(),
      analytics: getIt<AnalyticsService>(),
    ),
  );
  getIt.registerFactory<UpdateTaskUseCase>(
    () => UpdateTaskUseCase(getIt<TaskRepository>()),
  );
  getIt.registerFactory<DeleteTaskUseCase>(
    () => DeleteTaskUseCase(getIt<TaskRepository>()),
  );

  // ViewModels
  getIt.registerFactory<TaskViewModel>(
    () => TaskViewModel(
      getAllTasksUseCase: getIt<GetAllTasksUseCase>(),
      createTaskUseCase: getIt<CreateTaskUseCase>(),
      updateTaskUseCase: getIt<UpdateTaskUseCase>(),
      deleteTaskUseCase: getIt<DeleteTaskUseCase>(),
    ),
  );
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  runApp(MyApp());
}

// Usar na UI
class TaskListScreen extends StatefulWidget {
  // Injetar ViewModel
  final TaskViewModel viewModel;

  TaskListScreen({
    TaskViewModel? viewModel,
  }) : viewModel = viewModel ?? getIt<TaskViewModel>();

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}
```

---

### 15. Falta de Contratos de Teste

**Problema**: Não há testes mencionados no guia
- ❌ Sem testes unitários para Models
- ❌ Sem testes de integração para Repositories
- ❌ Sem testes de widget

**Recomendação - Suite Completa de Testes**:

```dart
// test/domain/entities/task_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task Entity', () {
    test('should create task with valid data', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        status: TaskStatus.pending,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.isCompleted, false);
    });

    test('should correctly identify completed task', () {
      final task = Task(
        id: '1',
        title: 'Test',
        description: '',
        status: TaskStatus.completed,
        createdAt: DateTime.now(),
      );

      expect(task.isCompleted, true);
    });

    test('should mark task as completed', () {
      final task = Task(
        id: '1',
        title: 'Test',
        description: '',
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      );

      final completedTask = task.markAsCompleted();

      expect(completedTask.status, TaskStatus.completed);
      expect(completedTask.isCompleted, true);
    });
  });
}

// test/data/models/task_model_test.dart
void main() {
  group('TaskModel', () {
    final tTaskModel = TaskModel(
      id: '1',
      title: 'Test Task',
      description: 'Description',
      status: 'pending',
      createdAt: '2024-01-01T00:00:00.000Z',
    );

    test('should parse valid JSON', () {
      final json = {
        'id': '1',
        'title': 'Test Task',
        'description': 'Description',
        'status': 'pending',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final result = TaskModel.fromJson(json);

      expect(result, tTaskModel);
    });

    test('should throw FormatException on invalid JSON', () {
      expect(
        () => TaskModel.fromJson(null),
        throwsA(isA<FormatException>()),
      );
    });

    test('should convert to domain entity', () {
      final task = tTaskModel.toDomain();

      expect(task, isA<Task>());
      expect(task.id, '1');
      expect(task.status, TaskStatus.pending);
    });

    test('should convert to JSON', () {
      final json = tTaskModel.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['status'], 'pending');
    });
  });
}

// test/data/repositories/task_repository_impl_test.dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ApiClient, AppDatabase, NetworkInfo])
void main() {
  late TaskRepositoryImpl repository;
  late MockApiClient mockApiClient;
  late MockAppDatabase mockDatabase;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDatabase = MockAppDatabase();
    mockNetworkInfo = MockNetworkInfo();

    repository = TaskRepositoryImpl(
      remoteDataSource: mockApiClient,
      localDataSource: mockDatabase,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllTasks', () {
    final tTaskList = [
      TaskModel(
        id: '1',
        title: 'Task 1',
        description: '',
        status: 'pending',
        createdAt: DateTime.now().toIso8601String(),
      ),
    ];

    test('should return tasks from API when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockApiClient.request<List<dynamic>>(
        endpoint: any,
        method: any,
      )).thenAnswer((_) async => Result.ok([tTaskList.first.toJson()]));

      // Act
      final result = await repository.getAllTasks(databaseId: 'test');

      // Assert
      expect(result.isOk, true);
      result.when(
        ok: (tasks) => expect(tasks.length, 1),
        error: (_) => fail('Should not return error'),
      );

      verify(mockApiClient.request(endpoint: any, method: any));
    });

    test('should return cached tasks when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockDatabase.getAllTasks()).thenAnswer(
        (_) async => [/* TaskData list */],
      );

      // Act
      final result = await repository.getAllTasks(databaseId: 'test');

      // Assert
      expect(result.isOk, true);
      verifyNever(mockApiClient.request(endpoint: any, method: any));
      verify(mockDatabase.getAllTasks());
    });

    test('should return error when API fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockApiClient.request<List<dynamic>>(
        endpoint: any,
        method: any,
      )).thenAnswer(
        (_) async => Result.error(ServerException(message: 'Server error')),
      );

      // Act
      final result = await repository.getAllTasks(databaseId: 'test');

      // Assert
      expect(result.isError, true);
      result.when(
        ok: (_) => fail('Should not return success'),
        error: (e) => expect(e, isA<ServerException>()),
      );
    });
  });
}

// test/domain/usecases/create_task_usecase_test.dart
@GenerateMocks([TaskRepository, AnalyticsService])
void main() {
  late CreateTaskUseCase useCase;
  late MockTaskRepository mockRepository;
  late MockAnalyticsService mockAnalytics;

  setUp(() {
    mockRepository = MockTaskRepository();
    mockAnalytics = MockAnalyticsService();

    useCase = CreateTaskUseCase(
      repository: mockRepository,
      analytics: mockAnalytics,
    );
  });

  group('CreateTaskUseCase', () {
    test('should return ValidationException for empty title', () async {
      // Act
      final result = await useCase.execute(
        title: '',
        description: 'Description',
      );

      // Assert
      expect(result.isError, true);
      result.when(
        ok: (_) => fail('Should not return success'),
        error: (e) {
          expect(e, isA<ValidationException>());
          expect((e as ValidationException).message, contains('vazio'));
        },
      );

      verifyNever(mockRepository.createTask(task: any));
    });

    test('should create task with valid data', () async {
      // Arrange
      final tTask = Task(
        id: '1',
        title: 'Valid Title',
        description: 'Description',
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      );

      when(mockRepository.createTask(task: any)).thenAnswer(
        (_) async => Result.ok(tTask),
      );

      // Act
      final result = await useCase.execute(
        title: 'Valid Title',
        description: 'Description',
      );

      // Assert
      expect(result.isOk, true);
      verify(mockRepository.createTask(task: any));
      verify(mockAnalytics.logEvent(
        AnalyticsEvents.taskCreated,
        any,
      ));
    });
  });
}

// test/presentation/viewmodels/task_viewmodel_test.dart
@GenerateMocks([
  GetAllTasksUseCase,
  CreateTaskUseCase,
  UpdateTaskUseCase,
  DeleteTaskUseCase,
])
void main() {
  late TaskViewModel viewModel;
  late MockGetAllTasksUseCase mockGetAllTasksUseCase;
  late MockCreateTaskUseCase mockCreateTaskUseCase;

  setUp(() {
    mockGetAllTasksUseCase = MockGetAllTasksUseCase();
    mockCreateTaskUseCase = MockCreateTaskUseCase();

    viewModel = TaskViewModel(
      getAllTasksUseCase: mockGetAllTasksUseCase,
      createTaskUseCase: mockCreateTaskUseCase,
      updateTaskUseCase: MockUpdateTaskUseCase(),
      deleteTaskUseCase: MockDeleteTaskUseCase(),
    );
  });

  group('TaskViewModel', () {
    test('should load tasks successfully', () async {
      // Arrange
      final tPaginatedList = PaginatedList<Task>(
        items: [
          Task(
            id: '1',
            title: 'Task 1',
            description: '',
            status: TaskStatus.pending,
            createdAt: DateTime.now(),
          ),
        ],
        currentPage: 1,
        totalPages: 1,
        totalItems: 1,
      );

      when(mockGetAllTasksUseCase.execute(
        databaseId: any,
        page: any,
        pageSize: any,
      )).thenAnswer((_) async => Result.ok(tPaginatedList));

      // Act
      await viewModel.loadTasks.execute();

      // Assert
      expect(viewModel.tasks.length, 1);
      expect(viewModel.loadTasks.completed, true);
      verify(mockGetAllTasksUseCase.execute(
        databaseId: 'default',
        page: 1,
        pageSize: 20,
      ));
    });

    test('should handle error when loading tasks fails', () async {
      // Arrange
      when(mockGetAllTasksUseCase.execute(
        databaseId: any,
        page: any,
        pageSize: any,
      )).thenAnswer(
        (_) async => Result.error(
          ServerException(message: 'Server error'),
        ),
      );

      // Act
      await viewModel.loadTasks.execute();

      // Assert
      expect(viewModel.loadTasks.error, true);
      expect(viewModel.tasks.isEmpty, true);
    });
  });
}

// test/presentation/widgets/task_card_test.dart
void main() {
  group('TaskCard Widget', () {
    testWidgets('should display task information', (tester) async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        createdAt: DateTime(2024, 1, 1),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.byType(TaskCard), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: '',
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      );

      bool wasTapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: task,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TaskCard));
      await tester.pump();

      // Assert
      expect(wasTapped, true);
    });
  });
}
```

**Adicionar ao guia react_to_flutter.md**:

```markdown
## 7️⃣ **Testes** (OBRIGATÓRIO)

### 7.1 Testes Unitários do Model
- [ ] `fromJson` com dados válidos retorna modelo correto
- [ ] `fromJson` com dados inválidos lança `FormatException`
- [ ] `fromJson` com null lança exceção
- [ ] `toJson` preserva todos os dados
- [ ] `toDomain` converte corretamente para entidade

### 7.2 Testes do Repository
- [ ] Mock de ApiClient e Database
- [ ] Testa cada método CRUD (create, read, update, delete)
- [ ] Verifica tratamento de erros de rede
- [ ] Verifica tratamento de erros de parsing
- [ ] Testa comportamento offline (retorna cache)
- [ ] Testa sincronização quando voltar online

### 7.3 Testes de UseCase
- [ ] Mock de Repository
- [ ] Testa validações de entrada
- [ ] Testa lógica de negócio
- [ ] Verifica logging de analytics

### 7.4 Testes da ViewModel
- [ ] Mock de UseCases
- [ ] Testa cada Command
- [ ] Verifica estados (running, error, completed)
- [ ] Verifica notifyListeners é chamado

### 7.5 Testes de Widget
- [ ] Testa renderização com dados
- [ ] Testa interações (tap, scroll)
- [ ] Testa estados de loading
- [ ] Testa exibição de erros

### Cobertura Mínima
- **Meta**: 80% de cobertura de código
- Executar: `flutter test --coverage`
- Visualizar: `genhtml coverage/lcov.info -o coverage/html`
```

---

## 📋 CHECKLIST DE MELHORIAS PRIORITÁRIAS

### 🔴 **Crítico** (Implementar Imediatamente)

#### Segurança
- [ ] Adicionar validação de entrada em todos os `fromJson`
- [ ] Mover URLs e tokens para variáveis de ambiente (`.env`)
- [ ] Implementar `flutter_secure_storage` para dados sensíveis
- [ ] Adicionar sanitização de strings antes de enviar para API
- [ ] Corrigir remoção de listeners (memory leak)

#### Estabilidade
- [ ] Adicionar timeout nas requisições (30s padrão)
- [ ] Implementar retry logic para falhas de rede
- [ ] Criar hierarquia de exceções customizadas
- [ ] Melhorar error handling (parar de usar `UnknownErrorException` genérico)

#### Performance
- [ ] Adicionar paginação em `getAllTasks()` e outras listagens
- [ ] Implementar cache local básico

**Tempo Estimado**: 2-3 sprints

---

### 🟡 **Importante** (Próximas Sprints)

#### Arquitetura
- [ ] Criar camada de **Domain** (entities, repositories interfaces, use cases)
- [ ] Separar lógica de negócio em **UseCases**
- [ ] Desacoplar de Supabase (criar interface `DataSource` genérica)
- [ ] Implementar injeção de dependências com **GetIt**
- [ ] Mover ViewModels para apenas coordenação (não lógica de negócio)

#### Offline-First
- [ ] Implementar banco de dados local com **Drift**
- [ ] Criar estratégia de sincronização offline → online
- [ ] Adicionar indicador visual de "Modo Offline"
- [ ] Implementar fila de sincronização para operações offline

#### Observabilidade
- [ ] Integrar **Firebase Analytics**
- [ ] Integrar **Firebase Crashlytics**
- [ ] Adicionar logging estruturado com contexto
- [ ] Implementar métricas de performance (tempo de resposta, etc.)

**Tempo Estimado**: 4-6 sprints

---

### 🟢 **Desejável** (Médio/Longo Prazo)

#### UX/UI
- [ ] Implementar skeleton loading para estados de carregamento
- [ ] Adicionar pull-to-refresh em todas as listas
- [ ] Desabilitar botões durante loading
- [ ] Criar estados de erro amigáveis com retry
- [ ] Implementar estados vazios informativos

#### Segurança Avançada
- [ ] Implementar certificate pinning (proteção MITM)
- [ ] Adicionar criptografia end-to-end para dados médicos
- [ ] Implementar auditoria de acesso a dados sensíveis

#### Testes
- [ ] Criar suite de testes unitários (Models, Repositories, UseCases)
- [ ] Criar testes de integração
- [ ] Criar testes de widget
- [ ] Atingir 80% de cobertura de código
- [ ] Configurar CI/CD para rodar testes automaticamente

#### Documentação
- [ ] Documentar todas as exceções customizadas
- [ ] Criar guia de contribuição
- [ ] Documentar arquitetura (diagramas)
- [ ] Criar ADRs (Architecture Decision Records)

**Tempo Estimado**: 6-12 sprints

---

## 💡 RECOMENDAÇÕES FINAIS

### 1. **Adotar Clean Architecture Completa**

**Por quê?**
- Separa responsabilidades claramente
- Facilita testes (cada camada isolada)
- Torna o código independente de frameworks
- Facilita manutenção e escalabilidade

**Estrutura Recomendada**:
```
lib/
├── core/          # Funcionalidades compartilhadas
├── domain/        # Lógica de negócio pura (entities, repositories, use cases)
├── data/          # Implementações (models, repositories, data sources)
└── presentation/  # UI (viewmodels, screens, widgets)
```

---

### 2. **Implementar Offline-First com Cache Local**

**Por quê?**
- App funciona sem internet
- Melhor experiência do usuário
- Reduz consumo de dados móveis
- Aumenta confiabilidade

**Tecnologias**:
- **Drift** (banco SQLite local)
- **Connectivity Plus** (detectar online/offline)
- Estratégia: Cache-first com sincronização em background

---

### 3. **Adicionar Segurança em Múltiplas Camadas**

**Por quê?**
- Dados de saúde são altamente sensíveis (LGPD/HIPAA)
- Previne vazamento de dados
- Protege contra ataques comuns

**Implementações**:
- Validação e sanitização de entrada
- Criptografia de dados sensíveis (`flutter_secure_storage`)
- Variáveis de ambiente para secrets
- Certificate pinning
- Timeout e rate limiting

---

### 4. **Melhorar Observabilidade**

**Por quê?**
- Debugging mais fácil em produção
- Rastreia comportamento do usuário
- Identifica gargalos de performance
- Prioriza melhorias baseado em dados reais

**Implementações**:
- **Firebase Analytics** (eventos de usuário)
- **Firebase Crashlytics** (erros em produção)
- Logging estruturado com contexto
- Métricas de performance (tempo de resposta)

---

### 5. **Criar Suite Completa de Testes**

**Por quê?**
- Previne regressões
- Facilita refatoração
- Aumenta confiança no código
- Documenta comportamento esperado

**Cobertura Mínima**:
- **80%** de cobertura de código
- Testes unitários (Models, Repositories, UseCases, ViewModels)
- Testes de integração (fluxos completos)
- Testes de widget (UI)

---

### 6. **Documentar Exceções Customizadas**

**Por quê?**
- Tratamento de erro específico
- Mensagens amigáveis para usuário
- Facilita debugging

**Hierarquia**:
```
AppException
├── NetworkException
│   ├── TimeoutException
│   ├── NoInternetException
│   └── ServerException
├── DataException
│   ├── DataParsingException
│   └── ValidationException
├── CacheException
└── AuthException
    └── UnauthorizedException
```

---

### 7. **Priorização Sugerida**

**Sprint 1-2** (Crítico - Segurança):
1. Validação de entrada
2. Variáveis de ambiente
3. Correção de memory leaks
4. Timeout e retry logic

**Sprint 3-5** (Importante - Arquitetura):
1. Criar camada Domain
2. Implementar UseCases
3. Injeção de dependências
4. Desacoplar de Supabase

**Sprint 6-8** (Importante - Offline):
1. Banco local (Drift)
2. Sincronização offline
3. Indicadores de conectividade

**Sprint 9-11** (Desejável - Qualidade):
1. Analytics e Crashlytics
2. Suite de testes
3. Melhorias de UX (skeleton, empty states)

**Sprint 12+** (Desejável - Polimento):
1. Certificate pinning
2. Criptografia avançada
3. Documentação completa

---

## 📚 Recursos Adicionais

### Artigos e Guias
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Offline-First Apps with Flutter](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [Testing Best Practices](https://docs.flutter.dev/cookbook/testing)

### Packages Recomendados
- `drift` - Banco de dados local type-safe
- `get_it` - Injeção de dependências
- `connectivity_plus` - Detectar conectividade
- `flutter_secure_storage` - Armazenamento seguro
- `logger` - Logging estruturado
- `mockito` - Mocks para testes

### Ferramentas
- **Codemagic / GitHub Actions** - CI/CD
- **Sentry / Firebase Crashlytics** - Crash reporting
- **Firebase Analytics** - Analytics
- **SonarQube** - Análise de código

---

## 🔄 Processo de Revisão

### Antes de Implementar
1. Ler este documento completamente
2. Priorizar melhorias baseado em impacto/esforço
3. Criar issues no GitHub/Jira para cada item
4. Estimar tempo e esforço

### Durante Implementação
1. Seguir checklist correspondente
2. Escrever testes antes do código (TDD)
3. Fazer code review rigoroso
4. Atualizar documentação

### Após Implementação
1. Validar com testes automatizados
2. Fazer teste manual de regressão
3. Medir impacto (performance, crashes)
4. Marcar item como concluído neste documento

---

**Última Atualização**: 2025-10-29
**Versão**: 1.0
**Autor**: Claude (Anthropic)
