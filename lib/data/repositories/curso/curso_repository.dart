import 'package:w3_diploma/domain/models/curso/curso_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório de Cursos
///
/// Define os contratos para operações de CRUD e busca de cursos.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class CursoRepository {
  /// 1. Buscar todos os cursos com paginação, busca e ordenação
  ///
  /// Retorna cursos paginados conforme os parâmetros de consulta.
  /// Suporta paginação, busca por termo e ordenação por campo.
  ///
  /// **Parâmetros:**
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<CursoModel>>` - Resposta paginada com cursos ou erro
  Future<Result<PaginatedResponse<CursoModel>>> getAllCursos({
    QueryParams? params,
  });

  /// 2. Buscar curso por ID
  ///
  /// Busca um curso específico pelo seu identificador único.
  ///
  /// **Parâmetros:**
  /// - `databaseId`: ID do banco de dados
  /// - `cursoId`: ID único do curso
  ///
  /// **Retorna:**
  /// - `Result<CursoModel>` - Curso encontrado ou erro se não existir
  Future<Result<CursoModel>> getCursoById({
    required String databaseId,
    required String cursoId
  });

  /// 3. Criar novo curso
  ///
  /// Cadastra um novo curso no sistema.
  ///
  /// **Parâmetros:**
  /// - `curso`: Modelo com dados do curso a ser criado (ID será ignorado e gerado automaticamente)
  ///
  /// **Retorna:**
  /// - `Result<CursoModel>` - Curso criado com ID gerado ou erro de validação
  ///
  /// **Validações:**
  /// - Nome do curso deve ser único para a IES Emissora
  /// - IES Emissora deve existir no sistema
  /// - Todos os campos obrigatórios devem estar preenchidos
  Future<Result<CursoModel>> createCurso({required CursoModel curso});

  /// 4. Atualizar curso existente
  ///
  /// Atualiza os dados de um curso já cadastrado.
  ///
  /// **Parâmetros:**
  /// - `curso`: Modelo com dados atualizados do curso (deve incluir o ID válido)
  ///
  /// **Retorna:**
  /// - `Result<CursoModel>` - Curso atualizado ou erro se não existir/validação falhar
  ///
  /// **Validações:**
  /// - Curso deve existir no sistema
  /// - Nome do curso deve ser único para a IES Emissora (exceto para o próprio curso)
  /// - IES Emissora deve existir no sistema
  Future<Result<CursoModel>> updateCurso({required CursoModel curso});

  /// 5. Deletar curso por ID
  ///
  /// Remove um curso do sistema permanentemente.
  ///
  /// **Parâmetros:**
  /// - `cursoId`: ID único do curso a ser removido
  ///
  /// **Retorna:**
  /// - `Result<dynamic>` - Sucesso vazio ou erro se não existir
  ///
  /// **⚠️ Atenção:**
  /// Esta operação é irreversível. Certifique-se de confirmar com o usuário.
  Future<Result<dynamic>> deleteCurso({required int cursoId});

  /// 6. Buscar cursos por IES Emissora
  ///
  /// Retorna todos os cursos associados a uma IES Emissora específica.
  ///
  /// **Parâmetros:**
  /// - `iesEmissoraId`: ID da IES Emissora
  ///
  /// **Retorna:**
  /// - `Result<List<CursoModel>>` - Lista de cursos ou erro
  Future<Result<List<CursoModel>>> getCursosByIesEmissora({required int iesEmissoraId});
}
