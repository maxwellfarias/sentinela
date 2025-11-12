import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/repositories/aluno/aluno_repository_impl.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/registro_diploma/registro_diploma_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import '../../../utils/result.dart';
import 'registro_diploma_repository.dart';

class RegistroDiplomaRepositoryImpl implements RegistroDiplomaRepository {
  RegistroDiplomaRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<PaginatedResponse<RegistroDiplomaModel>>> getAllRegistrosDiplomas({
    QueryParams? params,
  }) async {
    try {
      // Usa parâmetros padrão se não fornecidos
      final queryParams = params ?? const QueryParams();

      // Constrói a URL com query string
      final baseUrl = Urls.getRegistrosDiplomas(id: '1');
      final queryString = queryParams.toQueryString();
      final fullUrl = '$baseUrl?$queryString';

      return await _apiClient
          .request(
            url: fullUrl,
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => PaginatedResponse<RegistroDiplomaModel>.fromJson(
                data,
                (json) => RegistroDiplomaModel.fromJson(json),
              ));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar registros de diploma paginados', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<RegistroDiplomaModel>> getRegistroDiplomaById({
    required String databaseId,
    required String registroDiplomaId,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getRegistroDiploma(
              idBancoDeDados: databaseId,
              idRegistroDiploma: registroDiplomaId,
            ),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => RegistroDiplomaModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar registro de diploma por ID', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<RegistroDiplomaModel>> createRegistroDiploma({
    required RegistroDiplomaModel registroDiploma,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.setRegistroDiploma(idBancoDeDados: '1'),
            metodo: MetodoHttp.post,
            body: registroDiploma.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => RegistroDiplomaModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao criar registro de diploma', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<RegistroDiplomaModel>> updateRegistroDiploma({
    required RegistroDiplomaModel registroDiploma,
  }) async {
    try {
      return await _apiClient
          .request(
            url: Urls.atualizarRegistroDiploma(
              idBancoDeDados: '1',
              idRegistroDiploma: registroDiploma.registroDiplomaID.toString(),
            ),
            metodo: MetodoHttp.put,
            body: registroDiploma.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => RegistroDiplomaModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao atualizar registro de diploma', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteRegistroDiploma({
    required int registroDiplomaId,
  }) async {
    try {
      return await _apiClient.request(
        url: Urls.deletarRegistroDiploma(
          idBancoDeDados: '1',
          idRegistroDiploma: registroDiplomaId.toString(),
        ),
        metodo: MetodoHttp.delete,
        headers: Urls.bearerHeader,
      );
    } catch (e, s) {
      AppLogger.error('Erro ao deletar registro de diploma', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<RegistroDiplomaModel>>> getRegistrosDiplomasByAluno({
    required int alunoId,
  }) async {
    try {
      // Retorna dados fictícios para desenvolvimento
      final registrosFicticios = _gerarRegistrosDiplomasFicticios(alunoId);
      return Result.ok(registrosFicticios);
        // Nota: Esta rota precisa ser implementada no backend
      // Por enquanto, usamos a rota geral e filtramos no client se necessário
      // final result = await getAllRegistrosDiplomas();
      
      // if (result.isOk) {
      //   final paginatedResponse = (result as Ok<PaginatedResponse<RegistroDiplomaModel>>).value;
      //   final filteredData = paginatedResponse.data
      //       .where((registro) => registro.alunoID == alunoId)
      //       .toList();
      //   return Result.ok(filteredData);
      // } else {
      //   final error = (result as Error<PaginatedResponse<RegistroDiplomaModel>>).error;
      //   return Result.error(error);
      // }
    } catch (e, s) {
      AppLogger.error('Erro ao buscar registros de diploma por aluno', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  /// Gera registros de diploma fictícios para testes e desenvolvimento
  List<RegistroDiplomaModel> _gerarRegistrosDiplomasFicticios(int alunoId) {
    final now = DateTime.now();

    // Busca o nome do aluno nos dados fictícios
    String alunoNome = 'Aluno Exemplo';
    try {
      final aluno = gerarAlunosFicticios().data.where((aluno) => aluno.alunoID == alunoId).first;
      alunoNome = aluno.nome;
    } catch (e) {
      // Se não encontrar, usa nome padrão
    }

    return [
      RegistroDiplomaModel(
        registroDiplomaID: 1,
        alunoID: alunoId,
        alunoNome: alunoNome,
        dataConclusaoCurso: DateTime(2023, 12, 15),
        dataColacaoGrauDiploma: DateTime(2024, 2, 20),
        registroConclusao: 'RC-2024-001',
        livroRegistro: 'Livro 05',
        paginaRegistro: '123',
        numeroProcessoRegistroDiploma: '2024.1.001.000001',
        instituicaoDiploma: 'Universidade Federal de Exemplo',
        dataEmissaoDiploma: DateTime(2024, 3, 10),
        dataRegistroDiploma: DateTime(2024, 3, 15),
        dataPublicacaoDou: DateTime(2024, 3, 20),
        localizacaoFisicaPasta: 'Arquivo Central - Prédio A - Sala 102 - Estante 5',
        responsavelRegistroNome: 'Maria Oliveira Santos',
        responsavelRegistroCpf: '123.456.789-00',
        responsavelRegistroIdOuNumeroMatricula: 'REG-2024-001',
        codigoValidacao: 'ABCD-1234-EFGH-5678',
        numeroFolhaDiploma: 'F-2024-001',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      RegistroDiplomaModel(
        registroDiplomaID: 2,
        alunoID: alunoId,
        alunoNome: alunoNome,
        dataConclusaoCurso: DateTime(2022, 6, 30),
        dataColacaoGrauDiploma: DateTime(2022, 8, 15),
        registroConclusao: 'RC-2022-042',
        livroRegistro: 'Livro 03',
        paginaRegistro: '456',
        numeroProcessoRegistroDiploma: '2022.2.005.000042',
        instituicaoDiploma: 'Instituto Federal de Tecnologia',
        dataEmissaoDiploma: DateTime(2022, 9, 5),
        dataRegistroDiploma: DateTime(2022, 9, 10),
        dataPublicacaoDou: DateTime(2022, 9, 15),
        localizacaoFisicaPasta: 'Arquivo Central - Prédio B - Sala 205 - Estante 3',
        responsavelRegistroNome: 'Carlos Alberto Pereira',
        responsavelRegistroCpf: '987.654.321-00',
        responsavelRegistroIdOuNumeroMatricula: 'REG-2022-042',
        codigoValidacao: 'WXYZ-9876-IJKL-5432',
        numeroFolhaDiploma: 'F-2022-042',
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now.subtract(const Duration(days: 180)),
      ),
      RegistroDiplomaModel(
        registroDiplomaID: 3,
        alunoID: alunoId,
        alunoNome: alunoNome,
        dataConclusaoCurso: DateTime(2021, 12, 20),
        dataColacaoGrauDiploma: DateTime(2022, 2, 10),
        registroConclusao: 'RC-2022-015',
        livroRegistro: 'Livro 02',
        paginaRegistro: '789',
        numeroProcessoRegistroDiploma: '2022.1.003.000015',
        instituicaoDiploma: 'Faculdade de Ciências Aplicadas',
        dataEmissaoDiploma: DateTime(2022, 3, 1),
        dataRegistroDiploma: DateTime(2022, 3, 5),
        dataPublicacaoDou: DateTime(2022, 3, 10),
        localizacaoFisicaPasta: 'Arquivo Central - Prédio A - Sala 101 - Estante 2',
        responsavelRegistroNome: 'Ana Paula Rodrigues',
        responsavelRegistroCpf: '456.789.123-00',
        responsavelRegistroIdOuNumeroMatricula: 'REG-2022-015',
        codigoValidacao: 'MNOP-4567-QRST-8901',
        numeroFolhaDiploma: 'F-2022-015',
        createdAt: now.subtract(const Duration(days: 730)),
        updatedAt: now.subtract(const Duration(days: 365)),
      ),
    ];
  }
}
