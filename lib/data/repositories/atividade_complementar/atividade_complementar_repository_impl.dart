import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/atividade_complementar/atividade_complementar_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import 'package:w3_diploma/utils/result.dart';
import 'atividade_complementar_repository.dart';

class AtividadeComplementarRepositoryImpl implements AtividadeComplementarRepository {
  AtividadeComplementarRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<PaginatedResponse<AtividadeComplementarModel>>> getAllAtividadesComplementares({
    QueryParams? params,
  }) async {
    try {
      // Usa parâmetros padrão se não fornecidos
      final queryParams = params ?? const QueryParams();

      // Constrói a URL com query string
      final baseUrl = Urls.getAtividadesComplementares(id: '1');
      final queryString = queryParams.toQueryString();
      final fullUrl = '$baseUrl?$queryString';

      return await _apiClient
          .request(
            url: fullUrl,
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => PaginatedResponse<AtividadeComplementarModel>.fromJson(
                data,
                (json) => AtividadeComplementarModel.fromJson(json),
              ));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar atividades complementares paginadas', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<AtividadeComplementarModel>> getAtividadeComplementarById({
    required String databaseId,
    required String atividadeComplementarId,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getAtividadeComplementar(
              idBancoDeDados: databaseId,
              idAtividadeComplementar: atividadeComplementarId,
            ),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => AtividadeComplementarModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar atividade complementar por ID', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<AtividadeComplementarModel>> createAtividadeComplementar({
    required AtividadeComplementarModel atividadeComplementar,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.setAtividadeComplementar(idBancoDeDados: '1'),
            metodo: MetodoHttp.post,
            body: atividadeComplementar.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => AtividadeComplementarModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao criar atividade complementar', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<AtividadeComplementarModel>> updateAtividadeComplementar({
    required AtividadeComplementarModel atividadeComplementar,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.atualizarAtividadeComplementar(
              idBancoDeDados: '1',
              idAtividadeComplementar: atividadeComplementar.atividadeComplementarID.toString(),
            ),
            metodo: MetodoHttp.put,
            body: atividadeComplementar.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => AtividadeComplementarModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao atualizar atividade complementar', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteAtividadeComplementar({
    required int atividadeComplementarId,
  }) async {
    try {
      return await _apiClient.request(
        url: Urls.deletarAtividadeComplementar(
          idBancoDeDados: '1',
          idAtividadeComplementar: '$atividadeComplementarId',
        ),
        metodo: MetodoHttp.delete,
        headers: Urls.bearerHeader,
      );
    } catch (e, s) {
      AppLogger.error('Erro ao deletar atividade complementar', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<AtividadeComplementarModel>>> getAtividadesComplementaresByAluno({
    required int alunoId,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getAtividadeComplementar(
              idBancoDeDados: '1',
              idAtividadeComplementar: '$alunoId',
            ),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => (data as List)
              .map((e) => AtividadeComplementarModel.fromJson(e))
              .toList());
    } catch (e, s) {
      AppLogger.error('Erro ao buscar atividades complementares por aluno', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
}
