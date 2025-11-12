import 'package:w3_diploma/domain/models/aluno/aluno_dto.dart';

import '../../../domain/models/aluno/aluno_model.dart';
import '../../../domain/models/pagination/paginated_response.dart';
import '../../../domain/models/pagination/query_params.dart';
import '../../../utils/result.dart';

/// Interface do repositório de Alunos
/// 
/// Define os contratos para operações de CRUD e busca de alunos.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class AlunoRepository {
  /// 1. Buscar todos os alunos com paginação, busca e ordenação
  ///
  /// Retorna alunos paginados conforme os parâmetros de consulta.
  /// Suporta paginação, busca por termo e ordenação por campo.
  ///
  /// **Parâmetros:**
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<AlunoModel>>` - Resposta paginada com alunos ou erro
  ///
  /// **Exemplo básico:**
  /// ```dart
  /// final resultado = await repository.getAllAlunos();
  /// resultado.when(
  ///   onOk: (response) => print('${response.data.length} alunos na página ${response.page}'),
  ///   onError: (erro) => print('Erro: ${erro.message}'),
  /// );
  /// ```
  ///
  /// **Exemplo com busca e ordenação:**
  /// ```dart
  /// final params = QueryParams(
  ///   page: 2,
  ///   pageSize: 20,
  ///   search: 'Beatriz',
  ///   sortBy: 'nome',
  ///   sortOrder: 'desc',
  /// );
  /// final resultado = await repository.getAllAlunos(params: params);
  /// ```
  Future<Result<PaginatedResponse<AlunoModel>>> getAllAlunos({
    QueryParams? params,
  });

  /// 2. Buscar aluno por ID
  /// 
  /// Busca um aluno específico pelo seu identificador único.
  /// 
  /// **Parâmetros:**
  /// - `alunoId`: ID único do aluno
  /// 
  /// **Retorna:**
  /// - `Result<Aluno>` - Aluno encontrado ou erro se não existir
  /// 
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.getAlunoById(alunoId: 123);
  /// resultado.when(
  ///   onOk: (aluno) => print('Aluno encontrado: ${aluno.nome}'),
  ///   onError: (erro) => print('Aluno não encontrado'),
  /// );
  /// ```
  Future<Result<AlunoModel>> getAlunoById({required String databaseId, required String alunoId});

  /// 3. Criar novo aluno
  /// 
  /// Cadastra um novo aluno no sistema.
  /// 
  /// **Parâmetros:**
  /// - `aluno`: Dados do aluno a ser criado (ID será ignorado e gerado automaticamente)
  /// 
  /// **Retorna:**
  /// - `Result<Aluno>` - Aluno criado com ID gerado ou erro de validação
  /// 
  /// **Validações:**
  /// - CPF deve ser único no sistema
  /// - Todos os campos obrigatórios devem estar preenchidos
  /// 
  /// **Exemplo:**
  /// ```dart
  /// final novoAluno = Aluno(
  ///   alunoID: 0, // Será ignorado
  ///   nome: 'João Silva',
  ///   cpf: '123.456.789-00',
  ///   // ... outros campos
  /// );
  /// 
  /// final resultado = await repository.createAluno(aluno: novoAluno);
  /// resultado.when(
  ///   onOk: (alunoCriado) => print('Aluno criado com ID: ${alunoCriado.alunoID}'),
  ///   onError: (erro) => print('Erro ao criar: ${erro.message}'),
  /// );
  /// ```
  Future<Result<AlunoModel>> createAluno({required AlunoDto aluno});

  /// 4. Atualizar aluno existente
  /// 
  /// Atualiza os dados de um aluno já cadastrado.
  /// 
  /// **Parâmetros:**
  /// - `aluno`: Dados atualizados do aluno (deve incluir o ID válido)
  /// 
  /// **Retorna:**
  /// - `Result<Aluno>` - Aluno atualizado ou erro se não existir/validação falhar
  /// 
  /// **Validações:**
  /// - Aluno deve existir no sistema
  /// - CPF deve ser único (exceto para o próprio aluno)
  /// 
  /// **Exemplo:**
  /// ```dart
  /// final alunoAtualizado = alunoExistente.copyWith(
  ///   nome: 'Nome Atualizado',
  ///   telefone: '(11) 99999-9999',
  /// );
  /// 
  /// final resultado = await repository.updateAluno(aluno: alunoAtualizado);
  /// resultado.when(
  ///   onOk: (aluno) => print('Aluno atualizado com sucesso'),
  ///   onError: (erro) => print('Erro na atualização: ${erro.message}'),
  /// );
  /// ```
  Future<Result<AlunoModel>> updateAluno({required AlunoDto aluno});

  /// 5. Deletar aluno por ID
  /// 
  /// Remove um aluno do sistema permanentemente.
  /// 
  /// **Parâmetros:**
  /// - `alunoId`: ID único do aluno a ser removido
  /// 
  /// **Retorna:**
  /// - `Result<void>` - Sucesso vazio ou erro se não existir
  /// 
  /// **⚠️ Atenção:**
  /// Esta operação é irreversível. Certifique-se de confirmar com o usuário.
  /// 
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.deleteAluno(alunoId: 123);
  /// resultado.when(
  ///   onOk: (_) => print('Aluno excluído com sucesso'),
  ///   onError: (erro) => print('Erro na exclusão: ${erro.message}'),
  /// );
  /// ```
  Future<Result<dynamic>> deleteAluno({required int alunoId});

  /// 6. Buscar alunos por turma com paginação
  ///
  /// Retorna alunos matriculados em uma turma específica com suporte a paginação.
  ///
  /// **Parâmetros:**
  /// - `turmaId`: ID da turma
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<AlunoModel>>` - Resposta paginada com alunos da turma ou erro
  ///
  /// **Exemplo básico:**
  /// ```dart
  /// final resultado = await repository.getAlunosByTurma(turmaId: 1);
  /// resultado.when(
  ///   onOk: (response) => print('${response.data.length} alunos na página ${response.page}'),
  ///   onError: (erro) => print('Erro: ${erro.message}'),
  /// );
  /// ```
  ///
  /// **Exemplo com paginação:**
  /// ```dart
  /// final params = QueryParams(page: 2, pageSize: 20);
  /// final resultado = await repository.getAlunosByTurma(
  ///   turmaId: 1,
  ///   params: params,
  /// );
  /// ```
  Future<Result<PaginatedResponse<AlunoModel>>> getAlunosByTurma({
    required int turmaId,
    QueryParams? params,
  });

  /// 7. Buscar alunos por turma com paginação
  ///
  /// Retorna alunos matriculados em uma turma específica com suporte a paginação.
  ///
  /// **Parâmetros:**
  /// - `turmaId`: ID da turma
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<AlunoModel>>` - Resposta paginada com alunos da turma ou erro
  ///
  /// **Exemplo básico:**
  /// ```dart
  /// final resultado = await repository.getAlunosByTurmaPaginated(turmaId: 1);
  /// resultado.when(
  ///   onOk: (response) => print('${response.data.length} alunos na página ${response.page}'),
  ///   onError: (erro) => print('Erro: ${erro.message}'),
  /// );
  /// ```
  ///
  /// **Exemplo com paginação:**
  /// ```dart
  /// final params = QueryParams(page: 2, pageSize: 20);
  /// final resultado = await repository.getAlunosByTurmaPaginated(
  ///   turmaId: 1,
  ///   params: params,
  /// );
  /// ```
  Future<Result<PaginatedResponse<AlunoModel>>> getAlunosByTurmaPaginated({
    required int turmaId,
    QueryParams? params,
  });
}
