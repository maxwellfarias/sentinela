# Flutter/Supabase CRUD Architecture - Guia Completo de Implementação

> **Objetivo**: Este documento serve como referência completa para geração automatizada de todas as camadas necessárias para implementar CRUD completo de entidades no aplicativo, a partir de uma definição SQL de tabela do Supabase.

> **Escopo**: Abrange desde a camada de serviço até o ViewModel. A criação de UI (telas) está documentada separadamente.

---

## Índice

1. [Visão Geral da Arquitetura](#1-visão-geral-da-arquitetura)
2. [Convenções de Nomenclatura](#2-convenções-de-nomenclatura)
3. [Estrutura de Diretórios](#3-estrutura-de-diretórios)
4. [Mapeamento SQL → Dart](#4-mapeamento-sql--dart)
5. [Camada de Configuração](#5-camada-de-configuração)
6. [Camada de Serviço](#6-camada-de-serviço)
7. [Camada de Repositório](#7-camada-de-repositório)
8. [Camada de Domínio](#8-camada-de-domínio)
9. [Camada de ViewModel](#9-camada-de-viewmodel)
10. [Camada de Roteamento](#10-camada-de-roteamento)
11. [Padrão Result](#11-padrão-result)
12. [Guia Passo-a-Passo](#12-guia-passo-a-passo)
13. [Padrões Específicos do Supabase](#13-padrões-específicos-do-supabase)
14. [Checklist Completo](#14-checklist-completo)
15. [Problemas Comuns e Soluções](#15-problemas-comuns-e-soluções)

---

## 1. Visão Geral da Arquitetura

### 1.1 Clean Architecture

Este projeto segue **Clean Architecture** com separação clara entre camadas:

```
┌─────────────────────────────────────────────────────────┐
│                     UI LAYER                            │
│  (Screens/Widgets - Não coberto neste documento)       │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                  VIEWMODEL LAYER                        │
│  - Orquestra operações de negócio                      │
│  - Expõe Commands para a UI                            │
│  - Gerencia estado local                               │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                  REPOSITORY LAYER                       │
│  - Interface abstrata                                  │
│  - Implementação concreta                              │
│  - Acesso a dados                                       │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                   SERVICE LAYER                         │
│  - ApiClient (HTTP genérico)                           │
│  - EndpointBuilder (URLs Supabase)                     │
│  - HeaderBuilder (Auth, Prefer, Range)                 │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                   DOMAIN LAYER                          │
│  - Modelos de domínio                                  │
│  - Exceções customizadas                               │
│  - Result Pattern                                       │
└─────────────────────────────────────────────────────────┘
```

### 1.2 Padrões de Projeto Utilizados

| Padrão | Onde Usado | Propósito |
|--------|-----------|-----------|
| **Repository** | Data Layer | Abstração de acesso a dados |
| **Command** | ViewModel Layer | Encapsular operações assíncronas com estado |
| **Result/Either** | Todas as camadas | Tratamento explícito de erros sem exceptions |
| **Dependency Injection** | Config Layer | Provider para injeção de dependências |
| **Builder** | Service Layer | EndpointBuilder, HeaderBuilder |
| **Strategy** | Service Layer | Diferentes estratégias de endpoint por entidade |
| **MVVM** | UI + ViewModel | Separação entre lógica de apresentação e negócio |

### 1.3 Fluxo de Dados Completo

```
CRIAÇÃO DE ENTIDADE (Create):

1. UI: Usuário preenche formulário e clica em "Salvar"
   ↓
2. ViewModel: viewmodel.createCommand.execute(entity)
   ↓
3. Repository: repository.create(entity)
   ↓
4. EndpointBuilder: gera URL POST /rest/v1/table_name
   ↓
5. HeaderBuilder: adiciona headers (Authorization, apikey, Prefer)
   ↓
6. ApiClient: executa HTTP POST com Dio
   ↓
7. AuthInterceptor: valida/renova token automaticamente
   ↓
8. ApiClient: mapeia resposta → Result<T>
   ↓
9. Repository: desserializa JSON → Model
   ↓
10. ViewModel: atualiza estado local, notifica listeners
   ↓
11. UI: Recebe notificação, atualiza tela, mostra feedback
```

---

## 2. Convenções de Nomenclatura

### 2.1 Arquivos

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Interface de Repository | `{entity}_repository.dart` | `heart_rate_repository.dart` |
| Implementação de Repository | `{entity}_repository_impl.dart` | `heart_rate_repository_impl.dart` |
| Modelo de Domínio | `{entity}_model.dart` ou `{entity}.dart` | `medication_model.dart`, `heart_rate.dart` |
| ViewModel | `{feature}_viewmodel.dart` | `heart_rate_entry_viewmodel.dart` |
| Screen | `{feature}_screen.dart` | `heart_rate_entry_screen.dart` |

### 2.2 Classes

```dart
// Interfaces: abstract interface class (Dart 3.0+)
abstract interface class HeartRateRepository { }

// Implementações: final class com sufixo Impl
final class HeartRateRepositoryImpl implements HeartRateRepository { }

// Modelos: final class, opcionalmente com sufixo Model
final class MedicationModel { }
final class HeartRate { }

// ViewModels: final class com sufixo Viewmodel
final class HeartRateEntryViewmodel extends ChangeNotifier { }
```

### 2.3 Variáveis e Métodos

```dart
// Campos privados: prefixo underscore
final HeartRateRepository _repository;
final Logger _logger;

// Métodos de Repository: verbos CRUD descritivos
Future<Result<Entity>> createEntity({...});
Future<Result<List<Entity>>> getAllEntity();
Future<Result<Entity>> getEntityBy({required String id});
Future<Result<Entity>> updateEntity({...});
Future<Result<dynamic>> deleteEntity({required String id});

// Métodos paginados: sufixo Paginated
Future<Result<PaginatedResponse<Entity>>> getAllEntityPaginated({...});

// Métodos de agregação: prefixo get + Summary/Stats
Future<Result<MeasurementSummary>> getSummary({required String patientId});
```

### 2.4 Mapeamento de Nomes (Dart ↔ Database)

| Dart (camelCase) | Database (snake_case) |
|------------------|----------------------|
| `patientId` | `patient_id` |
| `createdAt` | `created_at` |
| `updatedAt` | `updated_at` |
| `bloodPressure` | `blood_pressure` |
| `oxygenSaturation` | `oxygen_saturation` |

**Conversão**: Feita automaticamente nos métodos `fromJson()` e `toJson()`.

---

## 3. Estrutura de Diretórios

```
lib/
├── config/
│   ├── constants/
│   │   └── http_types.dart                    # Enums: HttpMethod, Endpoint
│   ├── providers/
│   │   ├── external_providers.dart            # Libs externas (Dio, Storage)
│   │   ├── service_providers.dart             # Logger, ApiClient, HeaderBuilder
│   │   ├── repository_providers.dart          # Todos os repositories
│   │   └── viewmodel_providers.dart           # ViewModels globais
│   └── dependencies.dart                       # Agregador de todos os providers
│
├── core/
│   ├── interfaces/
│   │   └── logger.dart                        # Interface do Logger
│   └── services/
│       └── logger/
│           └── app_logger_impl.dart           # Implementação do Logger
│
├── data/
│   ├── repositories/
│   │   └── {entity_name}/
│   │       ├── {entity_name}_repository.dart          # Interface
│   │       └── {entity_name}_repository_impl.dart     # Implementação
│   │
│   └── services/
│       └── api/
│           ├── api_client/
│           │   ├── api_client.dart                    # Interface
│           │   └── api_client_impl.dart               # Implementação
│           └── http/
│               ├── endpoint_builder/
│               │   ├── endpoint_builder.dart          # Interface
│               │   └── endpoint_builder_impl.dart     # Implementação
│               ├── header_builder/
│               │   ├── header_builder.dart            # Interface
│               │   └── header_builder_impl.dart       # Implementação
│               └── response_parser.dart               # Utilitário
│
├── domain/
│   └── models/
│       ├── {entity_name}_model.dart            # Modelos de domínio
│       ├── paginated_response.dart             # Resposta paginada genérica
│       ├── pagination_params.dart              # Parâmetros de paginação
│       └── measurement_summary.dart            # Exemplo de modelo composto
│
├── exceptions/
│   └── app_exception.dart                      # Hierarquia de exceções
│
├── routing/
│   ├── router.dart                             # Configuração do GoRouter
│   └── routes.dart                             # Constantes de rotas
│
├── ui/
│   └── {feature_name}_screen/
│       ├── viewmodel/
│       │   └── {feature_name}_viewmodel.dart
│       └── widget/
│           └── {feature_name}_screen.dart
│
├── utils/
│   ├── result.dart                             # Result Pattern
│   ├── command.dart                            # Command Pattern
│   ├── paginated_command.dart                  # Command com paginação
│   └── app_logger.dart                         # Logger estático
│
└── main.dart                                   # Entry point
```

---

## 4. Mapeamento SQL → Dart

### 4.1 Tipos de Dados

| PostgreSQL (Supabase) | Dart | Observações |
|-----------------------|------|-------------|
| `UUID` | `String` | IDs gerados pelo Supabase |
| `TEXT` | `String` | Texto de tamanho variável |
| `VARCHAR(n)` | `String` | Texto com limite |
| `INTEGER` | `int` | Números inteiros |
| `SMALLINT` | `int` | Inteiros menores |
| `BIGINT` | `int` | Inteiros grandes |
| `NUMERIC` / `DECIMAL` | `double` | Números decimais |
| `BOOLEAN` | `bool` | Verdadeiro/Falso |
| `TIMESTAMP` | `DateTime` | Data e hora |
| `DATE` | `DateTime` | Apenas data |
| `TIME` | `String` | Formato "HH:mm:ss" |
| `JSONB` | `Map<String, dynamic>` | JSON estruturado |
| `ARRAY` | `List<T>` | Arrays |

### 4.2 Campos Especiais

#### Campos Auto-gerenciados pelo Banco
Campos com `DEFAULT` devem ser **excluídos do `toJson()`**:

```dart
// NÃO incluir no toJson():
// - id (gerado por gen_random_uuid())
// - created_at (default now())
// - updated_at (default now())

Map<String, dynamic> toJson() {
  return {
    'patient_id': patientId,
    'value': value,
    'date': date.toIso8601String(),
    // NÃO incluir: 'id', 'created_at', 'updated_at'
  };
}
```

#### Campos Nullable
Usar `?` em Dart para colunas SQL que permitem `NULL`:

```sql
notes TEXT NULL  -- Pode ser nulo
```

```dart
final String? notes;  // Nullable em Dart
```

#### Foreign Keys
```sql
patient_id UUID NOT NULL REFERENCES patients(id)
```

```dart
final String patientId;  // Obrigatório, referência ao ID do paciente
```

### 4.3 Conversão de Timestamps

```dart
// SQL → Dart (fromJson)
createdAt: DateTime.parse(
  json['created_at'] ?? DateTime.now().toString(),
),

// Dart → SQL (toJson)
'created_at': createdAt.toIso8601String(),
```

### 4.4 Exemplo Completo de Mapeamento

```sql
CREATE TABLE heart_rate (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id),
  value SMALLINT NOT NULL,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  time TIME WITHOUT TIME ZONE NULL,
  notes TEXT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
```

```dart
final class HeartRate {
  final String id;                // UUID → String
  final String patientId;         // UUID → String
  final int value;                // SMALLINT → int
  final DateTime date;            // TIMESTAMP → DateTime
  final String? time;             // TIME → String (nullable)
  final String? notes;            // TEXT NULL → String?
  final DateTime createdAt;       // TIMESTAMP → DateTime
  final DateTime updatedAt;       // TIMESTAMP → DateTime

  const HeartRate({
    required this.id,
    required this.patientId,
    required this.value,
    required this.date,
    this.time,               // Nullable
    this.notes,              // Nullable
    required this.createdAt,
    required this.updatedAt,
  });
}
```

---

## 5. Camada de Configuração

### 5.1 HTTP Types (`lib/config/constants/http_types.dart`)

#### 5.1.1 HttpMethod Enum
```dart
/// Métodos HTTP suportados
enum HttpMethod {
  get,
  post,
  patch,
  delete
}
```

#### 5.1.2 Endpoint Enum

**IMPORTANTE**: Adicionar novo endpoint para cada entidade.

```dart
/// Endpoints das tabelas do Supabase
enum Endpoint {
  heartRate,
  bloodPressure,
  temperature,
  respiratoryRate,
  oxygenSaturation,
  glucose,
  painLevel,
  medication;

  /// Retorna o nome da tabela no Supabase
  String get url => switch (this) {
    Endpoint.heartRate => 'heart_rate',
    Endpoint.bloodPressure => 'blood_pressure',
    Endpoint.temperature => 'temperature',
    Endpoint.respiratoryRate => 'respiratory_rate',
    Endpoint.oxygenSaturation => 'oxygen_saturation',
    Endpoint.glucose => 'glucose',
    Endpoint.painLevel => 'pain_level',
    Endpoint.medication => 'medications',
  };
}
```

**Para adicionar nova entidade**:
1. Adicionar valor ao enum (ex: `myNewEntity`)
2. Adicionar case ao switch com nome da tabela no Supabase

### 5.2 Dependency Injection

#### 5.2.1 Ordem CRÍTICA de Registro

**A ordem é FUNDAMENTAL!** Dependências devem ser registradas antes de serem consumidas:

```dart
// lib/config/dependencies.dart
List<SingleChildWidget> get providers {
  return [
    ...externalProviders,      // 1️⃣ Bibliotecas externas
    ...serviceProviders,        // 2️⃣ Serviços (dependem de 1)
    ...repositoryProviders,     // 3️⃣ Repositories (dependem de 2)
    ...viewmodelProviders,      // 4️⃣ ViewModels (dependem de 3)
  ];
}
```

#### 5.2.2 External Providers (`lib/config/providers/external_providers.dart`)

```dart
List<SingleChildWidget> get externalProviders {
  return [
    // Flutter Secure Storage (persistência segura)
    Provider(
      create: (context) => const FlutterSecureStorage(),
    ),

    // Internet Connection (verificação de conectividade)
    Provider(
      create: (context) => InternetConnection(),
    ),
  ];
}
```

#### 5.2.3 Service Providers (`lib/config/providers/service_providers.dart`)

```dart
List<SingleChildWidget> get serviceProviders {
  return [
    // 1. Logger (sem dependências)
    Provider(
      create: (context) => AppLoggerImpl() as Logger,
    ),

    // 2. Local Storage (depende de: FlutterSecureStorage, Logger)
    Provider(
      create: (context) => LocalSecureStorageImpl(
        storage: context.read<FlutterSecureStorage>(),
        logger: context.read<Logger>(),
      ) as LocalSecureStorage,
    ),

    // 3. Dio (depende de: Logger, LocalSecureStorage)
    Provider(
      create: (context) {
        final dio = Dio(
          BaseOptions(
            baseUrl: 'https://hqvximqtoskulhfltzvr.supabase.co',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

        // Adicionar interceptor de autenticação
        dio.interceptors.add(
          AuthInterceptor(
            storage: context.read<LocalSecureStorage>(),
            logger: context.read<Logger>(),
            dio: dio,
          ),
        );

        // Log de requisições (apenas debug)
        if (kDebugMode) {
          dio.interceptors.add(LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            error: true,
          ));
        }

        return dio;
      },
    ),

    // 4. Connection Checker (depende de: InternetConnection)
    Provider(
      create: (context) => ConnectionCheckerImpl(
        context.read<InternetConnection>(),
      ) as ConnectionChecker,
    ),

    // 5. Auth API Client (depende de: Dio, ConnectionChecker, Storage, Logger)
    Provider(
      create: (context) => AuthApiClientImpl(
        dio: context.read<Dio>(),
        connectionChecker: context.read<ConnectionChecker>(),
        storage: context.read<LocalSecureStorage>(),
        logger: context.read<Logger>(),
      ) as AuthApiClient,
    ),

    // 6. Header Builder (depende de: Storage, Logger, AuthApiClient)
    Provider(
      create: (context) => HeaderBuilderImpl(
        storage: context.read<LocalSecureStorage>(),
        logger: context.read<Logger>(),
        authApiClient: context.read<AuthApiClient>(),
      ) as HeaderBuilder,
    ),

    // 7. API Client (depende de: Dio, ConnectionChecker, HeaderBuilder, Logger)
    Provider(
      create: (context) => ApiClientImpl(
        dio: context.read<Dio>(),
        connectionChecker: context.read<ConnectionChecker>(),
        headerService: context.read<HeaderBuilder>(),
        logger: context.read<Logger>(),
      ) as ApiClient,
    ),
  ];
}
```

#### 5.2.4 Repository Providers (`lib/config/providers/repository_providers.dart`)

**TEMPLATE PARA NOVO REPOSITORY**:

```dart
List<SingleChildWidget> get repositoryProviders {
  return [
    // HeartRate Repository
    Provider(
      create: (context) => HeartRateRepositoryImpl(
        apiClient: context.read<ApiClient>(),
        headerService: context.read<HeaderBuilder>(),
        endpointBuilder: EndpointBuilderImpl(endpoint: Endpoint.heartRate),
        logger: context.read<Logger>(),
      ) as HeartRateRepository,
    ),

    // Medication Repository
    Provider(
      create: (context) => MedicationRepositoryImpl(
        apiClient: context.read<ApiClient>(),
        headerService: context.read<HeaderBuilder>(),
        endpointBuilder: EndpointBuilderImpl(endpoint: Endpoint.medication),
        logger: context.read<Logger>(),
      ) as MedicationRepository,
    ),

    // ⭐ ADICIONAR NOVOS REPOSITORIES AQUI ⭐
  ];
}
```

**Padrão**:
- Injetar: `ApiClient`, `HeaderBuilder`, `Logger`
- Criar inline: `EndpointBuilderImpl(endpoint: Endpoint.{entity})`
- Cast para interface: `as {Entity}Repository`

#### 5.2.5 ViewModel Providers (`lib/config/providers/viewmodel_providers.dart`)

**Apenas para ViewModels GLOBAIS** (compartilhados entre múltiplas telas):

```dart
List<SingleChildWidget> get viewmodelProviders {
  return [
    // Medication ViewModel (global - lista compartilhada)
    Provider(
      create: (context) => MedicationViewModel(
        medicationRepository: context.read<MedicationRepository>(),
      ),
    ),

    // VitalSignDetail ViewModel (global)
    Provider(
      create: (context) => VitalSignDetailViewmodel(
        heartRateMeasurementRepository: context.read<HeartRateRepository>(),
      ),
    ),

    // ⭐ ViewModels de entrada/edição NÃO vão aqui! ⭐
    // Eles são instanciados localmente nas rotas.
  ];
}
```

**Quando NÃO registrar ViewModel como Provider**:
- ViewModels de telas de entrada (create/edit)
- ViewModels descartáveis após navegação
- ViewModels com estado temporário

Esses são instanciados diretamente no `GoRoute`:

```dart
GoRoute(
  path: Routes.heartRateEntry,
  builder: (context, state) {
    return HeartRateEntryScreen(
      viewmodel: HeartRateEntryViewmodel(
        repository: context.read<HeartRateRepository>(),
      ),
    );
  },
),
```

---

## 6. Camada de Serviço

### 6.1 ApiClient

#### 6.1.1 Interface (`lib/data/services/api/api_client/api_client.dart`)

```dart
typedef PaginatedRequestResponse = ({
  dynamic data,
  Map<String, dynamic> headers,
});

abstract interface class ApiClient {
  /// Requisição padrão
  Future<Result<dynamic>> request({
    required ({String url, HttpMethod method}) endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  /// Requisição paginada (retorna headers com Content-Range)
  Future<Result<PaginatedRequestResponse>> paginatedRequest({
    required ({String url, HttpMethod method}) endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });
}
```

#### 6.1.2 Responsabilidades do ApiClient

- ✅ Verificar conexão de internet antes de requisitar
- ✅ Executar requisição HTTP via Dio
- ✅ Mapear status codes HTTP → exceções tipadas
- ✅ Tratar timeouts e erros de rede
- ✅ Retornar Result<T> (nunca throw exceptions)
- ✅ Logar todas as operações

#### 6.1.3 Mapeamento de Status Codes

```dart
Result<dynamic> _handleSuccessResponse(Response response) {
  return switch (response.statusCode) {
    200 || 201 => Result.ok(response.data),           // OK / Created
    204 => Result.ok(null),                           // No Content
    400 => Result.error(RequisicaoInvalidaException()), // Bad Request
    401 => Result.error(NaoAutorizadoException()),    // Unauthorized
    403 => Result.error(AcessoProibidoException()),   // Forbidden
    404 => Result.error(RecursoNaoEncontradoException()), // Not Found
    500 => Result.error(ErroInternoServidorException()), // Internal Error
    503 => Result.error(ServidorIndisponivelException()), // Service Unavailable
    _ => Result.error(ServidorIndisponivelException()),
  };
}
```

### 6.2 EndpointBuilder

#### 6.2.1 Interface (`lib/data/services/api/http/endpoint_builder/endpoint_builder.dart`)

```dart
abstract interface class EndpointBuilder {
  /// CREATE (POST)
  ({String url, HttpMethod method}) create();

  /// UPDATE (PATCH)
  ({String url, HttpMethod method}) update({required String id});

  /// GET ALL (GET)
  ({String url, HttpMethod method}) getAll({Map<String, String>? filters});

  /// DELETE (DELETE)
  ({String url, HttpMethod method}) delete({required String id});

  /// GET com filtros customizados (GET)
  ({String url, HttpMethod method}) getFilter({
    required Map<String, String> queryParameters,
  });

  /// GET ALL com paginação (GET)
  ({String url, HttpMethod method}) getAllPaginated({
    required int offset,
    required int limit,
    Map<String, String>? filters,
  });

  /// GET Summary/Agregação (GET)
  ({String url, HttpMethod method}) getSummary({
    required String patientId,
  });
}
```

#### 6.2.2 Implementação (`lib/data/services/api/http/endpoint_builder/endpoint_builder_impl.dart`)

```dart
final class EndpointBuilderImpl implements EndpointBuilder {
  EndpointBuilderImpl({required Endpoint endpoint}) : _endpoint = endpoint;

  final Endpoint _endpoint;

  static const String _baseUrl = 'https://hqvximqtoskulhfltzvr.supabase.co';
  static const String _restUrl = '/rest/v1/';

  @override
  ({String url, HttpMethod method}) create() {
    return (
      url: '$_baseUrl$_restUrl${_endpoint.url}',
      method: HttpMethod.post,
    );
  }

  @override
  ({String url, HttpMethod method}) update({required String id}) {
    return (
      url: '$_baseUrl$_restUrl${_endpoint.url}?id=eq.$id',
      method: HttpMethod.patch,
    );
  }

  @override
  ({String url, HttpMethod method}) getAll({Map<String, String>? filters}) {
    var url = '$_baseUrl$_restUrl${_endpoint.url}?select=*';

    if (filters != null && filters.isNotEmpty) {
      url += '&${_buildFilters(filters)}';
    }

    return (url: url, method: HttpMethod.get);
  }

  @override
  ({String url, HttpMethod method}) delete({required String id}) {
    return (
      url: '$_baseUrl$_restUrl${_endpoint.url}?id=eq.$id',
      method: HttpMethod.delete,
    );
  }

  @override
  ({String url, HttpMethod method}) getFilter({
    required Map<String, String> queryParameters,
  }) {
    final filters = _buildFilters(queryParameters);
    return (
      url: '$_baseUrl$_restUrl${_endpoint.url}?select=*&$filters',
      method: HttpMethod.get,
    );
  }

  @override
  ({String url, HttpMethod method}) getAllPaginated({
    required int offset,
    required int limit,
    Map<String, String>? filters,
  }) {
    var url = '$_baseUrl$_restUrl${_endpoint.url}?select=*';

    if (filters != null && filters.isNotEmpty) {
      url += '&${_buildFilters(filters)}';
    }

    url += '&offset=$offset&limit=$limit';

    return (url: url, method: HttpMethod.get);
  }

  @override
  ({String url, HttpMethod method}) getSummary({required String patientId}) {
    // Supabase usa views/functions com sufixo _summary
    final summaryUrl = switch (_endpoint) {
      Endpoint.heartRate => 'heart_rate_summary',
      Endpoint.bloodPressure => 'blood_pressure_summary',
      Endpoint.temperature => 'temperature_summary',
      // ... adicionar outros
      _ => '${_endpoint.url}_summary',
    };

    return (
      url: '$_baseUrl$_restUrl$summaryUrl?select=*&patient_id=eq.$patientId',
      method: HttpMethod.get,
    );
  }

  /// Helper: Constrói query string de filtros
  /// Exemplo: {'user_id': '123', 'active': 'true'} → 'user_id=eq.123&active=eq.true'
  static String _buildFilters(Map<String, String> filters) {
    return filters.entries
        .map((e) => '${e.key}=eq.${e.value}')
        .join('&');
  }
}
```

### 6.3 HeaderBuilder

#### 6.3.1 Interface (`lib/data/services/api/http/header_builder/header_builder.dart`)

```dart
abstract interface class HeaderBuilder {
  /// Headers padrão (com ou sem autenticação)
  Future<Map<String, String>> getHeaders({bool includeAuth = true});

  /// Headers com Prefer (para operações Supabase)
  Future<Map<String, String>> getHeadersWithPrefer(String preferValue);

  /// Headers com Range (para paginação)
  Future<Map<String, String>> getHeadersWithRange({
    required int start,
    required int end,
  });
}
```

#### 6.3.2 Responsabilidades

- ✅ Injetar API Key do Supabase
- ✅ Injetar Bearer Token (access_token)
- ✅ Verificar expiração do token
- ✅ Renovar token automaticamente se expirado
- ✅ Adicionar headers especiais (Prefer, Range)
- ✅ Cache da API Key

#### 6.3.3 Headers Padrão

```dart
{
  'apikey': 'SUPABASE_PUBLISHABLE_KEY',
  'Content-Type': 'application/json',
  'Authorization': 'Bearer {access_token}',
}
```

#### 6.3.4 Headers Especiais do Supabase

**Prefer: return=representation**
- Usado em POST/PATCH
- Retorna o objeto criado/atualizado na resposta
- Evita requisição adicional para buscar o objeto

```dart
final headers = await _headerService.getHeadersWithPrefer('return=representation');
```

**Range: start-end**
- Usado em GET com paginação
- Especifica intervalo de itens desejados
- Supabase retorna Content-Range no response

```dart
final headers = await _headerService.getHeadersWithRange(start: 0, end: 19);
```

### 6.4 ResponseParser

Utilitário para extrair informações de headers de resposta:

```dart
final class ResponseParser {
  /// Parse Content-Range header do Supabase
  /// Formato: "0-19/100" significa itens 0-19 de 100 totais
  static ({int start, int end, int total}) parseContentRange(
    Map<String, dynamic> headers,
  ) {
    final contentRange = headers['content-range'] ?? headers['Content-Range'];

    if (contentRange == null) {
      throw FormatException('Content-Range header not found');
    }

    final rangeString = contentRange.toString();

    // Caso especial: lista vazia "*/0"
    if (rangeString.startsWith('*/')) {
      final total = int.parse(rangeString.substring(2));
      return (start: 0, end: -1, total: total);
    }

    // Parse "start-end/total"
    final parts = rangeString.split('/');
    final rangeParts = parts[0].split('-');

    return (
      start: int.parse(rangeParts[0]),
      end: int.parse(rangeParts[1]),
      total: int.parse(parts[1]),
    );
  }

  /// Extrai apenas o total de itens
  static int getTotalCount(Map<String, dynamic> headers) {
    try {
      return parseContentRange(headers).total;
    } catch (_) {
      return 0;
    }
  }
}
```

---

## 7. Camada de Repositório

### 7.1 Interface do Repository

**TEMPLATE** (`lib/data/repositories/{entity}/{entity}_repository.dart`):

```dart
import 'package:palliative_care/domain/models/{entity}.dart';
import 'package:palliative_care/domain/models/paginated_response.dart';
import 'package:palliative_care/domain/models/pagination_params.dart';
import 'package:palliative_care/utils/result.dart';

abstract interface class {Entity}Repository {
  /// Buscar todos os registros
  Future<Result<List<{Entity}>>> getAll{Entity}();

  /// Buscar todos com paginação
  Future<Result<PaginatedResponse<{Entity}>>> getAll{Entity}Paginated({
    required PaginationParams params,
  });

  /// Buscar por ID
  Future<Result<{Entity}>> get{Entity}By({
    required String id,
  });

  /// Criar novo registro
  Future<Result<{Entity}>> create{Entity}({
    required {Entity} entity,
  });

  /// Atualizar registro existente
  Future<Result<{Entity}>> update{Entity}({
    required {Entity} entity,
  });

  /// Deletar registro
  Future<Result<dynamic>> delete{Entity}({
    required String id,
  });
}
```

**Métodos Opcionais** (adicionar conforme necessário):

```dart
// Se houver filtros específicos
Future<Result<List<{Entity}>>> get{Entity}ByUserId({
  required String userId,
});

// Se houver agregações/summary
Future<Result<MeasurementSummary>> getSummary({
  required String patientId,
});

// Se houver busca por múltiplos critérios
Future<Result<List<{Entity}>>> search({
  required Map<String, dynamic> filters,
});
```

### 7.2 Implementação do Repository

**TEMPLATE** (`lib/data/repositories/{entity}/{entity}_repository_impl.dart`):

```dart
import 'package:palliative_care/core/interfaces/logger.dart';
import 'package:palliative_care/data/repositories/{entity}/{entity}_repository.dart';
import 'package:palliative_care/data/services/api/api_client/api_client.dart';
import 'package:palliative_care/data/services/api/http/endpoint_builder/endpoint_builder.dart';
import 'package:palliative_care/data/services/api/http/header_builder/header_builder.dart';
import 'package:palliative_care/data/services/api/http/response_parser.dart';
import 'package:palliative_care/domain/models/{entity}.dart';
import 'package:palliative_care/domain/models/paginated_response.dart';
import 'package:palliative_care/domain/models/pagination_params.dart';
import 'package:palliative_care/exceptions/app_exception.dart';
import 'package:palliative_care/utils/result.dart';

final class {Entity}RepositoryImpl implements {Entity}Repository {
  final ApiClient _apiClient;
  final HeaderBuilder _headerService;
  final EndpointBuilder _endpointBuilder;
  final Logger _logger;
  static const String _logTag = '{Entity}Repository';

  {Entity}RepositoryImpl({
    required ApiClient apiClient,
    required HeaderBuilder headerService,
    required EndpointBuilder endpointBuilder,
    required Logger logger,
  }) : _apiClient = apiClient,
       _headerService = headerService,
       _endpointBuilder = endpointBuilder,
       _logger = logger;

  @override
  Future<Result<{Entity}>> create{Entity}({
    required {Entity} entity,
  }) async {
    try {
      // Use Prefer header para receber o objeto criado na resposta
      final headers = await _headerService.getHeadersWithPrefer(
        'return=representation'
      );
      final endpoint = _endpointBuilder.create();

      _logger.info('Creating {entity}', tag: _logTag);

      final response = await _apiClient.request(
        endpoint: endpoint,
        body: entity.toJson(),
        headers: headers,
      ).map((data) => {Entity}.fromJson(data));

      return response;
    } catch (e, s) {
      _logger.error(
        'Error serializing {entity}',
        error: e,
        stackTrace: s,
        tag: _logTag,
      );
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<{Entity}>>> getAll{Entity}() async {
    try {
      _logger.info('Fetching all {entity}s', tag: _logTag);

      return await _apiClient.request(
        endpoint: _endpointBuilder.getAll()
      ).map((data) {
        return (data as List)
            .map((json) => {Entity}.fromJson(json))
            .toList();
      });
    } catch (e, s) {
      _logger.error(
        'Error serializing {entity}s',
        error: e,
        stackTrace: s,
        tag: _logTag,
      );
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<PaginatedResponse<{Entity}>>> getAll{Entity}Paginated({
    required PaginationParams params,
  }) async {
    try {
      final endpoint = _endpointBuilder.getAllPaginated(
        offset: params.offset,
        limit: params.limit,
        filters: params.filters,
      );

      final headers = await _headerService.getHeadersWithRange(
        start: params.startIndex,
        end: params.endIndex,
      );

      _logger.info(
        'Fetching paginated {entity}s - Page: ${params.page}, Size: ${params.pageSize}',
        tag: _logTag,
      );

      final response = await _apiClient.paginatedRequest(
        endpoint: endpoint,
        headers: headers,
      );

      return response.map((paginatedData) {
        final items = (paginatedData.data as List)
            .map((json) => {Entity}.fromJson(json))
            .toList();

        final total = ResponseParser.getTotalCount(paginatedData.headers);

        _logger.info(
          'Fetched ${items.length} {entity}s, Total: $total',
          tag: _logTag,
        );

        return PaginatedResponse<{Entity}>(
          items: items,
          total: total,
          page: params.page,
          pageSize: params.pageSize,
        );
      });
    } catch (e, s) {
      _logger.error(
        'Error fetching paginated {entity}s',
        error: e,
        stackTrace: s,
        tag: _logTag,
      );
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<{Entity}>> get{Entity}By({
    required String id,
  }) async {
    try {
      _logger.info('Fetching {entity} with id: $id', tag: _logTag);

      final endpoint = _endpointBuilder.getFilter(
        queryParameters: {'id': id},
      );

      final response = await _apiClient.request(endpoint: endpoint)
          .map((data) => {Entity}.fromJson(data));

      return response;
    } catch (e, s) {
      _logger.error(
        'Error serializing {entity}',
        error: e,
        stackTrace: s,
        tag: _logTag,
      );
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<{Entity}>> update{Entity}({
    required {Entity} entity,
  }) async {
    try {
      _logger.info('Updating {entity} with id: ${entity.id}', tag: _logTag);

      final endpoint = _endpointBuilder.update(id: entity.id);

      final response = await _apiClient.request(
        endpoint: endpoint,
        body: entity.toJson(),
      ).map((data) => {Entity}.fromJson(data));

      return response;
    } catch (e, s) {
      _logger.error(
        'Error serializing {entity}',
        error: e,
        stackTrace: s,
        tag: _logTag,
      );
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> delete{Entity}({
    required String id,
  }) async {
    _logger.info('Deleting {entity} with id: $id', tag: _logTag);

    final endpoint = _endpointBuilder.delete(id: id);
    return await _apiClient.request(endpoint: endpoint);
  }
}
```

### 7.3 Pontos de Atenção

#### ✅ SEMPRE usar try-catch em serialização
```dart
try {
  return await _apiClient.request(...)
    .map((data) => Entity.fromJson(data));
} catch (e, s) {
  _logger.error('Serialization error', error: e, stackTrace: s, tag: _logTag);
  return Result.error(UnknownErrorException());
}
```

#### ✅ SEMPRE usar Prefer header no create
```dart
final headers = await _headerService.getHeadersWithPrefer('return=representation');
```

#### ✅ SEMPRE logar operações importantes
```dart
_logger.info('Creating entity', tag: _logTag);
_logger.error('Error creating entity', error: e, stackTrace: s, tag: _logTag);
```

#### ✅ SEMPRE retornar Result<T>
```dart
// ❌ NUNCA fazer isso
throw Exception('Error');

// ✅ SEMPRE fazer isso
return Result.error(UnknownErrorException());
```

---

## 8. Camada de Domínio

### 8.1 Modelo de Domínio - Template Completo

**ARQUIVO**: `lib/domain/models/{entity}_model.dart` ou `lib/domain/models/{entity}.dart`

```dart
/// Modelo de domínio para {Entity}
///
/// Representa {descrição breve da entidade} no sistema com todos os dados
/// necessários para a lógica de negócio.
final class {Entity}Model {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const {Entity}Model({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria instância a partir de JSON (API response)
  factory {Entity}Model.fromJson(Map<String, dynamic> json) {
    return {Entity}Model(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toString(),
      ),
    );
  }

  /// Converte para JSON (API request)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      // NÃO incluir: id, created_at, updated_at (gerenciados pelo DB)
    };
  }

  /// Cria cópia com campos atualizados
  {Entity}Model copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {Entity}Model(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '{Entity}Model(id: $id, userId: $userId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is {Entity}Model &&
        other.id == id &&
        other.userId == userId &&
        other.name == name;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, name, createdAt, updatedAt);
  }
}
```

### 8.2 Regras para fromJson()

#### ✅ Sempre fornecer defaults para evitar nulls
```dart
id: json['id'] ?? '',
name: json['name'] ?? '',
value: json['value'] ?? 0,
isActive: json['is_active'] ?? false,
```

#### ✅ Parse correto de timestamps
```dart
createdAt: DateTime.parse(
  json['created_at'] ?? DateTime.now().toString(),
),
```

#### ✅ Campos nullable sem default
```dart
notes: json['notes'] as String?,
description: json['description'] as String?,
```

#### ✅ Tratamento de listas
```dart
tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
```

#### ✅ Tratamento de objetos aninhados
```dart
user: json['user'] != null ? User.fromJson(json['user']) : null,
```

#### ⚠️ Supabase retorna lista em algumas operações
```dart
// Alguns endpoints do Supabase retornam array ao invés de objeto único
factory HeartRate.fromJson(dynamic list) {
  final json = list.first as Map<String, dynamic>;
  return HeartRate(
    id: json['id'],
    // ...
  );
}
```

### 8.3 Regras para toJson()

#### ✅ Excluir campos auto-gerenciados
```dart
Map<String, dynamic> toJson() {
  return {
    'user_id': userId,
    'name': name,
    'value': value,
    // ❌ NÃO incluir: id, created_at, updated_at
  };
}
```

#### ✅ Converter DateTime para ISO 8601
```dart
'date': date.toIso8601String(),
'created_at': createdAt.toIso8601String(),
```

#### ✅ Incluir campos nullable
```dart
'notes': notes,  // Será null se vazio, OK para Supabase
'description': description,
```

#### ✅ Converter enums
```dart
'status': status.name,  // Enum → String
'priority': priority.index,  // Enum → int
```

### 8.4 Modelos de Paginação

#### PaginationParams (`lib/domain/models/pagination_params.dart`)

```dart
final class PaginationParams {
  final int page;           // 1-indexed (primeira página = 1)
  final int pageSize;
  final Map<String, String>? filters;

  const PaginationParams({
    required this.page,
    required this.pageSize,
    this.filters,
  });

  static const PaginationParams defaultParams = PaginationParams(
    page: 1,
    pageSize: 20,
  );

  // Helpers para Supabase
  int get offset => (page - 1) * pageSize;
  int get limit => pageSize;
  int get startIndex => offset;
  int get endIndex => offset + pageSize - 1;

  PaginationParams copyWith({
    int? page,
    int? pageSize,
    Map<String, String>? filters,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      filters: filters ?? this.filters,
    );
  }

  PaginationParams nextPage() => copyWith(page: page + 1);
  PaginationParams previousPage() => copyWith(page: page > 1 ? page - 1 : 1);
  PaginationParams reset() => copyWith(page: 1);
}
```

#### PaginatedResponse (`lib/domain/models/paginated_response.dart`)

```dart
final class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  bool get hasMore => (page * pageSize) < total;
  int get totalPages => (total / pageSize).ceil();
  int get startIndex => (page - 1) * pageSize;
  int get endIndex => (startIndex + items.length - 1).clamp(0, total - 1);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  PaginatedResponse<T> copyWith({
    List<T>? items,
    int? total,
    int? page,
    int? pageSize,
  }) {
    return PaginatedResponse<T>(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  String toString() {
    return 'PaginatedResponse<$T>(items: ${items.length}, total: $total, page: $page/$totalPages)';
  }
}
```

---

## 9. Camada de ViewModel

### 9.1 Command Pattern

Os Commands encapsulam operações assíncronas e gerenciam automaticamente:
- ✅ Estado de loading (`running`)
- ✅ Estado de erro (`error`, `errorMessage`)
- ✅ Estado de sucesso (`completed`)
- ✅ Valor de retorno (`value`)
- ✅ Notificação de listeners

#### Command0 - Sem Parâmetros
```dart
final Command0<List<Item>> loadItems;

loadItems = Command0(() async {
  return await repository.getAll();
});

// Executar
await loadItems.execute();
```

#### Command1 - Com Um Parâmetro
```dart
final Command1<User, String> getUserById;

getUserById = Command1((String id) async {
  return await repository.getById(id: id);
});

// Executar
await getUserById.execute('user-123');
```

### 9.2 ViewModel Simples (Tela de Entrada)

**TEMPLATE** (`lib/ui/{feature}_entry_screen/viewmodel/{feature}_entry_viewmodel.dart`):

```dart
import 'package:flutter/foundation.dart';
import 'package:palliative_care/data/repositories/{entity}/{entity}_repository.dart';
import 'package:palliative_care/domain/models/{entity}.dart';
import 'package:palliative_care/utils/command.dart';
import 'package:palliative_care/utils/result.dart';

final class {Entity}EntryViewmodel extends ChangeNotifier {
  {Entity}EntryViewmodel({required {Entity}Repository repository})
      : _repository = repository {
    createEntity = Command1(_createEntity);
  }

  final {Entity}Repository _repository;

  late final Command1<{Entity}, {Entity}> createEntity;

  Future<Result<{Entity}>> _createEntity({Entity} entity) async {
    return await _repository.create{Entity}(entity: entity);
  }
}
```

**Quando usar ViewModel Simples**:
- ✅ Telas de criação/edição de item único
- ✅ Formulários de entrada
- ✅ ViewModels descartáveis após navegação
- ✅ Estado temporário

**Como instanciar**:
```dart
// NÃO registrar como Provider global!
// Instanciar localmente na rota:
GoRoute(
  path: Routes.entityEntry,
  builder: (context, state) {
    return EntityEntryScreen(
      viewmodel: EntityEntryViewmodel(
        repository: context.read<EntityRepository>(),
      ),
    );
  },
),
```

### 9.3 ViewModel Complexo (Lista com CRUD Completo)

**TEMPLATE** (`lib/ui/{feature}_screen/viewmodel/{feature}_viewmodel.dart`):

```dart
import 'package:palliative_care/data/repositories/{entity}/{entity}_repository.dart';
import 'package:palliative_care/domain/models/{entity}.dart';
import 'package:palliative_care/domain/models/pagination_params.dart';
import 'package:palliative_care/utils/command.dart';
import 'package:palliative_care/utils/paginated_command.dart';
import 'package:palliative_care/utils/result.dart';

final class {Entity}Viewmodel {
  {Entity}Viewmodel({required {Entity}Repository repository})
      : _repository = repository {
    // Comando paginado para lista
    getAllEntities = PaginatedCommand<{Entity}>(
      action: (params) => _repository.getAll{Entity}Paginated(
        params: params,
      ),
      pageSize: 20,
    );

    // Comandos CRUD
    getEntityBy = Command1(_getEntityBy);
    createEntity = Command1(_createEntity);
    updateEntity = Command1(_updateEntity);
    deleteEntity = Command1(_deleteEntity);
  }

  final {Entity}Repository _repository;

  /// Getters convenientes para a lista
  ValueNotifier<List<{Entity}>> get entitiesNotifier =>
    getAllEntities.itemsNotifier;
  List<{Entity}> get entities => getAllEntities.items;

  /// CRUD Commands
  late final PaginatedCommand<{Entity}> getAllEntities;
  late final Command1<{Entity}, String> getEntityBy;
  late final Command1<{Entity}, {Entity}> createEntity;
  late final Command1<{Entity}, {Entity}> updateEntity;
  late final Command1<dynamic, String> deleteEntity;

  /// Helper: Atualiza lista local preservando estado de paginação
  void _updateItemsList(List<{Entity}> Function(List<{Entity}>) updateFn) {
    final currentItems = List<{Entity}>.from(getAllEntities.items);
    final updatedItems = updateFn(currentItems);
    getAllEntities.itemsNotifier.value = updatedItems;
  }

  Future<Result<{Entity}>> _getEntityBy(String id) async {
    return await _repository.get{Entity}By(id: id);
  }

  Future<Result<{Entity}>> _createEntity({Entity} entity) async {
    return await _repository.create{Entity}(entity: entity)
        .map((created) {
      // Adiciona à lista local sem quebrar paginação
      _updateItemsList((items) => [created, ...items]);
      return created;
    });
  }

  Future<Result<{Entity}>> _updateEntity({Entity} entity) async {
    return await _repository.update{Entity}(entity: entity)
        .map((updated) {
      // Atualiza na lista local
      _updateItemsList((items) => items.map((item) {
        return item.id == updated.id ? updated : item;
      }).toList());
      return updated;
    });
  }

  Future<Result<dynamic>> _deleteEntity(String id) async {
    return await _repository.delete{Entity}(id: id)
        .map((_) {
      // Remove da lista local
      _updateItemsList((items) =>
        items.where((item) => item.id != id).toList()
      );
      return Result.ok(null);
    });
  }
}
```

**Quando usar ViewModel Complexo**:
- ✅ Telas de listagem com paginação infinita
- ✅ Telas com CRUD completo
- ✅ Estado compartilhado entre múltiplas telas
- ✅ ViewModels que devem persistir durante navegação

**Como registrar**:
```dart
// Registrar como Provider GLOBAL em viewmodel_providers.dart
Provider(
  create: (context) => EntityViewmodel(
    repository: context.read<EntityRepository>(),
  ),
),
```

### 9.4 PaginatedCommand - Uso Detalhado

```dart
// Inicializar
getAllEntities = PaginatedCommand<Entity>(
  action: (params) => repository.getAllPaginated(params: params),
  pageSize: 20,
);

// Carregar primeira página
await getAllEntities.execute();

// Carregar próxima página (infinite scroll)
await getAllEntities.loadMore();

// Refresh (volta para página 1)
await getAllEntities.refresh();

// Reset completo
getAllEntities.reset();

// Acessar dados
final items = getAllEntities.items;  // List<Entity>
final hasMore = getAllEntities.hasMore;  // bool
final isLoading = getAllEntities.running;  // bool
final isLoadingMore = getAllEntities.isLoadingMore;  // bool
final total = getAllEntities.total;  // int
final currentPage = getAllEntities.currentPage;  // int
```

### 9.5 Atualização de Estado Local

**Por que atualizar lista local após create/update/delete?**
- ✅ UI atualiza instantaneamente (otimistic update)
- ✅ Evita reload completo da lista
- ✅ Preserva estado de paginação
- ✅ Melhor UX

**Como fazer corretamente**:
```dart
Future<Result<Entity>> _createEntity(Entity entity) async {
  return await _repository.createEntity(entity: entity)
      .map((created) {
    // ✅ Adiciona no INÍCIO da lista
    _updateItemsList((items) => [created, ...items]);
    return created;
  });
}

Future<Result<Entity>> _updateEntity(Entity entity) async {
  return await _repository.updateEntity(entity: entity)
      .map((updated) {
    // ✅ Substitui item na lista
    _updateItemsList((items) => items.map((item) {
      return item.id == updated.id ? updated : item;
    }).toList());
    return updated;
  });
}

Future<Result<dynamic>> _deleteEntity(String id) async {
  return await _repository.deleteEntity(id: id)
      .map((_) {
    // ✅ Remove da lista
    _updateItemsList((items) =>
      items.where((item) => item.id != id).toList()
    );
    return Result.ok(null);
  });
}
```

---

## 10. Camada de Roteamento

### 10.1 Definição de Rotas (`lib/routing/routes.dart`)

```dart
abstract final class Routes {
  // Rotas principais (bottom navigation)
  static const home = '/home';
  static const medications = '/medication';
  static const tutorial = '/tutorial';
  static const settings = '/setting';
  static const signin = '/signin';

  // Rotas de detalhe (parâmetro de path)
  static const vitalSignDetail = 'vital-sign/:id';
  static const medicationDetail = '/medications/:id';
  static const medicationEdit = '/medications/:id/edit';

  // Rotas de entrada (standalone)
  static const medicationNew = '/medications/new';
  static const heartRateEntry = '/vital-sign/heart-rate/entry';

  // Helpers para navegação com IDs
  static String vitalSignDetailWithId(String id) => '/home/vital-sign/$id';
  static String medicationDetailWithId(String id) => '/medications/$id';
  static String medicationEditWithId(String id) => '/medications/$id/edit';

  // Helpers com query parameters
  static String heartRateEntryWithPatient(String patientId) =>
    '/vital-sign/heart-rate/entry?patientId=$patientId';
}
```

**Convenções**:
- Rotas principais: começam com `/`
- Sub-rotas: path relativo (sem `/` inicial)
- Parâmetros de path: `:paramName`
- Query parameters: adicionados via helpers

### 10.2 Configuração do Router (`lib/routing/router.dart`)

#### Template para Nova Rota de Entrada

```dart
GoRoute(
  path: Routes.{entity}Entry,
  builder: (context, state) {
    // Extrair query parameters (opcional)
    final patientId = state.uri.queryParameters['patientId'] ?? '';

    // Extrair path parameters (se houver)
    // final id = state.pathParameters['id']!;

    // Obter repository do Provider
    final repository = Provider.of<{Entity}Repository>(
      context,
      listen: false,
    );

    // Instanciar ViewModel localmente
    return {Entity}EntryScreen(
      patientId: patientId,  // Passar parâmetros necessários
      viewmodel: {Entity}EntryViewmodel(
        repository: repository,
      ),
    );
  },
),
```

#### Template para Rota de Listagem

```dart
GoRoute(
  path: Routes.{entity}s,
  pageBuilder: (context, state) {
    // Obter ViewModel global do Provider
    final viewModel = Provider.of<{Entity}Viewmodel>(
      context,
      listen: false,
    );

    return NoTransitionPage(
      child: {Entity}Screen(viewModel: viewModel),
    );
  },
),
```

#### Template para Rota de Detalhe

```dart
GoRoute(
  path: Routes.{entity}Detail,
  builder: (context, state) {
    // Extrair ID do path
    final id = state.pathParameters['id']!;

    return {Entity}DetailScreen(
      {entity}Id: id,
      viewmodel: context.read<{Entity}Viewmodel>(),
    );
  },
),
```

### 10.3 Rotas Aninhadas (Shell Routes)

Para rotas com bottom navigation bar:

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return ScaffoldWithNavBar(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: Routes.home,
          pageBuilder: (context, state) =>
              NoTransitionPage(child: HomeScreen()),
          routes: [
            // Sub-rotas dentro do Home
            GoRoute(
              path: Routes.vitalSignDetail,  // Relativo: 'vital-sign/:id'
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return VitalSignDetailScreen(vitalSignId: id);
              },
            ),
          ],
        ),
      ],
    ),

    StatefulShellBranch(
      routes: [
        GoRoute(
          path: Routes.medications,
          pageBuilder: (context, state) {
            final viewModel = context.read<MedicationViewmodel>();
            return NoTransitionPage(
              child: MedicationScreen(viewModel: viewModel),
            );
          },
        ),
      ],
    ),
  ],
),
```

### 10.4 Redirect para Autenticação

```dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<AuthRepository>().isAuthenticated();
  final loggingIn = state.matchedLocation == Routes.signin;

  // Se não autenticado, redireciona para signin
  if (!loggedIn) {
    return Routes.signin;
  }

  // Se autenticado e tentando acessar signin, vai para home
  if (loggingIn) {
    return Routes.home;
  }

  // Permite acesso
  return null;
}
```

### 10.5 Navegação no Código

```dart
// Push (adiciona na pilha)
context.push(Routes.entityDetailWithId('123'));

// Go (substitui a rota atual)
context.go(Routes.home);

// Pop (volta)
Navigator.pop(context);

// Pop com resultado
Navigator.pop(context, true);

// Push com resultado
final result = await context.push<bool>(Routes.entityEntry);
if (result == true) {
  // Atualizar lista
  viewmodel.getAllEntities.refresh();
}
```

---

## 11. Padrão Result

### 11.1 Conceito

Result<T> encapsula operações que podem falhar, forçando tratamento explícito:
- **Ok<T>**: operação bem-sucedida, contém valor T
- **Error<T>**: operação falhou, contém AppException

### 11.2 Criando Results

```dart
// Sucesso
Result<User> getUser() {
  return Result.ok(user);
}

// Erro
Result<User> getUser() {
  return Result.error(RecursoNaoEncontradoException());
}
```

### 11.3 Consumindo Results

#### Using `when` (side effects)
```dart
result.when(
  onOk: (user) => print('User: ${user.name}'),
  onError: (error) => print('Error: ${error.message}'),
);
```

#### Using `fold` (retorna valor)
```dart
final message = result.fold(
  onOk: (user) => 'Welcome ${user.name}',
  onError: (error) => 'Error: ${error.message}',
);
```

#### Using `map` (transforma sucesso)
```dart
final upperName = result.map((user) => user.name.toUpperCase());
// Result<User> → Result<String>
```

#### Using `flatMap` (encadeia operações que podem falhar)
```dart
final userProfile = result.flatMap((user) => getProfile(user.id));
// Evita Result<Result<Profile>>
```

### 11.4 Transformações Assíncronas

#### `mapAsync` - Transformação async que sempre funciona
```dart
final result = await validateEmail(email)
  .mapAsync((validEmail) async => await formatEmail(validEmail));
```

#### `flatMapAsync` - Operação async que pode falhar
```dart
final result = await validateEmail(email)
  .flatMapAsync((validEmail) => findUser(validEmail))
  .flatMapAsync((user) => loadProfile(user.id));
```

### 11.5 Pipeline Completo

```dart
// Exemplo: Criar usuário, enviar email, logar evento
final result = await validateUserData(formData)
  .flatMap((data) => checkEmailNotExists(data.email))
  .flatMapAsync((data) => createUser(data))
  .flatMapAsync((user) => sendWelcomeEmail(user))
  .flatMapAsync((user) => logUserCreated(user));

result.when(
  onOk: (user) {
    showSuccess('Usuário criado com sucesso!');
    navigateToHome();
  },
  onError: (error) {
    showError(error.message);
  },
);
```

### 11.6 Best Practices

✅ **SEMPRE retornar Result** em repositories e viewmodels
```dart
// ✅ BOM
Future<Result<User>> getUser(String id) async { }

// ❌ RUIM
Future<User> getUser(String id) async { }
```

✅ **NUNCA usar getSuccessOrNull sem verificação**
```dart
// ❌ RUIM
final user = result.getSuccessOrNull()!;  // Pode crashar!

// ✅ BOM
result.when(
  onOk: (user) => useUser(user),
  onError: (error) => handleError(error),
);
```

✅ **Usar map para transformações simples**
```dart
// Transformação que sempre funciona
final count = result.map((list) => list.length);
```

✅ **Usar flatMap para operações encadeadas**
```dart
// Evita aninhamento de Results
final profile = result.flatMap((user) => getProfile(user.id));
```

---

## 12. Guia Passo-a-Passo

### 12.1 Exemplo: Criar Entidade "BloodPressure"

#### SQL da Tabela
```sql
CREATE TABLE blood_pressure (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  systolic SMALLINT NOT NULL,
  diastolic SMALLINT NOT NULL,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  time TIME WITHOUT TIME ZONE NULL,
  notes TEXT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
```

#### PASSO 1: Adicionar Endpoint

**Arquivo**: `lib/config/constants/http_types.dart`

```dart
enum Endpoint {
  heartRate,
  bloodPressure,  // ✅ ADICIONAR AQUI
  // ... outros

  String get url => switch (this) {
    Endpoint.heartRate => 'heart_rate',
    Endpoint.bloodPressure => 'blood_pressure',  // ✅ ADICIONAR AQUI
    // ... outros
  };
}
```

#### PASSO 2: Criar Modelo de Domínio

**Arquivo**: `lib/domain/models/blood_pressure.dart`

```dart
final class BloodPressure {
  final String id;
  final String patientId;
  final int systolic;
  final int diastolic;
  final DateTime date;
  final String? time;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BloodPressure({
    required this.id,
    required this.patientId,
    required this.systolic,
    required this.diastolic,
    required this.date,
    this.time,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BloodPressure.fromJson(dynamic list) {
    final json = list.first as Map<String, dynamic>;
    return BloodPressure(
      id: json['id'],
      patientId: json['patient_id'] ?? '',
      systolic: json['systolic'] ?? 0,
      diastolic: json['diastolic'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
      time: json['time'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'systolic': systolic,
      'diastolic': diastolic,
      'date': date.toIso8601String(),
      'time': time,
      'notes': notes,
    };
  }

  BloodPressure copyWith({
    String? id,
    String? patientId,
    int? systolic,
    int? diastolic,
    DateTime? date,
    String? time,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BloodPressure(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      date: date ?? this.date,
      time: time ?? this.time,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
    'BloodPressure(id: $id, systolic: $systolic, diastolic: $diastolic)';

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is BloodPressure &&
    other.id == id &&
    other.patientId == patientId;

  @override
  int get hashCode => Object.hash(id, patientId, systolic, diastolic);
}
```

#### PASSO 3: Criar Interface do Repository

**Arquivo**: `lib/data/repositories/blood_pressure/blood_pressure_repository.dart`

```dart
import 'package:palliative_care/domain/models/blood_pressure.dart';
import 'package:palliative_care/utils/result.dart';

abstract interface class BloodPressureRepository {
  Future<Result<List<BloodPressure>>> getAllBloodPressure();

  Future<Result<BloodPressure>> createBloodPressure({
    required String patientId,
    required BloodPressure measurement,
  });

  Future<Result<BloodPressure>> updateBloodPressure({
    required BloodPressure measurement,
  });

  Future<Result<dynamic>> deleteBloodPressure({required String id});
}
```

#### PASSO 4: Criar Implementação do Repository

**Arquivo**: `lib/data/repositories/blood_pressure/blood_pressure_repository_impl.dart`

```dart
import 'package:palliative_care/core/interfaces/logger.dart';
import 'package:palliative_care/data/repositories/blood_pressure/blood_pressure_repository.dart';
import 'package:palliative_care/data/services/api/api_client/api_client.dart';
import 'package:palliative_care/data/services/api/http/endpoint_builder/endpoint_builder.dart';
import 'package:palliative_care/data/services/api/http/header_builder/header_builder.dart';
import 'package:palliative_care/domain/models/blood_pressure.dart';
import 'package:palliative_care/exceptions/app_exception.dart';
import 'package:palliative_care/utils/result.dart';

final class BloodPressureRepositoryImpl implements BloodPressureRepository {
  final ApiClient _apiClient;
  final HeaderBuilder _headerService;
  final EndpointBuilder _endpointBuilder;
  final Logger _logger;
  static const String _logTag = 'BloodPressureRepository';

  BloodPressureRepositoryImpl({
    required ApiClient apiClient,
    required HeaderBuilder headerService,
    required EndpointBuilder endpointBuilder,
    required Logger logger,
  }) : _apiClient = apiClient,
       _headerService = headerService,
       _endpointBuilder = endpointBuilder,
       _logger = logger;

  @override
  Future<Result<BloodPressure>> createBloodPressure({
    required String patientId,
    required BloodPressure measurement,
  }) async {
    try {
      final headers = await _headerService.getHeadersWithPrefer(
        'return=representation'
      );
      final endpoint = _endpointBuilder.create();

      _logger.info('Creating blood pressure measurement', tag: _logTag);

      final response = await _apiClient.request(
        endpoint: endpoint,
        body: measurement.toJson(),
        headers: headers,
      ).map((data) => BloodPressure.fromJson(data));

      return response;
    } catch (e, s) {
      _logger.error(
        'Error serializing blood pressure',
        error: e,
        stackTrace: s,
        tag: _logTag,
      );
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<BloodPressure>>> getAllBloodPressure() async {
    try {
      _logger.info('Fetching all blood pressure measurements', tag: _logTag);

      return await _apiClient.request(
        endpoint: _endpointBuilder.getAll()
      ).map((data) {
        return (data as List)
            .map((json) => BloodPressure.fromJson(json))
            .toList();
      });
    } catch (e, s) {
      _logger.error(
        'Error serializing blood pressure measurements',
        error: e,
        stackTrace: s,
        tag: _logTag,
      );
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<BloodPressure>> updateBloodPressure({
    required BloodPressure measurement,
  }) async {
    try {
      _logger.info(
        'Updating blood pressure with id: ${measurement.id}',
        tag: _logTag,
      );

      final endpoint = _endpointBuilder.update(id: measurement.id);

      final response = await _apiClient.request(
        endpoint: endpoint,
        body: measurement.toJson(),
      ).map((data) => BloodPressure.fromJson(data));

      return response;
    } catch (e, s) {
      _logger.error(
        'Error serializing blood pressure',
        error: e,
        stackTrace: s,
        tag: _logTag,
      );
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteBloodPressure({required String id}) async {
    _logger.info('Deleting blood pressure with id: $id', tag: _logTag);

    final endpoint = _endpointBuilder.delete(id: id);
    return await _apiClient.request(endpoint: endpoint);
  }
}
```

#### PASSO 5: Registrar Repository em Providers

**Arquivo**: `lib/config/providers/repository_providers.dart`

```dart
List<SingleChildWidget> get repositoryProviders {
  return [
    // ... outros repositories

    // BloodPressure Repository
    Provider(
      create: (context) => BloodPressureRepositoryImpl(
        apiClient: context.read<ApiClient>(),
        headerService: context.read<HeaderBuilder>(),
        endpointBuilder: EndpointBuilderImpl(endpoint: Endpoint.bloodPressure),
        logger: context.read<Logger>(),
      ) as BloodPressureRepository,
    ),
  ];
}
```

#### PASSO 6: Criar ViewModel

**Arquivo**: `lib/ui/blood_pressure_entry_screen/viewmodel/blood_pressure_entry_viewmodel.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:palliative_care/data/repositories/blood_pressure/blood_pressure_repository.dart';
import 'package:palliative_care/domain/models/blood_pressure.dart';
import 'package:palliative_care/utils/command.dart';
import 'package:palliative_care/utils/result.dart';

final class BloodPressureEntryViewmodel extends ChangeNotifier {
  BloodPressureEntryViewmodel({required BloodPressureRepository repository})
      : _repository = repository {
    createMeasurement = Command1(_createMeasurement);
  }

  final BloodPressureRepository _repository;

  late final Command1<BloodPressure, BloodPressure> createMeasurement;

  Future<Result<BloodPressure>> _createMeasurement(
    BloodPressure measurement,
  ) async {
    return await _repository.createBloodPressure(
      patientId: measurement.patientId,
      measurement: measurement,
    );
  }
}
```

#### PASSO 7: Adicionar Rotas

**Arquivo**: `lib/routing/routes.dart`

```dart
abstract final class Routes {
  // ... outras rotas

  static const bloodPressureEntry = '/vital-sign/blood-pressure/entry';

  static String bloodPressureEntryWithPatient(String patientId) =>
    '/vital-sign/blood-pressure/entry?patientId=$patientId';
}
```

**Arquivo**: `lib/routing/router.dart`

```dart
GoRoute(
  path: Routes.bloodPressureEntry,
  builder: (context, state) {
    final patientId = state.uri.queryParameters['patientId'] ?? '';
    final repository = Provider.of<BloodPressureRepository>(
      context,
      listen: false,
    );
    return BloodPressureEntryScreen(
      patientId: patientId,
      viewmodel: BloodPressureEntryViewmodel(repository: repository),
    );
  },
),
```

#### PASSO 8: Criar UI Screen (Não coberto neste documento)

A criação da tela está documentada separadamente.

---

## 13. Padrões Específicos do Supabase

### 13.1 Headers Especiais

#### Prefer: return=representation
**Quando usar**: POST e PATCH
**Propósito**: Retorna o objeto criado/atualizado na resposta

```dart
final headers = await _headerService.getHeadersWithPrefer('return=representation');

await _apiClient.request(
  endpoint: _endpointBuilder.create(),
  body: entity.toJson(),
  headers: headers,  // ← Inclui Prefer
);
```

#### Range: start-end
**Quando usar**: GET com paginação
**Propósito**: Especifica intervalo de itens desejados

```dart
final headers = await _headerService.getHeadersWithRange(
  start: 0,
  end: 19,
);

await _apiClient.paginatedRequest(
  endpoint: _endpointBuilder.getAll(),
  headers: headers,  // ← Inclui Range: 0-19
);
```

### 13.2 Content-Range Response Header

Supabase retorna este header em requisições paginadas:

```
Content-Range: 0-19/100
```

Significado:
- `0-19`: itens retornados nesta resposta
- `100`: total de itens disponíveis

Caso especial (lista vazia):
```
Content-Range: */0
```

### 13.3 Sintaxe de Filtros

#### Operadores Básicos
```
?column=eq.value         // Igual a
?column=neq.value        // Diferente de
?column=gt.value         // Maior que
?column=gte.value        // Maior ou igual a
?column=lt.value         // Menor que
?column=lte.value        // Menor ou igual a
```

#### Operadores de Texto
```
?column=like.pattern     // LIKE (case-sensitive)
?column=ilike.pattern    // ILIKE (case-insensitive)
```

#### Operadores de Conjunto
```
?column=in.(val1,val2,val3)    // IN
?column=is.null                // IS NULL
?column=not.is.null            // IS NOT NULL
```

#### Combinar Múltiplos Filtros
```
?select=*&user_id=eq.123&is_active=eq.true&created_at=gte.2024-01-01
```

### 13.4 Select Columns

#### Selecionar Todas as Colunas
```
?select=*
```

#### Selecionar Colunas Específicas
```
?select=id,name,email
```

#### Selecionar com Relacionamentos
```
?select=*,user(id,name)
```

### 13.5 Ordenação

```
?order=column_name.asc
?order=column_name.desc
?order=column1.asc,column2.desc
```

### 13.6 Limitação de Resultados

```
?limit=10
?offset=20&limit=10
```

---

## 14. Checklist Completo

### ✅ Configuração
- [ ] Adicionar enum ao `Endpoint` em `http_types.dart`
- [ ] Adicionar case ao switch `url` do `Endpoint`

### ✅ Domínio
- [ ] Criar arquivo `lib/domain/models/{entity}.dart`
- [ ] Definir classe `final class {Entity}`
- [ ] Adicionar todos os campos com tipos corretos
- [ ] Implementar `fromJson()` factory
- [ ] Implementar `toJson()` method
- [ ] Implementar `copyWith()` method
- [ ] Override `toString()`
- [ ] Override `operator ==`
- [ ] Override `hashCode`

### ✅ Repository
- [ ] Criar arquivo `lib/data/repositories/{entity}/{entity}_repository.dart`
- [ ] Definir interface `abstract interface class {Entity}Repository`
- [ ] Adicionar métodos CRUD necessários
- [ ] Criar arquivo `lib/data/repositories/{entity}/{entity}_repository_impl.dart`
- [ ] Implementar classe `final class {Entity}RepositoryImpl`
- [ ] Injetar dependências: `ApiClient`, `HeaderBuilder`, `EndpointBuilder`, `Logger`
- [ ] Implementar `create{Entity}` com Prefer header
- [ ] Implementar `getAll{Entity}` com serialização
- [ ] Implementar `get{Entity}By` se necessário
- [ ] Implementar `update{Entity}` se necessário
- [ ] Implementar `delete{Entity}` se necessário
- [ ] Adicionar try-catch em todas as serializações
- [ ] Adicionar logs em operações importantes

### ✅ Dependency Injection
- [ ] Abrir `lib/config/providers/repository_providers.dart`
- [ ] Adicionar `Provider` para o repository
- [ ] Injetar dependências com `context.read<>()`
- [ ] Criar `EndpointBuilderImpl` inline com endpoint correto
- [ ] Cast para interface do repository

### ✅ ViewModel
- [ ] Criar arquivo `lib/ui/{feature}_viewmodel/{feature}_viewmodel.dart`
- [ ] Definir classe com `ChangeNotifier` (se necessário)
- [ ] Injetar repository no construtor
- [ ] Inicializar commands no construtor
- [ ] Criar métodos privados para cada operação
- [ ] Se lista: usar `PaginatedCommand`
- [ ] Se CRUD completo: implementar `_updateItemsList`
- [ ] Se global: registrar em `viewmodel_providers.dart`

### ✅ Routing
- [ ] Abrir `lib/routing/routes.dart`
- [ ] Adicionar constante de rota
- [ ] Adicionar helpers com IDs/query params
- [ ] Abrir `lib/routing/router.dart`
- [ ] Criar `GoRoute` entry
- [ ] Extrair path/query parameters
- [ ] Obter repository do Provider
- [ ] Instanciar viewmodel
- [ ] Passar para tela

### ✅ Validação Final
- [ ] Testar compilação: `flutter pub get`
- [ ] Verificar imports corretos
- [ ] Verificar nomenclatura consistente
- [ ] Verificar todos os campos do SQL mapeados
- [ ] Verificar campos nullable corretos
- [ ] Verificar campos auto-gerenciados excluídos do `toJson()`

---

## 15. Problemas Comuns e Soluções

### ❌ Provider not found
**Erro**: `ProviderNotFoundException`

**Causa**: Dependency registrado após ser usado ou não registrado

**Solução**:
1. Verificar ordem em `dependencies.dart`: external → service → repository → viewmodel
2. Verificar se Provider está registrado no arquivo correto
3. Verificar se está usando `context.read<Type>()` correto

### ❌ Null check operator used on null value
**Erro**: `Null check operator used on a null value`

**Causa**: Campo esperado não existe no JSON

**Solução**:
```dart
// ❌ RUIM
id: json['id'],

// ✅ BOM
id: json['id'] ?? '',
value: json['value'] ?? 0,
```

### ❌ type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'
**Erro**: Type casting incorreto

**Causa**: Supabase às vezes retorna lista ao invés de objeto

**Solução**:
```dart
factory Entity.fromJson(dynamic list) {
  final json = list.first as Map<String, dynamic>;
  return Entity(
    id: json['id'],
    // ...
  );
}
```

### ❌ Command não atualiza UI
**Erro**: UI não reflete mudanças após command

**Causa**: Falta `ListenableBuilder` ou listener

**Solução**:
```dart
ListenableBuilder(
  listenable: viewmodel.createCommand,
  builder: (context, child) {
    if (viewmodel.createCommand.running) {
      return CircularProgressIndicator();
    }
    // ... resto da UI
  },
)
```

### ❌ Paginação não funciona
**Erro**: Sempre retorna mesmos itens

**Causa**: Headers incorretos ou parsing errado

**Solução**:
1. Usar `paginatedRequest()` não `request()`
2. Adicionar Range header com `getHeadersWithRange()`
3. Parse correto do Content-Range
4. Retornar `PaginatedResponse` com total

### ❌ Token não renova automaticamente
**Erro**: 401 Unauthorized

**Causa**: AuthInterceptor não configurado ou HeaderBuilder incorreto

**Solução**:
1. Verificar se `AuthInterceptor` está adicionado ao Dio
2. Verificar se `HeaderBuilder` tem `AuthApiClient` injetado
3. Verificar lógica de verificação de expiração
4. Verificar refresh token válido no storage

### ❌ Endpoint não encontrado (404)
**Erro**: 404 Not Found

**Causa**: URL incorreta ou tabela não existe

**Solução**:
1. Verificar nome da tabela em `Endpoint.url`
2. Verificar se tabela existe no Supabase
3. Verificar permissions RLS no Supabase
4. Verificar se API key está correta

### ❌ Serialization error ao criar
**Erro**: Exception durante `fromJson`

**Causa**: Campos esperados não retornados pelo Supabase

**Solução**:
1. Usar Prefer header: `return=representation`
2. Verificar se campos têm valores default no SQL
3. Adicionar null checks no `fromJson`

---

## 📝 Notas Finais

### Filosofia do Projeto

Este projeto prioriza:
- **Type Safety**: Uso extensivo de sealed classes, Result pattern
- **Explicitness**: Erros explícitos, sem exceptions escondidas
- **Separation of Concerns**: Cada camada tem responsabilidade clara
- **Testability**: Dependency injection facilita testes
- **Developer Experience**: Padrões consistentes, menos surpresas

### Quando Desviar dos Padrões

Estes padrões são guidelines, não regras absolutas. Considere desviar quando:
- Performance é crítica (ex: cache local)
- Requisito muito específico (ex: upload de arquivos)
- Integração com biblioteca externa exige padrão diferente

Mas sempre documente o desvio e o motivo.

### Recursos Adicionais

- **Result Pattern**: Veja exemplos extensivos em `lib/utils/result.dart`
- **Command Pattern**: Veja `lib/utils/command.dart` e `lib/utils/paginated_command.dart`
- **Supabase Docs**: https://supabase.com/docs/guides/api
- **GoRouter**: https://pub.dev/packages/go_router
- **Provider**: https://pub.dev/packages/provider

---

**Versão**: 1.0
**Última Atualização**: 2025-01-13
**Autor**: Documentação gerada para projeto Palliative Care Mobile
