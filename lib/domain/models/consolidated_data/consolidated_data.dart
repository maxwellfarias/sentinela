import 'package:w3_diploma/domain/models/aluno/aluno_model.dart';
import 'package:w3_diploma/domain/models/curso/curso_model.dart';
import 'package:w3_diploma/domain/models/ies_emissora_model.dart';
import 'package:w3_diploma/domain/models/registro_diploma/registro_diploma_model.dart';
import 'package:w3_diploma/domain/models/consolidate_data_response_dto/consolidate_data_response_dto.dart';
import 'package:w3_diploma/domain/models/turma/turma_model.dart';

/// Modelo de dados consolidados que reutiliza classes já existentes no projeto
///
/// Esta classe substitui ConsolidatedDataResponseDTO utilizando classes do domínio
/// quando há equivalência 100% entre elas, evitando duplicação de código.
final class ConsolidatedData {
  final AlunoModel? aluno;
  final TurmaModel? turma;
  final CursoModel? curso;
  final IesEmissoraModel? iesEmissora;
  final RegistroDiplomaModel? registroDiploma;

  final List<AtividadeComplementarWithDocenteDTO> atividadesComplementares;
  final List<DisciplinaHistoricoResponseDTO> disciplinasHistorico;
  final List<EstagioWithDocenteDTO> estagios;

  ConsolidatedData({
    this.aluno,
    this.turma,
    this.curso,
    this.iesEmissora,
    this.registroDiploma,
    required this.atividadesComplementares,
    required this.disciplinasHistorico,
    required this.estagios,
  });

  factory ConsolidatedData.fromJson(Map<String, dynamic> json) {
    return ConsolidatedData(
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
          ? RegistroDiplomaModel.fromJson(json['registroDiploma'] as Map<String, dynamic>)
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

  /// Cria uma instância a partir de ConsolidatedDataResponseDTO
  /// convertendo RegistroDiplomaResponseDTO para RegistroDiplomaModel
  factory ConsolidatedData.fromConsolidatedDataResponseDTO(
      ConsolidatedDataResponseDTO dto) {
    return ConsolidatedData(
      aluno: dto.aluno,
      turma: dto.turma,
      curso: dto.curso,
      iesEmissora: dto.iesEmissora,
      registroDiploma: dto.registroDiploma != null
          ? RegistroDiplomaModel(
              registroDiplomaID: dto.registroDiploma!.registroDiplomaID,
              alunoID: dto.registroDiploma!.alunoID,
              alunoNome: dto.registroDiploma!.alunoNome,
              dataConclusaoCurso: dto.registroDiploma!.dataConclusaoCurso,
              dataColacaoGrauDiploma: dto.registroDiploma!.dataColacaoGrauDiploma,
              registroConclusao: dto.registroDiploma!.registroConclusao,
              livroRegistro: dto.registroDiploma!.livroRegistro,
              paginaRegistro: dto.registroDiploma!.paginaRegistro,
              numeroProcessoRegistroDiploma: dto.registroDiploma!.numeroProcessoRegistroDiploma,
              instituicaoDiploma: dto.registroDiploma!.instituicaoDiploma,
              dataEmissaoDiploma: dto.registroDiploma!.dataEmissaoDiploma,
              dataRegistroDiploma: dto.registroDiploma!.dataRegistroDiploma,
              dataPublicacaoDou: dto.registroDiploma!.dataPublicacaoDou,
              localizacaoFisicaPasta: dto.registroDiploma!.localizacaoFisicaPasta,
              responsavelRegistroNome: dto.registroDiploma!.responsavelRegistroNome,
              responsavelRegistroCpf: dto.registroDiploma!.responsavelRegistroCpf,
              responsavelRegistroIdOuNumeroMatricula: dto.registroDiploma!.responsavelRegistroIdOuNumeroMatricula,
              codigoValidacao: dto.registroDiploma!.codigoValidacao,
              numeroFolhaDiploma: dto.registroDiploma!.numeroFolhaDiploma,
              createdAt: dto.registroDiploma!.createdAt,
              updatedAt: dto.registroDiploma!.updatedAt,
            )
          : null,
      atividadesComplementares: dto.atividadesComplementares,
      disciplinasHistorico: dto.disciplinasHistorico,
      estagios: dto.estagios,
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
