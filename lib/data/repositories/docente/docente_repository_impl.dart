import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import '../../../domain/models/docente/docente_model.dart';
import '../../../utils/result.dart';
import 'docente_repository.dart';

class DocenteRepositoryImpl implements DocenteRepository {
  DocenteRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<PaginatedResponse<DocenteModel>>> getAllDocentes({QueryParams? params}) async {
    try {
      // Usa parâmetros padrão se não fornecidos
      final queryParams = params ?? const QueryParams();

      // Constrói a URL com query string
      final baseUrl = Urls.getDocentes(id: '1');
      final queryString = queryParams.toQueryString();
      final fullUrl = '$baseUrl?$queryString';

      return await _apiClient
          .request(
            url: fullUrl,
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => PaginatedResponse<DocenteModel>.fromJson(data, (json) => DocenteModel.fromJson(json)));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar docentes paginados', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<DocenteModel>> getDocenteById({required String databaseId, required String docenteId}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getDocente(idBancoDeDados: databaseId, idDocente: docenteId),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => DocenteModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar docente por ID', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<DocenteModel>> createDocente({required DocenteModel docente}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.setDocente(idBancoDeDados: '1'),
            metodo: MetodoHttp.post,
            body: docente.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => DocenteModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao criar docente', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<DocenteModel>> updateDocente({required DocenteModel docente}) async {
    try {
      final response = await _apiClient
          .request(
            url: Urls.atualizarDocente(
              idBancoDeDados: '1',
              idDocente: docente.id.toString(),
            ),
            metodo: MetodoHttp.put,
            body: docente.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => DocenteModel.fromJson(data));
      return response;
    } catch (e, s) {
      AppLogger.error('Erro ao atualizar docente', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteDocente({required int docenteId}) async {
    try {
      return await _apiClient.request(
        url: Urls.deletarDocente(idBancoDeDados: '1', idDocente: '$docenteId'),
        metodo: MetodoHttp.delete,
        headers: Urls.bearerHeader,
      );
    } catch (e, s) {
      AppLogger.error('Erro ao deletar docente', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
}
