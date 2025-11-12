
import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/repositories/endereco/endereco_repository.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/data/services/api_client/api_model/endereco_api_model.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import 'package:w3_diploma/utils/result.dart';

final class EnderecoRepositoryImpl implements EnderecoRepository {
  final ApiClient _apiClient;

  EnderecoRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Result<EnderecoApiModel>> buscarEndereco({required String cep}) async {
    try {
      return await _apiClient.request(url: Urls.buscarCepApi(cep: cep), metodo: MetodoHttp.get, headers: {})
      .flatMap(_verificarRespostaComErro)
      .map(EnderecoApiModel.fromJson);
    } catch (e, s) {
      AppLogger.error('Erro de serialização: $cep - Erro: $e', tag: 'EnderecoRepository', stackTrace: s, error: e);
      return Result.error(ErroDeComunicacaoException());
    }
  }
  Result<Map<String, dynamic>> _verificarRespostaComErro(dynamic resposta) {
    if (resposta.containsKey('erro')) {
      AppLogger.warning('CEP não encontrado na API: $resposta', tag: 'EnderecoRepository');
      return Result.error(CepNaoEncontradoException());
    }
    return Result.ok(resposta);
  }
}