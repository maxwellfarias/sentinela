class AlunoDto {
  final int alunoID;
  final int turmaID;
  final String nome;
  final String sexo;
  final String nacionalidade;
  final String cep;
  final String logradouro;
  final int codigoMunicipio;
  final String nomeMunicipio;
  final String uf;
  final String cpf;
  final String rgNumero;
  final String rgOrgaoExpedidor;
  final String rgUf;
  final DateTime dataNascimento;
  final String? filiacaoMaeNome;
  final String? filiacaoPaiNome;
  final DateTime dataMatricula;
  final DateTime? dataConclusaoCurso;
  final DateTime? dataColacaoGrau;
  final DateTime? dataExpedicaoDiploma;
  final String situacaoVinculo;
  final String? periodoLetivoAtual;
  final String? nomeHabilitacao;
  final DateTime? dataHabilitacao;
  final Map<String, dynamic>? documentosBase64;
  // final String base64DocumentoIdentidade;
  // final String? base64ProvaConclusaoEnsinoMedio;
  // final String? base64ProvaColacao;
  // final String? base64ComprovacaoEstagioCurricular;
  // final String? base64CertidaoNascimento;
  // final String? base64CertidaoCasamento;
  // final String? base64TituloEleitor;
  // final String? base64AtoNaturalizacao;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlunoDto({
    required this.alunoID,
    required this.turmaID,
    required this.nome,
    required this.sexo,
    required this.nacionalidade,
    required this.cep,
    required this.logradouro,
    required this.codigoMunicipio,
    required this.nomeMunicipio,
    required this.uf,
    required this.cpf,
    required this.rgNumero,
    required this.rgOrgaoExpedidor,
    required this.rgUf,
    required this.dataNascimento,
    this.filiacaoMaeNome,
    this.filiacaoPaiNome,
    required this.dataMatricula,
    this.dataConclusaoCurso,
    this.dataColacaoGrau,
    this.dataExpedicaoDiploma,
    required this.situacaoVinculo,
    this.periodoLetivoAtual,
    this.nomeHabilitacao,
    this.dataHabilitacao,
    this.documentosBase64,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlunoDto.fromJson(Map<String, dynamic> json) {
    return AlunoDto(
      alunoID: json['alunoID'] as int,
      turmaID: json['turmaID'] as int,
      nome: json['nome'] as String,
      sexo: json['sexo'] as String,
      nacionalidade: json['nacionalidade'] as String,
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      codigoMunicipio: int.tryParse(json['codigoMunicipio'].toString()) ?? 0,
      nomeMunicipio: json['nomeMunicipio'] as String,
      uf: json['uf'] as String,
      cpf: json['cpf'] as String,
      rgNumero: json['rgNumero'] as String,
      rgOrgaoExpedidor: json['rgOrgaoExpedidor'] as String,
      rgUf: json['rgUf'] as String,
      dataNascimento: DateTime.parse(json['dataNascimento'] as String),
      filiacaoMaeNome: json['filiacaoMaeNome'],
      filiacaoPaiNome: json['filiacaoPaiNome'],
      dataMatricula: DateTime.parse(json['dataMatricula'] as String),
      dataConclusaoCurso: json['dataConclusaoCurso'] != null
          ? DateTime.parse(json['dataConclusaoCurso'] as String)
          : null,
      dataColacaoGrau: json['dataColacaoGrau'] != null
          ? DateTime.parse(json['dataColacaoGrau'] as String)
          : null,
      dataExpedicaoDiploma: json['dataExpedicaoDiploma'] != null
          ? DateTime.parse(json['dataExpedicaoDiploma'] as String)
          : null,
      situacaoVinculo: json['situacaoVinculo'] as String,
      periodoLetivoAtual: json['periodoLetivoAtual'],
      nomeHabilitacao: json['nomeHabilitacao'],
      dataHabilitacao: json['dataHabilitacao'] != null
          ? DateTime.parse(json['dataHabilitacao'] as String)
          : null,
      documentosBase64: json['documentosBase64'] != null
          ? Map<String, dynamic>.from(json['documentosBase64'] as Map)
          : <String, String>{},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'turmaID': turmaID,
      'nome': nome,
      'sexo': sexo,
      'nacionalidade': nacionalidade,
      'cep': cep,
      'logradouro': logradouro,
      'codigoMunicipio': codigoMunicipio,
      'nomeMunicipio': nomeMunicipio,
      'uf': uf,
      'cpf': cpf,
      'rgNumero': rgNumero,
      'rgOrgaoExpedidor': rgOrgaoExpedidor,
      'rgUf': rgUf,
      'dataNascimento': dataNascimento.toIso8601String(),
      'filiacaoMaeNome': filiacaoMaeNome,
      'filiacaoPaiNome': filiacaoPaiNome,
      'dataMatricula': dataMatricula.toIso8601String(),
      'dataConclusaoCurso':
          dataConclusaoCurso?.toIso8601String(),
      'dataColacaoGrau': dataColacaoGrau?.toIso8601String(),
      'dataExpedicaoDiploma':
          dataExpedicaoDiploma?.toIso8601String(),
      'situacaoVinculo': situacaoVinculo,
      'documentosBase64': documentosBase64,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}