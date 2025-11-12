/// Modelo de domínio para Registro de Diploma
///
/// Representa um registro de diploma no sistema com todos os dados necessários
/// conforme a tabela SQL registro_diploma.
final class RegistroDiplomaModel {
  final int registroDiplomaID;
  final int alunoID;
  final String alunoNome; // Nome do aluno associado ao registro de diploma
  final DateTime? dataConclusaoCurso;
  final DateTime? dataColacaoGrauDiploma;
  final String? registroConclusao;
  final String? livroRegistro;
  final String? paginaRegistro;
  final String? numeroProcessoRegistroDiploma;
  final String? instituicaoDiploma;
  final DateTime? dataEmissaoDiploma;
  final DateTime? dataRegistroDiploma;
  final DateTime? dataPublicacaoDou;
  final String? localizacaoFisicaPasta;
  final String? responsavelRegistroNome;
  final String? responsavelRegistroCpf;
  final String? responsavelRegistroIdOuNumeroMatricula;
  final String? codigoValidacao;
  final String? numeroFolhaDiploma;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RegistroDiplomaModel({
    required this.registroDiplomaID,
    required this.alunoID,
    required this.alunoNome,
    this.dataConclusaoCurso,
    this.dataColacaoGrauDiploma,
    this.registroConclusao,
    this.livroRegistro,
    this.paginaRegistro,
    this.numeroProcessoRegistroDiploma,
    this.instituicaoDiploma,
    this.dataEmissaoDiploma,
    this.dataRegistroDiploma,
    this.dataPublicacaoDou,
    this.localizacaoFisicaPasta,
    this.responsavelRegistroNome,
    this.responsavelRegistroCpf,
    this.responsavelRegistroIdOuNumeroMatricula,
    this.codigoValidacao,
    this.numeroFolhaDiploma,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegistroDiplomaModel.fromJson(Map<String, dynamic> json) {
    return RegistroDiplomaModel(
      registroDiplomaID: json['registroDiplomaID'] as int,
      alunoID: json['alunoID'] as int,
      alunoNome: json['alunoNome'] as String,
      dataConclusaoCurso: json['dataConclusaoCurso'] != null
          ? DateTime.parse(json['dataConclusaoCurso'] as String)
          : null,
      dataColacaoGrauDiploma: json['dataColacaoGrauDiploma'] != null
          ? DateTime.parse(json['dataColacaoGrauDiploma'] as String)
          : null,
      registroConclusao: json['registroConclusao'] as String?,
      livroRegistro: json['livroRegistro'] as String?,
      paginaRegistro: json['paginaRegistro'] as String?,
      numeroProcessoRegistroDiploma: json['numeroProcessoRegistroDiploma'] as String?,
      instituicaoDiploma: json['instituicaoDiploma'] as String?,
      dataEmissaoDiploma: json['dataEmissaoDiploma'] != null
          ? DateTime.parse(json['dataEmissaoDiploma'] as String)
          : null,
      dataRegistroDiploma: json['dataRegistroDiploma'] != null
          ? DateTime.parse(json['dataRegistroDiploma'] as String)
          : null,
      dataPublicacaoDou: json['dataPublicacaoDou'] != null
          ? DateTime.parse(json['dataPublicacaoDou'] as String)
          : null,
      localizacaoFisicaPasta: json['localizacaoFisicaPasta'] as String?,
      responsavelRegistroNome: json['responsavelRegistroNome'] as String?,
      responsavelRegistroCpf: json['responsavelRegistroCpf'] as String?,
      responsavelRegistroIdOuNumeroMatricula: json['responsavelRegistroIdOuNumeroMatricula'] as String?,
      codigoValidacao: json['codigoValidacao'] as String?,
      numeroFolhaDiploma: json['numeroFolhaDiploma'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alunoID': alunoID,
      'alunoNome': alunoNome,
      'dataConclusaoCurso': dataConclusaoCurso?.toIso8601String(),
      'dataColacaoGrauDiploma': dataColacaoGrauDiploma?.toIso8601String(),
      'registroConclusao': registroConclusao,
      'livroRegistro': livroRegistro,
      'paginaRegistro': paginaRegistro,
      'numeroProcessoRegistroDiploma': numeroProcessoRegistroDiploma,
      'instituicaoDiploma': instituicaoDiploma,
      'dataEmissaoDiploma': dataEmissaoDiploma?.toIso8601String(),
      'dataRegistroDiploma': dataRegistroDiploma?.toIso8601String(),
      'dataPublicacaoDou': dataPublicacaoDou?.toIso8601String(),
      'localizacaoFisicaPasta': localizacaoFisicaPasta,
      'responsavelRegistroNome': responsavelRegistroNome,
      'responsavelRegistroCpf': responsavelRegistroCpf,
      'responsavelRegistroIdOuNumeroMatricula': responsavelRegistroIdOuNumeroMatricula,
      'codigoValidacao': codigoValidacao,
      'numeroFolhaDiploma': numeroFolhaDiploma,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  RegistroDiplomaModel copyWith({
    int? registroDiplomaID,
    int? alunoID,
    String? alunoNome,
    DateTime? dataConclusaoCurso,
    DateTime? dataColacaoGrauDiploma,
    String? registroConclusao,
    String? livroRegistro,
    String? paginaRegistro,
    String? numeroProcessoRegistroDiploma,
    String? instituicaoDiploma,
    DateTime? dataEmissaoDiploma,
    DateTime? dataRegistroDiploma,
    DateTime? dataPublicacaoDou,
    String? localizacaoFisicaPasta,
    String? responsavelRegistroNome,
    String? responsavelRegistroCpf,
    String? responsavelRegistroIdOuNumeroMatricula,
    String? codigoValidacao,
    String? numeroFolhaDiploma,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RegistroDiplomaModel(
      registroDiplomaID: registroDiplomaID ?? this.registroDiplomaID,
      alunoID: alunoID ?? this.alunoID,
      alunoNome: alunoNome ?? this.alunoNome,
      dataConclusaoCurso: dataConclusaoCurso ?? this.dataConclusaoCurso,
      dataColacaoGrauDiploma: dataColacaoGrauDiploma ?? this.dataColacaoGrauDiploma,
      registroConclusao: registroConclusao ?? this.registroConclusao,
      livroRegistro: livroRegistro ?? this.livroRegistro,
      paginaRegistro: paginaRegistro ?? this.paginaRegistro,
      numeroProcessoRegistroDiploma: numeroProcessoRegistroDiploma ?? this.numeroProcessoRegistroDiploma,
      instituicaoDiploma: instituicaoDiploma ?? this.instituicaoDiploma,
      dataEmissaoDiploma: dataEmissaoDiploma ?? this.dataEmissaoDiploma,
      dataRegistroDiploma: dataRegistroDiploma ?? this.dataRegistroDiploma,
      dataPublicacaoDou: dataPublicacaoDou ?? this.dataPublicacaoDou,
      localizacaoFisicaPasta: localizacaoFisicaPasta ?? this.localizacaoFisicaPasta,
      responsavelRegistroNome: responsavelRegistroNome ?? this.responsavelRegistroNome,
      responsavelRegistroCpf: responsavelRegistroCpf ?? this.responsavelRegistroCpf,
      responsavelRegistroIdOuNumeroMatricula: responsavelRegistroIdOuNumeroMatricula ?? this.responsavelRegistroIdOuNumeroMatricula,
      codigoValidacao: codigoValidacao ?? this.codigoValidacao,
      numeroFolhaDiploma: numeroFolhaDiploma ?? this.numeroFolhaDiploma,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'RegistroDiplomaModel('
        'registroDiplomaID: $registroDiplomaID, '
        'alunoID: $alunoID, '
        'alunoNome: $alunoNome, '
        'dataConclusaoCurso: $dataConclusaoCurso, '
        'dataColacaoGrauDiploma: $dataColacaoGrauDiploma, '
        'registroConclusao: $registroConclusao, '
        'livroRegistro: $livroRegistro, '
        'paginaRegistro: $paginaRegistro, '
        'numeroProcessoRegistroDiploma: $numeroProcessoRegistroDiploma, '
        'instituicaoDiploma: $instituicaoDiploma, '
        'dataEmissaoDiploma: $dataEmissaoDiploma, '
        'dataRegistroDiploma: $dataRegistroDiploma, '
        'dataPublicacaoDou: $dataPublicacaoDou, '
        'localizacaoFisicaPasta: $localizacaoFisicaPasta, '
        'responsavelRegistroNome: $responsavelRegistroNome, '
        'responsavelRegistroCpf: $responsavelRegistroCpf, '
        'responsavelRegistroIdOuNumeroMatricula: $responsavelRegistroIdOuNumeroMatricula, '
        'codigoValidacao: $codigoValidacao, '
        'numeroFolhaDiploma: $numeroFolhaDiploma, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt)';
  }
}
