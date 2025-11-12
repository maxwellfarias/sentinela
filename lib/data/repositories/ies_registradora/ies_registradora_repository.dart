import 'package:w3_diploma/domain/models/ies_registradora.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface do repositório para IESRegistradora
///
/// Define os contratos para operações CRUD de IES Registradora.
/// A implementação real pode usar API, banco local, cache, etc.
abstract interface class IESRegistradoraRepository {
  /// 1. Buscar todas as IES Registradoras
  ///
  /// Retorna uma lista de todas as IES Registradoras disponíveis no database especificado.
  ///
  /// [databaseId] - Identificador do database/workspace
  ///
  /// Retorna:
  /// - `Result.ok(List<IESRegistradora>)` em caso de sucesso
  /// - `Result.error(AppException)` em caso de falha
  Future<Result<List<IESRegistradoraModel>>> getAllIESRegistradoras({required String databaseId});

  /// 2. Buscar uma IES Registradora específica por ID
  ///
  /// [databaseId] - Identificador do database/workspace
  /// [iesRegistradoraId] - ID da IES Registradora a ser buscada
  ///
  /// Retorna:
  /// - `Result.ok(IESRegistradora)` se encontrada
  /// - `Result.error(RecursoNaoEncontradoException)` se não existir
  Future<Result<IESRegistradoraModel>> getIESRegistradoraBy({
    required String databaseId,
    required int iesRegistradoraId,
  });

  /// 3. Criar uma nova IES Registradora
  ///
  /// [databaseId] - Identificador do database/workspace
  /// [iesRegistradora] - Dados da nova IES Registradora
  ///
  /// Retorna:
  /// - `Result.ok(IESRegistradora)` com a IES criada
  /// - `Result.error(AppException)` em caso de falha
  Future<Result<IESRegistradoraModel>> createIESRegistradora({
    required String databaseId,
    required IESRegistradoraModel iesRegistradora,
  });

  /// 4. Atualizar uma IES Registradora existente
  ///
  /// [databaseId] - Identificador do database/workspace
  /// [iesRegistradora] - Dados atualizados da IES Registradora
  ///
  /// Retorna:
  /// - `Result.ok(IESRegistradora)` com a IES atualizada
  /// - `Result.error(RecursoNaoEncontradoException)` se não existir
  Future<Result<IESRegistradoraModel>> updateIESRegistradora({
    required String databaseId,
    required IESRegistradoraModel iesRegistradora,
  });

  /// 5. Deletar uma IES Registradora
  ///
  /// [databaseId] - Identificador do database/workspace
  /// [iesRegistradoraId] - ID da IES Registradora a ser deletada
  ///
  /// Retorna:
  /// - `Result.ok(true)` se deletada com sucesso
  /// - `Result.error(RecursoNaoEncontradoException)` se não existir
  Future<Result<dynamic>> deleteIESRegistradora({
    required String databaseId,
    required int iesRegistradoraId,
  });
}
