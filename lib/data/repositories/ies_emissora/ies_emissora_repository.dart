import 'package:w3_diploma/domain/models/ies_emissora_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório de IES Emissoras
///
/// Define os contratos para operações de CRUD e busca de IES Emissoras.
/// Implementações concretas devem fornecer a lógica específica de cada fonte de dados.
abstract interface class IesEmissoraRepository {
  /// 1. Buscar todas as IES Emissoras com paginação, busca e ordenação
  ///
  /// Retorna IES Emissoras paginadas conforme os parâmetros de consulta.
  /// Suporta paginação, busca por termo e ordenação por campo.
  ///
  /// **Parâmetros:**
  /// - `params`: Parâmetros de consulta (page, pageSize, search, sortBy, sortOrder)
  ///   Se não fornecido, usa valores padrão (page: 1, pageSize: 10)
  ///
  /// **Retorna:**
  /// - `Result<PaginatedResponse<IesEmissoraModel>>` - Resposta paginada com IES Emissoras ou erro
  Future<Result<IesEmissoraModel>> getAllIesEmissoras();

  /// 2. Buscar IES Emissora por ID
  ///
  /// Busca uma IES Emissora específica pelo seu identificador único.
  ///
  /// **Parâmetros:**
  /// - `databaseId`: ID do banco de dados
  /// - `iesEmissoraId`: ID único da IES Emissora
  ///
  /// **Retorna:**
  /// - `Result<IesEmissoraModel>` - IES Emissora encontrada ou erro se não existir
  Future<Result<IesEmissoraModel>> getIesEmissoraById({
    required String databaseId,
    required String iesEmissoraId
  });

  /// 3. Criar nova IES Emissora
  ///
  /// Cadastra uma nova IES Emissora no sistema.
  ///
  /// **Parâmetros:**
  /// - `iesEmissora`: Modelo com dados da IES Emissora a ser criada (ID será ignorado e gerado automaticamente)
  ///
  /// **Retorna:**
  /// - `Result<IesEmissoraModel>` - IES Emissora criada com ID gerado ou erro de validação
  ///
  /// **Validações:**
  /// - CNPJ deve ser único no sistema
  /// - Todos os campos obrigatórios devem estar preenchidos
  Future<Result<IesEmissoraModel>> createIesEmissora({required IesEmissoraModel iesEmissora});

  /// 4. Atualizar IES Emissora existente
  ///
  /// Atualiza os dados de uma IES Emissora já cadastrada.
  ///
  /// **Parâmetros:**
  /// - `iesEmissora`: Modelo com dados atualizados da IES Emissora (deve incluir o ID válido)
  ///
  /// **Retorna:**
  /// - `Result<IesEmissoraModel>` - IES Emissora atualizada ou erro se não existir/validação falhar
  ///
  /// **Validações:**
  /// - IES Emissora deve existir no sistema
  /// - CNPJ deve ser único (exceto para a própria IES Emissora)
  Future<Result<IesEmissoraModel>> updateIesEmissora({required IesEmissoraModel iesEmissora});

  /// 5. Deletar IES Emissora por ID
  ///
  /// Remove uma IES Emissora do sistema permanentemente.
  ///
  /// **Parâmetros:**
  /// - `iesEmissoraId`: ID único da IES Emissora a ser removida
  ///
  /// **Retorna:**
  /// - `Result<dynamic>` - Sucesso vazio ou erro se não existir
  ///
  /// **⚠️ Atenção:**
  /// Esta operação é irreversível. Certifique-se de confirmar com o usuário.
  Future<Result<dynamic>> deleteIesEmissora({required int iesEmissoraId});
}
