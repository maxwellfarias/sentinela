import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/kabam/widget/componentes/kabam_models.dart';
import 'package:sentinela/ui/kabam/widget/componentes/kabam_task_card.dart';

/// Coluna individual do quadro Kanban
class KabamColumnWidget extends StatelessWidget {
  final KabamColumn column;
  final VoidCallback? onAddTask;
  final Function(KabamTask)? onTaskTap;
  final VoidCallback? onMenuTap;

  const KabamColumnWidget({
    super.key,
    required this.column,
    this.onAddTask,
    this.onTaskTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    // Se for coluna de adicionar grupo
    if (column.type == KabamColumnType.addGroup) {
      return _buildAddGroupColumn(context);
    }

    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header da coluna
          _buildColumnHeader(context),
          const SizedBox(height: 16),

          // Lista de tarefas
          Expanded(
            child: ListView.builder(
              itemCount:
                  column.tasks.length + 1, // +1 para o botão de adicionar
              itemBuilder: (context, index) {
                if (index == column.tasks.length) {
                  // Botão de adicionar tarefa (apenas para coluna Done)
                  if (column.type == KabamColumnType.done) {
                    return _buildAddTaskButton(context);
                  }
                  return const SizedBox.shrink();
                }

                final task = column.tasks[index];
                return KabamTaskCard(
                  task: task,
                  onTap: () => onTaskTap?.call(task),
                  onEdit: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          column.title,
          style: context.customTextTheme.textSmSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        InkWell(
          onTap: onMenuTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.more_vert,
              size: 20,
              color: context.colorTheme.fgBodySubtle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAddTask,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colorTheme.borderDefault,
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 18,
                  color: context.colorTheme.fgBodySubtle,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add new task',
                  style: context.customTextTheme.textSmMedium.copyWith(
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddGroupColumn(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                column.title,
                style: context.customTextTheme.textSmSemibold.copyWith(
                  color: context.colorTheme.fgHeading,
                ),
              ),
              InkWell(
                onTap: onMenuTap,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Card vazio com botão de adicionar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colorTheme.bgNeutralPrimary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.colorTheme.borderDefault,
                width: 1,
              ),
            ),
            child: Center(
              child: InkWell(
                onTap: onAddTask,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorTheme.borderDefault,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 24,
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
