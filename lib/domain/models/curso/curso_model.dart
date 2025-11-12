/// Modelo de domínio para Curso
///
/// Representa um curso no sistema com todos os dados necessários
/// conforme a tabela SQL curso.
final class CursoModel {
  final int cursoID;
  final int iesEmissoraID;
  final String nomeCurso;
  final String nomeIesEmissora;
  final int codigoCursoEMEC;
  final String modalidade;
  final String grauConferido;
  final String logradouro;
  final String bairro;
  final String codigoMunicipio;
  final String nomeMunicipio;
  final String uf;
  final String cep;
  // Autorização
  final String autorizacaoTipo;
  final String autorizacaoNumero;
  final DateTime autorizacaoData;
  // Reconhecimento
  final String reconhecimentoTipo;
  final String reconhecimentoNumero;
  final DateTime reconhecimentoData;
  // Campos para curso sem código eMEC
  final String? numeroProcesso;
  final String? tipoProcesso;
  final DateTime? dataCadastro;
  final DateTime? dataProtocolo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CursoModel({
    required this.cursoID,
    required this.iesEmissoraID,
    required this.nomeCurso,
    required this.nomeIesEmissora,
    required this.codigoCursoEMEC,
    required this.modalidade,
    required this.grauConferido,
    required this.logradouro,
    required this.bairro,
    required this.codigoMunicipio,
    required this.nomeMunicipio,
    required this.uf,
    required this.cep,
    required this.autorizacaoTipo,
    required this.autorizacaoNumero,
    required this.autorizacaoData,
    required this.reconhecimentoTipo,
    required this.reconhecimentoNumero,
    required this.reconhecimentoData,
    this.numeroProcesso,
    this.tipoProcesso,
    this.dataCadastro,
    this.dataProtocolo,
    this.createdAt,
    this.updatedAt,
  });

  factory CursoModel.fromJson(dynamic json) {
    return CursoModel(
      cursoID: json['cursoID'] ?? 0,
      iesEmissoraID: json['iesEmissoraID'] ?? 0,
      nomeCurso: json['nomeCurso'] ?? '',
      nomeIesEmissora: json['nomeIesEmissora'] ?? '',
      codigoCursoEMEC: json['codigoCursoEMEC'] ?? 0,
      modalidade: json['modalidade'] ?? '',
      grauConferido: json['grauConferido'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      codigoMunicipio: json['codigoMunicipio'] ?? '',
      nomeMunicipio: json['nomeMunicipio'] ?? '',
      uf: json['uf'] ?? '',
      cep: json['cep'] ?? '',
      autorizacaoTipo: json['autorizacaoTipo'] ?? '',
      autorizacaoNumero: json['autorizacaoNumero'] ?? '',
      autorizacaoData: json['autorizacaoData'] != null
          ? DateTime.parse(json['autorizacaoData'])
          : DateTime.now(),
      reconhecimentoTipo: json['reconhecimentoTipo'] ?? '',
      reconhecimentoNumero: json['reconhecimentoNumero'] ?? '',
      reconhecimentoData: json['reconhecimentoData'] != null
          ? DateTime.parse(json['reconhecimentoData'])
          : DateTime.now(),
      numeroProcesso: json['numeroProcesso'],
      tipoProcesso: json['tipoProcesso'],
      dataCadastro: json['dataCadastro'] != null
          ? DateTime.parse(json['dataCadastro'])
          : null,
      dataProtocolo: json['dataProtocolo'] != null
          ? DateTime.parse(json['dataProtocolo'])
          : null,
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
      'cursoID': cursoID,
      'iesEmissoraID': iesEmissoraID,
      'nomeCurso': nomeCurso,
      'nomeIesEmissora': nomeIesEmissora,
      'codigoCursoEMEC': codigoCursoEMEC,
      'modalidade': modalidade,
      'grauConferido': grauConferido,
      'logradouro': logradouro,
      'bairro': bairro,
      'codigoMunicipio': codigoMunicipio,
      'nomeMunicipio': nomeMunicipio,
      'uf': uf,
      'cep': cep,
      'autorizacaoTipo': autorizacaoTipo,
      'autorizacaoNumero': autorizacaoNumero,
      'autorizacaoData': autorizacaoData.toIso8601String(),
      'reconhecimentoTipo': reconhecimentoTipo,
      'reconhecimentoNumero': reconhecimentoNumero,
      'reconhecimentoData': reconhecimentoData.toIso8601String(),
      'numeroProcesso': numeroProcesso,
      'tipoProcesso': tipoProcesso,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataProtocolo': dataProtocolo?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  CursoModel copyWith({
    int? cursoID,
    int? iesEmissoraID,
    String? nomeCurso,
    String? nomeIesEmissora,
    int? codigoCursoEMEC,
    String? modalidade,
    String? grauConferido,
    String? logradouro,
    String? bairro,
    String? codigoMunicipio,
    String? nomeMunicipio,
    String? uf,
    String? cep,
    String? autorizacaoTipo,
    String? autorizacaoNumero,
    DateTime? autorizacaoData,
    String? reconhecimentoTipo,
    String? reconhecimentoNumero,
    DateTime? reconhecimentoData,
    String? numeroProcesso,
    String? tipoProcesso,
    DateTime? dataCadastro,
    DateTime? dataProtocolo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CursoModel(
      cursoID: cursoID ?? this.cursoID,
      iesEmissoraID: iesEmissoraID ?? this.iesEmissoraID,
      nomeCurso: nomeCurso ?? this.nomeCurso,
      nomeIesEmissora: nomeIesEmissora ?? this.nomeIesEmissora,
      codigoCursoEMEC: codigoCursoEMEC ?? this.codigoCursoEMEC,
      modalidade: modalidade ?? this.modalidade,
      grauConferido: grauConferido ?? this.grauConferido,
      logradouro: logradouro ?? this.logradouro,
      bairro: bairro ?? this.bairro,
      codigoMunicipio: codigoMunicipio ?? this.codigoMunicipio,
      nomeMunicipio: nomeMunicipio ?? this.nomeMunicipio,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      autorizacaoTipo: autorizacaoTipo ?? this.autorizacaoTipo,
      autorizacaoNumero: autorizacaoNumero ?? this.autorizacaoNumero,
      autorizacaoData: autorizacaoData ?? this.autorizacaoData,
      reconhecimentoTipo: reconhecimentoTipo ?? this.reconhecimentoTipo,
      reconhecimentoNumero: reconhecimentoNumero ?? this.reconhecimentoNumero,
      reconhecimentoData: reconhecimentoData ?? this.reconhecimentoData,
      numeroProcesso: numeroProcesso ?? this.numeroProcesso,
      tipoProcesso: tipoProcesso ?? this.tipoProcesso,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataProtocolo: dataProtocolo ?? this.dataProtocolo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CursoModel('
        'cursoID: $cursoID, '
        'iesEmissoraID: $iesEmissoraID, '
        'nomeCurso: $nomeCurso, '
        'nomeIesEmissora: $nomeIesEmissora, '
        'codigoCursoEMEC: $codigoCursoEMEC, '
        'modalidade: $modalidade, '
        'grauConferido: $grauConferido, '
        'logradouro: $logradouro, '
        'bairro: $bairro, '
        'codigoMunicipio: $codigoMunicipio, '
        'nomeMunicipio: $nomeMunicipio, '
        'uf: $uf, '
        'cep: $cep, '
        'autorizacaoTipo: $autorizacaoTipo, '
        'autorizacaoNumero: $autorizacaoNumero, '
        'autorizacaoData: $autorizacaoData, '
        'reconhecimentoTipo: $reconhecimentoTipo, '
        'reconhecimentoNumero: $reconhecimentoNumero, '
        'reconhecimentoData: $reconhecimentoData, '
        'numeroProcesso: $numeroProcesso, '
        'tipoProcesso: $tipoProcesso, '
        'dataCadastro: $dataCadastro, '
        'dataProtocolo: $dataProtocolo, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
