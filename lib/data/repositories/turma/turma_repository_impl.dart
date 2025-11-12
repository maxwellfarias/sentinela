import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/turma/turma_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import 'package:w3_diploma/utils/result.dart';
import 'turma_repository.dart';

class TurmaRepositoryImpl implements TurmaRepository {
  TurmaRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<PaginatedResponse<TurmaModel>>> getAllTurmas({QueryParams? params}) async {
    try {
      // return Result.ok(getFictitiousTurmas());
      // Usa parâmetros padrão se não fornecidos
      final queryParams = params ?? const QueryParams();

      // Constrói a URL com query string
      final baseUrl = Urls.getTurmas(idBancoDeDados: '1');
      final queryString = queryParams.toQueryString();
      final fullUrl = '$baseUrl?$queryString';

      return await _apiClient
          .request(
            url: fullUrl,
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => PaginatedResponse<TurmaModel>.fromJson(data, (json) => TurmaModel.fromJson(json),
));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar turmas paginadas', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<TurmaModel>> getTurmaById({required String databaseId, required String turmaId}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getTurma(idBancoDeDados: databaseId, idTurma: turmaId),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => TurmaModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar turma por ID', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<TurmaModel>> createTurma({required TurmaModel turma}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.setTurma(idBancoDeDados: '1'),
            metodo: MetodoHttp.post,
            body: turma.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => TurmaModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao criar turma', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<TurmaModel>> updateTurma({required TurmaModel turma}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.atualizarTurma(
              idBancoDeDados: '1',
              idTurma: turma.turmaID.toString(),
            ),
            metodo: MetodoHttp.put,
            body: turma.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => TurmaModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao atualizar turma', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteTurma({required int turmaId}) async {
    try {
      return await _apiClient.request(
        url: Urls.deletarTurma(idBancoDeDados: '1', idTurma: '$turmaId'),
        metodo: MetodoHttp.delete,
        headers: Urls.bearerHeader,
      );
    } catch (e, s) {
      AppLogger.error('Erro ao deletar turma', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<TurmaModel>>> getTurmasByCurso({required int cursoId}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getTurma(idBancoDeDados: '1', idTurma: '$cursoId'),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => (data as List).map((e) => TurmaModel.fromJson(e)).toList());
    } catch (e, s) {
      AppLogger.error('Erro ao buscar turmas por curso', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
}

/// Retorna uma resposta paginada fictícia com 50 turmas para testes
///
/// Turmas com IDs de 1 a 50, distribuídas entre os 50 cursos existentes (IDs 1-50)
PaginatedResponse<TurmaModel> getFictitiousTurmas() {
  final List<TurmaModel> turmas = List.generate(50, (index) {
    final turmaId = index + 1;
    final cursoId = ((index % 50) + 1); // Distribui entre os 50 cursos (1-50)
    final anoInicio = 2018 + (index % 6); // Anos entre 2018 e 2023
    final periodos = ['Matutino', 'Vespertino', 'Noturno', 'Integral'];
    final periodoLetivo = periodos[index % periodos.length];

    return TurmaModel(
      turmaID: turmaId,
      cursoID: cursoId,
      nomeTurma: 'Turma ${String.fromCharCode(65 + (index % 26))}${turmaId ~/ 26 > 0 ? (turmaId ~/ 26).toString() : ''}',
      anoInicio: anoInicio,
      anoTermino: anoInicio + 4, // Curso de 4 anos
      periodoLetivo: periodoLetivo,
      createdAt: DateTime.now().subtract(Duration(days: 365 - (index * 7))),
      updatedAt: DateTime.now().subtract(Duration(days: index * 3)),
    );
  });

  return PaginatedResponse<TurmaModel>(
    data: turmas,
    page: 1,
    pageSize: 50,
    totalRecords: 50,
    totalPages: 1,
    hasNextPage: false,
    hasPreviousPage: false,
  );
}
