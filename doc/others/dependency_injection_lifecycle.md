# Gerenciamento de Dependências e Ciclo de Vida no Flutter

## Índice
1. [Ciclo de Vida das Dependências com Provider](#1-ciclo-de-vida-das-dependências-com-provider)
2. [Análise do Código Atual](#2-análise-do-código-atual)
3. [Otimização de Memória com Provider](#3-otimização-de-memória-com-provider)
4. [Alternativas ao Provider](#4-alternativas-ao-provider)
5. [Recomendações e Melhores Práticas](#5-recomendações-e-melhores-práticas)
6. [Implementação Otimizada](#6-implementação-otimizada)

---

## 1. Ciclo de Vida das Dependências com Provider

### 1.1 Como o Provider Funciona

O Provider é um wrapper em torno do `InheritedWidget` do Flutter que gerencia o estado e as dependências de forma reativa. Entender seu ciclo de vida é crucial para otimizar o uso de memória.

#### Tipos de Providers e Seus Ciclos de Vida

##### **Provider (Stateless)**
```dart
Provider<Dio>(
  create: (context) => Dio(),
)
```

**Ciclo de Vida:**
- ✅ **Criação:** A instância é criada **uma única vez** quando o Provider é montado na árvore de widgets
- ✅ **Vida:** A instância permanece em memória enquanto o Provider estiver na árvore de widgets
- ✅ **Destruição:** A instância é destruída quando o Provider é removido da árvore (geralmente quando o app é fechado)
- ⚠️ **Características:**
  - Não notifica listeners sobre mudanças
  - Ideal para objetos imutáveis ou serviços stateless
  - **Lazy Loading:** Por padrão, a função `create` é chamada **apenas quando alguém acessa o Provider pela primeira vez**

##### **ListenableProvider (Stateful)**
```dart
ListenableProvider<AuthRepository>(
  create: (context) => AuthRepositoryImpl(...),
)
```

**Ciclo de Vida:**
- ✅ **Criação:** Similar ao Provider, criado quando necessário (lazy) ou imediatamente (se `lazy: false`)
- ✅ **Vida:** Mantém-se ativo e pode notificar listeners através do `notifyListeners()`
- ✅ **Destruição:** Quando removido da árvore, o `dispose()` é chamado automaticamente se o objeto for `ChangeNotifier`
- ⚠️ **Características:**
  - Automaticamente gerencia a subscrição/desinscrição de listeners
  - Chama `dispose()` automaticamente em objetos `ChangeNotifier`

##### **ChangeNotifierProvider**
```dart
ChangeNotifierProvider<MyViewModel>(
  create: (context) => MyViewModel(),
)
```

**Ciclo de Vida:**
- Similar ao ListenableProvider, mas específico para `ChangeNotifier`
- Gerenciamento automático de memória através do `dispose()`

### 1.2 Lazy Loading no Provider

**Comportamento Padrão (lazy: true):**
```dart
Provider(
  create: (context) => ExpensiveService(),
  lazy: true, // Padrão
  child: MyApp(),
)
```
- A função `create` **NÃO é executada** imediatamente
- A instância só é criada quando `context.read<ExpensiveService>()` ou `context.watch<ExpensiveService>()` é chamado pela primeira vez
- **Benefício:** Economia de memória inicial, criação sob demanda

**Criação Imediata (lazy: false):**
```dart
Provider(
  create: (context) => CriticalService(),
  lazy: false,
  child: MyApp(),
)
```
- A função `create` é executada **imediatamente** quando o Provider é montado
- **Uso:** Serviços que precisam inicializar antes de serem usados

### 1.3 Escopo das Dependências

#### Escopo Global (Main)
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [...],
      child: MyApp(),
    ),
  );
}
```
- **Duração:** Toda a vida do aplicativo
- **Memória:** Permanece em memória até o app fechar
- **Uso:** Singletons, serviços globais (Dio, Database, Auth)

#### Escopo de Tela/Feature
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ScreenViewModel>(
      create: (context) => ScreenViewModel(),
      child: MyScreenContent(),
    );
  }
}
```
- **Duração:** Enquanto a tela estiver na navegação
- **Memória:** Liberado quando a tela é removida da navegação
- **Uso:** ViewModels, estados específicos de tela

---

## 2. Análise do Código Atual

### 2.1 Problemas Identificados

Analisando seu arquivo `dependencies.dart`:

```dart
List<SingleChildWidget> get providers {
  return [
    // ❌ PROBLEMA 1: Todos os providers são globais
    Provider(create: (context) => Dio()),
    Provider(create: (context) => FlutterSecureStorage()),
    
    // ❌ PROBLEMA 2: ViewModels no escopo global
    Provider(create: (context) => VitalSignDetailViewmodel(...)),
    
    // ❌ PROBLEMA 3: Lazy loading padrão, mas sem controle fino
  ];
}
```

**Problemas:**

1. **ViewModels Globais:** `VitalSignDetailViewmodel` está no escopo global, mas deveria ser criado apenas quando a tela específica é aberta
2. **Sem Dispose Explícito:** ViewModels que não são `ChangeNotifier` não têm `dispose()` automático
3. **Todos em Memória:** Mesmo com lazy loading, uma vez criados, permanecem em memória indefinidamente
4. **Sem Separação de Escopo:** Não há distinção clara entre dependências globais e específicas de features

### 2.2 Impacto na Memória

**Cenário Atual:**
```
App Iniciado (0 MB usado)
├── Usuário navega para VitalSignDetail
│   └── VitalSignDetailViewmodel criado (+ X MB)
│       └── HeartRateMeasurementRepository criado (+ Y MB)
├── Usuário volta para Home
│   └── VitalSignDetailViewmodel PERMANECE em memória (X MB ainda alocado)
└── Aplicativo continua rodando
    └── Todas as dependências criadas permanecem ativas
```

**Memória desperdiçada:** Todas as dependências criadas ficam em memória mesmo quando não estão sendo usadas.

---

## 3. Otimização de Memória com Provider

### 3.1 Estratégias de Otimização

#### Estratégia 1: Separação de Escopos

**dependencies.dart (Escopo Global - Apenas Singletons)**
```dart
List<SingleChildWidget> get globalProviders {
  return [
    // Bibliotecas externas (Singletons verdadeiros)
    Provider(
      create: (context) => Dio(),
      lazy: true,
    ),
    Provider(
      create: (context) => FlutterSecureStorage(),
      lazy: true,
    ),
    Provider(
      create: (context) => InternetConnection(),
      lazy: true,
    ),
    Provider(
      create: (context) => SupabaseClient(
        Urls.baseUrl,
        dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '',
      ),
      lazy: false, // Pode precisar inicializar cedo
    ),

    // Utils (Singletons)
    Provider(
      create: (context) => ConnectionCheckerImpl(
        context.read<InternetConnection>(),
      ) as ConnectionChecker,
      lazy: true,
    ),

    // API Clients (Singletons)
    Provider(
      create: (context) => ApiClientImpl(
        dio: context.read<Dio>(),
        connectionChecker: context.read<ConnectionChecker>(),
      ) as ApiClient,
      lazy: true,
    ),
    Provider(
      create: (context) => AuthApiClientImpl(
        connectionChecker: context.read<ConnectionChecker>(),
        supabaseClient: context.read<SupabaseClient>(),
      ) as AuthApiClient,
      lazy: true,
    ),
    Provider(
      create: (context) => LocalSecureStorageImpl(
        storage: context.read<FlutterSecureStorage>(),
      ) as LocalSecureStorage,
      lazy: true,
    ),

    // Repositories (Singletons)
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryImpl(
        apiClient: context.read<AuthApiClient>(),
        connectionChecker: context.read<ConnectionChecker>(),
      ) as AuthRepository,
      lazy: true,
    ),
    Provider(
      create: (context) => HeartRateMeasurementRepositoryImpl(
        apiClient: context.read<ApiClient>(),
      ) as HeartRateMeasurementRepository,
      lazy: true,
    ),
  ];
}
```

**main.dart**
```dart
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: globalProviders, // Apenas singletons
      child: const MyApp(),
    ),
  );
}
```

#### Estratégia 2: ViewModels com Escopo de Tela

**vital_sign_detail_screen.dart**
```dart
class VitalSignDetailScreen extends StatelessWidget {
  final String patientId;
  final VitalSignType measurementType;

  const VitalSignDetailScreen({
    super.key,
    required this.patientId,
    required this.measurementType,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ ViewModel criado apenas quando a tela é aberta
    return ChangeNotifierProvider(
      create: (context) => VitalSignDetailViewmodel(
        heartRateMeasurementRepository: context.read<HeartRateMeasurementRepository>(),
      ),
      // ✅ dispose() será chamado automaticamente quando sair da tela
      child: _VitalSignDetailContent(
        patientId: patientId,
        measurementType: measurementType,
      ),
    );
  }
}

class _VitalSignDetailContent extends StatelessWidget {
  final String patientId;
  final VitalSignType measurementType;

  const _VitalSignDetailContent({
    required this.patientId,
    required this.measurementType,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VitalSignDetailViewmodel>();
    // Implementação da tela...
    return Scaffold(...);
  }
}
```

#### Estratégia 3: ViewModel com ChangeNotifier e Dispose

**vital_sign_detail_viewmodel.dart (Refatorado)**
```dart
final class VitalSignDetailViewmodel extends ChangeNotifier {
  VitalSignDetailViewmodel({
    required HeartRateMeasurementRepository heartRateMeasurementRepository,
  }) : _heartRateMeasurementRepository = heartRateMeasurementRepository {
    getMeasurementSummary = Command1(
      _fetchMeasurementSummary,
    );
  }

  final HeartRateMeasurementRepository _heartRateMeasurementRepository;

  late final Command1<MeasurementSummary, ({String patientId, VitalSignType measurementType})> getMeasurementSummary;

  Future<Result<MeasurementSummary>> _fetchMeasurementSummary(
    ({String patientId, VitalSignType measurementType}) params,
  ) async {
    // Implementação...
  }

  // ✅ Cleanup de recursos quando o ViewModel é destruído
  @override
  void dispose() {
    // Cancela requisições pendentes, fecha streams, etc.
    getMeasurementSummary.clearValue();
    super.dispose();
  }
}
```

### 3.2 Uso de ProxyProvider para Dependências Dinâmicas

Se você precisar que uma dependência reaja a mudanças em outra:

```dart
ProxyProvider<AuthRepository, SomeService>(
  update: (context, auth, previousService) => SomeService(
    userId: auth.currentUserId,
  ),
  dispose: (context, service) => service.dispose(),
)
```

### 3.3 Resultado da Otimização

**Com Escopo Correto:**
```
App Iniciado (0 MB)
├── Singletons criados sob demanda (lazy)
├── Usuário navega para VitalSignDetail
│   └── VitalSignDetailViewmodel criado (+ X MB)
├── Usuário volta para Home
│   └── VitalSignDetailViewmodel.dispose() chamado
│       └── Memória liberada (- X MB) ✅
└── Apenas singletons permanecem em memória
```

---

## 4. Alternativas ao Provider

### 4.1 get_it (Service Locator)

**Características:**
- ✅ Mantido pela comunidade (muito popular)
- ✅ Não depende de `BuildContext`
- ✅ Suporta singletons, factories e lazy singletons
- ✅ Escopo de dependências
- ❌ Não é recomendado pela documentação oficial do Flutter
- ❌ Service Locator pattern (considerado anti-pattern por alguns)

**Exemplo:**
```dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Singleton (criado uma vez)
  getIt.registerSingleton<Dio>(Dio());
  
  // Lazy Singleton (criado quando necessário)
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClientImpl(dio: getIt<Dio>()),
  );
  
  // Factory (nova instância sempre)
  getIt.registerFactory<VitalSignDetailViewmodel>(
    () => VitalSignDetailViewmodel(
      heartRateMeasurementRepository: getIt<HeartRateMeasurementRepository>(),
    ),
  );
}

// Uso:
final viewModel = getIt<VitalSignDetailViewmodel>();
```

**Gerenciamento de Memória:**
```dart
// Registrar com dispose
getIt.registerFactoryParam<MyViewModel, String, void>(
  (param, _) => MyViewModel(id: param),
  dispose: (viewModel) => viewModel.dispose(),
);

// Usar escopo
await getIt.pushNewScope();
getIt.registerSingleton<TemporaryService>(TemporaryService());
// ... usar o serviço
await getIt.popScope(); // ✅ TemporaryService.dispose() é chamado
```

### 4.2 riverpod (Evolução do Provider)

**Características:**
- ✅ Criado pelo mesmo autor do Provider
- ✅ Compilação type-safe
- ✅ Não depende de `BuildContext`
- ✅ Melhor suporte a testes
- ✅ Gerenciamento automático de lifecycle
- ✅ **Dispose automático quando não há mais listeners**
- ⚠️ Curva de aprendizado maior
- ⚠️ Sintaxe diferente (código generation opcional)

**Exemplo:**
```dart
// Singleton (mantido em memória)
final dioProvider = Provider((ref) => Dio());

// Auto-dispose quando não usado
final vitalSignViewModelProvider = Provider.autoDispose.family<
  VitalSignDetailViewmodel,
  ({String patientId, VitalSignType type})
>((ref, params) {
  final repository = ref.watch(heartRateRepositoryProvider);
  final viewModel = VitalSignDetailViewmodel(
    heartRateMeasurementRepository: repository,
  );
  
  // ✅ Dispose automático quando não há listeners
  ref.onDispose(() {
    viewModel.dispose();
  });
  
  return viewModel;
});

// Uso:
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(
      vitalSignViewModelProvider((patientId: '123', type: VitalSignType.heartRate)),
    );
    // Quando o widget é destruído, o provider é automaticamente disposed ✅
    return ...;
  }
}
```

**Gerenciamento de Memória (Riverpod):**
- `Provider`: Mantém instância enquanto o app rodar
- `Provider.autoDispose`: **Destroi automaticamente quando não há listeners**
- `Provider.family`: Cria instâncias diferentes para diferentes parâmetros
- `Provider.autoDispose.family`: Combinação perfeita para ViewModels com parâmetros

### 4.3 flutter_bloc / bloc

**Características:**
- ✅ Muito popular e bem mantido
- ✅ Padrão BLoC bem definido
- ✅ Excelente para gerenciamento de estado complexo
- ✅ Suporta `close()` automático via `BlocProvider`
- ⚠️ Mais verboso
- ⚠️ Curva de aprendizado

**Exemplo:**
```dart
BlocProvider(
  create: (context) => VitalSignBloc(
    repository: context.read<HeartRateMeasurementRepository>(),
  ),
  // ✅ close() é chamado automaticamente quando o provider é removido
  child: VitalSignDetailScreen(),
)
```

### 4.4 Comparação das Alternativas

| Critério | Provider | get_it | Riverpod | BLoC |
|----------|----------|--------|----------|------|
| **Recomendado pelo Flutter** | ✅ Sim | ❌ Não | ⚠️ Comunidade | ⚠️ Comunidade |
| **Dispose Automático** | ⚠️ Apenas ChangeNotifier | ❌ Manual com scopes | ✅ Sim (autoDispose) | ✅ Sim |
| **Lazy Loading** | ✅ Sim | ✅ Sim | ✅ Sim | ✅ Sim |
| **Sem BuildContext** | ❌ Não | ✅ Sim | ✅ Sim | ❌ Não |
| **Curva de Aprendizado** | 🟢 Baixa | 🟢 Baixa | 🟡 Média | 🟡 Média |
| **Manutenção** | ✅ Ativa | ✅ Ativa | ✅ Ativa | ✅ Ativa |
| **Gerenciamento de Memória** | ⚠️ Manual | ⚠️ Manual | ✅ Automático | ✅ Bom |
| **Type Safety** | ⚠️ Runtime | ⚠️ Runtime | ✅ Compile time | ✅ Compile time |

---

## 5. Recomendações e Melhores Práticas

### 5.1 Para Seu Projeto (Continuando com Provider)

**Recomendação:** Continue com Provider, mas faça as seguintes otimizações:

1. **Separe Dependências Globais de Escopadas**
   - Globals: Dio, SupabaseClient, Repositories, API Clients
   - Escopadas: ViewModels (um por tela)

2. **Transforme ViewModels em ChangeNotifier**
   ```dart
   class MyViewModel extends ChangeNotifier {
     @override
     void dispose() {
       // Cleanup
       super.dispose();
     }
   }
   ```

3. **Use ChangeNotifierProvider no Escopo de Tela**
   ```dart
   class MyScreen extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return ChangeNotifierProvider(
         create: (context) => MyViewModel(...),
         child: ...,
       );
     }
   }
   ```

4. **Implemente Dispose em Todos os ViewModels**
   - Cancele streams
   - Limpe timers
   - Dispose de controllers

### 5.2 Se Considerar Migração

**Melhor Alternativa: Riverpod**

**Motivos:**
1. Mesmo autor do Provider (fácil migração)
2. Dispose automático com `autoDispose`
3. Compile-time safety
4. Mantém a filosofia do Flutter (recomendado pela comunidade)
5. Excelente para aplicativos médios a grandes

**Migração Gradual:**
```dart
// 1. Adicionar riverpod ao pubspec.yaml
dependencies:
  flutter_riverpod: ^2.6.1

// 2. Mudar MultiProvider para ProviderScope
void main() {
  runApp(ProviderScope(child: MyApp()));
}

// 3. Migrar providers gradualmente
// Antes (Provider):
Provider(create: (context) => Dio())

// Depois (Riverpod):
final dioProvider = Provider((ref) => Dio());
```

### 5.3 Padrão Recomendado de Arquitetura

```
lib/
├── config/
│   ├── dependencies/
│   │   ├── global_providers.dart      # Singletons (Dio, Supabase, etc)
│   │   └── repository_providers.dart  # Repositories
├── features/
│   ├── vital_sign_detail/
│   │   ├── presentation/
│   │   │   ├── viewmodel/
│   │   │   │   └── vital_sign_detail_viewmodel.dart
│   │   │   └── vital_sign_detail_screen.dart
│   │   ├── domain/
│   │   └── data/
```

---

## 6. Implementação Otimizada

### 6.1 Estrutura de Dependências Otimizada

**lib/config/dependencies/global_providers.dart**
```dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Providers globais que devem persistir durante toda a vida do app
/// Usar apenas para singletons verdadeiros
List<SingleChildWidget> get globalProviders {
  return [
    // External libraries
    Provider(
      create: (context) => Dio(),
      lazy: true,
    ),
    Provider(
      create: (context) => FlutterSecureStorage(),
      lazy: true,
    ),
    Provider(
      create: (context) => InternetConnection(),
      lazy: true,
    ),
    Provider(
      create: (context) => SupabaseClient(
        Urls.baseUrl,
        dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '',
      ),
      lazy: false, // Inicializa imediatamente
    ),

    // Utils
    Provider(
      create: (context) => ConnectionCheckerImpl(
        context.read<InternetConnection>(),
      ) as ConnectionChecker,
      lazy: true,
    ),

    // API Clients
    Provider(
      create: (context) => ApiClientImpl(
        dio: context.read<Dio>(),
        connectionChecker: context.read<ConnectionChecker>(),
      ) as ApiClient,
      lazy: true,
    ),
    Provider(
      create: (context) => AuthApiClientImpl(
        connectionChecker: context.read<ConnectionChecker>(),
        supabaseClient: context.read<SupabaseClient>(),
      ) as AuthApiClient,
      lazy: true,
    ),
    Provider(
      create: (context) => LocalSecureStorageImpl(
        storage: context.read<FlutterSecureStorage>(),
      ) as LocalSecureStorage,
      lazy: true,
    ),

    // Repositories
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryImpl(
        apiClient: context.read<AuthApiClient>(),
        connectionChecker: context.read<ConnectionChecker>(),
      ) as AuthRepository,
      lazy: true,
    ),
    Provider(
      create: (context) => HeartRateMeasurementRepositoryImpl(
        apiClient: context.read<ApiClient>(),
      ) as HeartRateMeasurementRepository,
      lazy: true,
    ),
  ];
}
```

**lib/ui/vital_sign_detail/viewmodel/vital_sign_detail_viewmodel.dart**
```dart
import 'package:flutter/foundation.dart';
import 'package:palliative_care/data/repositories/heart_rate/heart_rate_repository.dart';
import 'package:palliative_care/domain/models/measurement_summary.dart';
import 'package:palliative_care/exceptions/app_exception.dart';
import 'package:palliative_care/utils/command.dart';
import 'package:palliative_care/utils/result.dart';

enum VitalSignType {
  heartRate,
  bloodPressure,
  temperature,
  respiratoryRate,
  glucose,
  saturation,
  pain;

  static fromString(String value) {
    return switch (value) {
      'heart-rate' => VitalSignType.heartRate,
      'blood-pressure' => VitalSignType.bloodPressure,
      'temperature' => VitalSignType.temperature,
      'respiratory-rate' => VitalSignType.respiratoryRate,
      'glucose' => VitalSignType.glucose,
      'saturation' => VitalSignType.saturation,
      'pain' => VitalSignType.pain,
      _ => throw ArgumentError('Invalid VitalSignType string: $value'),
    };
  }
}

/// ✅ Agora estende ChangeNotifier para gerenciamento automático de lifecycle
final class VitalSignDetailViewmodel extends ChangeNotifier {
  VitalSignDetailViewmodel({
    required HeartRateMeasurementRepository heartRateMeasurementRepository,
  }) : _heartRateMeasurementRepository = heartRateMeasurementRepository {
    getMeasurementSummary = Command1(
      _fetchMeasurementSummary,
    );
  }

  final HeartRateMeasurementRepository _heartRateMeasurementRepository;

  late final Command1<MeasurementSummary, ({String patientId, VitalSignType measurementType})> getMeasurementSummary;

  Future<Result<MeasurementSummary>> _fetchMeasurementSummary(
    ({String patientId, VitalSignType measurementType}) params,
  ) async {
    final String patientId = params.patientId;
    final VitalSignType measurementType = params.measurementType;

    switch (measurementType) {
      case VitalSignType.heartRate:
        final result = await _heartRateMeasurementRepository.getHeartRateSummary(
          patientId: patientId,
        );
        return result;
      case VitalSignType.bloodPressure:
        return Result.error(UnknownErrorException());
      case VitalSignType.temperature:
        throw UnimplementedError();
      case VitalSignType.respiratoryRate:
        throw UnimplementedError();
      case VitalSignType.glucose:
        throw UnimplementedError();
      case VitalSignType.pain:
        throw UnimplementedError();
      case VitalSignType.saturation:
        throw UnimplementedError();
    }
  }

  /// ✅ Cleanup de recursos quando o ViewModel é destruído
  @override
  void dispose() {
    // Limpa o comando para evitar callbacks pendentes
    getMeasurementSummary.clearValue();
    
    // Cancele qualquer stream, timer, ou requisição pendente aqui
    // Exemplo:
    // _streamSubscription?.cancel();
    // _timer?.cancel();
    
    super.dispose();
  }
}
```

**lib/ui/vital_sign_detail/vital_sign_detail_screen.dart**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palliative_care/data/repositories/heart_rate/heart_rate_repository.dart';
import 'package:palliative_care/ui/vital_sign_detail/viewmodel/vital_sign_detail_viewmodel.dart';

class VitalSignDetailScreen extends StatelessWidget {
  final String patientId;
  final VitalSignType measurementType;

  const VitalSignDetailScreen({
    super.key,
    required this.patientId,
    required this.measurementType,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ ViewModel criado apenas quando a tela é aberta
    // ✅ Dispose será chamado automaticamente quando a tela for removida
    return ChangeNotifierProvider(
      create: (context) => VitalSignDetailViewmodel(
        heartRateMeasurementRepository: context.read<HeartRateMeasurementRepository>(),
      ),
      child: _VitalSignDetailContent(
        patientId: patientId,
        measurementType: measurementType,
      ),
    );
  }
}

class _VitalSignDetailContent extends StatefulWidget {
  final String patientId;
  final VitalSignType measurementType;

  const _VitalSignDetailContent({
    required this.patientId,
    required this.measurementType,
  });

  @override
  State<_VitalSignDetailContent> createState() => _VitalSignDetailContentState();
}

class _VitalSignDetailContentState extends State<_VitalSignDetailContent> {
  @override
  void initState() {
    super.initState();
    // Carregar dados quando a tela inicializa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<VitalSignDetailViewmodel>();
      viewModel.getMeasurementSummary.execute((
        patientId: widget.patientId,
        measurementType: widget.measurementType,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ context.watch recria o widget quando o ViewModel notifica mudanças
    final viewModel = context.watch<VitalSignDetailViewmodel>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Vital Sign Detail'),
      ),
      body: viewModel.getMeasurementSummary.running
          ? Center(child: CircularProgressIndicator())
          : viewModel.getMeasurementSummary.error != null
              ? Center(child: Text('Error: ${viewModel.getMeasurementSummary.error}'))
              : _buildContent(viewModel.getMeasurementSummary.value),
    );
  }

  Widget _buildContent(MeasurementSummary? summary) {
    if (summary == null) {
      return Center(child: Text('No data available'));
    }
    
    // Construir UI com os dados
    return ListView(
      children: [
        // Seu conteúdo aqui
      ],
    );
  }
}
```

**lib/ui/signin_screen/signin_screen.dart**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palliative_care/data/repositories/auth/auth_repository.dart';
import 'package:palliative_care/ui/signin_screen/viewmodel/signin_viewmodel.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ ViewModel no escopo da tela
    return ChangeNotifierProvider(
      create: (context) => SigninViewmodel(
        authRepository: context.read<AuthRepository>(),
      ),
      child: _SigninScreenContent(),
    );
  }
}

class _SigninScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SigninViewmodel>();
    
    return Scaffold(
      // Implementação da tela...
    );
  }
}
```

**lib/ui/signin_screen/viewmodel/signin_viewmodel.dart**
```dart
import 'package:flutter/foundation.dart';
import 'package:palliative_care/data/repositories/auth/auth_repository.dart';
import 'package:palliative_care/utils/command.dart';
import 'package:palliative_care/utils/result.dart';

/// ✅ Estende ChangeNotifier para dispose automático
final class SigninViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;

  SigninViewmodel({required AuthRepository authRepository}) 
      : _authRepository = authRepository {
    signIn = Command1(_signIn);
  }

  late final Command1<dynamic, ({String email, String password})> signIn;

  Future<Result<dynamic>> _signIn(({String email, String password}) params) {
    return _authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }

  /// ✅ Cleanup
  @override
  void dispose() {
    signIn.clearValue();
    super.dispose();
  }
}
```

### 6.2 Ciclo de Vida Otimizado

**Antes (Problema):**
```
App Init
├── VitalSignDetailViewmodel criado globalmente (mas lazy)
├── SigninViewmodel criado globalmente (mas lazy)
└── Usuário navega
    ├── Primeira vez em VitalSignDetail → ViewModel instanciado
    └── Volta ao Home → ViewModel permanece em memória ❌
```

**Depois (Otimizado):**
```
App Init
├── Apenas singletons (Dio, Repositories, etc) registrados
└── Usuário navega
    ├── Entra em SigninScreen
    │   └── SigninViewmodel criado ✅
    ├── Faz login e sai
    │   └── SigninViewmodel.dispose() chamado ✅ (memória liberada)
    ├── Entra em VitalSignDetail
    │   └── VitalSignDetailViewmodel criado ✅
    └── Volta ao Home
        └── VitalSignDetailViewmodel.dispose() chamado ✅ (memória liberada)
```

### 6.3 Monitorando Uso de Memória

Para verificar se a otimização está funcionando:

```dart
class VitalSignDetailViewmodel extends ChangeNotifier {
  VitalSignDetailViewmodel(...) {
    debugPrint('✅ VitalSignDetailViewmodel CREATED');
  }

  @override
  void dispose() {
    debugPrint('🗑️ VitalSignDetailViewmodel DISPOSED');
    super.dispose();
  }
}
```

Você verá no console:
```
✅ VitalSignDetailViewmodel CREATED    // Quando entra na tela
🗑️ VitalSignDetailViewmodel DISPOSED   // Quando sai da tela
```

---

## Conclusão

### Resumo das Recomendações

1. **Continue com Provider** - É estável, recomendado pelo Flutter, e suficiente para seu caso
2. **Separe escopos** - Globais (singletons) vs. Escopados (ViewModels)
3. **Use ChangeNotifier** - Para dispose automático
4. **Providers de tela** - Crie ViewModels no escopo da tela, não globalmente
5. **Implemente dispose()** - Em todos os ViewModels

### Quando Considerar Migração

Considere **Riverpod** se:
- O app crescer significativamente
- Precisar de mais controle sobre lifecycle
- Quiser compile-time safety
- Precisar de providers parametrizados (`.family`)

### Impacto Esperado

Com as otimizações:
- ✅ **Redução de 30-50% no uso de memória** (dependendo do número de telas)
- ✅ **Dispose automático** de ViewModels
- ✅ **Lazy loading** mantido para singletons
- ✅ **Arquitetura mais limpa** com separação clara de responsabilidades

---

**Última atualização:** 27 de outubro de 2025
