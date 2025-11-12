import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/domain/models/documento_base64/documento_base64_model.dart';
import 'package:w3_diploma/utils/result.dart';

/// Interface que define as opera��es de busca de documentos em Base64
///
/// Esta interface estabelece o contrato para acesso a documentos
/// armazenados em formato Base64 associados a alunos.
abstract interface class DocumentoBase64Repository {
  /// Busca um documento Base64 espec�fico de um aluno
  ///
  /// Par�metros:
  /// - [databaseId]: ID do banco de dados
  /// - [alunoId]: ID do aluno propriet�rio do documento
  /// - [nomeDocumento]: Tipo do documento a ser buscado
  ///
  /// Retorna um [Result] contendo o [DocumentoBase64Model] ou um erro
  Future<Result<DocumentoBase64Model>> getDocumentoBase64({
    required String databaseId,
    required String alunoId,
    required TipoDocumentoBase64 nomeDocumento,
  });
}
