import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/ies_emissora_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import 'package:w3_diploma/utils/result.dart';
import 'ies_emissora_repository.dart';

class IesEmissoraRepositoryImpl implements IesEmissoraRepository {
  IesEmissoraRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<IesEmissoraModel>> getAllIesEmissoras() async {
    try {
      final resultado = await _apiClient.request(url: Urls.getIESEmissoras(idBancoDeDados: '1'), metodo: MetodoHttp.get, headers: Urls.bearerHeader)
          .map((resultado) => resultado as List)
          .map((dados) => dados.first as Map<String, dynamic>)
          .map((dado) => IesEmissoraModel.fromJson(dado));
          return resultado;
    } catch (e, s) {
      AppLogger.error('Erro ao buscar IES Emissoras paginadas', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<IesEmissoraModel>> getIesEmissoraById({required String databaseId, required String iesEmissoraId}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getIESEmissora(idBancoDeDados: databaseId, idIESEmissora: iesEmissoraId),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => IesEmissoraModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar IES Emissora por ID', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<IesEmissoraModel>> createIesEmissora({required IesEmissoraModel iesEmissora}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.setIESEmissora(idBancoDeDados: '1'),
            metodo: MetodoHttp.post,
            body: iesEmissora.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => IesEmissoraModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao criar IES Emissora', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<IesEmissoraModel>> updateIesEmissora({required IesEmissoraModel iesEmissora}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.atualizarIESEmissora(
              idBancoDeDados: '1',
              idIESEmissora: iesEmissora.iesEmissoraID.toString(),
            ),
            metodo: MetodoHttp.put,
            body: iesEmissora.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => IesEmissoraModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao atualizar IES Emissora', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteIesEmissora({required int iesEmissoraId}) async {
    try {
      return await _apiClient.request(
        url: Urls.deletarIESEmissora(idBancoDeDados: '1', idIESEmissora: '$iesEmissoraId'),
        metodo: MetodoHttp.delete,
        headers: Urls.bearerHeader,
      );
    } catch (e, s) {
      AppLogger.error('Erro ao deletar IES Emissora', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
}
