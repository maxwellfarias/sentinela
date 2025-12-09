/// Modelos de dados para o quadro Kanban
/// Estes são modelos fictícios para demonstração

enum BadgeType { tomorrow, daysLeft, done }

class TaskBadge {
  final BadgeType type;
  final String label;

  const TaskBadge({required this.type, required this.label});

  factory TaskBadge.tomorrow() =>
      const TaskBadge(type: BadgeType.tomorrow, label: 'Tomorrow');

  factory TaskBadge.daysLeft(int days) =>
      TaskBadge(type: BadgeType.daysLeft, label: '$days days left');

  factory TaskBadge.done() =>
      const TaskBadge(type: BadgeType.done, label: 'Done');
}

class KabamTask {
  final String id;
  final String title;
  final String description;
  final bool hasChart;
  final int memberCount;
  final TaskBadge? badge;

  const KabamTask({
    required this.id,
    required this.title,
    required this.description,
    this.hasChart = false,
    this.memberCount = 3,
    this.badge,
  });
}

enum KabamColumnType { toDo, inProgress, done, addGroup }

class KabamColumn {
  final String id;
  final String title;
  final KabamColumnType type;
  final List<KabamTask> tasks;

  const KabamColumn({
    required this.id,
    required this.title,
    required this.type,
    this.tasks = const [],
  });
}

/// Dados fictícios para demonstração
class KabamMockData {
  static List<KabamColumn> getColumns() {
    return [
      KabamColumn(
        id: '1',
        title: 'To Do',
        type: KabamColumnType.toDo,
        tasks: [
          KabamTask(
            id: '1',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: true,
            memberCount: 3,
            badge: TaskBadge.tomorrow(),
          ),
          KabamTask(
            id: '2',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: false,
            memberCount: 3,
            badge: TaskBadge.daysLeft(5),
          ),
          KabamTask(
            id: '3',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: true,
            memberCount: 3,
            badge: null,
          ),
        ],
      ),
      KabamColumn(
        id: '2',
        title: 'In Progress',
        type: KabamColumnType.inProgress,
        tasks: [
          KabamTask(
            id: '4',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: true,
            memberCount: 3,
            badge: TaskBadge.tomorrow(),
          ),
          KabamTask(
            id: '5',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: true,
            memberCount: 3,
            badge: null,
          ),
          KabamTask(
            id: '6',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: false,
            memberCount: 3,
            badge: TaskBadge.tomorrow(),
          ),
          KabamTask(
            id: '7',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: false,
            memberCount: 3,
            badge: null,
          ),
        ],
      ),
      KabamColumn(
        id: '3',
        title: 'Done',
        type: KabamColumnType.done,
        tasks: [
          KabamTask(
            id: '8',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: true,
            memberCount: 3,
            badge: TaskBadge.done(),
          ),
          KabamTask(
            id: '9',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: false,
            memberCount: 3,
            badge: TaskBadge.done(),
          ),
          KabamTask(
            id: '10',
            title: 'Change charts color',
            description:
                'In _variables.scss on line 672 you define \$table_variants. Each instance of "color-level" needs to be changed to "shift-color".',
            hasChart: false,
            memberCount: 3,
            badge: TaskBadge.done(),
          ),
        ],
      ),
      const KabamColumn(
        id: '4',
        title: 'Add another group',
        type: KabamColumnType.addGroup,
        tasks: [],
      ),
    ];
  }
}
