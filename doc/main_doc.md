# 🏗️ Guia de Arquitetura Flutter - Padrões e Princípios do Projeto

## 📌 **RESUMO DAS MUDANÇAS NA ARQUITETURA**

Este guia define o padrão arquitetural obrigatório para desenvolvimento no projeto W3AssinaDiploma.

### **Principais Mudanças:**


2. **🔗 Requisito SQL Obrigatório**: Antes de criar qualquer modelo, a estrutura SQL da tabela deve ser fornecida no prompt.

3. **🌐 URLs Centralizadas**: Todas as rotas da API devem ser declaradas em `/lib/config/constants/urls.dart` seguindo padrão REST.

4. **🔌 Injeção de Dependências**: Repositories devem ser registrados em `/lib/config/dependencies.dart` usando Provider.

5. **🔑 Chaves Estrangeiras**: Para cada FK no SQL, o repository correspondente deve ser injetado no ViewModel.

6. **📄 Paginação Backend**: Uso de `PaginatedResponse` e `QueryParams` para gerenciar dados paginados vindos do backend.

7. **🏗️ Arquitetura em 7 Camadas**:
   - 0️⃣ URLs e Rotas da API
   - 1️⃣ Domain Model (baseado no SQL)
   - 2️⃣ Repository Interface
   - 3️⃣ Repository Implementation (usando ApiClient)
   - 4️⃣ Injeção de Dependências
   - 5️⃣ ViewModel (com paginação e FKs)
   - 6️⃣ UI Screen

---

## 📊 **MODELO SQL - ESTRUTURA DA TABELA**

**IMPORTANTE**: Antes de criar qualquer modelo, a estrutura SQL da tabela deve ser fornecida no prompt. Esta será a base para a criação do Domain Model.

**Exemplo de entrada SQL necessária:**
```sql
CREATE TABLE Aluno (
    AlunoID INT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(200) NOT NULL,
    CPF VARCHAR(14) UNIQUE NOT NULL,
    RG VARCHAR(20),
    DataNascimento DATE,
    Sexo CHAR(1),
    -- Chaves Estrangeiras
    EnderecoID INT FOREIGN KEY REFERENCES Endereco(EnderecoID),
    TurmaID INT FOREIGN KEY REFERENCES Turma(TurmaID)
);
```

**⚠️ Observações sobre chaves estrangeiras:**
- Cada chave estrangeira identificada no SQL deve ter seu respectivo Repository criado
- Os Repositories de chaves estrangeiras devem ser injetados no ViewModel
- Os modelos das chaves estrangeiras devem ser adicionados ao contexto do prompt

---

## 🎯 **ARQUITETURA OBRIGATÓRIA (7 CAMADAS)**

### 0️⃣ **URLs e Rotas da API** (OBRIGATÓRIO)
**Path**: `/lib/config/constants/urls.dart`

**IMPORTANTE**: Após criar o Domain Model baseado no SQL, as rotas da API devem ser declaradas neste arquivo seguindo o padrão REST.

**Padrão obrigatório para rotas:**
```dart
// {NOME_ENTIDADE} (maiúsculo nos comentários, camelCase no código)
///GET: /api/{entidade}/get{Entidades}/{numeroBanco}
static String get{Entidades}({required String idBancoDeDados}) => '${urlBase}{entidade}/get{Entidades}/$idBancoDeDados';

///GET: /api/{entidade}/get{Entidade}/{numeroBanco}/{id}
static String get{Entidade}({required String idBancoDeDados, required String id{Entidade}}) => '${urlBase}{entidade}/get{Entidade}/$idBancoDeDados/$id{Entidade}';

///POST: /api/{entidade}/set{Entidade}/{numeroBanco}
static String set{Entidade}({required String idBancoDeDados}) => '${urlBase}{entidade}/set{Entidade}/$idBancoDeDados';

///PUT: /api/{entidade}/atualizar{Entidade}/{numeroBanco}/{id}
static String atualizar{Entidade}({required String idBancoDeDados, required String id{Entidade}}) => '${urlBase}{entidade}/atualizar{Entidade}/$idBancoDeDados/$id{Entidade}';

///DELETE: /api/{entidade}/deletar{Entidade}/{numeroBanco}/{id}
static String deletar{Entidade}({required String idBancoDeDados, required String id{Entidade}}) => '${urlBase}{entidade}/deletar{Entidade}/$idBancoDeDados/$id{Entidade}';
```

**Exemplo real (Alunos):**
```dart
//ALUNOS
///GET: /api/alunos/getAlunos/{numeroBanco}
static String getAlunos({required String id}) => '${urlBase}alunos/getAlunos/$id';

///GET: /api/alunos/getAluno/{numeroBanco}/{id}
static String getAluno({required String idBancoDeDados, required String idAluno}) => '${urlBase}alunos/getAluno/$idBancoDeDados/$idAluno';

///POST: /api/alunos/setAluno/{numeroBanco}
static String setAluno({required String idBancoDeDados}) => '${urlBase}alunos/setAluno/$idBancoDeDados';

///PUT: /api/alunos/atualizarAluno/{numeroBanco}/{id}
static String atualizarAluno({required String idBancoDeDados, required String idAluno}) => '${urlBase}alunos/atualizarAluno/$idBancoDeDados/$idAluno';

///DELETE: /api/alunos/deletarAluno/{numeroBanco}/{id}
static String deletarAluno({required String idBancoDeDados, required String idAluno}) => '${urlBase}alunos/deletarAluno/$idBancoDeDados/$idAluno';
```

---

### 1️⃣ **Domain Model** (OBRIGATÓRIO)
**Path**: `/lib/domain/models/{nome_modelo}/{nome_modelo}_model.dart`

**Métodos Obrigatórios**: `fromJson`, `toJson`, `copyWith`, `toString`

**IMPORTANTE**: O modelo deve ser criado com base na estrutura SQL fornecida no prompt. Cada coluna do SQL corresponde a uma propriedade do modelo.

**Mapeamento SQL → Dart:**
- `INT` → `int`
- `VARCHAR/TEXT` → `String`
- `DATE/DATETIME` → `DateTime`
- `CHAR(1)` → `String`
- `BIT/BOOLEAN` → `bool`
- `DECIMAL/FLOAT` → `double`
- `NULL` → tipo nullable (`int?`, `String?`, etc.)

**Exemplo baseado no SQL de Aluno:**
```dart
/// Modelo de domínio para Aluno
///
/// Representa um aluno no sistema com todos os dados necessários
/// conforme a tabela SQL Aluno.
final class AlunoModel {
  final int alunoID;
  final String nome;
  final String cpf;
  final String? rg;
  final DateTime? dataNascimento;
  final String? sexo;
  final int? enderecoID;  // Chave estrangeira
  final int? turmaID;     // Chave estrangeira

  const AlunoModel({
    required this.alunoID,
    required this.nome,
    required this.cpf,
    this.rg,
    this.dataNascimento,
    this.sexo,
    this.enderecoID,
    this.turmaID,
  });

  factory AlunoModel.fromJson(dynamic json) {
    return AlunoModel(
      alunoID: json['alunoID'] ?? 0,
      nome: json['nome'] ?? '',
      cpf: json['cpf'] ?? '',
      rg: json['rg'],
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.parse(json['dataNascimento'])
          : null,
      sexo: json['sexo'],
      enderecoID: json['enderecoID'],
      turmaID: json['turmaID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alunoID': alunoID,
      'nome': nome,
      'cpf': cpf,
      'rg': rg,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'sexo': sexo,
      'enderecoID': enderecoID,
      'turmaID': turmaID,
    };
  }

  AlunoModel copyWith({
    int? alunoID,
    String? nome,
    String? cpf,
    String? rg,
    DateTime? dataNascimento,
    String? sexo,
    int? enderecoID,
    int? turmaID,
  }) {
    return AlunoModel(
      alunoID: alunoID ?? this.alunoID,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      rg: rg ?? this.rg,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      sexo: sexo ?? this.sexo,
      enderecoID: enderecoID ?? this.enderecoID,
      turmaID: turmaID ?? this.turmaID,
    );
  }

  @override
  String toString() {
    return 'AlunoModel('
        'alunoID: $alunoID, '
        'nome: $nome, '
        'cpf: $cpf, '
        'rg: $rg, '
        'dataNascimento: $dataNascimento, '
        'sexo: $sexo, '
        'enderecoID: $enderecoID, '
        'turmaID: $turmaID'
        ')';
  }
}
```

---

### 2️⃣ **Repository Interface** (OBRIGATÓRIO)
**Path**: `/lib/data/repositories/{nome_modelo}/{nome_modelo}_repository.dart`

**IMPORTANTE**: A interface define os contratos para operações CRUD. Pode incluir métodos adicionais conforme necessidades específicas da entidade.

**Estrutura obrigatória:**
- Documentação completa de cada método
- Uso de `Result<T>` para tratamento de erros
- Suporte a paginação com `PaginatedResponse` quando aplicável
- Parâmetros nomeados (`required` quando obrigatório)

**Exemplo baseado em AlunoRepository:**
```dart
import 'package:w3_diploma/domain/models/aluno/aluno_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório de Alunos
///
/// Define os contratos para operações de CRUD e busca de alunos.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class AlunoRepository {
  /// 1. Buscar todos os itens com paginação, busca e ordenação
  ///
  /// Retorna alunos paginados conforme os parâmetros de consulta.
  /// Suporta paginação, busca por termo e ordenação por campo.
  ///
  /// **Parâmetros:**
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<AlunoModel>>` - Resposta paginada com alunos ou erro
  Future<Result<PaginatedResponse<AlunoModel>>> getAllAlunos({
    QueryParams? params,
  });

  /// 2. Buscar item por ID
  ///
  /// Busca um aluno específico pelo seu identificador único.
  ///
  /// **Parâmetros:**
  /// - `databaseId`: ID do banco de dados
  /// - `alunoId`: ID único do aluno
  ///
  /// **Retorna:**
  /// - `Result<AlunoModel>` - Aluno encontrado ou erro se não existir
  Future<Result<AlunoModel>> getAlunoById({
    required String databaseId,
    required String alunoId
  });

  /// 3. Criar novo item
  ///
  /// Cadastra um novo aluno no sistema.
  ///
  /// **Parâmetros:**
  /// - `aluno`: Modelo com dados do aluno a ser criado (ID será ignorado e gerado automaticamente)
  ///
  /// **Retorna:**
  /// - `Result<AlunoModel>` - Aluno criado com ID gerado ou erro de validação
  ///
  /// **Validações:**
  /// - CPF deve ser único no sistema
  /// - Todos os campos obrigatórios devem estar preenchidos
  Future<Result<AlunoModel>> createAluno({required AlunoModel aluno});

  /// 4. Atualizar item existente
  ///
  /// Atualiza os dados de um aluno já cadastrado.
  ///
  /// **Parâmetros:**
  /// - `aluno`: Modelo com dados atualizados do aluno (deve incluir o ID válido)
  ///
  /// **Retorna:**
  /// - `Result<AlunoModel>` - Aluno atualizado ou erro se não existir/validação falhar
  ///
  /// **Validações:**
  /// - Aluno deve existir no sistema
  /// - CPF deve ser único (exceto para o próprio aluno)
  Future<Result<AlunoModel>> updateAluno({required AlunoModel aluno});

  /// 5. Deletar item por ID
  ///
  /// Remove um aluno do sistema permanentemente.
  ///
  /// **Parâmetros:**
  /// - `alunoId`: ID único do aluno a ser removido
  ///
  /// **Retorna:**
  /// - `Result<dynamic>` - Sucesso vazio ou erro se não existir
  ///
  /// **⚠️ Atenção:**
  /// Esta operação é irreversível. Certifique-se de confirmar com o usuário.
  Future<Result<dynamic>> deleteAluno({required int alunoId});

  /// 6. MÉTODOS ADICIONAIS (OPCIONAIS)
  ///
  /// Métodos específicos da entidade podem ser adicionados conforme necessidade.
  /// Exemplo: buscar alunos por turma
  Future<Result<List<AlunoModel>>> getAlunosByTurma({required int turmaId});
}
```

**📝 Observações importantes:**
- Sempre documente validações e regras de negócio
- Métodos adicionais específicos da entidade são permitidos

---

### 3️⃣ **Repository Implementation** (OBRIGATÓRIO)
**Path**: `/lib/data/repositories/{nome_modelo}/{nome_modelo}_repository_impl.dart`

**IMPORTANTE**: A implementação utiliza `ApiClient` para fazer requisições HTTP à API backend. Não há uso de mocks em produção.

**Estrutura obrigatória:**
- Injeção de dependência do `ApiClient` via construtor
- Tratamento de erros com try-catch
- Log de erros usando `AppLogger`
- Uso das URLs declaradas em `Urls`
- Mapeamento de respostas JSON para modelos

**Exemplo baseado em AlunoRepositoryImpl:**
```dart
import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import '../../../domain/models/aluno/aluno_model.dart';
import '../../../utils/result.dart';
import 'aluno_repository.dart';

class AlunoRepositoryImpl implements AlunoRepository {
  AlunoRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<PaginatedResponse<AlunoModel>>> getAllAlunos({QueryParams? params}) async {
    try {
      // Usa parâmetros padrão se não fornecidos
      final queryParams = params ?? const QueryParams();

      // Constrói a URL com query string
      final baseUrl = Urls.getAlunos(id: '1');
      final queryString = queryParams.toQueryString();
      final fullUrl = '$baseUrl?$queryString';

      return await _apiClient
          .request(
            url: fullUrl,
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => PaginatedResponse<AlunoModel>.fromJson(
                data,
                (json) => AlunoModel.fromJson(json),
              ));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar alunos paginados', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<AlunoModel>> getAlunoById({required String databaseId, required String alunoId}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getAluno(idBancoDeDados: databaseId, idAluno: alunoId),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => AlunoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar aluno por ID', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<AlunoModel>> createAluno({required AlunoModel aluno}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.setAluno(idBancoDeDados: '1'),
            metodo: MetodoHttp.post,
            body: aluno.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => AlunoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao criar aluno', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<AlunoModel>> updateAluno({required AlunoModel aluno}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.atualizarAluno(
              idBancoDeDados: '1',
              idAluno: aluno.alunoID.toString(),
            ),
            metodo: MetodoHttp.put,
            body: aluno.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => AlunoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao atualizar aluno', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteAluno({required int alunoId}) async {
    try {
      return await _apiClient.request(
        url: Urls.deletarAluno(idBancoDeDados: '1', idAluno: '$alunoId'),
        metodo: MetodoHttp.delete,
        headers: Urls.bearerHeader,
      );
    } catch (e, s) {
      AppLogger.error('Erro ao deletar aluno', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<AlunoModel>>> getAlunosByTurma({required int turmaId}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getAluno(idBancoDeDados: '1', idAluno: '$turmaId'),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => (data as List).map((e) => AlunoModel.fromJson(e)).toList());
    } catch (e, s) {
      AppLogger.error('Erro ao buscar alunos por turma', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
}
```

**📝 Observações importantes:**
- **ApiClient**: Sempre injetado via construtor para facilitar testes
- **Tratamento de Erros**: Todo método deve ter try-catch com log apropriado
- **Headers**: Usar `Urls.bearerHeader` para autenticação
- **Database ID**: Por padrão usa '1', mas pode ser parametrizado
- **Result Pattern**: Sempre retornar `Result<T>` para tratamento consistente de erros

---

### 4️⃣ **Injeção de Dependências** (OBRIGATÓRIO)
**Path**: `/lib/config/dependencies.dart`

**IMPORTANTE**: Após criar o Repository e sua implementação, eles devem ser registrados no sistema de injeção de dependências.

**Estrutura obrigatória:**
- Usar `Provider` para registrar repositórios
- Usar `context.read()` para resolver dependências
- Seguir a ordem: ApiClient → Repositories → UseCases

**Exemplo baseado em dependencies.dart:**
```dart
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:w3_diploma/data/repositories/aluno/aluno_repository.dart';
import 'package:w3_diploma/data/repositories/aluno/aluno_repository_impl.dart';
// ... outros imports

List<SingleChildWidget> get providers {
  return [
    // 1. Cliente HTTP
    Provider(create: (context) => Dio()),

    // 2. ApiClient
    Provider(create: (context) => ApiClientImpl(context.read()) as ApiClient),

    // 3. Repositories - ADICIONE AQUI O NOVO REPOSITORY
    Provider(create: (context) => AlunoRepositoryImpl(apiClient: context.read()) as AlunoRepository),
    Provider(create: (context) => TurmaRepositoryImpl(apiClient: context.read()) as TurmaRepository),
    Provider(create: (context) => EnderecoRepositoryImpl(apiClient: context.read()) as EnderecoRepository),
    // ... outros repositories

    // 4. UseCases (se houver)
    // Provider(create: (context) => GerarXmlAcademicoUseCaseImpl() as GerarXmlAcademicoUseCase)
  ];
}
```

**📝 Padrão para adicionar novo repository:**
```dart
Provider(create: (context) => {Entidade}RepositoryImpl(apiClient: context.read()) as {Entidade}Repository),
```

**⚠️ Observações importantes:**
- Sempre registrar a implementação (`...Impl`) mas retornar como interface abstrata
- ApiClient deve ser resolvido via `context.read()`
- Ordem de declaração é importante: dependências devem vir antes de quem as usa

---

### 5️⃣ **ViewModel** (OBRIGATÓRIO)
**Path**: `/lib/ui/{nome_tela}/viewmodel/{nome_tela}_viewmodel.dart`

**IMPORTANTE**: O ViewModel implementa o padrão MVVM com Command Pattern e gerencia paginação do backend.

**Estrutura obrigatória:**
- Extends `ChangeNotifier` para reatividade
- Injeção de repositories via construtor (incluindo repositories de chaves estrangeiras)
- Commands para todas as operações CRUD
- Gerenciamento de paginação com `PaginatedResponse`
- Métodos auxiliares para navegação entre páginas e filtros

**⚠️ CHAVES ESTRANGEIRAS:**
- Para cada chave estrangeira no SQL, injete o repository correspondente no construtor
- Exemplo: Se a tabela tem `EnderecoID`, injete `EnderecoRepository`
- Crie commands para buscar os dados das entidades relacionadas

**Exemplo baseado em CursoViewModel:**
```dart
import 'package:flutter/widgets.dart';
import 'package:w3_diploma/data/repositories/curso/curso_repository.dart';
import 'package:w3_diploma/data/repositories/endereco/endereco_repository.dart';
import 'package:w3_diploma/data/repositories/ies_emissora/ies_emissora_repository.dart';
import 'package:w3_diploma/domain/models/curso/curso_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

/// ViewModel para a tela de gerenciamento de cursos
///
/// Implementa o padrão MVVM com Command Pattern para separar a lógica de negócio
/// da interface do usuário com suporte a paginação, busca e ordenação via backend.
final class CursoViewModel extends ChangeNotifier {
  final CursoRepository _cursoRepository;
  final EnderecoRepository _enderecoRepository;
  final IesEmissoraRepository _iesEmissoraRepository;

  CursoViewModel({
    required CursoRepository cursoRepository,
    required EnderecoRepository enderecoRepository,
    required IesEmissoraRepository iesEmissoraRepository,
  })  : _cursoRepository = cursoRepository,
        _enderecoRepository = enderecoRepository,
        _iesEmissoraRepository = iesEmissoraRepository {
    // Inicializa os comandos CRUD
    getAllCursos = Command0(_getAllCursos);
    createCurso = Command1(_createCurso);
    updateCurso = Command1(_updateCurso);
    deleteCurso = Command1(_deleteCurso);
    buscarEndereco = Command1(_buscarEndereco);
    getAllIesEmissoras = Command0(_getAllIesEmissoras);
  }

  // ==================== COMMANDS ====================

  /// Comando para buscar todos os cursos com paginação
  late final Command0<PaginatedResponse<CursoModel>> getAllCursos;

  /// Comando para criar um novo curso
  late final Command1<CursoModel, CursoModel> createCurso;

  /// Comando para atualizar um curso existente
  late final Command1<CursoModel, CursoModel> updateCurso;

  /// Comando para deletar um curso
  late final Command1<void, int> deleteCurso;

  /// Comando para buscar endereço por CEP
  late final Command1<EnderecoApiModel, String> buscarEndereco;

  /// Comando para buscar IES Emissora
  late final Command0<IesEmissoraModel> getAllIesEmissoras;


  // ==================== STATE ====================

  PaginatedResponse<CursoModel>? _paginatedResponse;
  QueryParams _currentParams = const QueryParams();

  // ==================== GETTERS ====================

  /// Lista de cursos da página atual
  List<CursoModel> get cursos => _paginatedResponse?.data ?? [];

  /// Página atual
  int get currentPage => _paginatedResponse?.page ?? 1;

  /// Tamanho da página
  int get pageSize => _paginatedResponse?.pageSize ?? 10;

  /// Total de registros
  int get totalRecords => _paginatedResponse?.totalRecords ?? 0;

  /// Total de páginas
  int get totalPages => _paginatedResponse?.totalPages ?? 1;

  /// Verifica se há próxima página
  bool get hasNextPage => currentPage < totalPages;

  /// Verifica se há página anterior
  bool get hasPreviousPage => currentPage > 1;


  // ==================== PRIVATE METHODS ====================

  /// Busca todos os cursos com os parâmetros atuais
  Future<Result<PaginatedResponse<CursoModel>>> _getAllCursos() async {
    return await _cursoRepository.getAllCursos(params: _currentParams)
    .map((response) {
      _paginatedResponse = response;
      notifyListeners();
      return response;
    });
  }

  /// Cria um novo curso
  Future<Result<CursoModel>> _createCurso(CursoModel curso) async {
    return await _cursoRepository.createCurso(curso: curso)
    .map((createdCurso) {
      _paginatedResponse?.data.add(createdCurso);
      notifyListeners();
      return createdCurso;
    });
  }

  /// Atualiza um curso existente
  Future<Result<CursoModel>> _updateCurso(CursoModel curso) async {
    return await _cursoRepository.updateCurso(curso: curso)
    .map((updatedCurso) {
      final index = _paginatedResponse?.data.indexWhere((c) => c.cursoID == updatedCurso.cursoID);
      if (index != null && index != -1) {
        _paginatedResponse?.data[index] = updatedCurso;
        notifyListeners();
      }
      return updatedCurso;
    });
  }

  /// Deleta um curso
  Future<Result<void>> _deleteCurso(int cursoId) async {
    return await _cursoRepository.deleteCurso(cursoId: cursoId)
    .map((_) {
      _paginatedResponse?.data.removeWhere((c) => c.cursoID == cursoId);
      notifyListeners();
    });
  }

  /// Busca endereço por CEP
  Future<Result<EnderecoApiModel>> _buscarEndereco(String cep) async {
    final result = await _enderecoRepository.buscarEndereco(cep: cep);
    return result;
  }

  Future<Result<IesEmissoraModel>> _getAllIesEmissoras() async {
    final result = await _iesEmissoraRepository.getAllIesEmissoras();
    return result;
  }


  // ==================== PAGINATION METHODS ====================

  /// Navega para uma página específica
  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;

    _currentParams = _currentParams.copyWith(page: page);
    getAllCursos.execute();
  }

  /// Vai para a próxima página
  void goToNextPage() {
    if (hasNextPage) {
      goToPage(currentPage + 1);
    }
  }

  /// Volta para a página anterior
  void goToPreviousPage() {
    if (hasPreviousPage) {
      goToPage(currentPage - 1);
    }
  }

  /// Atualiza o termo de busca e reseta para a primeira página
  void updateSearch(String searchTerm) {
    _currentParams = _currentParams.copyWith(
      search: searchTerm.isEmpty ? null : searchTerm,
      page: 1,
    );
    getAllCursos.execute();
  }

  /// Limpa todos os filtros
  void clearAllFilters() {
    _currentParams = const QueryParams(page: 1);
    getAllCursos.execute();
  }

  @override
  void dispose() {
    getAllCursos.dispose();
    createCurso.dispose();
    updateCurso.dispose();
    deleteCurso.dispose();
    buscarEndereco.dispose();
    super.dispose();
  }
}
```

**📝 Observações importantes:**
- **Organização por Seções**: Use comentários `// ====================` para separar as seções do código
- **Seções Obrigatórias**:
  - `COMMANDS`: Declaração de todos os commands late final
  - `STATE`: Variáveis de estado privadas (ex: `_paginatedResponse`, `_currentParams`)
  - `GETTERS`: Getters públicos para expor estado à UI
  - `PRIVATE METHODS`: Métodos privados que executam a lógica dos commands
  - `PAGINATION METHODS`: Métodos públicos para navegação e filtros
- **Repositories de FK**: Injete todos os repositories das chaves estrangeiras identificadas no SQL
- **Atualização Local**: Após create/update/delete, atualize `_paginatedResponse` localmente e chame `notifyListeners()`
- **Dispose**: Faça dispose explícito de todos os commands

### 6️⃣ **UI Screen** (OBRIGATÓRIO)
**Path**: `/lib/ui/{nome_tela}/widget/{nome_tela}.dart`

**Padrões Obrigatórios**:
- `initState`: Listeners para 3 commands (update, delete, create) + `getAllTasks.execute()`
- `dispose`: Remover todos os listeners
- `_onResult`: Feedback visual para operações CRUD
- `ListenableBuilder`: Estados loading/error/empty/success
- **ESTILIZAÇÃO OBRIGATÓRIA**: Tipografia e cores conforme mapeamentos abaixo

**⚠️ ORGANIZAÇÃO DE COMPONENTES OBRIGATÓRIA:**

Para evitar que a screen principal fique muito grande, **DEVE-SE** criar uma pasta `componentes` dentro da estrutura:

```
/lib/ui/{nome_tela}/widget/
├── {nome_tela}.dart                    # ← Screen principal (LIMPA E ENXUTA)
└── componentes/                        # ← Pasta obrigatória para componentes
    ├── {nome_tela}_card.dart          # ← Card/item da lista
    ├── {nome_tela}_form_dialog.dart   # ← Modal de criação/edição
    ├── {nome_tela}_filter_bar.dart    # ← Barra de filtros
    ├── {nome_tela}_stats_panel.dart   # ← Painel de estatísticas
    └── {nome_tela}_empty_state.dart   # ← Estado vazio customizado
```

**🚫 NÃO CRIAR componentes muito pequenos** (menos de 30 linhas) - prefira manter na screen principal.

**✅ CRIAR componentes quando tiver:**
- Cards complexos com múltiplas interações
- Formulários de criação/edição
- Modais ou dialogs elaborados
- Barras de filtro ou busca
- Painéis de estatísticas
- Estados vazios customizados
- Seções com lógica própria

#### 🎨 **MAPEAMENTO DE ESTILOS OBRIGATÓRIO**

##### 📝 **Tipografia (CustomTextTheme)**

**IMPORTANTE**: Todo `Theme.of(context).textTheme` DEVE ser substituído por `context.customTextTheme`:

| Descrição | Tamanho | Peso | Flutter Equivalent (OBRIGATÓRIO) |
|-----------|---------|------|--------------------------------|
| Extra Large Bold | 36px | 700 | `context.customTextTheme.text4xlBold` |
| 3XL Bold | 30px | 700 | `context.customTextTheme.text3xlBold` |
| 2XL Bold | 24px | 700 | `context.customTextTheme.text2xlBold` |
| XL Semibold | 20px | 600 | `context.customTextTheme.textXlSemibold` |
| XL Medium | 20px | 500 | `context.customTextTheme.textXlMedium` |
| Large Semibold | 18px | 600 | `context.customTextTheme.textLgSemibold` |
| Large Medium | 18px | 500 | `context.customTextTheme.textLgMedium` |
| Base Medium | 16px | 500 | `context.customTextTheme.textBaseMedium` |
| Base | 16px | 400 | `context.customTextTheme.textBase` |
| Small Semibold | 14px | 600 | `context.customTextTheme.textSmSemibold` |
| Small Medium | 14px | 500 | `context.customTextTheme.textSmMedium` |
| Small | 14px | 400 | `context.customTextTheme.textSm` |
| Extra Small Medium | 12px | 500 | `context.customTextTheme.textXsMedium` |
| Extra Small | 12px | 400 | `context.customTextTheme.textXs` |

##### 🎨 **Cores (NewAppColorTheme)**

**IMPORTANTE**: Todo `Colors.*`, `Theme.of(context).colorScheme.*` DEVE ser substituído por `context.customColorTheme`:

| Descrição | Flutter Equivalent (OBRIGATÓRIO) |
|-----------|--------------------------------|
| Fundo principal | `context.customColorTheme.background` |
| Texto principal | `context.customColorTheme.foreground` |
| Cor primária | `context.customColorTheme.primary` |
| Texto sobre primário | `context.customColorTheme.primaryForeground` |
| Primário claro | `context.customColorTheme.primaryLight` |
| Primário escuro | `context.customColorTheme.primaryShade` |
| Cor secundária | `context.customColorTheme.secondary` |
| Texto sobre secundário | `context.customColorTheme.secondaryForeground` |
| Verde de sucesso | `context.customColorTheme.success` |
| Texto sobre sucesso | `context.customColorTheme.successForeground` |
| Laranja de aviso | `context.customColorTheme.warning` |
| Texto sobre aviso | `context.customColorTheme.warningForeground` |
| Vermelho de erro | `context.customColorTheme.destructive` |
| Texto sobre erro | `context.customColorTheme.destructiveForeground` |
| Fundo de cards | `context.customColorTheme.card` |
| Texto em cards | `context.customColorTheme.cardForeground` |
| Fundo neutro | `context.customColorTheme.muted` |
| Texto secundário | `context.customColorTheme.mutedForeground` |
| Cor de destaque | `context.customColorTheme.accent` |
| Texto sobre destaque | `context.customColorTheme.accentForeground` |
| Bordas | `context.customColorTheme.border` |
| Fundo de inputs | `context.customColorTheme.background` |
| Foco/seleção | `context.customColorTheme.ring` |

##### 🚫 **CONVERSÕES PROIBIDAS**

❌ **NÃO usar**:
- `Theme.of(context).textTheme.*`
- `Colors.red`, `Colors.blue`, `Colors.green`, etc.
- `context.colorScheme.*`
- Cores hardcoded como `Color(0xFF...)`

✅ **SEMPRE usar**:
- `context.customTextTheme.*`
- `context.customColorTheme.*`

##### 📦 **Import Obrigatório**

```dart
import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';
```

##### 🎯 **Exemplos de Estilização Obrigatória**

```dart
// ❌ ERRADO - Não usar
Text(
  'Título',
  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)

// ✅ CORRETO - Usar sempre
Text(
  'Título',
  style: context.customTextTheme.text2xlBold.copyWith(
    color: context.customColorTheme.primary,
  ),
)

// ❌ ERRADO - Card com cores hardcoded
Card(
  color: Colors.white,
  child: Text('Conteúdo', style: TextStyle(color: Colors.black)),
)

// ✅ CORRETO - Card com tema customizado
Card(
  color: context.customColorTheme.card,
  child: Text(
    'Conteúdo',
    style: context.customTextTheme.textBase.copyWith(
      color: context.customColorTheme.cardForeground,
    ),
  ),
)
```

#### 📱 **Exemplo Completo de UI Screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mastering_tests/domain/models/task_model.dart';
import 'package:mastering_tests/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:mastering_tests/utils/command.dart';
import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';

final class TodoListScreen extends StatefulWidget {
  final TaskViewModel viewModel;

  const TodoListScreen({super.key, required this.viewModel});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    // LISTENERS OBRIGATÓRIOS PARA 3 COMMANDS
    widget.viewModel.updateTask.addListener(() => _onResult(command: widget.viewModel.updateTask, successMessage: 'Tarefa atualizada com sucesso!'));
    widget.viewModel.deleteTask.addListener(() => _onResult(command: widget.viewModel.deleteTask, successMessage: 'Tarefa excluída com sucesso!'));
    widget.viewModel.createTask.addListener(() => _onResult(command: widget.viewModel.createTask, successMessage: 'Tarefa criada com sucesso!'));
    // EXECUTAR GET ALL OBRIGATÓRIO
    widget.viewModel.getAllTasks.execute();
  }

  @override
  void dispose() {
    // DISPOSE DE TODOS OS LISTENERS OBRIGATÓRIO
    widget.viewModel.updateTask.removeListener(() => _onResult(command: widget.viewModel.updateTask, successMessage: 'Tarefa atualizada com sucesso!'));
    widget.viewModel.deleteTask.removeListener(() => _onResult(command: widget.viewModel.deleteTask, successMessage: 'Tarefa excluída com sucesso!'));
    widget.viewModel.createTask.removeListener(() => _onResult(command: widget.viewModel.createTask, successMessage: 'Tarefa criada com sucesso!'));
    super.dispose();
  }

  /// MÉTODO _onResult OBRIGATÓRIO PARA FEEDBACK VISUAL
  void _onResult({required Command command, required String successMessage}) {
    if(command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${command.errorMessage ?? 'Ocorreu um erro desconhecido.'}'),
          backgroundColor: context.customColorTheme.destructive,
        ),
      );
    } else if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: context.customColorTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => widget.viewModel.getAllTasks.execute(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.getAllTasks,
        ]),
        builder: (context, _) {
          /// ESTADO LOADING OBRIGATÓRIO
          if (widget.viewModel.getAllTasks.running) {
            return const Center(child: CupertinoActivityIndicator());
          }

          /// ESTADO ERROR OBRIGATÓRIO
          if (widget.viewModel.getAllTasks.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Erro ao carregar tarefas: ${widget.viewModel.getAllTasks.errorMessage}',
                  style: context.customTextTheme.textBase.copyWith(
                    color: context.customColorTheme.destructive,
                  ),
                ),
              ),
            );
          }

          /// ESTADO EMPTY OBRIGATÓRIO
          if (widget.viewModel.tasks.isEmpty) {
            return Center(
              child: Text(
                'Nenhuma tarefa encontrada',
                style: context.customTextTheme.textLgMedium.copyWith(
                  color: context.customColorTheme.mutedForeground,
                ),
              ),
            );
          }

          /// ESTADO SUCCESS - LISTA DE DADOS
          return ListView.builder(
            itemCount: widget.viewModel.tasks.length,
            itemBuilder: (context, index) {
              final task = widget.viewModel.tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: context.customColorTheme.card,
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) => _toggleTaskCompletion(task),
                  ),
                  title: Text(
                    task.title,
                    style: context.customTextTheme.textBaseMedium.copyWith(
                      color: context.customColorTheme.cardForeground,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    task.description,
                    style: context.customTextTheme.textSm.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: context.customColorTheme.primary,
                        ),
                        onPressed: () => _editTask(task),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: context.customColorTheme.destructive,
                        ),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    ],
                  ),
                  onTap: () => _showTaskDetails(task),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewTask,
        backgroundColor: context.customColorTheme.primary,
        foregroundColor: context.customColorTheme.primaryForeground,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ... métodos CRUD implementados conforme necessário
  void _toggleTaskCompletion(TaskModel task) {
    // Implementação
  }

  void _editTask(TaskModel task) {
    // Implementação
  }

  void _deleteTask(String id) {
    // Implementação
  }

  void _showTaskDetails(TaskModel task) {
    // Implementação
  }

  void _createNewTask() {
    // Implementação
  }
}
```

## 📋 **CHECKLIST DE IMPLEMENTAÇÃO OBRIGATÓRIO**

### ✅ **Fase 0: Preparação (OBRIGATÓRIA)**
- [ ] **SQL Fornecido**: Estrutura da tabela SQL está disponível no prompt
- [ ] **Chaves Estrangeiras Identificadas**: Listar todas as FKs e seus modelos correspondentes
- [ ] **Repositories de FK Criados**: Garantir que os repositories das FKs já existem
- [ ] **Modelos de FK no Contexto**: Adicionar os modelos das FKs ao contexto do prompt

### ✅ **Fase 1: Verificação de Arquitetura (OBRIGATÓRIA)**
- [ ] **URLs Criadas**: Rotas da API declaradas em `urls.dart` seguindo padrão REST
- [ ] **Domain Model**: Classe criada baseada no SQL com 4 métodos obrigatórios (`toJson`, `fromJson`, `copyWith`, `toString`)
- [ ] **Repository Interface**: Interface com métodos CRUD + métodos específicos documentados
- [ ] **Repository Implementation**: Implementação usando `ApiClient` com tratamento de erros
- [ ] **Injeção de Dependências**: Repository registrado em `dependencies.dart`
- [ ] **ViewModel**: Command pattern com commands CRUD + commands para FKs + paginação
- [ ] **UI Screen**: ListenableBuilder com 4 estados obrigatórios + estilização customizada

### ✅ **Fase 2: Padrões Arquiteturais (OBRIGATÓRIOS)**
- [ ] **Command Pattern**: Commands implementados (getAll com paginação, getBy, create, update, delete)
- [ ] **Result Pattern**: Retornos tipados para tratamento de erros
- [ ] **Repository Pattern**: Inversão de dependência na ViewModel
- [ ] **Observer Pattern**: ChangeNotifier + ListenableBuilder
- [ ] **Pagination Pattern**: PaginatedResponse + QueryParams para gerenciar dados do backend
- [ ] **Dependency Injection**: Provider para injeção de dependências

### ✅ **Fase 3: Estados da UI (OBRIGATÓRIOS)**
- [ ] **Loading State**: CupertinoActivityIndicator quando `command.running == true`
- [ ] **Error State**: Widget de erro quando `command.error == true`
- [ ] **Empty State**: Widget vazio quando lista está vazia
- [ ] **Success State**: Lista de dados quando `command.completed == true`

### ✅ **Fase 4: Lifecycle Obrigatório**
- [ ] **initState**: 3 listeners (create, update, delete) + `getAllTasks.execute()`
- [ ] **dispose**: Remoção de todos os listeners
- [ ] **_onResult**: Feedback visual com SnackBar para success/error

### ✅ **Fase 5: Estilização (OBRIGATÓRIA)**
- [ ] **Import Build Context Extension**: `import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';`
- [ ] **Tipografia Customizada**: Todos os textos usando `context.customTextTheme.*`
- [ ] **Cores Customizadas**: Todas as cores usando `context.customColorTheme.*`
- [ ] **Headers**: Títulos usando `context.customTextTheme.text2xlBold` ou similar
- [ ] **Cards**: Fundos usando `context.customColorTheme.card` e textos `context.customColorTheme.cardForeground`
- [ ] **Botões**: Cores primárias usando `context.customColorTheme.primary/primaryForeground`
- [ ] **Estados**: Success usando `context.customColorTheme.success`, Error usando `context.customColorTheme.destructive`
- [ ] **Inputs**: Bordas usando `context.customColorTheme.border`, foco usando `context.customColorTheme.ring`
- [ ] **Textos Secundários**: Usando `context.customColorTheme.mutedForeground`
- [ ] **Validação**: Nenhuma cor hardcoded ou tema padrão Flutter sendo usado

## 🚀 **WORKFLOW DE IMPLEMENTAÇÃO OBRIGATÓRIO**

### 📝 **Ordem de Implementação (SEGUIR EXATAMENTE)**

#### **0. Preparação** (2 min)
```bash
# Verificar pré-requisitos:
✅ SQL da tabela fornecido no prompt
✅ Identificar chaves estrangeiras (FKs)
✅ Verificar se repositories das FKs existem
✅ Adicionar modelos das FKs ao contexto
```

#### **1. URLs da API** (3 min)
```bash
# Editar arquivo
/lib/config/constants/urls.dart

# Adicionar rotas seguindo padrão REST:
✅ GET: get{Entidades}({required String idBancoDeDados})
✅ GET: get{Entidade}({required String idBancoDeDados, required String id{Entidade}})
✅ POST: set{Entidade}({required String idBancoDeDados})
✅ PUT: atualizar{Entidade}({required String idBancoDeDados, required String id{Entidade}})
✅ DELETE: deletar{Entidade}({required String idBancoDeDados, required String id{Entidade}})
```

#### **2. Domain Model** (5-10 min)
```bash
# Criar arquivo
/lib/domain/models/{nome_modelo}/{nome_modelo}_model.dart

# Implementar baseado no SQL:
✅ Classe final com propriedades mapeadas do SQL
✅ Identificar campos nullable (NULL no SQL → tipo? no Dart)
✅ factory fromJson(dynamic json) com tratamento de nulls
✅ Map<String, dynamic> toJson()
✅ copyWith() para atualizações imutáveis
✅ toString() para debug
✅ Incluir IDs de chaves estrangeiras como int?
```

#### **3. Repository Interface** (5 min)
```bash
# Criar arquivo
/lib/data/repositories/{nome_modelo}/{nome_modelo}_repository.dart

# Implementar obrigatoriamente:
✅ abstract interface class
✅ Documentação completa de cada método
✅ getAll{Entidade}({QueryParams? params}) → PaginatedResponse
✅ get{Entidade}ById({required String databaseId, required String id})
✅ create{Entidade}({required {Entidade} item})
✅ update{Entidade}({required {Entidade} item})
✅ delete{Entidade}({required int id})
✅ Métodos adicionais específicos (se necessário)
```

#### **4. Repository Implementation** (10 min)
```bash
# Criar arquivo
/lib/data/repositories/{nome_modelo}/{nome_modelo}_repository_impl.dart

# Implementar obrigatoriamente:
✅ class implements {Entidade}Repository
✅ Constructor com ApiClient injetado
✅ Todos os métodos usando ApiClient.request()
✅ Try-catch com AppLogger.error() em cada método
✅ Mapeamento de JSON para Model usando .fromJson()
✅ Usar URLs declaradas em Urls.{metodo}()
✅ Headers com Urls.bearerHeader
```

#### **5. Injeção de Dependências** (2 min)
```bash
# Editar arquivo
/lib/config/dependencies.dart

# Adicionar provider:
✅ Provider(create: (context) => {Entidade}RepositoryImpl(apiClient: context.read()) as {Entidade}Repository)
✅ Verificar ordem: deve vir depois de ApiClient
```

#### **6. ViewModel** (15-20 min)
```bash
# Criar arquivo
/lib/ui/{nome_tela}/viewmodel/{nome_tela}_viewmodel.dart

# Implementar obrigatoriamente:
✅ class extends ChangeNotifier
✅ Constructor com Repository principal + Repositories de FKs
✅ PaginatedResponse<Model>? _paginatedResponse
✅ QueryParams _currentParams
✅ Getters para paginação (currentPage, totalPages, hasNextPage, etc.)
✅ 5 Commands CRUD (getAll, getById, create, update, delete)
✅ Commands para buscar dados de FKs
✅ Métodos de navegação (goToPage, goToNextPage, goToPreviousPage)
✅ Métodos de filtro (updateSearch, updateSort, clearFilters)
✅ Recarregar getAllItems após create/update/delete
```

#### **7. UI Screen** (20-30 min)
```bash
# Criar arquivo
/lib/ui/{nome_tela}/widget/{nome_tela}.dart

# Implementar obrigatoriamente:
✅ StatefulWidget com ViewModel injection
✅ initState() com 3 listeners + getAllItems.execute()
✅ dispose() removendo todos os listeners
✅ _onResult() para feedback SnackBar
✅ ListenableBuilder com Listenable.merge()
✅ 4 estados: loading, error, empty, success
✅ CRUD UI (create, edit, delete dialogs)
✅ Paginação UI (botões prev/next, indicador de página)
✅ Busca e filtros UI
✅ Estilização usando context.customTextTheme e context.customColorTheme
✅ Criar componentes em /componentes/ se necessário
```

## 📌 **OBSERVAÇÕES IMPORTANTES**

### ⚠️ **Documentação**
- Após concluída toda a implementação, **não é necessário** criar arquivos README ou documentação adicional
- O código deve ser autoexplicativo com comentários inline quando necessário

### 🎯 **Princípios de Design**
- **Clean Architecture**: Separação clara entre camadas (Domain, Data, UI)
- **SOLID**: Principalmente Single Responsibility e Dependency Inversion
- **DRY**: Reutilização de componentes e lógica
- **KISS**: Manter a simplicidade sempre que possível
- **Testabilidade**: Todo código deve ser facilmente testável com mocks

### 🔄 **Padrões de Estado**
- **Command Pattern**: Para operações assíncronas com estados (running, completed, error)
- **Observer Pattern**: Para reatividade da UI (ChangeNotifier + ListenableBuilder)
- **Result Pattern**: Para tratamento de erros de forma type-safe

### 🌐 **Internacionalização**
- Todos os textos devem estar em português brasileiro
- Métodos, variáveis e classes devem seguir camelCase em inglês
- Mensagens de usuário e labels devem estar em português
