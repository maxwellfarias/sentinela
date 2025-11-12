/// Modelo de domínio para Atividade Complementar
///
/// Representa uma atividade complementar realizada por um aluno no sistema
/// com todos os dados necessários conforme a tabela SQL atividade_complementar.
final class AtividadeComplementarModel {
  final int atividadeComplementarID;
  final int alunoID;
  final String tipoAtividadeComplementar;
  final String descricao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final DateTime dataRegistro;
  final int cargaHorariaEmHoraRelogio;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AtividadeComplementarModel({
    required this.atividadeComplementarID,
    required this.alunoID,
    required this.tipoAtividadeComplementar,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.dataRegistro,
    required this.cargaHorariaEmHoraRelogio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AtividadeComplementarModel.fromJson(dynamic json) {
    return AtividadeComplementarModel(
      atividadeComplementarID: json['atividadeComplementarID'] as int? ?? 0,
      alunoID: json['alunoID'] as int? ?? 0,
      tipoAtividadeComplementar: json['tipoAtividadeComplementar'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      dataInicio: json['dataInicio'] != null
          ? DateTime.parse(json['dataInicio'] as String)
          : DateTime.now(),
      dataFim: json['dataFim'] != null
          ? DateTime.parse(json['dataFim'] as String)
          : DateTime.now(),
      dataRegistro: json['dataRegistro'] != null
          ? DateTime.parse(json['dataRegistro'] as String)
          : DateTime.now(),
      cargaHorariaEmHoraRelogio: json['cargaHorariaEmHoraRelogio'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atividadeComplementarID': atividadeComplementarID,
      'alunoID': alunoID,
      'tipoAtividadeComplementar': tipoAtividadeComplementar,
      'descricao': descricao,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      'dataRegistro': dataRegistro.toIso8601String(),
      'cargaHorariaEmHoraRelogio': cargaHorariaEmHoraRelogio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AtividadeComplementarModel copyWith({
    int? atividadeComplementarID,
    int? alunoID,
    String? tipoAtividadeComplementar,
    String? descricao,
    DateTime? dataInicio,
    DateTime? dataFim,
    DateTime? dataRegistro,
    int? cargaHorariaEmHoraRelogio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AtividadeComplementarModel(
      atividadeComplementarID: atividadeComplementarID ?? this.atividadeComplementarID,
      alunoID: alunoID ?? this.alunoID,
      tipoAtividadeComplementar: tipoAtividadeComplementar ?? this.tipoAtividadeComplementar,
      descricao: descricao ?? this.descricao,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      dataRegistro: dataRegistro ?? this.dataRegistro,
      cargaHorariaEmHoraRelogio: cargaHorariaEmHoraRelogio ?? this.cargaHorariaEmHoraRelogio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'AtividadeComplementarModel('
        'atividadeComplementarID: $atividadeComplementarID, '
        'alunoID: $alunoID, '
        'tipoAtividadeComplementar: $tipoAtividadeComplementar, '
        'descricao: $descricao, '
        'dataInicio: $dataInicio, '
        'dataFim: $dataFim, '
        'dataRegistro: $dataRegistro, '
        'cargaHorariaEmHoraRelogio: $cargaHorariaEmHoraRelogio, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
