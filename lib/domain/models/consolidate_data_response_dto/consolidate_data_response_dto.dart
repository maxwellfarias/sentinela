import 'package:w3_diploma/domain/models/aluno/aluno_model.dart';
import 'package:w3_diploma/domain/models/curso/curso_model.dart';
import 'package:w3_diploma/domain/models/ies_emissora_model.dart';
import 'package:w3_diploma/domain/models/turma/turma_model.dart';

final class DocenteResponseDTO {
  final int id;
  final String nome;
  final String titulacao;
  final String? cpf;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  DocenteResponseDTO({
    required this.id,
    required this.nome,
    required this.titulacao,
    this.cpf,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  factory DocenteResponseDTO.fromJson(Map<String, dynamic> json) {
    return DocenteResponseDTO(
      id: json['id'] as int,
      nome: json['nome'] as String,
      titulacao: json['titulacao'] as String,
      cpf: json['cpf'] as String?,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
      dataAtualizacao: DateTime.parse(json['dataAtualizacao'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'titulacao': titulacao,
      'cpf': cpf,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataAtualizacao': dataAtualizacao.toIso8601String(),
    };
  }
}

final class AlunoResponseDTO {
  final int alunoID;
  final int turmaID;
  final String nome;
  final String sexo;
  final String nacionalidade;
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final String cep;
  final String logradouro;

  AlunoResponseDTO({
    required this.alunoID,
    required this.turmaID,
    required this.nome,
    required this.sexo,
    required this.nacionalidade,
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
    required this.createdAt,
    required this.updatedAt,
    required this.cep,
    required this.logradouro,
  });

  factory AlunoResponseDTO.fromJson(Map<String, dynamic> json) {
    return AlunoResponseDTO(
      alunoID: json['alunoID'] as int,
      turmaID: json['turmaID'] as int,
      nome: json['nome'] as String,
      sexo: json['sexo'] as String,
      nacionalidade: json['nacionalidade'] as String,
      codigoMunicipio: json['codigoMunicipio'] as int,
      nomeMunicipio: json['nomeMunicipio'] as String,
      uf: json['uf'] as String,
      cpf: json['cpf'] as String,
      rgNumero: json['rgNumero'] as String,
      rgOrgaoExpedidor: json['rgOrgaoExpedidor'] as String,
      rgUf: json['rgUf'] as String,
      dataNascimento: DateTime.parse(json['dataNascimento'] as String),
      filiacaoMaeNome: json['filiacaoMaeNome'] as String?,
      filiacaoPaiNome: json['filiacaoPaiNome'] as String?,
      dataMatricula: DateTime.parse(json['dataMatricula'] as String),
      dataConclusaoCurso: DateTime.parse(json['dataConclusaoCurso'] as String),
      dataColacaoGrau: DateTime.parse(json['dataColacaoGrau'] as String),
      dataExpedicaoDiploma: json['dataExpedicaoDiploma'] != null
          ? DateTime.parse(json['dataExpedicaoDiploma'] as String)
          : null,
      situacaoVinculo: json['situacaoVinculo'] as String,
      estaSalvoBase64DocumentoIdentidade: json['estaSalvoBase64DocumentoIdentidade'] as bool,
      estaSalvoBase64ProvaConclusaoEnsinoMedio: json['estaSalvoBase64ProvaConclusaoEnsinoMedio'] as bool,
      estaSalvoBase64ProvaColacao: json['estaSalvoBase64ProvaColacao'] as bool,
      estaSalvoBase64ComprovacaoEstagioCurricular: json['estaSalvoBase64ComprovacaoEstagioCurricular'] as bool,
      estaSalvoBase64CertidaoNascimento: json['estaSalvoBase64CertidaoNascimento'] as bool,
      estaSalvoBase64CertidaoCasamento: json['estaSalvoBase64CertidaoCasamento'] as bool,
      estaSalvoBase64TituloEleitor: json['estaSalvoBase64TituloEleitor'] as bool,
      estaSalvoBase64AtoNaturalizacao: json['estaSalvoBase64AtoNaturalizacao'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cep: json['cep'] as String,
      logradouro: json['logradouro'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alunoID': alunoID,
      'turmaID': turmaID,
      'nome': nome,
      'sexo': sexo,
      'nacionalidade': nacionalidade,
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
      'dataConclusaoCurso': dataConclusaoCurso.toIso8601String(),
      'dataColacaoGrau': dataColacaoGrau.toIso8601String(),
      'dataExpedicaoDiploma': dataExpedicaoDiploma?.toIso8601String(),
      'situacaoVinculo': situacaoVinculo,
      'estaSalvoBase64DocumentoIdentidade': estaSalvoBase64DocumentoIdentidade,
      'estaSalvoBase64ProvaConclusaoEnsinoMedio': estaSalvoBase64ProvaConclusaoEnsinoMedio,
      'estaSalvoBase64ProvaColacao': estaSalvoBase64ProvaColacao,
      'estaSalvoBase64ComprovacaoEstagioCurricular': estaSalvoBase64ComprovacaoEstagioCurricular,
      'estaSalvoBase64CertidaoNascimento': estaSalvoBase64CertidaoNascimento,
      'estaSalvoBase64CertidaoCasamento': estaSalvoBase64CertidaoCasamento,
      'estaSalvoBase64TituloEleitor': estaSalvoBase64TituloEleitor,
      'estaSalvoBase64AtoNaturalizacao': estaSalvoBase64AtoNaturalizacao,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'cep': cep,
      'logradouro': logradouro,
    };
  }
}

final class TurmaResponseDTO {
  final int turmaID;
  final int cursoID;
  final String nomeTurma;
  final int anoInicio;
  final int? anoTermino;
  final String periodoLetivo;
  final DateTime createdAt;
  final DateTime updatedAt;

  TurmaResponseDTO({
    required this.turmaID,
    required this.cursoID,
    required this.nomeTurma,
    required this.anoInicio,
    this.anoTermino,
    required this.periodoLetivo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TurmaResponseDTO.fromJson(Map<String, dynamic> json) {
    return TurmaResponseDTO(
      turmaID: json['turmaID'] as int,
      cursoID: json['cursoID'] as int,
      nomeTurma: json['nomeTurma'] as String,
      anoInicio: json['anoInicio'] as int,
      anoTermino: json['anoTermino'] as int?,
      periodoLetivo: json['periodoLetivo'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

final class CursoResponseDTO {
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
  final String autorizacaoTipo;
  final String autorizacaoNumero;
  final DateTime autorizacaoData;
  final String reconhecimentoTipo;
  final String reconhecimentoNumero;
  final DateTime reconhecimentoData;
  final String? numeroProcesso;
  final String? tipoProcesso;
  final DateTime? dataCadastro;
  final DateTime? dataProtocolo;
  final DateTime createdAt;
  final DateTime updatedAt;

  CursoResponseDTO({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory CursoResponseDTO.fromJson(Map<String, dynamic> json) {
    return CursoResponseDTO(
      cursoID: json['cursoID'] as int,
      iesEmissoraID: json['iesEmissoraID'] as int,
      nomeCurso: json['nomeCurso'] as String,
      nomeIesEmissora: json['nomeIesEmissora'] as String,
      codigoCursoEMEC: json['codigoCursoEMEC'] as int,
      modalidade: json['modalidade'] as String,
      grauConferido: json['grauConferido'] as String,
      logradouro: json['logradouro'] as String,
      bairro: json['bairro'] as String,
      codigoMunicipio: json['codigoMunicipio'] as String,
      nomeMunicipio: json['nomeMunicipio'] as String,
      uf: json['uf'] as String,
      cep: json['cep'] as String,
      autorizacaoTipo: json['autorizacaoTipo'] as String,
      autorizacaoNumero: json['autorizacaoNumero'] as String,
      autorizacaoData: DateTime.parse(json['autorizacaoData'] as String),
      reconhecimentoTipo: json['reconhecimentoTipo'] as String,
      reconhecimentoNumero: json['reconhecimentoNumero'] as String,
      reconhecimentoData: DateTime.parse(json['reconhecimentoData'] as String),
      numeroProcesso: json['numeroProcesso'] as String?,
      tipoProcesso: json['tipoProcesso'] as String?,
      dataCadastro: json['dataCadastro'] != null
          ? DateTime.parse(json['dataCadastro'] as String)
          : null,
      dataProtocolo: json['dataProtocolo'] != null
          ? DateTime.parse(json['dataProtocolo'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

final class IesEmissoraResponseDTO {
  final int iesEmissoraID;
  final String nome;
  final int codigoMec;
  final String cnpj;
  final String enderecoLogradouro;
  final String enderecoBairro;
  final String enderecoCodigoMunicipio;
  final String enderecoNomeMunicipio;
  final String enderecoUf;
  final String enderecoCep;
  final String credenciamentoTipo;
  final String credenciamentoNumero;
  final DateTime credenciamentoData;
  final String? numeroProcessoIesSemCodigoEmec;
  final String? tipoProcessoIesSemCodigoEmec;
  final DateTime? dataCadastroIesSemCodigoEmec;
  final DateTime? dataProtocoloIesSemCodigoEmec;
  final String perfilTipoMedia;
  final String nomeAssinanteTermoResponsabilidade;
  final String cpfAssinanteTermoResponsabilidade;
  final String cargoAssinanteTermoResponsabilidade;
  final DateTime createdAt;
  final DateTime updatedAt;

  IesEmissoraResponseDTO({
    required this.iesEmissoraID,
    required this.nome,
    required this.codigoMec,
    required this.cnpj,
    required this.enderecoLogradouro,
    required this.enderecoBairro,
    required this.enderecoCodigoMunicipio,
    required this.enderecoNomeMunicipio,
    required this.enderecoUf,
    required this.enderecoCep,
    required this.credenciamentoTipo,
    required this.credenciamentoNumero,
    required this.credenciamentoData,
    this.numeroProcessoIesSemCodigoEmec,
    this.tipoProcessoIesSemCodigoEmec,
    this.dataCadastroIesSemCodigoEmec,
    this.dataProtocoloIesSemCodigoEmec,
    required this.perfilTipoMedia,
    required this.nomeAssinanteTermoResponsabilidade,
    required this.cpfAssinanteTermoResponsabilidade,
    required this.cargoAssinanteTermoResponsabilidade,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IesEmissoraResponseDTO.fromJson(Map<String, dynamic> json) {
    return IesEmissoraResponseDTO(
      iesEmissoraID: json['iesEmissoraID'] as int,
      nome: json['nome'] as String,
      codigoMec: json['codigoMec'] as int,
      cnpj: json['cnpj'] as String,
      enderecoLogradouro: json['enderecoLogradouro'] as String,
      enderecoBairro: json['enderecoBairro'] as String,
      enderecoCodigoMunicipio: json['enderecoCodigoMunicipio'] as String,
      enderecoNomeMunicipio: json['enderecoNomeMunicipio'] as String,
      enderecoUf: json['enderecoUf'] as String,
      enderecoCep: json['enderecoCep'] as String,
      credenciamentoTipo: json['credenciamentoTipo'] as String,
      credenciamentoNumero: json['credenciamentoNumero'] as String,
      credenciamentoData: DateTime.parse(json['credenciamentoData'] as String),
      numeroProcessoIesSemCodigoEmec: json['numeroProcessoIesSemCodigoEmec'] as String?,
      tipoProcessoIesSemCodigoEmec: json['tipoProcessoIesSemCodigoEmec'] as String?,
      dataCadastroIesSemCodigoEmec: json['dataCadastroIesSemCodigoEmec'] != null
          ? DateTime.parse(json['dataCadastroIesSemCodigoEmec'] as String)
          : null,
      dataProtocoloIesSemCodigoEmec: json['dataProtocoloIesSemCodigoEmec'] != null
          ? DateTime.parse(json['dataProtocoloIesSemCodigoEmec'] as String)
          : null,
      perfilTipoMedia: json['perfilTipoMedia'] as String,
      nomeAssinanteTermoResponsabilidade: json['nomeAssinanteTermoResponsabilidade'] as String,
      cpfAssinanteTermoResponsabilidade: json['cpfAssinanteTermoResponsabilidade'] as String,
      cargoAssinanteTermoResponsabilidade: json['cargoAssinanteTermoResponsabilidade'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iesEmissoraID': iesEmissoraID,
      'nome': nome,
      'codigoMec': codigoMec,
      'cnpj': cnpj,
      'enderecoLogradouro': enderecoLogradouro,
      'enderecoBairro': enderecoBairro,
      'enderecoCodigoMunicipio': enderecoCodigoMunicipio,
      'enderecoNomeMunicipio': enderecoNomeMunicipio,
      'enderecoUf': enderecoUf,
      'enderecoCep': enderecoCep,
      'credenciamentoTipo': credenciamentoTipo,
      'credenciamentoNumero': credenciamentoNumero,
      'credenciamentoData': credenciamentoData.toIso8601String(),
      'numeroProcessoIesSemCodigoEmec': numeroProcessoIesSemCodigoEmec,
      'tipoProcessoIesSemCodigoEmec': tipoProcessoIesSemCodigoEmec,
      'dataCadastroIesSemCodigoEmec': dataCadastroIesSemCodigoEmec?.toIso8601String(),
      'dataProtocoloIesSemCodigoEmec': dataProtocoloIesSemCodigoEmec?.toIso8601String(),
      'perfilTipoMedia': perfilTipoMedia,
      'nomeAssinanteTermoResponsabilidade': nomeAssinanteTermoResponsabilidade,
      'cpfAssinanteTermoResponsabilidade': cpfAssinanteTermoResponsabilidade,
      'cargoAssinanteTermoResponsabilidade': cargoAssinanteTermoResponsabilidade,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

final class RegistroDiplomaResponseDTO {
  final int registroDiplomaID;
  final int alunoID;
  final String alunoNome;
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

  RegistroDiplomaResponseDTO({
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

  factory RegistroDiplomaResponseDTO.fromJson(Map<String, dynamic> json) {
    return RegistroDiplomaResponseDTO(
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
      'registroDiplomaID': registroDiplomaID,
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
}

final class AtividadeComplementarResponseDTO {
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

  AtividadeComplementarResponseDTO({
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

  factory AtividadeComplementarResponseDTO.fromJson(Map<String, dynamic> json) {
    return AtividadeComplementarResponseDTO(
      atividadeComplementarID: json['atividadeComplementarID'] as int,
      alunoID: json['alunoID'] as int,
      tipoAtividadeComplementar: json['tipoAtividadeComplementar'] as String,
      descricao: json['descricao'] as String,
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataFim: DateTime.parse(json['dataFim'] as String),
      dataRegistro: DateTime.parse(json['dataRegistro'] as String),
      cargaHorariaEmHoraRelogio: json['cargaHorariaEmHoraRelogio'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
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
}

final class AtividadeComplementarDocenteResponseDTO {
  final int atividadeComplementarDocenteID;
  final int atividadeComplementarID;
  final int docenteID;
  final String? titulacao;
  final DateTime createdAt;

  AtividadeComplementarDocenteResponseDTO({
    required this.atividadeComplementarDocenteID,
    required this.atividadeComplementarID,
    required this.docenteID,
    this.titulacao,
    required this.createdAt,
  });

  factory AtividadeComplementarDocenteResponseDTO.fromJson(Map<String, dynamic> json) {
    return AtividadeComplementarDocenteResponseDTO(
      atividadeComplementarDocenteID: json['atividadeComplementarDocenteID'] as int,
      atividadeComplementarID: json['atividadeComplementarID'] as int,
      docenteID: json['docenteID'] as int,
      titulacao: json['titulacao'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atividadeComplementarDocenteID': atividadeComplementarDocenteID,
      'atividadeComplementarID': atividadeComplementarID,
      'docenteID': docenteID,
      'titulacao': titulacao,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

final class DisciplinaHistoricoResponseDTO {
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
  final DateTime createdAt;
  final DateTime updatedAt;

  DisciplinaHistoricoResponseDTO({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory DisciplinaHistoricoResponseDTO.fromJson(Map<String, dynamic> json) {
    return DisciplinaHistoricoResponseDTO(
      disciplinaHistoricoID: json['disciplinaHistoricoID'] as int,
      alunoID: json['alunoID'] as int,
      alunoNome: json['alunoNome'] as String,
      codigoDisciplina: json['codigoDisciplina'] as String,
      nomeDisciplina: json['nomeDisciplina'] as String,
      periodoLetivo: json['periodoLetivo'] as String,
      cargaHoraria: json['cargaHoraria'] as int,
      media1: json['media1'] != null ? (json['media1'] as num).toDouble() : null,
      media2: json['media2'] != null ? (json['media2'] as num).toDouble() : null,
      disciplinaSituacaoID: json['disciplinaSituacaoID'] as int,
      docenteNome: json['docenteNome'] as String,
      docenteTitulacao: json['docenteTitulacao'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

final class EstagioResponseDTO {
  final int estagioID;
  final int alunoID;
  final String codigoUnidadeCurricular;
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final String concedenteRazaoSocial;
  final String? concedenteNomeFantasia;
  final String concedenteCNPJ;
  final String? concedenteNome;
  final String? concedenteCPF;
  final String descricao;
  final int cargaHorariaEmHorasRelogio;
  final DateTime createdAt;
  final DateTime updatedAt;

  EstagioResponseDTO({
    required this.estagioID,
    required this.alunoID,
    required this.codigoUnidadeCurricular,
    this.dataInicio,
    this.dataFim,
    required this.concedenteRazaoSocial,
    this.concedenteNomeFantasia,
    required this.concedenteCNPJ,
    this.concedenteNome,
    this.concedenteCPF,
    required this.descricao,
    required this.cargaHorariaEmHorasRelogio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EstagioResponseDTO.fromJson(Map<String, dynamic> json) {
    return EstagioResponseDTO(
      estagioID: json['estagioID'] as int,
      alunoID: json['alunoID'] as int,
      codigoUnidadeCurricular: json['codigoUnidadeCurricular'] as String,
      dataInicio: json['dataInicio'] != null
          ? DateTime.parse(json['dataInicio'] as String)
          : null,
      dataFim: json['dataFim'] != null
          ? DateTime.parse(json['dataFim'] as String)
          : null,
      concedenteRazaoSocial: json['concedenteRazaoSocial'] as String,
      concedenteNomeFantasia: json['concedenteNomeFantasia'] as String?,
      concedenteCNPJ: json['concedenteCNPJ'] as String,
      concedenteNome: json['concedenteNome'] as String?,
      concedenteCPF: json['concedenteCPF'] as String?,
      descricao: json['descricao'] as String,
      cargaHorariaEmHorasRelogio: json['cargaHorariaEmHorasRelogio'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estagioID': estagioID,
      'alunoID': alunoID,
      'codigoUnidadeCurricular': codigoUnidadeCurricular,
      'dataInicio': dataInicio?.toIso8601String(),
      'dataFim': dataFim?.toIso8601String(),
      'concedenteRazaoSocial': concedenteRazaoSocial,
      'concedenteNomeFantasia': concedenteNomeFantasia,
      'concedenteCNPJ': concedenteCNPJ,
      'concedenteNome': concedenteNome,
      'concedenteCPF': concedenteCPF,
      'descricao': descricao,
      'cargaHorariaEmHorasRelogio': cargaHorariaEmHorasRelogio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

final class EstagioDocenteResponseDTO {
  final int estagioDocenteID;
  final int estagioID;
  final int docenteID;
  final DateTime createdAt;

  EstagioDocenteResponseDTO({
    required this.estagioDocenteID,
    required this.estagioID,
    required this.docenteID,
    required this.createdAt,
  });

  factory EstagioDocenteResponseDTO.fromJson(Map<String, dynamic> json) {
    return EstagioDocenteResponseDTO(
      estagioDocenteID: json['estagioDocenteID'] as int,
      estagioID: json['estagioID'] as int,
      docenteID: json['docenteID'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estagioDocenteID': estagioDocenteID,
      'estagioID': estagioID,
      'docenteID': docenteID,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

final class AtividadeComplementarDocenteWithDetailsDTO {
  final AtividadeComplementarDocenteResponseDTO atividadeComplementarDocente;
  final DocenteResponseDTO? docente;

  AtividadeComplementarDocenteWithDetailsDTO({
    required this.atividadeComplementarDocente,
    this.docente,
  });

  factory AtividadeComplementarDocenteWithDetailsDTO.fromJson(Map<String, dynamic> json) {
    return AtividadeComplementarDocenteWithDetailsDTO(
      atividadeComplementarDocente: AtividadeComplementarDocenteResponseDTO.fromJson(
          json['atividadeComplementarDocente'] as Map<String, dynamic>),
      docente: json['docente'] != null
          ? DocenteResponseDTO.fromJson(json['docente'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atividadeComplementarDocente': atividadeComplementarDocente.toJson(),
      'docente': docente?.toJson(),
    };
  }
}

final class AtividadeComplementarWithDocenteDTO {
  final AtividadeComplementarResponseDTO atividadeComplementar;
  final List<AtividadeComplementarDocenteWithDetailsDTO> docentes;

  AtividadeComplementarWithDocenteDTO({
    required this.atividadeComplementar,
    required this.docentes,
  });

  factory AtividadeComplementarWithDocenteDTO.fromJson(Map<String, dynamic> json) {
    return AtividadeComplementarWithDocenteDTO(
      atividadeComplementar: AtividadeComplementarResponseDTO.fromJson(
          json['atividadeComplementar'] as Map<String, dynamic>),
      docentes: (json['docentes'] as List<dynamic>)
          .map((e) => AtividadeComplementarDocenteWithDetailsDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atividadeComplementar': atividadeComplementar.toJson(),
      'docentes': docentes.map((e) => e.toJson()).toList(),
    };
  }
}

final class EstagioDocenteWithDetailsDTO {
  final EstagioDocenteResponseDTO estagioDocente;
  final DocenteResponseDTO? docente;

  EstagioDocenteWithDetailsDTO({
    required this.estagioDocente,
    this.docente,
  });

  factory EstagioDocenteWithDetailsDTO.fromJson(Map<String, dynamic> json) {
    return EstagioDocenteWithDetailsDTO(
      estagioDocente: EstagioDocenteResponseDTO.fromJson(
          json['estagioDocente'] as Map<String, dynamic>),
      docente: json['docente'] != null
          ? DocenteResponseDTO.fromJson(json['docente'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estagioDocente': estagioDocente.toJson(),
      'docente': docente?.toJson(),
    };
  }
}

final class EstagioWithDocenteDTO {
  final EstagioResponseDTO estagio;
  final List<EstagioDocenteWithDetailsDTO> docentes;

  EstagioWithDocenteDTO({
    required this.estagio,
    required this.docentes,
  });

  factory EstagioWithDocenteDTO.fromJson(Map<String, dynamic> json) {
    return EstagioWithDocenteDTO(
      estagio: EstagioResponseDTO.fromJson(json['estagio'] as Map<String, dynamic>),
      docentes: (json['docentes'] as List<dynamic>)
          .map((e) => EstagioDocenteWithDetailsDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estagio': estagio.toJson(),
      'docentes': docentes.map((e) => e.toJson()).toList(),
    };
  }
}

final class ConsolidatedDataResponseDTO {
  final AlunoModel? aluno;
  final TurmaModel? turma;
  final CursoModel? curso;
  final IesEmissoraModel? iesEmissora;
  final RegistroDiplomaResponseDTO? registroDiploma;
  final List<AtividadeComplementarWithDocenteDTO> atividadesComplementares;
  final List<DisciplinaHistoricoResponseDTO> disciplinasHistorico;
  final List<EstagioWithDocenteDTO> estagios;

  ConsolidatedDataResponseDTO({
    this.aluno,
    this.turma,
    this.curso,
    this.iesEmissora,
    this.registroDiploma,
    required this.atividadesComplementares,
    required this.disciplinasHistorico,
    required this.estagios,
  });

  factory ConsolidatedDataResponseDTO.fromJson(Map<String, dynamic> json) {
    return ConsolidatedDataResponseDTO(
      aluno: json['aluno'] != null
          ? AlunoModel.fromJson(json['aluno'] as Map<String, dynamic>)
          : null,
      turma: json['turma'] != null
          ? TurmaModel.fromJson(json['turma'] as Map<String, dynamic>)
          : null,
      curso: json['curso'] != null
          ? CursoModel.fromJson(json['curso'] as Map<String, dynamic>)
          : null,
      iesEmissora: json['iesEmissora'] != null
          ? IesEmissoraModel.fromJson(json['iesEmissora'] as Map<String, dynamic>)
          : null,
      registroDiploma: json['registroDiploma'] != null
          ? RegistroDiplomaResponseDTO.fromJson(json['registroDiploma'] as Map<String, dynamic>)
          : null,
      atividadesComplementares: (json['atividadesComplementares'] as List<dynamic>?)
              ?.map((e) => AtividadeComplementarWithDocenteDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      disciplinasHistorico: (json['disciplinasHistorico'] as List<dynamic>?)
              ?.map((e) => DisciplinaHistoricoResponseDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      estagios: (json['estagios'] as List<dynamic>?)
              ?.map((e) => EstagioWithDocenteDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aluno': aluno?.toJson(),
      'turma': turma?.toJson(),
      'curso': curso?.toJson(),
      'iesEmissora': iesEmissora?.toJson(),
      'registroDiploma': registroDiploma?.toJson(),
      'atividadesComplementares': atividadesComplementares.map((e) => e.toJson()).toList(),
      'disciplinasHistorico': disciplinasHistorico.map((e) => e.toJson()).toList(),
      'estagios': estagios.map((e) => e.toJson()).toList(),
    };
  }
}