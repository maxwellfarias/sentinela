import 'package:w3_diploma/domain/models/aluno/aluno_model.dart';
import 'package:w3_diploma/domain/models/curso/curso_model.dart';
import 'package:w3_diploma/domain/models/ies_emissora_model.dart';
import 'package:w3_diploma/domain/models/turma/turma_model.dart';
import 'package:w3_diploma/utils/result.dart';

abstract interface class GerarXmlAcademicoUseCase {
  Future<Result<dynamic>> call({
    required AlunoModel aluno,
    required TurmaModel turma,
    required CursoModel curso,
    required IesEmissoraModel iesEmissora,
  });
}