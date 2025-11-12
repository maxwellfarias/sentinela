import 'package:w3_diploma/domain/models/turma/turma_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório de Turmas
///
/// Define os contratos para operações de CRUD e busca de turmas.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class TurmaRepository {
  /// 1. Buscar todas as turmas com paginação, busca e ordenação
  ///
  /// Retorna turmas paginadas conforme os parâmetros de consulta.
  /// Suporta paginação, busca por termo e ordenação por campo.
  ///
  /// **Parâmetros:**
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<TurmaModel>>` - Resposta paginada com turmas ou erro
  ///
  /// **Exemplo básico:**
  /// ```dart
  /// final resultado = await repository.getAllTurmas();
  /// resultado.when(
  ///   onOk: (response) => print('${response.data.length} turmas na página ${response.page}'),
  ///   onError: (erro) => print('Erro: ${erro.message}'),
  /// );
  /// ```
  ///
  /// **Exemplo com busca e ordenação:**
  /// ```dart
  /// final params = QueryParams(
  ///   page: 2,
  ///   pageSize: 20,
  ///   search: '2024',
  ///   sortBy: 'nomeTurma',
  ///   sortOrder: 'desc',
  /// );
  /// final resultado = await repository.getAllTurmas(params: params);
  /// ```
  Future<Result<PaginatedResponse<TurmaModel>>> getAllTurmas({
    QueryParams? params,
  });

  /// 2. Buscar turma por ID
  ///
  /// Busca uma turma específica pelo seu identificador único.
  ///
  /// **Parâmetros:**
  /// - `databaseId`: ID do banco de dados
  /// - `turmaId`: ID único da turma
  ///
  /// **Retorna:**
  /// - `Result<TurmaModel>` - Turma encontrada ou erro se não existir
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.getTurmaById(
  ///   databaseId: '1',
  ///   turmaId: '123',
  /// );
  /// resultado.when(
  ///   onOk: (turma) => print('Turma encontrada: ${turma.nomeTurma}'),
  ///   onError: (erro) => print('Turma não encontrada'),
  /// );
  /// ```
  Future<Result<TurmaModel>> getTurmaById({
    required String databaseId,
    required String turmaId,
  });

  /// 3. Criar nova turma
  ///
  /// Cadastra uma nova turma no sistema.
  ///
  /// **Parâmetros:**
  /// - `turma`: Modelo com dados da turma a ser criada (ID será ignorado e gerado automaticamente)
  ///
  /// **Retorna:**
  /// - `Result<TurmaModel>` - Turma criada com ID gerado ou erro de validação
  ///
  /// **Validações:**
  /// - Curso deve existir no sistema
  /// - Todos os campos obrigatórios devem estar preenchidos
  /// - Ano de início deve ser válido
  ///
  /// **Exemplo:**
  /// ```dart
  /// final novaTurma = TurmaModel(
  ///   turmaID: 0, // Será ignorado
  ///   cursoID: 1,
  ///   nomeTurma: 'Turma A',
  ///   anoInicio: 2024,
  ///   periodoLetivo: '2024/1',
  /// );
  ///
  /// final resultado = await repository.createTurma(turma: novaTurma);
  /// resultado.when(
  ///   onOk: (turmaCriada) => print('Turma criada com ID: ${turmaCriada.turmaID}'),
  ///   onError: (erro) => print('Erro ao criar: ${erro.message}'),
  /// );
  /// ```
  Future<Result<TurmaModel>> createTurma({required TurmaModel turma});

  /// 4. Atualizar turma existente
  ///
  /// Atualiza os dados de uma turma já cadastrada.
  ///
  /// **Parâmetros:**
  /// - `turma`: Modelo com dados atualizados da turma (deve incluir o ID válido)
  ///
  /// **Retorna:**
  /// - `Result<TurmaModel>` - Turma atualizada ou erro se não existir/validação falhar
  ///
  /// **Validações:**
  /// - Turma deve existir no sistema
  /// - Curso deve existir se alterado
  ///
  /// **Exemplo:**
  /// ```dart
  /// final turmaAtualizada = turmaExistente.copyWith(
  ///   nomeTurma: 'Turma A - Noturno',
  ///   anoTermino: 2028,
  /// );
  ///
  /// final resultado = await repository.updateTurma(turma: turmaAtualizada);
  /// resultado.when(
  ///   onOk: (turma) => print('Turma atualizada com sucesso'),
  ///   onError: (erro) => print('Erro na atualização: ${erro.message}'),
  /// );
  /// ```
  Future<Result<TurmaModel>> updateTurma({required TurmaModel turma});

  /// 5. Deletar turma por ID
  ///
  /// Remove uma turma do sistema permanentemente.
  ///
  /// **Parâmetros:**
  /// - `turmaId`: ID único da turma a ser removida
  ///
  /// **Retorna:**
  /// - `Result<dynamic>` - Sucesso vazio ou erro se não existir
  ///
  /// **⚠️ Atenção:**
  /// Esta operação é irreversível. Certifique-se de confirmar com o usuário.
  /// Pode falhar se houver alunos matriculados na turma.
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.deleteTurma(turmaId: 123);
  /// resultado.when(
  ///   onOk: (_) => print('Turma excluída com sucesso'),
  ///   onError: (erro) => print('Erro na exclusão: ${erro.message}'),
  /// );
  /// ```
  Future<Result<dynamic>> deleteTurma({required int turmaId});

  /// 6. Buscar turmas por curso
  ///
  /// Retorna todas as turmas vinculadas a um curso específico.
  ///
  /// **Parâmetros:**
  /// - `cursoId`: ID do curso
  ///
  /// **Retorna:**
  /// - `Result<List<TurmaModel>>` - Lista de turmas do curso ou erro
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.getTurmasByCurso(cursoId: 1);
  /// resultado.when(
  ///   onOk: (turmas) => print('${turmas.length} turmas no curso'),
  ///   onError: (erro) => print('Erro: ${erro.message}'),
  /// );
  /// ```
  Future<Result<List<TurmaModel>>> getTurmasByCurso({required int cursoId});
}
