import 'package:w3_diploma/domain/models/docente/docente_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório de Docentes
///
/// Define os contratos para operações de CRUD e busca de docentes.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class DocenteRepository {
  /// 1. Buscar todos os docentes com paginação, busca e ordenação
  ///
  /// Retorna docentes paginados conforme os parâmetros de consulta.
  /// Suporta paginação, busca por termo e ordenação por campo.
  ///
  /// **Parâmetros:**
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<DocenteModel>>` - Resposta paginada com docentes ou erro
  ///
  /// **Exemplo básico:**
  /// ```dart
  /// final resultado = await repository.getAllDocentes();
  /// resultado.when(
  ///   onOk: (response) => print('${response.data.length} docentes na página ${response.page}'),
  ///   onError: (erro) => print('Erro: ${erro.message}'),
  /// );
  /// ```
  ///
  /// **Exemplo com busca e ordenação:**
  /// ```dart
  /// final params = QueryParams(
  ///   page: 2,
  ///   pageSize: 20,
  ///   search: 'Silva',
  ///   sortBy: 'nome',
  ///   sortOrder: 'asc',
  /// );
  /// final resultado = await repository.getAllDocentes(params: params);
  /// ```
  Future<Result<PaginatedResponse<DocenteModel>>> getAllDocentes({
    QueryParams? params,
  });

  /// 2. Buscar docente por ID
  ///
  /// Busca um docente específico pelo seu identificador único.
  ///
  /// **Parâmetros:**
  /// - `databaseId`: ID do banco de dados
  /// - `docenteId`: ID único do docente
  ///
  /// **Retorna:**
  /// - `Result<DocenteModel>` - Docente encontrado ou erro se não existir
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.getDocenteById(
  ///   databaseId: '1',
  ///   docenteId: '123',
  /// );
  /// resultado.when(
  ///   onOk: (docente) => print('Docente encontrado: ${docente.nome}'),
  ///   onError: (erro) => print('Docente não encontrado'),
  /// );
  /// ```
  Future<Result<DocenteModel>> getDocenteById({
    required String databaseId,
    required String docenteId,
  });

  /// 3. Criar novo docente
  ///
  /// Cadastra um novo docente no sistema.
  ///
  /// **Parâmetros:**
  /// - `docente`: Modelo com dados do docente a ser criado (ID será ignorado e gerado automaticamente)
  ///
  /// **Retorna:**
  /// - `Result<DocenteModel>` - Docente criado com ID gerado ou erro de validação
  ///
  /// **Validações:**
  /// - Nome deve ser preenchido
  /// - Titulação deve ser uma das opções válidas (Graduação, Especialização, Mestrado, Doutorado)
  /// - CPF deve ser único no sistema (se fornecido)
  ///
  /// **Exemplo:**
  /// ```dart
  /// final novoDocente = DocenteModel(
  ///   docenteID: 0, // Será ignorado
  ///   nome: 'Prof. João Silva',
  ///   titulacao: 'Mestrado',
  ///   cpf: '123.456.789-00',
  ///   createdAt: DateTime.now(),
  ///   updatedAt: DateTime.now(),
  /// );
  ///
  /// final resultado = await repository.createDocente(docente: novoDocente);
  /// resultado.when(
  ///   onOk: (docenteCriado) => print('Docente criado com ID: ${docenteCriado.docenteID}'),
  ///   onError: (erro) => print('Erro ao criar: ${erro.message}'),
  /// );
  /// ```
  Future<Result<DocenteModel>> createDocente({required DocenteModel docente});

  /// 4. Atualizar docente existente
  ///
  /// Atualiza os dados de um docente já cadastrado.
  ///
  /// **Parâmetros:**
  /// - `docente`: Modelo com dados atualizados do docente (deve incluir o ID válido)
  ///
  /// **Retorna:**
  /// - `Result<DocenteModel>` - Docente atualizado ou erro se não existir/validação falhar
  ///
  /// **Validações:**
  /// - Docente deve existir no sistema
  /// - CPF deve ser único (exceto para o próprio docente)
  ///
  /// **Exemplo:**
  /// ```dart
  /// final docenteAtualizado = docenteExistente.copyWith(
  ///   nome: 'Prof. João Silva Jr.',
  ///   titulacao: 'Doutorado',
  /// );
  ///
  /// final resultado = await repository.updateDocente(docente: docenteAtualizado);
  /// resultado.when(
  ///   onOk: (docente) => print('Docente atualizado com sucesso'),
  ///   onError: (erro) => print('Erro na atualização: ${erro.message}'),
  /// );
  /// ```
  Future<Result<DocenteModel>> updateDocente({required DocenteModel docente});

  /// 5. Deletar docente por ID
  ///
  /// Remove um docente do sistema permanentemente.
  ///
  /// **Parâmetros:**
  /// - `docenteId`: ID único do docente a ser removido
  ///
  /// **Retorna:**
  /// - `Result<dynamic>` - Sucesso vazio ou erro se não existir
  ///
  /// **⚠️ Atenção:**
  /// Esta operação é irreversível. Certifique-se de confirmar com o usuário.
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await repository.deleteDocente(docenteId: 123);
  /// resultado.when(
  ///   onOk: (_) => print('Docente excluído com sucesso'),
  ///   onError: (erro) => print('Erro na exclusão: ${erro.message}'),
  /// );
  /// ```
  Future<Result<dynamic>> deleteDocente({required int docenteId});
}
