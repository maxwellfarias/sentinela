import 'package:w3_diploma/domain/models/consolidated_data/consolidated_data.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório de ConsolidatedData
///
/// Define o contrato para operações de busca de dados consolidados.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class ConsolidatedDataRepository {
  /// Buscar dados consolidados por turma
  ///
  /// Retorna uma lista de dados consolidados para todos os alunos de uma turma específica.
  /// Os dados consolidados incluem informações do aluno, turma, curso, IES emissora,
  /// registro de diploma, atividades complementares, disciplinas do histórico e estágios.
  ///
  /// **Parâmetros:**
  /// - `turmaId`: ID da turma para buscar os dados consolidados
  ///
  /// **Retorna:**
  /// - `Result<List<ConsolidatedData>>` - Lista de dados consolidados ou erro
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.getConsolidatedDataByTurma(turmaId: 1);
  /// resultado.when(
  ///   onOk: (dados) => print('${dados.length} registros encontrados'),
  ///   onError: (erro) => print('Erro: ${erro.message}'),
  /// );
  /// ```
  Future<Result<List<ConsolidatedData>>> getConsolidatedDataByTurma({
    required int turmaId,
  });
}
