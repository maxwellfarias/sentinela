import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/repositories/consolidated_data/consolidated_data_repository.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/consolidated_data/consolidated_data.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import 'package:w3_diploma/utils/result.dart';

class ConsolidatedDataRepositoryImpl implements ConsolidatedDataRepository {
  ConsolidatedDataRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<List<ConsolidatedData>>> getConsolidatedDataByTurma({
    required int turmaId,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getDadosCompletosPorTurma(
              idBancoDeDados: '1',
              turmaId: '$turmaId',
            ),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => (data as List)
              .map((e) => ConsolidatedData.fromJson(e as Map<String, dynamic>))
              .toList());
    } catch (e, s) {
      AppLogger.error('Erro ao buscar dados consolidados por turma',
          error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
}
