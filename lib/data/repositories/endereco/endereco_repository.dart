
import 'package:sentinela/data/services/api/api_client/api_model/endereco_api_model.dart';
import 'package:sentinela/utils/result.dart';

abstract interface class EnderecoRepository {
  Future<Result<EnderecoApiModel>> buscarEndereco({required String cep});
}