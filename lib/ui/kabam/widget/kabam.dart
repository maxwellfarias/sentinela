import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/kabam/widget/componentes/kabam_column.dart';
import 'package:sentinela/ui/kabam/widget/componentes/kabam_models.dart';

/// Tela de Kanban Board para gerenciamento de tarefas
///
/// Exibe colunas de tarefas organizadas por status:
/// - To Do: Tarefas a fazer
/// - In Progress: Tarefas em andamento
/// - Done: Tarefas concluídas
/// - Add another group: Opção para adicionar nova coluna
final class Kabam extends StatefulWidget {
  const Kabam({super.key});

  @override
  State<Kabam> createState() => _KabamState();
}

class _KabamState extends State<Kabam> {
  // Lista de colunas do Kanban (dados fictícios)
  late List<KabamColumn> _columns;

  @override
  void initState() {
    super.initState();
    // Carrega os dados fictícios
    _columns = KabamMockData.getColumns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorTheme.bgNeutralSecondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colunas do Kanban em scroll horizontal
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _columns.length,
                  itemBuilder: (context, index) {
                    final column = _columns[index];
                    return KabamColumnWidget(
                      column: column,
                      onAddTask: () => _showAddTaskDialog(column),
                      onTaskTap: (task) => _showTaskDetails(task),
                      onMenuTap: () => _showColumnMenu(column),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Exibe diálogo para adicionar nova tarefa
  void _showAddTaskDialog(KabamColumn column) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colorTheme.bgNeutralPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Add New Task',
          style: context.customTextTheme.textLgSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBodySubtle,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: context.colorTheme.borderDefault,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: context.colorTheme.borderBrandLight,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBodySubtle,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: context.colorTheme.borderDefault,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: context.colorTheme.borderBrandLight,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar('Task added to ${column.title}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorTheme.bgBrand,
              foregroundColor: context.colorTheme.bgNeutralPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add Task',
              style: context.customTextTheme.textSmMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Exibe detalhes de uma tarefa
  void _showTaskDetails(KabamTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colorTheme.bgNeutralPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          task.title,
          style: context.customTextTheme.textLgSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: context.customTextTheme.textSmSemibold.copyWith(
                color: context.colorTheme.fgHeading,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBody,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: context.colorTheme.fgBodySubtle,
                ),
                const SizedBox(width: 8),
                Text(
                  '${task.memberCount} members assigned',
                  style: context.customTextTheme.textXs.copyWith(
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar('Opening task editor...');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorTheme.bgBrand,
              foregroundColor: context.colorTheme.bgNeutralPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Edit Task',
              style: context.customTextTheme.textSmMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Exibe menu de opções da coluna
  void _showColumnMenu(KabamColumn column) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colorTheme.bgNeutralPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              column.title,
              style: context.customTextTheme.textLgSemibold.copyWith(
                color: context.colorTheme.fgHeading,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.edit_outlined,
                color: context.colorTheme.fgBody,
              ),
              title: Text(
                'Rename Column',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBody,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showSnackBar('Rename column: ${column.title}');
              },
            ),
            ListTile(
              leading: Icon(Icons.add, color: context.colorTheme.fgBody),
              title: Text(
                'Add Task',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgBody,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showAddTaskDialog(column);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: context.colorTheme.fgDanger,
              ),
              title: Text(
                'Delete Column',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.colorTheme.fgDanger,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showSnackBar('Column deleted: ${column.title}');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Exibe SnackBar de feedback
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.colorTheme.bgNeutralPrimary,
          ),
        ),
        backgroundColor: context.colorTheme.bgDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
