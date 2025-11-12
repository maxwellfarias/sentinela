/// Modelo de domínio para Turma
///
/// Representa uma turma no sistema com todos os dados necessários
/// conforme a tabela SQL turma.
final class TurmaModel {
  final int turmaID;
  final int cursoID;
  final String nomeTurma;
  final int anoInicio;
  final int? anoTermino;
  final String periodoLetivo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TurmaModel({
    required this.turmaID,
    required this.cursoID,
    required this.nomeTurma,
    required this.anoInicio,
    this.anoTermino,
    required this.periodoLetivo,
    this.createdAt,
    this.updatedAt,
  });

  factory TurmaModel.fromJson(dynamic json) {
    return TurmaModel(
      turmaID: json['turmaID'] ?? 0,
      cursoID: json['cursoID'] ?? 0,
      nomeTurma: json['nomeTurma'] ?? '',
      anoInicio: json['anoInicio'] ?? 0,
      anoTermino: json['anoTermino'],
      periodoLetivo: json['periodoLetivo'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'turmaID': turmaID,
      'cursoID': cursoID,
      'nomeTurma': nomeTurma,
      'anoInicio': anoInicio,
      'anoTermino': anoTermino,
      'periodoLetivo': periodoLetivo,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  TurmaModel copyWith({
    int? turmaID,
    int? cursoID,
    String? nomeTurma,
    int? anoInicio,
    int? anoTermino,
    String? periodoLetivo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TurmaModel(
      turmaID: turmaID ?? this.turmaID,
      cursoID: cursoID ?? this.cursoID,
      nomeTurma: nomeTurma ?? this.nomeTurma,
      anoInicio: anoInicio ?? this.anoInicio,
      anoTermino: anoTermino ?? this.anoTermino,
      periodoLetivo: periodoLetivo ?? this.periodoLetivo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TurmaModel('
        'turmaID: $turmaID, '
        'cursoID: $cursoID, '
        'nomeTurma: $nomeTurma, '
        'anoInicio: $anoInicio, '
        'anoTermino: $anoTermino, '
        'periodoLetivo: $periodoLetivo, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
