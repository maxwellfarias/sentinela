import 'package:w3_diploma/domain/models/registro_diploma/registro_diploma_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório de Registro de Diploma
///
/// Define os contratos para operações de CRUD e busca de registros de diploma.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class RegistroDiplomaRepository {
  /// 1. Buscar todos os itens com paginação, busca e ordenação
  ///
  /// Retorna registros de diploma paginados conforme os parâmetros de consulta.
  /// Suporta paginação, busca por termo e ordenação por campo.
  ///
  /// **Parâmetros:**
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<RegistroDiplomaModel>>` - Resposta paginada com registros ou erro
  Future<Result<PaginatedResponse<RegistroDiplomaModel>>> getAllRegistrosDiplomas({
    QueryParams? params,
  });

  /// 2. Buscar item por ID
  ///
  /// Busca um registro de diploma específico pelo seu identificador único.
  ///
  /// **Parâmetros:**
  /// - `databaseId`: ID do banco de dados
  /// - `registroDiplomaId`: ID único do registro de diploma
  ///
  /// **Retorna:**
  /// - `Result<RegistroDiplomaModel>` - Registro encontrado ou erro se não existir
  Future<Result<RegistroDiplomaModel>> getRegistroDiplomaById({
    required String databaseId,
    required String registroDiplomaId,
  });

  /// 3. Criar novo item
  ///
  /// Cadastra um novo registro de diploma no sistema.
  ///
  /// **Parâmetros:**
  /// - `registroDiploma`: Modelo com dados do registro a ser criado (ID será ignorado e gerado automaticamente)
  ///
  /// **Retorna:**
  /// - `Result<RegistroDiplomaModel>` - Registro criado com ID gerado ou erro de validação
  ///
  /// **Validações:**
  /// - alunoID deve existir no sistema
  /// - Todos os campos obrigatórios devem estar preenchidos
  Future<Result<RegistroDiplomaModel>> createRegistroDiploma({
    required RegistroDiplomaModel registroDiploma,
  });

  /// 4. Atualizar item existente
  ///
  /// Atualiza os dados de um registro de diploma já cadastrado.
  ///
  /// **Parâmetros:**
  /// - `registroDiploma`: Modelo com dados atualizados do registro (deve incluir o ID válido)
  ///
  /// **Retorna:**
  /// - `Result<RegistroDiplomaModel>` - Registro atualizado ou erro se não existir/validação falhar
  ///
  /// **Validações:**
  /// - Registro deve existir no sistema
  /// - alunoID deve existir no sistema
  Future<Result<RegistroDiplomaModel>> updateRegistroDiploma({
    required RegistroDiplomaModel registroDiploma,
  });

  /// 5. Deletar item por ID
  ///
  /// Remove um registro de diploma do sistema permanentemente.
  ///
  /// **Parâmetros:**
  /// - `registroDiplomaId`: ID único do registro a ser removido
  ///
  /// **Retorna:**
  /// - `Result<dynamic>` - Sucesso vazio ou erro se não existir
  ///
  /// **⚠️ Atenção:**
  /// Esta operação é irreversível. Certifique-se de confirmar com o usuário.
  Future<Result<dynamic>> deleteRegistroDiploma({
    required int registroDiplomaId,
  });

  /// 6. Buscar registros de diploma por aluno
  ///
  /// Retorna todos os registros de diploma associados a um aluno específico.
  ///
  /// **Parâmetros:**
  /// - `alunoId`: ID do aluno
  ///
  /// **Retorna:**
  /// - `Result<List<RegistroDiplomaModel>>` - Lista de registros ou erro
  Future<Result<List<RegistroDiplomaModel>>> getRegistrosDiplomasByAluno({
    required int alunoId,
  });
}
