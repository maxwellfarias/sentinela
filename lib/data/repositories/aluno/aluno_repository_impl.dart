import 'package:w3_diploma/config/constants/urls.dart';
import 'package:w3_diploma/data/services/api_client/api_client/api_client.dart';
import 'package:w3_diploma/domain/models/aluno/aluno_dto.dart';
import 'package:w3_diploma/domain/models/pagination/paginated_response.dart';
import 'package:w3_diploma/domain/models/pagination/query_params.dart';
import 'package:w3_diploma/exceptions/app_exception.dart';
import 'package:w3_diploma/utils/app_logger.dart';
import '../../../domain/models/aluno/aluno_model.dart';
import '../../../utils/result.dart';
import 'aluno_repository.dart';

class AlunoRepositoryImpl implements AlunoRepository {
  AlunoRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  final ApiClient _apiClient;

  @override
  Future<Result<PaginatedResponse<AlunoModel>>> getAllAlunos({QueryParams? params}) async {
    try {
      // return Result.ok(generateFakeAlunosResponse());
      // Usa parâmetros padrão se não fornecidos
      final queryParams = params ?? const QueryParams();

      // Constrói a URL com query string
      final baseUrl = Urls.getAlunos(id: '1');
      final queryString = queryParams.toQueryString();
      final fullUrl = '$baseUrl?$queryString';

      return await _apiClient
          .request(
            url: fullUrl,
            metodo: MetodoHttp.get,
            headers: Urls.bearerHeader,
          )
          .map((data) => PaginatedResponse<AlunoModel>.fromJson(
                data,
                (json) => AlunoModel.fromJson(json),
              ));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar alunos paginados', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<AlunoModel>> getAlunoById({required String databaseId, required String alunoId}) async {
    try{
    return await _apiClient.request(url: Urls.getAluno(idBancoDeDados: databaseId, idAluno: alunoId), metodo: MetodoHttp.get, headers: Urls.bearerHeader)
    .map((data) => AlunoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro de serialização', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<AlunoModel>> createAluno({required AlunoDto aluno}) async {
    try{
    return await _apiClient.request(url: Urls.setAluno(idBancoDeDados: '1'), metodo: MetodoHttp.post, body: aluno.toJson(), headers: Urls.bearerHeader)
    .map((data) => AlunoModel.fromJson(data));
    } catch (e, s) {
      AppLogger.error('Erro de serialização', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<AlunoModel>> updateAluno({required AlunoDto aluno}) async {
    try{
    final respose =  await _apiClient.request(url: Urls.atualizarAluno(idBancoDeDados: '1', idAluno: aluno.alunoID.toString()), metodo: MetodoHttp.put, body: aluno.toJson(), headers: Urls.bearerHeader)
    .map((data) => AlunoModel.fromJson(data));
    return respose;
    } catch (e, s) {
      AppLogger.error('Erro de serialização', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteAluno({required int alunoId}) async {
    return await _apiClient.request(url: Urls.deletarAluno(idBancoDeDados: '1', idAluno: '$alunoId'), metodo: MetodoHttp.delete, headers: Urls.bearerHeader); 
  }

  @override
  Future<Result<PaginatedResponse<AlunoModel>>> getAlunosByTurma({
    required int turmaId,
    QueryParams? params,
  }) async {
    try {
      // Usa parâmetros padrão se não fornecidos
      final queryParams = params ?? const QueryParams();

      // Constrói a URL com query string
      final baseUrl = Urls.getAlunosByTurma(idBancoDeDados: '1', turmaId: '$turmaId');
      final queryString = queryParams.toQueryString();
      final fullUrl = '$baseUrl?$queryString';

      final response =  await _apiClient
          .request(url: fullUrl, metodo: MetodoHttp.get, headers: Urls.bearerHeader)
          .map((data) => PaginatedResponse<AlunoModel>.fromJson(data,(json) => AlunoModel.fromJson(json)));
          return response;
    } catch (e, s) {
      AppLogger.error('Erro ao buscar alunos por turma', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<PaginatedResponse<AlunoModel>>> getAlunosByTurmaPaginated({
    required int turmaId,
    QueryParams? params,
  }) async {
    try {
      // Gera dados fictícios filtrando por turmaId
      return Result.ok(generateFakeAlunosResponse());

      // Implementação real comentada para quando a API estiver disponível:
      // final queryParams = params ?? const QueryParams();
      // final baseUrl = Urls.getAlunosByTurma(idBancoDeDados: '1', turmaId: '$turmaId');
      // final queryString = queryParams.toQueryString();
      // final fullUrl = '$baseUrl?$queryString';
      //
      // return await _apiClient
      //     .request(
      //       url: fullUrl,
      //       metodo: MetodoHttp.get,
      //       headers: Urls.bearerHeader,
      //     )
      //     .map((data) => PaginatedResponse<AlunoModel>.fromJson(
      //           data,
      //           (json) => AlunoModel.fromJson(json),
      //         ));
    } catch (e, s) {
      AppLogger.error('Erro ao buscar alunos por turma paginados', error: e, stackTrace: s);
      return Result.error(UnknownErrorException());
    }
  }

  /// Gera dados fictícios de alunos para testes/desenvolvimento
  ///
  /// Distribui alunos entre as 50 turmas existentes (IDs 1-50)
  PaginatedResponse<AlunoModel> generateFakeAlunosResponse({
    int page = 1,
    int pageSize = 10,
  }) {
    final List<AlunoModel> fakeAlunos = gerarAlunosFicticios().data;

    const totalRecords = 47; // Total fictício
    final totalPages = (totalRecords / pageSize).ceil();

    return PaginatedResponse<AlunoModel>(
      data: fakeAlunos,
      page: page,
      pageSize: pageSize,
      totalRecords: totalRecords,
      totalPages: totalPages,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
    );
  }

  /// Gera uma resposta paginada com dados fictícios de múltiplos alunos
  ///
  /// Retorna uma lista com 50 alunos fictícios distribuídos entre as 50 turmas existentes (IDs 1-50),
  /// com variações em sexo, nacionalidade, estado civil e situação acadêmica.
  
}


PaginatedResponse<AlunoModel> gerarAlunosFicticios() {
    final now = DateTime.now();

    final List<String> nomes = [
      'Ana Silva Santos', 'Bruno Costa Lima', 'Carla Oliveira Souza',
      'Daniel Pereira Alves', 'Eduarda Rodrigues Martins', 'Felipe Santos Ferreira',
      'Gabriela Lima Costa', 'Henrique Alves Ribeiro', 'Isabela Martins Carvalho',
      'João Ferreira Gomes', 'Karina Souza Dias', 'Lucas Ribeiro Cardoso',
      'Mariana Carvalho Rocha', 'Nicolas Gomes Barbosa', 'Olivia Dias Fernandes',
      'Paulo Cardoso Correia', 'Quésia Rocha Teixeira', 'Rafael Barbosa Araújo',
      'Sofia Fernandes Pinto', 'Thiago Correia Monteiro', 'Ursula Teixeira Castro',
      'Vinicius Araújo Duarte', 'Wanda Pinto Cavalcanti', 'Xavier Monteiro Rezende',
      'Yasmin Castro Melo', 'Zilda Duarte Sampaio', 'Arthur Cavalcanti Nogueira',
      'Beatriz Rezende Freitas', 'Caio Melo Barros', 'Débora Sampaio Cunha',
      'Erick Nogueira Pires', 'Fernanda Freitas Moura', 'Gustavo Barros Campos',
      'Helena Cunha Azevedo', 'Igor Pires Caldeira', 'Júlia Moura Viana',
      'Kevin Campos Lopes', 'Larissa Azevedo Machado', 'Matheus Caldeira Nunes',
      'Natália Viana Tavares', 'Otávio Lopes Mendes', 'Priscila Machado Porto',
      'Quintino Nunes Farias', 'Renata Tavares Xavier', 'Samuel Mendes Guerra',
      'Tatiana Porto Siqueira', 'Ulisses Farias Braga', 'Valentina Xavier Moraes',
      'Wagner Guerra Leite', 'Ximena Siqueira Ramos'
    ];

    final List<String> municipios = [
      'São Paulo', 'Rio de Janeiro', 'Belo Horizonte', 'Brasília', 'Salvador',
      'Fortaleza', 'Curitiba', 'Recife', 'Porto Alegre', 'Manaus'
    ];

    final List<String> ufs = [
      'SP', 'RJ', 'MG', 'DF', 'BA', 'CE', 'PR', 'PE', 'RS', 'AM'
    ];

    final List<int> codigosMunicipio = [
      3550308, 3304557, 3106200, 5300108, 2927408,
      2304400, 4106902, 2611606, 4314902, 1302603
    ];

    final List<AlunoModel> alunosFicticios = List.generate(
      50,
      (index) {
        final municipioIndex = index % municipios.length;
        final sexo = index % 2 == 0 ? 'M' : 'F';
        final turmaId = index <= 25 ? 1 : 2; // Distribui entre as turmas 1 e 2
        final anoNascimento = 1990 + (index % 15); // Nascidos entre 1990 e 2004
        final mesNascimento = 1 + (index % 12);
        final diaNascimento = 1 + (index % 28);
        
        // Varia a situação do vínculo
        String situacaoVinculo;
        DateTime? dataConclusao;
        DateTime? dataColacao;
        DateTime? dataExpedicao;
        String? periodoLetivo;
        
        if (index % 5 == 0) {
          situacaoVinculo = 'Concluído';
          dataConclusao = DateTime(2024, 12, 15);
          dataColacao = DateTime(2024, 12, 20);
          dataExpedicao = DateTime(2025, 1, 10);
          periodoLetivo = null;
        } else if (index % 5 == 1) {
          situacaoVinculo = 'Formando';
          dataConclusao = null;
          dataColacao = null;
          dataExpedicao = null;
          periodoLetivo = '2025/1';
        } else if (index % 5 == 2) {
          situacaoVinculo = 'Trancado';
          dataConclusao = null;
          dataColacao = null;
          dataExpedicao = null;
          periodoLetivo = null;
        } else if (index % 5 == 3) {
          situacaoVinculo = 'Jubilado';
          dataConclusao = null;
          dataColacao = null;
          dataExpedicao = null;
          periodoLetivo = null;
        } else {
          situacaoVinculo = 'Ativo';
          dataConclusao = null;
          dataColacao = null;
          dataExpedicao = null;
          periodoLetivo = '2025/1';
        }

        return AlunoModel(
          alunoID: index + 1,
          turmaID: turmaId,
          nome: nomes[index],
          sexo: sexo,
          nacionalidade: index % 10 == 0 ? 'Estrangeira' : 'Brasileira',
          cep: '${(10000 + index * 100).toString().padLeft(5, '0')}-${(index % 1000).toString().padLeft(3, '0')}',
          logradouro: 'Rua ${['das Flores', 'do Comércio', 'Principal', 'Central', 'da Paz'][index % 5]}, ${100 + index}',
          codigoMunicipio: codigosMunicipio[municipioIndex],
          nomeMunicipio: municipios[municipioIndex],
          uf: ufs[municipioIndex],
          cpf: '${(100 + index).toString().padLeft(3, '0')}.${(200 + index).toString().padLeft(3, '0')}.${(300 + index).toString().padLeft(3, '0')}-${((10 + index) % 100).toString().padLeft(2, '0')}',
          rgNumero: (10000000 + index * 1000).toString(),
          rgOrgaoExpedidor: ['SSP', 'DETRAN', 'PC', 'IFP'][index % 4],
          rgUf: ufs[municipioIndex],
          dataNascimento: DateTime(anoNascimento, mesNascimento, diaNascimento),
          filiacaoMaeNome: index % 7 != 0 ? 'Maria ${nomes[index].split(' ').last}' : null,
          filiacaoPaiNome: index % 11 != 0 ? 'José ${nomes[index].split(' ').last}' : null,
          dataMatricula: DateTime(2018 + (index % 7), 1 + (index % 2) * 6, 1),
          dataConclusaoCurso: dataConclusao ?? DateTime.now(),
          dataColacaoGrau: dataColacao ?? DateTime.now(),
          dataExpedicaoDiploma: dataExpedicao ?? DateTime.now(),
          situacaoVinculo: situacaoVinculo,
          estaSalvoBase64DocumentoIdentidade: index % 2 == 0,
          estaSalvoBase64ProvaConclusaoEnsinoMedio: index % 3 == 0,
          estaSalvoBase64ProvaColacao: index % 4 == 0,
          estaSalvoBase64ComprovacaoEstagioCurricular: index % 5 == 0,
          estaSalvoBase64CertidaoNascimento: index % 2 == 0,
          estaSalvoBase64CertidaoCasamento: index % 7 == 0,
          estaSalvoBase64TituloEleitor: index % 3 == 0,
          estaSalvoBase64AtoNaturalizacao: index % 10 == 0,
          estaSalvoBase64Gru: index % 4 == 0,
          estaSalvoBase64CertificadoConclusaoEnsinoSuperior: index % 5 == 0,
          estaSalvoBase64OficioEncaminhamento: index % 6 == 0,
          estaSalvoBase64TermoResponsabilidade: index % 2 == 0,
          createdAt: now.subtract(Duration(days: 365 - (index * 7))),
          updatedAt: now.subtract(Duration(days: index)),
        );
      },
    );

    return PaginatedResponse<AlunoModel>(
      data: alunosFicticios,
      page: 1,
      pageSize: 50,
      totalRecords: 50,
      totalPages: 1,
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }

  /// Gera dados fictícios de alunos filtrados por turmaId com paginação
  ///
  /// Filtra os alunos que pertencem a uma turma específica e retorna
  /// uma resposta paginada conforme os parâmetros fornecidos.
  ///
  /// **Parâmetros:**
  /// - `turmaId`: ID da turma para filtrar os alunos
  /// - `params`: Parâmetros de paginação (page, pageSize, etc.)
  PaginatedResponse<AlunoModel> _generateFakeAlunosByTurma({
    required int turmaId,
    QueryParams? params,
  }) {
    final queryParams = params ?? const QueryParams();
    final page = queryParams.page;
    final pageSize = queryParams.pageSize;

    // Gera todos os 50 alunos fictícios
    final todosAlunos = gerarAlunosFicticios().data;

    // Filtra apenas os alunos que pertencem à turma especificada
    final alunosDaTurma = todosAlunos.where((aluno) => aluno.turmaID == turmaId).toList();

    // Calcula a paginação
    final totalRecords = alunosDaTurma.length;
    final totalPages = totalRecords > 0 ? (totalRecords / pageSize).ceil() : 1;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalRecords);

    // Extrai a página solicitada
    final alunosPaginados = startIndex < totalRecords
        ? alunosDaTurma.sublist(startIndex, endIndex)
        : <AlunoModel>[];

    return PaginatedResponse<AlunoModel>(
      data: alunosPaginados,
      page: page,
      pageSize: pageSize,
      totalRecords: totalRecords,
      totalPages: totalPages,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
    );
  }
