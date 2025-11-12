import 'package:w3_diploma/domain/models/disciplina_historico/disciplina_historico_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório de Disciplinas do Histórico Acadêmico
///
/// Define os contratos para operações de CRUD e busca de disciplinas do histórico.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class DisciplinaHistoricoRepository {
  /// 1. Buscar todas as disciplinas do histórico com paginação, busca e ordenação
  ///
  /// Retorna disciplinas paginadas conforme os parâmetros de consulta.
  /// Suporta paginação, busca por termo e ordenação por campo.
  ///
  /// **Parâmetros:**
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<DisciplinaHistoricoModel>>` - Resposta paginada com disciplinas ou erro
  Future<Result<PaginatedResponse<DisciplinaHistoricoModel>>> getAllDisciplinasHistorico({
    QueryParams? params,
  });

  /// 2. Buscar disciplina do histórico por ID
  ///
  /// Busca uma disciplina específica do histórico pelo seu identificador único.
  ///
  /// **Parâmetros:**
  /// - `databaseId`: ID do banco de dados
  /// - `disciplinaHistoricoId`: ID único da disciplina no histórico
  ///
  /// **Retorna:**
  /// - `Result<DisciplinaHistoricoModel>` - Disciplina encontrada ou erro se não existir
  Future<Result<DisciplinaHistoricoModel>> getDisciplinaHistoricoById({
    required String databaseId,
    required String disciplinaHistoricoId,
  });

  /// 3. Criar nova disciplina no histórico
  ///
  /// Cadastra uma nova disciplina no histórico acadêmico do aluno.
  ///
  /// **Parâmetros:**
  /// - `disciplinaHistorico`: Modelo com dados da disciplina a ser criada
  ///   (ID será ignorado e gerado automaticamente)
  ///
  /// **Retorna:**
  /// - `Result<DisciplinaHistoricoModel>` - Disciplina criada com ID gerado ou erro de validação
  ///
  /// **Validações:**
  /// - Aluno deve existir no sistema (alunoID válido)
  /// - Todos os campos obrigatórios devem estar preenchidos
  /// - Notas devem estar entre 0 e 10 (se informadas)
  /// - Situação deve ser válida (3=Pendente, 4=Aprovado, 5=Reprovado)
  Future<Result<DisciplinaHistoricoModel>> createDisciplinaHistorico({
    required DisciplinaHistoricoModel disciplinaHistorico,
  });

  /// 4. Atualizar disciplina existente no histórico
  ///
  /// Atualiza os dados de uma disciplina já cadastrada no histórico.
  ///
  /// **Parâmetros:**
  /// - `disciplinaHistorico`: Modelo com dados atualizados (deve incluir o ID válido)
  ///
  /// **Retorna:**
  /// - `Result<DisciplinaHistoricoModel>` - Disciplina atualizada ou erro se não existir/validação falhar
  ///
  /// **Validações:**
  /// - Disciplina deve existir no sistema
  /// - Aluno deve existir no sistema
  /// - Notas devem estar entre 0 e 10 (se informadas)
  /// - Situação deve ser válida
  Future<Result<DisciplinaHistoricoModel>> updateDisciplinaHistorico({
    required DisciplinaHistoricoModel disciplinaHistorico,
  });

  /// 5. Deletar disciplina do histórico por ID
  ///
  /// Remove uma disciplina do histórico acadêmico permanentemente.
  ///
  /// **Parâmetros:**
  /// - `disciplinaHistoricoId`: ID único da disciplina a ser removida
  ///
  /// **Retorna:**
  /// - `Result<dynamic>` - Sucesso vazio ou erro se não existir
  ///
  /// **⚠️ Atenção:**
  /// Esta operação é irreversível. Certifique-se de confirmar com o usuário.
  Future<Result<dynamic>> deleteDisciplinaHistorico({
    required int disciplinaHistoricoId,
  });

  /// 6. MÉTODOS ADICIONAIS (OPCIONAIS)
  ///
  /// Buscar disciplinas do histórico por aluno
  ///
  /// Retorna todas as disciplinas cursadas por um aluno específico.
  ///
  /// **Parâmetros:**
  /// - `alunoId`: ID do aluno
  ///
  /// **Retorna:**
  /// - `Result<List<DisciplinaHistoricoModel>>` - Lista de disciplinas do aluno ou erro
  Future<Result<List<DisciplinaHistoricoModel>>> getDisciplinasHistoricoByAluno({
    required int alunoId,
  });

  /// Buscar disciplinas do histórico por situação
  ///
  /// Retorna disciplinas filtradas por situação (Pendente, Aprovado, Reprovado).
  ///
  /// **Parâmetros:**
  /// - `situacaoId`: ID da situação (3=Pendente, 4=Aprovado, 5=Reprovado)
  ///
  /// **Retorna:**
  /// - `Result<List<DisciplinaHistoricoModel>>` - Lista de disciplinas na situação especificada
  Future<Result<List<DisciplinaHistoricoModel>>> getDisciplinasHistoricoBySituacao({
    required int situacaoId,
  });
}
