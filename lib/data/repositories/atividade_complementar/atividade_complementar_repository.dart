import 'package:w3_diploma/domain/models/atividade_complementar/atividade_complementar_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório de Atividades Complementares
///
/// Define os contratos para operações de CRUD e busca de atividades complementares.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class AtividadeComplementarRepository {
  /// 1. Buscar todas as atividades complementares com paginação, busca e ordenação
  ///
  /// Retorna atividades complementares paginadas conforme os parâmetros de consulta.
  /// Suporta paginação, busca por termo e ordenação por campo.
  ///
  /// **Parâmetros:**
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<AtividadeComplementarModel>>` - Resposta paginada com atividades ou erro
  ///
  /// **Exemplo básico:**
  /// ```dart
  /// final resultado = await repository.getAllAtividadesComplementares();
  /// resultado.when(
  ///   onOk: (response) => print('${response.data.length} atividades na página ${response.page}'),
  ///   onError: (erro) => print('Erro: ${erro.message}'),
  /// );
  /// ```
  ///
  /// **Exemplo com busca e ordenação:**
  /// ```dart
  /// final params = QueryParams(
  ///   page: 2,
  ///   pageSize: 20,
  ///   search: 'Pesquisa',
  ///   sortBy: 'dataInicio',
  ///   sortOrder: 'desc',
  /// );
  /// final resultado = await repository.getAllAtividadesComplementares(params: params);
  /// ```
  Future<Result<PaginatedResponse<AtividadeComplementarModel>>> getAllAtividadesComplementares({
    QueryParams? params,
  });

  /// 2. Buscar atividade complementar por ID
  ///
  /// Busca uma atividade complementar específica pelo seu identificador único.
  ///
  /// **Parâmetros:**
  /// - `databaseId`: ID do banco de dados
  /// - `atividadeComplementarId`: ID único da atividade complementar
  ///
  /// **Retorna:**
  /// - `Result<AtividadeComplementarModel>` - Atividade encontrada ou erro se não existir
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.getAtividadeComplementarById(
  ///   databaseId: '1',
  ///   atividadeComplementarId: '123',
  /// );
  /// resultado.when(
  ///   onOk: (atividade) => print('Atividade encontrada: ${atividade.tipoAtividadeComplementar}'),
  ///   onError: (erro) => print('Atividade não encontrada'),
  /// );
  /// ```
  Future<Result<AtividadeComplementarModel>> getAtividadeComplementarById({
    required String databaseId,
    required String atividadeComplementarId,
  });

  /// 3. Criar nova atividade complementar
  ///
  /// Cadastra uma nova atividade complementar no sistema.
  ///
  /// **Parâmetros:**
  /// - `atividadeComplementar`: Modelo com dados da atividade a ser criada
  ///   (ID será ignorado e gerado automaticamente)
  ///
  /// **Retorna:**
  /// - `Result<AtividadeComplementarModel>` - Atividade criada com ID gerado ou erro de validação
  ///
  /// **Validações:**
  /// - Todos os campos obrigatórios devem estar preenchidos
  /// - Data de início deve ser anterior à data de fim
  /// - Carga horária deve ser maior que zero
  /// - Aluno deve existir no sistema
  ///
  /// **Exemplo:**
  /// ```dart
  /// final novaAtividade = AtividadeComplementarModel(
  ///   atividadeComplementarID: 0, // Será ignorado
  ///   alunoID: 123,
  ///   tipoAtividadeComplementar: 'Pesquisa',
  ///   descricao: 'Pesquisa em inteligência artificial',
  ///   dataInicio: DateTime(2024, 1, 1),
  ///   dataFim: DateTime(2024, 6, 30),
  ///   dataRegistro: DateTime.now(),
  ///   cargaHorariaEmHoraRelogio: 120,
  ///   createdAt: DateTime.now(),
  ///   updatedAt: DateTime.now(),
  /// );
  ///
  /// final resultado = await repository.createAtividadeComplementar(
  ///   atividadeComplementar: novaAtividade,
  /// );
  /// resultado.when(
  ///   onOk: (atividadeCriada) => print('Atividade criada com ID: ${atividadeCriada.atividadeComplementarID}'),
  ///   onError: (erro) => print('Erro ao criar: ${erro.message}'),
  /// );
  /// ```
  Future<Result<AtividadeComplementarModel>> createAtividadeComplementar({
    required AtividadeComplementarModel atividadeComplementar,
  });

  /// 4. Atualizar atividade complementar existente
  ///
  /// Atualiza os dados de uma atividade complementar já cadastrada.
  ///
  /// **Parâmetros:**
  /// - `atividadeComplementar`: Modelo com dados atualizados (deve incluir o ID válido)
  ///
  /// **Retorna:**
  /// - `Result<AtividadeComplementarModel>` - Atividade atualizada ou erro se não existir/validação falhar
  ///
  /// **Validações:**
  /// - Atividade deve existir no sistema
  /// - Data de início deve ser anterior à data de fim
  /// - Carga horária deve ser maior que zero
  ///
  /// **Exemplo:**
  /// ```dart
  /// final atividadeAtualizada = atividadeExistente.copyWith(
  ///   descricao: 'Descrição atualizada',
  ///   cargaHorariaEmHoraRelogio: 150,
  /// );
  ///
  /// final resultado = await repository.updateAtividadeComplementar(
  ///   atividadeComplementar: atividadeAtualizada,
  /// );
  /// resultado.when(
  ///   onOk: (atividade) => print('Atividade atualizada com sucesso'),
  ///   onError: (erro) => print('Erro na atualização: ${erro.message}'),
  /// );
  /// ```
  Future<Result<AtividadeComplementarModel>> updateAtividadeComplementar({
    required AtividadeComplementarModel atividadeComplementar,
  });

  /// 5. Deletar atividade complementar por ID
  ///
  /// Remove uma atividade complementar do sistema permanentemente.
  ///
  /// **Parâmetros:**
  /// - `atividadeComplementarId`: ID único da atividade a ser removida
  ///
  /// **Retorna:**
  /// - `Result<dynamic>` - Sucesso vazio ou erro se não existir
  ///
  /// **⚠️ Atenção:**
  /// Esta operação é irreversível. Certifique-se de confirmar com o usuário.
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.deleteAtividadeComplementar(
  ///   atividadeComplementarId: 123,
  /// );
  /// resultado.when(
  ///   onOk: (_) => print('Atividade excluída com sucesso'),
  ///   onError: (erro) => print('Erro na exclusão: ${erro.message}'),
  /// );
  /// ```
  Future<Result<dynamic>> deleteAtividadeComplementar({
    required int atividadeComplementarId,
  });

  /// 6. Buscar atividades complementares por aluno
  ///
  /// Retorna todas as atividades complementares registradas para um aluno específico.
  ///
  /// **Parâmetros:**
  /// - `alunoId`: ID do aluno
  ///
  /// **Retorna:**
  /// - `Result<List<AtividadeComplementarModel>>` - Lista de atividades do aluno ou erro
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.getAtividadesComplementaresByAluno(
  ///   alunoId: 123,
  /// );
  /// resultado.when(
  ///   onOk: (atividades) => print('${atividades.length} atividades registradas'),
  ///   onError: (erro) => print('Erro: ${erro.message}'),
  /// );
  /// ```
  Future<Result<List<AtividadeComplementarModel>>> getAtividadesComplementaresByAluno({
    required int alunoId,
  });
}
