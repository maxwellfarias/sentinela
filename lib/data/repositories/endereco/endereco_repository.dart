
import 'package:w3_diploma/data/services/api_client/api_model/endereco_api_model.dart';
import 'package:w3_diploma/utils/result.dart';

abstract interface class EnderecoRepository {
  Future<Result<EnderecoApiModel>> buscarEndereco({required String cep});
}