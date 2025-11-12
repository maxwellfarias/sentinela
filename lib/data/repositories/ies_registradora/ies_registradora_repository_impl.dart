import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/repositories/ies_registradora/ies_registradora_repository.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/ies_registradora.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import 'package:w3_diploma/utils/result.dart';

/// Implementação do repositório de IESRegistradora usando dados mock
///
/// Esta implementação usa a classe IESRegistradoraMock para simular
/// operações de persistência com delay de 2 segundos.
class IESRegistradoraRepositoryImpl implements IESRegistradoraRepository {
  IESRegistradoraRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<List<IESRegistradoraModel>>> getAllIESRegistradoras({required String databaseId}) async {
    try{
      return await _apiClient.request(url: Urls.getIESRegistradoras(idBancoDeDados: databaseId), metodo: MetodoHttp.get)
      .map((dados) => (dados as List)
      .map((item) => IESRegistradoraModel.fromJson(item))
      .toList());

    } catch (e, s) {
      AppLogger.error("Erro ao serealizar lista de IES Registradoras", error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<IESRegistradoraModel>> getIESRegistradoraBy({required String databaseId, required int iesRegistradoraId}) async {
    try{
      return await _apiClient.request(url: Urls.getIESRegistradora(idBancoDeDados: databaseId, idIESRegistradora: iesRegistradoraId.toString()), metodo: MetodoHttp.get)
      .map((dados) => IESRegistradoraModel.fromJson(dados));
    } catch (e, s) {
      AppLogger.error("Erro ao serealizar IES Registradora", error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<IESRegistradoraModel>> createIESRegistradora({required String databaseId, required IESRegistradoraModel iesRegistradora}) async {
    try {
      final json = iesRegistradora.toJson()..remove('iesRegistradoraId');
      return await _apiClient.request(url: Urls.setIESRegistradora(idBancoDeDados: databaseId), metodo: MetodoHttp.post, body: json)
      .map(IESRegistradoraModel.fromJson);
    } catch (e, s) {
      AppLogger.error("Erro ao criar IES Registradora", error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<IESRegistradoraModel>> updateIESRegistradora({required String databaseId, required IESRegistradoraModel iesRegistradora}) async {
    try {
      return await _apiClient.request(url: Urls.atualizarIESRegistradora(idBancoDeDados: databaseId, idIESRegistradora: iesRegistradora.iesRegistradoraID.toString()), metodo: MetodoHttp.put, body: iesRegistradora.toJson())
      .map(IESRegistradoraModel.fromJson);
    } catch (e, s) {
      AppLogger.error("Erro ao atualizar IES Registradora", error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteIESRegistradora({required String databaseId, required int iesRegistradoraId}) async {
    try {
      return await _apiClient.request(url: Urls.deletarIESRegistradora(idBancoDeDados: databaseId, idIESRegistradora: iesRegistradoraId.toString()), metodo: MetodoHttp.delete);
    } catch (e, s) {
      AppLogger.error("Erro ao deletar IES Registradora", error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
}
