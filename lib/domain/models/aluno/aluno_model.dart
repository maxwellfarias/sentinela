class AlunoModel {
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
  final DateTime dataConclusaoCurso;
  final DateTime dataColacaoGrau;
  final DateTime? dataExpedicaoDiploma;
  final String situacaoVinculo;
  final bool estaSalvoBase64DocumentoIdentidade;
  final bool estaSalvoBase64ProvaConclusaoEnsinoMedio;
  final bool estaSalvoBase64ProvaColacao;
  final bool estaSalvoBase64ComprovacaoEstagioCurricular;
  final bool estaSalvoBase64CertidaoNascimento;
  final bool estaSalvoBase64CertidaoCasamento;
  final bool estaSalvoBase64TituloEleitor;
  final bool estaSalvoBase64AtoNaturalizacao;
  final bool estaSalvoBase64Gru;
  final bool estaSalvoBase64CertificadoConclusaoEnsinoSuperior;
  final bool estaSalvoBase64OficioEncaminhamento;
  final bool estaSalvoBase64TermoResponsabilidade;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlunoModel({
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
    required this.dataConclusaoCurso,
    required this.dataColacaoGrau,
    this.dataExpedicaoDiploma,
    required this.situacaoVinculo,
    required this.estaSalvoBase64DocumentoIdentidade,
    required this.estaSalvoBase64ProvaConclusaoEnsinoMedio,
    required this.estaSalvoBase64ProvaColacao,
    required this.estaSalvoBase64ComprovacaoEstagioCurricular,
    required this.estaSalvoBase64CertidaoNascimento,
    required this.estaSalvoBase64CertidaoCasamento,
    required this.estaSalvoBase64TituloEleitor,
    required this.estaSalvoBase64AtoNaturalizacao,
    required this.estaSalvoBase64Gru,
    required this.estaSalvoBase64CertificadoConclusaoEnsinoSuperior,
    required this.estaSalvoBase64OficioEncaminhamento,
    required this.estaSalvoBase64TermoResponsabilidade,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlunoModel.fromJson(Map<String, dynamic> json) {
    return AlunoModel(
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
      dataConclusaoCurso: DateTime.parse(json['dataConclusaoCurso'] as String),
      dataColacaoGrau: DateTime.parse(json['dataColacaoGrau'] as String),
      dataExpedicaoDiploma: DateTime.tryParse(json['dataExpedicaoDiploma'] ?? ''),
      situacaoVinculo: json['situacaoVinculo'] as String,
      estaSalvoBase64DocumentoIdentidade: json['estaSalvoBase64DocumentoIdentidade'] as bool? ?? false,
      estaSalvoBase64ProvaConclusaoEnsinoMedio: json['estaSalvoBase64ProvaConclusaoEnsinoMedio'] as bool? ?? false,
      estaSalvoBase64ProvaColacao: json['estaSalvoBase64ProvaColacao'] as bool? ?? false,
      estaSalvoBase64ComprovacaoEstagioCurricular:
          json['estaSalvoBase64ComprovacaoEstagioCurricular'] as bool? ?? false,
      estaSalvoBase64CertidaoNascimento: json['estaSalvoBase64CertidaoNascimento'] as bool? ?? false,
      estaSalvoBase64CertidaoCasamento: json['estaSalvoBase64CertidaoCasamento'] as bool? ?? false,
      estaSalvoBase64TituloEleitor: json['estaSalvoBase64TituloEleitor'] as bool? ?? false,
      estaSalvoBase64AtoNaturalizacao: json['estaSalvoBase64AtoNaturalizacao'] as bool? ?? false,
      estaSalvoBase64Gru: json['estaSalvoBase64Gru'] as bool? ?? false,
      estaSalvoBase64CertificadoConclusaoEnsinoSuperior: json['estaSalvoBase64CertificadoConclusaoEnsinoSuperior'] as bool? ?? false,
      estaSalvoBase64OficioEncaminhamento: json['estaSalvoBase64OficioEncaminhamento'] as bool? ?? false,
      estaSalvoBase64TermoResponsabilidade: json['estaSalvoBase64TermoResponsabilidade'] as bool? ?? false,
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
      'estaSalvoBase64DocumentoIdentidade': estaSalvoBase64DocumentoIdentidade,
      'estaSalvoBase64ProvaConclusaoEnsinoMedio':
          estaSalvoBase64ProvaConclusaoEnsinoMedio,
      'estaSalvoBase64ProvaColacao': estaSalvoBase64ProvaColacao,
      'estaSalvoBase64ComprovacaoEstagioCurricular':
          estaSalvoBase64ComprovacaoEstagioCurricular,
      'estaSalvoBase64CertidaoNascimento': estaSalvoBase64CertidaoNascimento,
      'estaSalvoBase64CertidaoCasamento': estaSalvoBase64CertidaoCasamento,
      'estaSalvoBase64TituloEleitor': estaSalvoBase64TituloEleitor,
      'estaSalvoBase64AtoNaturalizacao': estaSalvoBase64AtoNaturalizacao,
      'estaSalvoBase64Gru': estaSalvoBase64Gru,
      'estaSalvoBase64CertificadoConclusaoEnsinoSuperior':
      estaSalvoBase64CertificadoConclusaoEnsinoSuperior,
      'estaSalvoBase64OficioEncaminhamento': estaSalvoBase64OficioEncaminhamento,
      'estaSalvoBase64TermoResponsabilidade': estaSalvoBase64TermoResponsabilidade,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}