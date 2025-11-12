import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import '../../../domain/models/documento_base64/documento_base64_model.dart';
import '../../../utils/result.dart';
import 'documento_base64_repository.dart';

/// Implementação concreta do DocumentoBase64Repository usando API
///
/// Esta implementação utiliza o ApiClient para realizar requisições HTTP
/// e buscar documentos Base64 do servidor.
class DocumentoBase64RepositoryImpl implements DocumentoBase64Repository {
  DocumentoBase64RepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<DocumentoBase64Model>> getDocumentoBase64({
    required String databaseId,
    required String alunoId,
    required TipoDocumentoBase64 nomeDocumento,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getDocumentoBase64(
              idBancoDeDados: databaseId,
              alunoId: alunoId,
              nomeDocumento: nomeDocumento,
            ),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => DocumentoBase64Model.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro de serialização', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }
}
