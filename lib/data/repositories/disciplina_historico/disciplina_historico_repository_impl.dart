import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/disciplina_historico/disciplina_historico_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import 'package:w3_diploma/utils/result.dart';
import 'disciplina_historico_repository.dart';

class DisciplinaHistoricoRepositoryImpl implements DisciplinaHistoricoRepository {
  DisciplinaHistoricoRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<PaginatedResponse<DisciplinaHistoricoModel>>> getAllDisciplinasHistorico({
    QueryParams? params,
  }) async {
    try {
      // Usa parâmetros padrão se não fornecidos
      final queryParams = params ?? const QueryParams();

      // Constrói a URL com query string
      final baseUrl = Urls.getDisciplinasHistorico(id: '1');
      final queryString = queryParams.toQueryString();
      final fullUrl = '$baseUrl?$queryString';

      return await _apiClient
          .request(
            url: fullUrl,
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => PaginatedResponse<DisciplinaHistoricoModel>.fromJson(
                data,
                (json) => DisciplinaHistoricoModel.fromJson(json),
              ));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar disciplinas do histórico paginadas',
          error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<DisciplinaHistoricoModel>> getDisciplinaHistoricoById({
    required String databaseId,
    required String disciplinaHistoricoId,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getDisciplinaHistorico(
              idBancoDeDados: databaseId,
              idDisciplinaHistorico: disciplinaHistoricoId,
            ),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => DisciplinaHistoricoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar disciplina do histórico por ID',
          error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<DisciplinaHistoricoModel>> createDisciplinaHistorico({
    required DisciplinaHistoricoModel disciplinaHistorico,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.setDisciplinaHistorico(idBancoDeDados: '1'),
            metodo: MetodoHttp.post,
            body: disciplinaHistorico.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => DisciplinaHistoricoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao criar disciplina no histórico',
          error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<DisciplinaHistoricoModel>> updateDisciplinaHistorico({
    required DisciplinaHistoricoModel disciplinaHistorico,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.atualizarDisciplinaHistorico(
              idBancoDeDados: '1',
              idDisciplinaHistorico:
                  disciplinaHistorico.disciplinaHistoricoID.toString(),
            ),
            metodo: MetodoHttp.put,
            body: disciplinaHistorico.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => DisciplinaHistoricoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao atualizar disciplina do histórico',
          error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteDisciplinaHistorico({
    required int disciplinaHistoricoId,
  }) async {
    try {
      return await _apiClient.request(
        url: Urls.deletarDisciplinaHistorico(
          idBancoDeDados: '1',
          idDisciplinaHistorico: '$disciplinaHistoricoId',
        ),
        metodo: MetodoHttp.delete,
        headers: Urls.bearerHeader,
      );
    } catch (e, s) {
      AppLogger.error('Erro ao deletar disciplina do histórico',
          error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<DisciplinaHistoricoModel>>> getDisciplinasHistoricoByAluno({
    required int alunoId,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getDisciplinasHistorico(id: '1'),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => (data as List)
              .map((e) => DisciplinaHistoricoModel.fromJson(e))
              .where((d) => d.alunoID == alunoId)
              .toList());
    } catch (e, s) {
      AppLogger.error('Erro ao buscar disciplinas do histórico por aluno',
          error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<DisciplinaHistoricoModel>>> getDisciplinasHistoricoBySituacao({
    required int situacaoId,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getDisciplinasHistorico(id: '1'),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => (data as List)
              .map((e) => DisciplinaHistoricoModel.fromJson(e))
              .where((d) => d.disciplinaSituacaoID == situacaoId)
              .toList());
    } catch (e, s) {
      AppLogger.error('Erro ao buscar disciplinas do histórico por situação',
          error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
}
