import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/curso/curso_model.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import 'package:w3_diploma/utils/result.dart';
import 'curso_repository.dart';

class CursoRepositoryImpl implements CursoRepository {
  CursoRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<PaginatedResponse<CursoModel>>> getAllCursos({QueryParams? params}) async {
    try {
      // return Result.ok(getMockCursosPaginated());
      // Usa parâmetros padrão se não fornecidos
      final queryParams = params ?? const QueryParams();

      // Constrói a URL com query string
      final baseUrl = Urls.getCursos(id: '1');
      final queryString = queryParams.toQueryString();
      final fullUrl = '$baseUrl?$queryString';

      return await _apiClient
          .request(
            url: fullUrl,
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => PaginatedResponse<CursoModel>.fromJson(
                data,
                (json) => CursoModel.fromJson(json),
              ));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar cursos paginados', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<CursoModel>> getCursoById({required String databaseId, required String cursoId}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getCurso(idBancoDeDados: databaseId, idCurso: cursoId),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => CursoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar curso por ID', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<CursoModel>> createCurso({required CursoModel curso}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.setCurso(idBancoDeDados: '1'),
            metodo: MetodoHttp.post,
            body: curso.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => CursoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao criar curso', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<CursoModel>> updateCurso({required CursoModel curso}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.atualizarCurso(
              idBancoDeDados: '1',
              idCurso: curso.cursoID.toString(),
            ),
            metodo: MetodoHttp.put,
            body: curso.toJson(),
            headers: Urls.bearerHeader,
          )
          .map((data) => CursoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro ao atualizar curso', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteCurso({required int cursoId}) async {
    try {
      return await _apiClient.request(
        url: Urls.deletarCurso(idBancoDeDados: '1', idCurso: '$cursoId'),
        metodo: MetodoHttp.delete,
        headers: Urls.bearerHeader,
      );
    } catch (e, s) {
      AppLogger.error('Erro ao deletar curso', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<CursoModel>>> getCursosByIesEmissora({required int iesEmissoraId}) async {
    try {
      return await _apiClient
          .request(
            url: Urls.getCursos(id: '1'),
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => (data as List)
              .map((e) => CursoModel.fromJson(e))
              .where((curso) => curso.iesEmissoraID == iesEmissoraId)
              .toList());
    } catch (e, s) {
      AppLogger.error('Erro ao buscar cursos por IES Emissora', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  /// Retorna uma resposta paginada contendo 50 cursos fictícios para testes
  ///
  /// Cursos com IDs de 1 a 50, distribuídos entre 10 IES Emissoras (IDs 1-10)
  PaginatedResponse<CursoModel> getMockCursosPaginated() {
    final List<CursoModel> cursosFicticios = List.generate(50, (index) {
      final cursoId = index + 1;
      final modalidades = ['Presencial', 'EAD', 'Semipresencial'];
      final graus = ['Bacharelado', 'Licenciatura', 'Tecnólogo'];
      final ufs = ['SP', 'RJ', 'MG', 'RS', 'PR', 'SC', 'BA', 'PE', 'CE', 'GO'];
      final tiposAutorizacao = ['Portaria', 'Decreto', 'Resolução'];

      return CursoModel(
        cursoID: cursoId,
        iesEmissoraID: ((cursoId - 1) % 10) + 1, // Distribui entre IES 1-10
        nomeCurso: 'Curso de Teste $cursoId',
        nomeIesEmissora: 'Instituição ${(cursoId % 10) + 1}',
        codigoCursoEMEC: 1000000 + cursoId,
        modalidade: modalidades[cursoId % modalidades.length],
        grauConferido: graus[cursoId % graus.length],
        logradouro: 'Rua Teste, ${cursoId * 10}',
        bairro: 'Bairro ${cursoId % 5 + 1}',
        codigoMunicipio: '${3500000 + cursoId}',
        nomeMunicipio: 'Município ${cursoId % 20 + 1}',
        uf: ufs[cursoId % ufs.length],
        cep: '${10000000 + cursoId * 100}',
        autorizacaoTipo: tiposAutorizacao[cursoId % tiposAutorizacao.length],
        autorizacaoNumero: '${1000 + cursoId}',
        autorizacaoData: DateTime(2020 + (cursoId % 5), (cursoId % 12) + 1, (cursoId % 28) + 1),
        reconhecimentoTipo: tiposAutorizacao[(cursoId + 1) % tiposAutorizacao.length],
        reconhecimentoNumero: '${2000 + cursoId}',
        reconhecimentoData: DateTime(2021 + (cursoId % 4), (cursoId % 12) + 1, (cursoId % 28) + 1),
        numeroProcesso: cursoId % 3 == 0 ? '${23000000000 + cursoId}' : null,
        tipoProcesso: cursoId % 3 == 0 ? 'Processo Tipo ${cursoId % 3 + 1}' : null,
        dataCadastro: DateTime.now().subtract(Duration(days: 365 - cursoId * 7)),
        dataProtocolo: cursoId % 2 == 0
            ? DateTime.now().subtract(Duration(days: 365 - cursoId * 7 + 5))
            : null,
        createdAt: DateTime.now().subtract(Duration(days: 400 - cursoId * 8)),
        updatedAt: DateTime.now().subtract(Duration(days: cursoId)),
      );
    });

    return PaginatedResponse<CursoModel>(
      data: cursosFicticios,
      page: 1,
      pageSize: 50,
      totalRecords: 50,
      totalPages: 1,
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }
}


