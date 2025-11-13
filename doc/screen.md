# 📱 Guia de Criação de Telas Flutter

## 📋 **ÍNDICE**

1. [Comunicação entre Tela e ViewModel](#comunicação-entre-tela-e-viewmodel)
2. [Estrutura da UI Screen](#estrutura-da-ui-screen)
3. [Componentes Reutilizáveis](#componentes-reutilizáveis)
4. [Organização de Componentes](#organização-de-componentes)
5. [Estilização Obrigatória](#estilização-obrigatória)
6. [Checklist de Implementação](#checklist-de-implementação)

---

## 🔌 **COMUNICAÇÃO ENTRE TELA E VIEWMODEL**

### **5️⃣ ViewModel - Como a Tela se Comunica**

**Path**: `/lib/ui/{nome_tela}/viewmodel/{nome_tela}_viewmodel.dart`

A ViewModel implementa o padrão MVVM com Command Pattern e gerencia a comunicação entre a UI e os repositórios.

#### **Estrutura Obrigatória:**
- Extends `ChangeNotifier` para reatividade
- Injeção de repositories via construtor (incluindo repositories de chaves estrangeiras)
- Commands para todas as operações CRUD
- Gerenciamento de paginação com `PaginatedResponse`
- Métodos auxiliares para navegação entre páginas e filtros

#### **Exemplo Completo de ViewModel:**

```dart
import 'package:flutter/widgets.dart';
import 'package:w3_diploma/data/repositories/curso/curso_repository.dart';
import 'package:w3_diploma/data/repositories/endereco/endereco_repository.dart';
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

  CursoViewModel({
    required CursoRepository cursoRepository,
    required EnderecoRepository enderecoRepository,
  })  : _cursoRepository = cursoRepository,
        _enderecoRepository = enderecoRepository {
    // Inicializa os comandos CRUD
    getAllCursos = Command0(_getAllCursos);
    createCurso = Command1(_createCurso);
    updateCurso = Command1(_updateCurso);
    deleteCurso = Command1(_deleteCurso);
    buscarEndereco = Command1(_buscarEndereco);
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

#### **📝 Como a Tela Interage com a ViewModel:**

1. **Inicialização**: No `initState()`, adicione listeners aos commands
2. **Executar Ações**: Chame `.execute()` nos commands (ex: `viewModel.getAllCursos.execute()`)
3. **Observar Estado**: Use `ListenableBuilder` para reagir às mudanças
4. **Feedback Visual**: Use `_onResult()` para mostrar SnackBars de sucesso/erro

---

## 📱 **ESTRUTURA DA UI SCREEN**

### **6️⃣ UI Screen - Layout Obrigatório**

**Path**: `/lib/ui/{nome_tela}/widget/{nome_tela}.dart`

#### **Padrões Obrigatórios:**
- `initState`: Listeners para 3 commands (update, delete, create) + `getAllTasks.execute()`
- `dispose`: Remover todos os listeners
- `_onResult`: Feedback visual para operações CRUD
- `ListenableBuilder`: Estados loading/error/empty/success
- **ESTILIZAÇÃO OBRIGATÓRIA**: Tipografia e cores conforme mapeamentos abaixo

#### **Exemplo Completo de UI Screen:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:w3_diploma/domain/models/task_model.dart';
import 'package:w3_diploma/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:w3_diploma/utils/command.dart';
import 'package:w3_diploma/ui/core/extensions/build_context_extension.dart';

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

---

## 🧩 **COMPONENTES REUTILIZÁVEIS**

**Path**: `/lib/ui/core/componentes_reutilizaveis/`

**⚠️ IMPORTANTE**: Sempre que precisar criar um componente que poderia ser reutilizado em outras telas, **crie-o na pasta de componentes reutilizáveis** e **atualize esta documentação** informando o novo componente.

### **Componentes Disponíveis:**

#### **1. CepTextField**
Campo de texto para CEP com máscara automática e busca de endereço via API.

**Uso:**
```dart
import 'package:w3_diploma/ui/core/componentes_reutilizaveis/cep_text_field.dart';

CepTextField(
  controller: _cepController,
  buscarCep: viewModel.buscarEndereco,
  isRequired: true,
  comLabelExterna: false,
  onBuscaIniciada: () {
    // Callback quando a busca é iniciada
  },
)
```

**Características:**
- Máscara automática `#####-###`
- Busca automática quando CEP completo (8 dígitos)
- Indicador de loading durante busca
- Validação de formato
- Suporte a label externa ou interna

---

#### **2. CustomDatePicker**
Seletor de data customizado com validação.

**Uso:**
```dart
import 'package:w3_diploma/ui/core/componentes_reutilizaveis/custom_datepicker_field.dart';

CustomDatePicker(
  label: 'Data de Nascimento *',
  value: _dataNascimento,
  onDateSelected: (date) {
    setState(() {
      _dataNascimento = date;
    });
  },
  isRequired: true,
)
```

**Características:**
- Interface nativa do Flutter
- Formato `dd/MM/yyyy`
- Validação de campo obrigatório
- Range de datas configurável (1900-2100)
- Estilização customizada

---

#### **3. CustomDropdown**
Dropdown simples sem busca.

**Uso:**
```dart
import 'package:w3_diploma/ui/core/componentes_reutilizaveis/custom_dropdown.dart';

CustomDropdown<String>(
  label: 'Estado *',
  valorInicial: _estadoSelecionado,
  itens: [
    DropdownMenuItem(value: 'SP', child: Text('São Paulo')),
    DropdownMenuItem(value: 'RJ', child: Text('Rio de Janeiro')),
    DropdownMenuItem(value: 'MG', child: Text('Minas Gerais')),
  ],
  aoSelecionar: (valor) {
    setState(() {
      _estadoSelecionado = valor;
    });
  },
  validador: (value) {
    if (value == null) return 'Este campo é obrigatório';
    return null;
  },
)
```

**Características:**
- Genérico (`T`)
- Validação customizável
- Estilização com tema customizado
- Ícone prefixo configurável

---

#### **4. SearchableDropdown**
Dropdown avançado com campo de busca para grandes listas.

**Uso:**
```dart
import 'package:w3_diploma/ui/core/componentes_reutilizaveis/searchable_dropdown.dart';

final _turmaController = ValueNotifier<TurmaModel?>(null);

SearchableDropdown<TurmaModel>(
  controller: _turmaController,
  label: 'Turma',
  items: viewModel.turmas,
  itemAsString: (turma) => turma.nome,
  itemId: (turma) => turma.turmaID,
  searchHint: 'Buscar turma...',
  isRequired: true,
  validator: (value) {
    if (value == null) return 'Selecione uma turma';
    return null;
  },
  onChanged: (turma) {
    // Callback quando um item é selecionado
  },
)
```

**Características:**
- Genérico (`T`)
- Busca em tempo real com filtro
- Overlay customizado
- Seleção com indicador visual
- Validação integrada ao FormField
- Gerenciamento via `ValueNotifier`
- Atualização automática da lista de itens
- Estados vazios tratados

---

### **📝 Quando Criar um Novo Componente Reutilizável:**

✅ **CRIAR componente reutilizável quando:**
- O mesmo componente é usado em 2+ telas
- O componente tem lógica complexa (> 50 linhas)
- O componente pode ser parametrizado para diferentes contextos
- Exemplos: formulários, cards, inputs customizados, modais

❌ **NÃO criar componente reutilizável quando:**
- O componente é específico de uma única tela
- O componente tem menos de 30 linhas
- O componente não tem lógica reutilizável

### **🔄 Processo ao Criar Novo Componente Reutilizável:**

1. **Criar arquivo** em `/lib/ui/core/componentes_reutilizaveis/{nome_componente}.dart`
2. **Implementar componente** seguindo padrões:
   - Usar `context.customTextTheme` e `context.customColorTheme`
   - Documentar parâmetros com comentários
   - Adicionar validação quando aplicável
   - Suportar genericidade quando fizer sentido
3. **Atualizar ESTA documentação** adicionando:
   - Nome do componente
   - Exemplo de uso
   - Características principais
   - Path do arquivo

---

## 📦 **ORGANIZAÇÃO DE COMPONENTES**

### **⚠️ ORGANIZAÇÃO DE COMPONENTES OBRIGATÓRIA:**

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

### **🚫 NÃO CRIAR componentes muito pequenos**
Componentes com menos de 30 linhas devem permanecer na screen principal.

### **✅ CRIAR componentes quando tiver:**
- Cards complexos com múltiplas interações
- Formulários de criação/edição
- Modais ou dialogs elaborados
- Barras de filtro ou busca
- Painéis de estatísticas
- Estados vazios customizados
- Seções com lógica própria

### **Diferença entre Componentes da Tela vs Reutilizáveis:**

| Aspecto | Componentes da Tela | Componentes Reutilizáveis |
|---------|---------------------|---------------------------|
| **Localização** | `/lib/ui/{tela}/widget/componentes/` | `/lib/ui/core/componentes_reutilizaveis/` |
| **Escopo** | Específicos de uma tela | Usados em múltiplas telas |
| **Acoplamento** | Pode acessar ViewModel diretamente | Desacoplado, recebe dados via parâmetros |
| **Documentação** | Não precisa atualizar doc | **DEVE atualizar esta documentação** |
| **Exemplo** | `turma_card.dart`, `turma_form_dialog.dart` | `searchable_dropdown.dart`, `cep_text_field.dart` |

---

## 🎨 **ESTILIZAÇÃO OBRIGATÓRIA**

### **📝 Tipografia (CustomTextTheme)**

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

### **🎨 Cores (NewAppColorTheme)**

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

### **🚫 CONVERSÕES PROIBIDAS**

❌ **NÃO usar**:
- `Theme.of(context).textTheme.*`
- `Colors.red`, `Colors.blue`, `Colors.green`, etc.
- `context.colorScheme.*`
- Cores hardcoded como `Color(0xFF...)`

✅ **SEMPRE usar**:
- `context.customTextTheme.*`
- `context.customColorTheme.*`

### **📦 Import Obrigatório**

```dart
import 'package:w3_diploma/ui/core/extensions/build_context_extension.dart';
```

### **🎯 Exemplos de Estilização Obrigatória**

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

---

## ✅ **CHECKLIST DE IMPLEMENTAÇÃO**

### **Fase 1: ViewModel (5-10 min)**
- [ ] Classe extends `ChangeNotifier`
- [ ] Constructor com repositories injetados (incluindo FKs)
- [ ] Commands CRUD (getAll, create, update, delete)
- [ ] State privado (`_paginatedResponse`, `_currentParams`)
- [ ] Getters públicos para UI
- [ ] Métodos de paginação
- [ ] Dispose de todos os commands

### **Fase 2: UI Screen (20-30 min)**
- [ ] StatefulWidget com ViewModel injection
- [ ] `initState()` com 3 listeners + `getAllItems.execute()`
- [ ] `dispose()` removendo listeners
- [ ] `_onResult()` para SnackBars
- [ ] `ListenableBuilder` com 4 estados (loading, error, empty, success)
- [ ] Import de `build_context_extension.dart`
- [ ] Estilização usando `context.customTextTheme`
- [ ] Estilização usando `context.customColorTheme`

### **Fase 3: Componentes (conforme necessário)**
- [ ] Criar pasta `componentes/` se necessário
- [ ] Separar cards, forms, dialogs em arquivos próprios
- [ ] Usar componentes reutilizáveis quando aplicável
- [ ] Se criar novo componente reutilizável, atualizar esta doc

### **Fase 4: Validação Final**
- [ ] Nenhum `Theme.of(context).textTheme` no código
- [ ] Nenhum `Colors.*` hardcoded
- [ ] Todos os commands têm listeners
- [ ] Todos os listeners são removidos no dispose
- [ ] Estados loading/error/empty/success implementados
- [ ] Feedback visual (SnackBar) funcionando

---

## 📌 **OBSERVAÇÕES FINAIS**

### **🔄 Fluxo de Criação de Tela:**

1. **ViewModel já existe** (criado seguindo arquitetura em 7 camadas)
2. **Criar UI Screen** seguindo este guia
3. **Identificar componentes complexos** e separar em `/componentes/`
4. **Usar componentes reutilizáveis** sempre que possível
5. **Criar novos componentes reutilizáveis** quando necessário e atualizar esta doc
6. **Validar estilização** garantindo uso do tema customizado

### **🎯 Princípios:**
- **Separation of Concerns**: ViewModel gerencia lógica, UI apenas renderiza
- **Reusability**: Componentes reutilizáveis economizam tempo
- **Consistency**: Tema customizado garante identidade visual
- **Testability**: ViewModel desacoplado facilita testes
- **Maintainability**: Organização clara facilita manutenção