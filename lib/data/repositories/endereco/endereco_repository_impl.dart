import 'package:sentinela/data/repositories/endereco/endereco_repository.dart';
import 'package:sentinela/data/services/api/api_client/api_client/api_client.dart';
import 'package:sentinela/data/services/api/api_client/api_model/endereco_api_model.dart';
import 'package:sentinela/utils/result.dart';

final class EnderecoRepositoryImpl implements EnderecoRepository {
  final ApiClient _apiClient;

  EnderecoRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<EnderecoApiModel>> buscarEndereco({required String cep}) async {
    return Result.ok(EnderecoApiModel(
      cep: '01001-000',
      logradouro: 'Praça da Sé',
      codigoMunicipio: '3550308',
      bairro: 'Sé',
      localidade: 'São Paulo',
      uf: 'SP',
      estado: cep
    ));
  }
}
