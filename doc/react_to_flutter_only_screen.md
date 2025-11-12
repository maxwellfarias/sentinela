# 🚀 Guia de Conversão React → Flutter - Arquitetura Completa

  ## 📋 **INFORMAÇÕES OBRIGATÓRIAS PARA CONVERSÃO**


### **UI Screen** (OBRIGATÓRIO)
**Path**: `/lib/ui/{nome_tela}/widget/{nome_tela}.dart`

**Padrões Obrigatórios**:
- `initState`: Listeners para 3 commands (update, delete, create) + `getAllTasks.execute()`
- `dispose`: Remover todos os listeners
- `_onResult`: Feedback visual para operações CRUD
- `ListenableBuilder`: Estados loading/error/empty/success

## IMPORTANTE: **Tradução em português**: Todos os textos que precisam ser traduzidos para o português, incluindo placeholders, labels, mensagens de erro, nome de métodos, etc.

- **CONVERSÃO DE ESTILOS OBRIGATÓRIA**: Tipografia e cores conforme mapeamentos abaixo


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

###

#### 🎨 **MAPEAMENTO DE ESTILOS OBRIGATÓRIO**

##### 📝 **Tipografia (React Tailwind → Flutter CustomTextTheme)**

**IMPORTANTE**: Todo `Theme.of(context).textTheme` DEVE ser substituído por `context.customTextTheme`:

| React Tailwind Class | Tamanho | Peso | Flutter Equivalent (OBRIGATÓRIO) |
|---------------------|---------|------|--------------------------------|
| `text-4xl font-bold` | 36px | 700 | `context.customTextTheme.text4xlBold` |
| `text-3xl font-bold` | 30px | 700 | `context.customTextTheme.text3xlBold` |
| `text-2xl font-bold` | 24px | 700 | `context.customTextTheme.text2xlBold` |
| `text-xl font-semibold` | 20px | 600 | `context.customTextTheme.textXlSemibold` |
| `text-xl font-medium` | 20px | 500 | `context.customTextTheme.textXlMedium` |
| `text-lg font-semibold` | 18px | 600 | `context.customTextTheme.textLgSemibold` |
| `text-lg font-medium` | 18px | 500 | `context.customTextTheme.textLgMedium` |
| `text-base font-medium` | 16px | 500 | `context.customTextTheme.textBaseMedium` |
| `text-base` | 16px | 400 | `context.customTextTheme.textBase` |
| `text-sm font-semibold` | 14px | 600 | `context.customTextTheme.textSmSemibold` |
| `text-sm font-medium` | 14px | 500 | `context.customTextTheme.textSmMedium` |
| `text-sm` | 14px | 400 | `context.customTextTheme.textSm` |
| `text-xs font-medium` | 12px | 500 | `context.customTextTheme.textXsMedium` |
| `text-xs` | 12px | 400 | `context.customTextTheme.textXs` |

##### 🎨 **Cores (React CSS → Flutter NewAppColorTheme)**

**IMPORTANTE**: Todo `Colors.*`, `Theme.of(context).colorScheme.*` DEVE ser substituído por `context.customColorTheme`:

| React CSS Variable | Descrição | Flutter Equivalent (OBRIGATÓRIO) |
|-------------------|-----------|--------------------------------|
| `--background` | Fundo principal | `context.customColorTheme.background` |
| `--foreground` | Texto principal | `context.customColorTheme.foreground` |
| `--primary` | Cor primária | `context.customColorTheme.primary` |
| `--primary-foreground` | Texto sobre primário | `context.customColorTheme.primaryForeground` |
| `--primary-light` | Primário claro | `context.customColorTheme.primaryLight` |
| `--primary-dark` | Primário escuro | `context.customColorTheme.primaryShade` |
| `--secondary` | Cor secundária | `context.customColorTheme.secondary` |
| `--secondary-foreground` | Texto sobre secundário | `context.customColorTheme.secondaryForeground` |
| `--success` | Verde de sucesso | `context.customColorTheme.success` |
| `--success-foreground` | Texto sobre sucesso | `context.customColorTheme.successForeground` |
| `--warning` | Laranja de aviso | `context.customColorTheme.warning` |
| `--warning-foreground` | Texto sobre aviso | `context.customColorTheme.warningForeground` |
| `--destructive` | Vermelho de erro | `context.customColorTheme.destructive` |
| `--destructive-foreground` | Texto sobre erro | `context.customColorTheme.destructiveForeground` |
| `--card` | Fundo de cards | `context.customColorTheme.card` |
| `--card-foreground` | Texto em cards | `context.customColorTheme.cardForeground` |
| `--muted` | Fundo neutro | `context.customColorTheme.muted` |
| `--muted-foreground` | Texto secundário | `context.customColorTheme.mutedForeground` |
| `--accent` | Cor de destaque | `context.customColorTheme.accent` |
| `--accent-foreground` | Texto sobre destaque | `context.customColorTheme.accentForeground` |
| `--border` | Bordas | `context.customColorTheme.border` |
| `--input` | Fundo de inputs | `context.customColorTheme.input` |
| `--ring` | Foco/seleção | `context.customColorTheme.ring` |

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

##### 🎯 **Exemplos de Conversão Obrigatória**

```dart
// ❌ ERRADO - Não usar
SelectableText(
  'Título',
  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)

// ✅ CORRETO - Usar sempre
SelectableText(
  'Título',
  style: context.customTextTheme.text2xlBold.copyWith(
    color: context.customColorTheme.primary,
  ),
)

// ❌ ERRADO - Card com cores hardcoded
Card(
  color: Colors.white,
  child: SelectableText('Conteúdo', style: TextStyle(color: Colors.black)),
)

// ✅ CORRETO - Card com tema customizado
Card(
  color: context.customColorTheme.card,
  child: SelectableText(
    'Conteúdo',
    style: context.customTextTheme.textBase.copyWith(
      color: context.customColorTheme.cardForeground,
    ),
  ),
)
```

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mastering_tests/domain/models/task_model.dart';
import 'package:mastering_tests/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:mastering_tests/utils/command.dart';

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
          content: SelectableText('Erro: ${command.errorMessage ?? 'Ocorreu um erro desconhecido.'}'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SelectableText(successMessage),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SelectableText('Todo List'),
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
                child: SelectableText(
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
              child: SelectableText(
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
                  title: SelectableText(
                    task.title,
                    style: context.customTextTheme.textBaseMedium.copyWith(
                      color: context.customColorTheme.cardForeground,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  subtitle: SelectableText(
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

  // ... métodos CRUD implementados conforme modelo
}
```

### ✅ **Fase 1: Estados da UI (OBRIGATÓRIOS)**
- [ ] **Loading State**: CupertinoActivityIndicator quando `command.running == true`
- [ ] **Error State**: Widget de erro quando `command.error == true`
- [ ] **Empty State**: Widget vazio quando lista está vazia
- [ ] **Success State**: Lista de dados quando `command.completed == true`

### ✅ **Fase 2: Lifecycle Obrigatório**
- [ ] **initState**: 3 listeners (create, update, delete) + `getAllTasks.execute()`
- [ ] **dispose**: Remoção de todos os listeners
- [ ] **_onResult**: Feedback visual com SnackBar para success/error

### ✅ **Fase 33: Conversão de Estilos (OBRIGATÓRIA)**
- [ ] **Import Build Context Extension**: `import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';`
- [ ] **Tipografia Convertida**: Todos os `Theme.of(context).textTheme.*` substituídos por `context.customTextTheme.*`
- [ ] **Cores Convertidas**: Todos os `Colors.*` e `context.colorScheme.*` substituídos por `context.customColorTheme.*`
- [ ] **Headers**: Títulos usando `context.customTextTheme.text2xlBold` ou similar
- [ ] **Cards**: Fundos usando `context.customColorTheme.card` e textos `context.customColorTheme.cardForeground`
- [ ] **Botões**: Cores primárias usando `context.customColorTheme.primary/primaryForeground`
- [ ] **Estados**: Success usando `context.customColorTheme.success`, Error usando `context.customColorTheme.destructive`
- [ ] **Inputs**: Bordas usando `context.customColorTheme.border`, foco usando `context.customColorTheme.ring`
- [ ] **Textos Secundários**: Usando `context.customColorTheme.mutedForeground`
- [ ] **Validação**: Nenhuma cor hardcoded ou tema padrão Flutter sendo usado


## 🚀 **WORKFLOW DE CONVERSÃO OBRIGATÓRIO**



## **. Após concluída a toda implementação, não é necessário criar arquivos ReadMe ou Documentação** 
```bash