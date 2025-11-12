/// Modelo de domínio para Disciplina Histórico
///
/// Representa uma disciplina cursada por um aluno no sistema acadêmico,
/// contendo informações sobre notas, situação, carga horária e docente responsável.
/// Baseado na tabela SQL disciplina_historico.
final class DisciplinaHistoricoModel {
  final int disciplinaHistoricoID;
  final int alunoID;
  final String alunoNome;
  final String codigoDisciplina;
  final String nomeDisciplina;
  final String periodoLetivo;
  final int cargaHoraria;
  final double? media1;
  final double? media2;
  final int disciplinaSituacaoID;
  final String docenteNome;
  final String docenteTitulacao;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DisciplinaHistoricoModel({
    required this.disciplinaHistoricoID,
    required this.alunoID,
    required this.alunoNome,
    required this.codigoDisciplina,
    required this.nomeDisciplina,
    required this.periodoLetivo,
    required this.cargaHoraria,
    this.media1,
    this.media2,
    required this.disciplinaSituacaoID,
    required this.docenteNome,
    required this.docenteTitulacao,
    this.createdAt,
    this.updatedAt,
  });

  factory DisciplinaHistoricoModel.fromJson(dynamic json) {
    return DisciplinaHistoricoModel(
      disciplinaHistoricoID: json['disciplinaHistoricoID'] ?? 0,
      alunoID: json['alunoID'] ?? 0,
      alunoNome: json['alunoNome'] ?? '',
      codigoDisciplina: json['codigoDisciplina'] ?? '',
      nomeDisciplina: json['nomeDisciplina'] ?? '',
      periodoLetivo: json['periodoLetivo'] ?? '',
      cargaHoraria: json['cargaHoraria'] ?? 0,
      media1: json['media1'] != null ? (json['media1'] as num).toDouble() : null,
      media2: json['media2'] != null ? (json['media2'] as num).toDouble() : null,
      disciplinaSituacaoID: json['disciplinaSituacaoID'] ?? 3,
      docenteNome: json['docenteNome'] ?? '',
      docenteTitulacao: json['docenteTitulacao'] ?? '',
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
      'disciplinaHistoricoID': disciplinaHistoricoID,
      'alunoID': alunoID,
      'alunoNome': alunoNome,
      'codigoDisciplina': codigoDisciplina,
      'nomeDisciplina': nomeDisciplina,
      'periodoLetivo': periodoLetivo,
      'cargaHoraria': cargaHoraria,
      'media1': media1,
      'media2': media2,
      'disciplinaSituacaoID': disciplinaSituacaoID,
      'docenteNome': docenteNome,
      'docenteTitulacao': docenteTitulacao,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  DisciplinaHistoricoModel copyWith({
    int? disciplinaHistoricoID,
    int? alunoID,
    String? alunoNome,
    String? codigoDisciplina,
    String? nomeDisciplina,
    String? periodoLetivo,
    int? cargaHoraria,
    double? media1,
    double? media2,
    int? disciplinaSituacaoID,
    String? docenteNome,
    String? docenteTitulacao,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DisciplinaHistoricoModel(
      disciplinaHistoricoID: disciplinaHistoricoID ?? this.disciplinaHistoricoID,
      alunoID: alunoID ?? this.alunoID,
      alunoNome: alunoNome ?? this.alunoNome,
      codigoDisciplina: codigoDisciplina ?? this.codigoDisciplina,
      nomeDisciplina: nomeDisciplina ?? this.nomeDisciplina,
      periodoLetivo: periodoLetivo ?? this.periodoLetivo,
      cargaHoraria: cargaHoraria ?? this.cargaHoraria,
      media1: media1 ?? this.media1,
      media2: media2 ?? this.media2,
      disciplinaSituacaoID: disciplinaSituacaoID ?? this.disciplinaSituacaoID,
      docenteNome: docenteNome ?? this.docenteNome,
      docenteTitulacao: docenteTitulacao ?? this.docenteTitulacao,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'DisciplinaHistoricoModel('
        'disciplinaHistoricoID: $disciplinaHistoricoID, '
        'alunoID: $alunoID, '
        'alunoNome: $alunoNome, '
        'codigoDisciplina: $codigoDisciplina, '
        'nomeDisciplina: $nomeDisciplina, '
        'periodoLetivo: $periodoLetivo, '
        'cargaHoraria: $cargaHoraria, '
        'media1: $media1, '
        'media2: $media2, '
        'disciplinaSituacaoID: $disciplinaSituacaoID, '
        'docenteNome: $docenteNome, '
        'docenteTitulacao: $docenteTitulacao, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
