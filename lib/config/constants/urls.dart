abstract final class Urls {
  static bool isUsingLocalhost = true;
  static Map<String, String> bearerHeader = {'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlx'};
  static String urlBase = isUsingLocalhost ?  'https://localhost:5290/api/' : 'https://w3soft3.com.br/W3DiplomaAPI/api/';
  // static String urlBase = isUsingLocalhost ?  'https://localhost:44370/api/' : 'https://w3soft3.com.br/W3DiplomaAPI/api/';
  static String buscarCepApi({required String cep}) => 'https://viacep.com.br/ws/$cep/json/';

  //AUTH
  ///POST: /login/1
  ///Espera: { "cpf": "000.000.000-52", "password": "senha" }
  ///Retorna: { "token", "refreshToken", "expires", "numeroBancoDados", "username", "role", "id", "dataCriacao", "ativo" }
  static String login() => 'https://localhost:5290/login/1';

  ///POST: /api/Revoke
  ///Revoga o refresh token (logout)
  ///Retorna: { "success": true, "message": "Logout realizado com sucesso" }
  static String logout() => '${urlBase}Revoke';

  ///POST: /api/Refresh
  ///Espera: { "token": "...", "refreshToken": "..." }
  ///Retorna: { "token", "refreshToken", "expires", "numeroBancoDados", "username", "role", "id", "dataCriacao", "ativo" }
  static String refreshToken() => '${urlBase}Refresh';

  static String urlBuscarCursos({required String clienteID}) => '${urlBase}cursos/getCursos/$clienteID';
  static String urlBuscarTurmas({required String clienteID}) => '${urlBase}turmas/getTurmas/$clienteID';

  //CURSOS
  ///GET: /api/cursos/getCursos/{numeroBanco}
  static String getCursos({required String id}) => '${urlBase}cursos/getCursos/$id';
  ///GET: /api/cursos/getCurso/{numeroBanco}/{id}
  static String getCurso({required String idBancoDeDados, required String idCurso}) => '${urlBase}cursos/getCurso/$idBancoDeDados/$idCurso';
  ///POST: /api/cursos/setCurso/{numeroBanco}
  static String setCurso({required String idBancoDeDados}) => '${urlBase}cursos/setCurso/$idBancoDeDados';
  ///PUT: /api/cursos/atualizarCurso/{numeroBanco}/{id}
  static String atualizarCurso({required String idBancoDeDados, required String idCurso}) => '${urlBase}cursos/atualizarCurso/$idBancoDeDados/$idCurso';
///DELETE: /api/cursos/deletarCurso/{numeroBanco}/{id
  static String deletarCurso({required String idBancoDeDados, required String idCurso}) => '${urlBase}cursos/deletarCurso/$idBancoDeDados/$idCurso';


  //ALUNOS
  ///GET: /api/alunos/getAlunos/{numeroBanco}
  static String getAlunos({required String id}) => '${urlBase}alunos/getAlunos/$id';
  ///GET: /api/alunos/getAluno/{numeroBanco}/{id}
  static String getAluno({required String idBancoDeDados, required String idAluno}) => '${urlBase}alunos/getAluno/$idBancoDeDados/$idAluno';
  ///POST: /api/alunos/setAluno/{numeroBanco}
  static String setAluno({required String idBancoDeDados}) => '${urlBase}alunos/setAluno/$idBancoDeDados';
  ///PUT: /api/alunos/atualizarAluno/{numeroBanco}/{id}
  static String atualizarAluno({required String idBancoDeDados, required String idAluno}) => '${urlBase}alunos/atualizarAluno/$idBancoDeDados/$idAluno';
  ///DELETE: /api/alunos/deletarAluno/{numeroBanco}/{id}
  static String deletarAluno({required String idBancoDeDados, required String idAluno}) => '${urlBase}alunos/deletarAluno/$idBancoDeDados/$idAluno';
  ///GET: /api/alunos/searchAlunos/{numeroBanco}/{searchTerm}
  static String searchAlunos({required String idBancoDeDados, required String searchTerm}) => '${urlBase}alunos/searchAlunos/$idBancoDeDados/$searchTerm';
  //GET: /api/alunos/getAlunosByTurma/{numeroBanco}/{turmaId}
  static String getAlunosByTurma({required String idBancoDeDados, required String turmaId}) => '${urlBase}alunos/getAlunosByTurma/$idBancoDeDados/$turmaId';

  //TURMAS
  ///GET: /api/turmas/getTurmas/{numeroBanco}
  static String getTurmas({required String idBancoDeDados}) => '${urlBase}turmas/getTurmas/$idBancoDeDados';
  ///GET: /api/turmas/getTurma/{numeroBanco}/{id}
  static String getTurma({required String idBancoDeDados, required String idTurma}) => '${urlBase}turmas/getTurma/$idBancoDeDados/$idTurma';
  ///POST: /api/turmas/setTurma/{numeroBanco}
  static String setTurma({required String idBancoDeDados}) => '${urlBase}turmas/setTurma/$idBancoDeDados';
  ///PUT: /api/turmas/atualizarTurma/{numeroBanco}/{id}
  static String atualizarTurma({required String idBancoDeDados, required String idTurma}) => '${urlBase}turmas/atualizarTurma/$idBancoDeDados/$idTurma';
  ///DELETE: /api/turmas/deletarTurma/{numeroBanco}/{id}
  static String deletarTurma({required String idBancoDeDados, required String idTurma}) => '${urlBase}turmas/deletarTurma/$idBancoDeDados/$idTurma';

  //IES REGISTRADORA
  ///GET: /api/iesRegistradora/getIESRegistradoras/{numeroBanco}
  static String getIESRegistradoras({required String idBancoDeDados}) => '${urlBase}iesRegistradora/getIESRegistradoras/$idBancoDeDados';
  ///GET: /api/iesRegistradora/getIESRegistradora/{numeroBanco}/{id}
  static String getIESRegistradora({required String idBancoDeDados, required String idIESRegistradora}) => '${urlBase}iesRegistradora/getIESRegistradora/$idBancoDeDados/$idIESRegistradora';
  ///POST: /api/iesRegistradora/setIESRegistradora/{numeroBanco}
  static String setIESRegistradora({required String idBancoDeDados}) => '${urlBase}iesRegistradora/setIESRegistradora/$idBancoDeDados';
  ///PUT: /api/iesRegistradora/atualizarIESRegistradora/{numeroBanco}/{id}
  static String atualizarIESRegistradora({required String idBancoDeDados, required String idIESRegistradora}) => '${urlBase}iesRegistradora/atualizarIESRegistradora/$idBancoDeDados/$idIESRegistradora';
  ///DELETE: /api/iesRegistradora/deletarIESRegistradora/{numeroBanco}/{id}
  static String deletarIESRegistradora({required String idBancoDeDados, required String idIESRegistradora}) => '${urlBase}iesRegistradora/deletarIESRegistradora/$idBancoDeDados/$idIESRegistradora';



  //IES EMISSORA
  ///GET: /api/iesEmissora/getIESEmissoras/{numeroBanco}
  static String getIESEmissoras({required String idBancoDeDados}) => '${urlBase}iesEmissora/getIESEmissoras/$idBancoDeDados';
  ///GET: /api/iesEmissora/getIESEmissora/{numeroBanco}/{id}
  static String getIESEmissora({required String idBancoDeDados, required String idIESEmissora}) => '${urlBase}iesEmissora/getIESEmissora/$idBancoDeDados/$idIESEmissora';
  ///POST: /api/iesEmissora/setIESEmissora/{numeroBanco}
  static String setIESEmissora({required String idBancoDeDados}) => '${urlBase}iesEmissora/setIESEmissora/$idBancoDeDados';
  ///PUT: /api/iesEmissora/atualizarIESEmissora/{numeroBanco}/{id}
  static String atualizarIESEmissora({required String idBancoDeDados, required String idIESEmissora}) => '${urlBase}iesEmissora/atualizarIESEmissora/$idBancoDeDados/$idIESEmissora';
  ///DELETE: /api/iesEmissora/deletarIESEmissora/{numeroBanco}/{id}
  static String deletarIESEmissora({required String idBancoDeDados, required String idIESEmissora}) => '${urlBase}iesEmissora/deletarIESEmissora/$idBancoDeDados/$idIESEmissora';

  //DISCIPLINAS
  ///GET: /api/disciplinas/getDisciplinas/{numeroBanco}
  static String getDisciplinas({required String idBancoDeDados}) => '${urlBase}disciplinas/getDisciplinas/$idBancoDeDados';
  ///GET: /api/disciplinas/getDisciplina/{numeroBanco}/{id}
  static String getDisciplina({required String idBancoDeDados, required String idDisciplina}) => '${urlBase}disciplinas/getDisciplina/$idBancoDeDados/$idDisciplina';
  ///POST: /api/disciplinas/setDisciplina/{numeroBanco}
  static String setDisciplina({required String idBancoDeDados}) => '${urlBase}disciplinas/setDisciplina/$idBancoDeDados';
  ///PUT: /api/disciplinas/atualizarDisciplina/{numeroBanco}/{id}
  static String atualizarDisciplina({required String idBancoDeDados, required String idDisciplina}) => '${urlBase}disciplinas/atualizarDisciplina/$idBancoDeDados/$idDisciplina';
  ///DELETE: /api/disciplinas/deletarDisciplina/{numeroBanco}/{id}
  static String deletarDisciplina({required String idBancoDeDados, required String idDisciplina}) => '${urlBase}disciplinas/deletarDisciplina/$idBancoDeDados/$idDisciplina';


  //DOCENTES
  ///GET: /api/docentes/getDocentes/{numeroBanco}
  static String getDocentes({required String id}) => '${urlBase}docentes/getDocentes/$id';
  ///GET: /api/docentes/getDocente/{numeroBanco}/{id}
  static String getDocente({required String idBancoDeDados, required String idDocente}) => '${urlBase}docentes/getDocente/$idBancoDeDados/$idDocente';
  ///POST: /api/docentes/setDocente/{numeroBanco}
  static String setDocente({required String idBancoDeDados}) => '${urlBase}docentes/setDocente/$idBancoDeDados';
  ///PUT: /api/docentes/atualizarDocente/{numeroBanco}/{id}
  static String atualizarDocente({required String idBancoDeDados, required String idDocente}) => '${urlBase}docentes/atualizarDocente/$idBancoDeDados/$idDocente';
  ///DELETE: /api/docentes/deletarDocente/{numeroBanco}/{id}
  static String deletarDocente({required String idBancoDeDados, required String idDocente}) => '${urlBase}docentes/deletarDocente/$idBancoDeDados/$idDocente';

  //DOCUMENTOS BASE64
  ///GET: /api/documentoBase64/getDocumentoBase64/{numeroBanco}/{alunoId}
  static String getDocumentoBase64({required String idBancoDeDados, required String alunoId, required TipoDocumentoBase64 nomeDocumento}) => '${urlBase}documentoBase64/getDocumentoBase64/$idBancoDeDados/$alunoId/${nomeDocumento.name}';

  //DISCIPLINA HISTORICO
  ///GET: /api/disciplinaHistorico/getDisciplinasHistorico/{numeroBanco}
  static String getDisciplinasHistorico({required String id}) => '${urlBase}disciplinaHistorico/getDisciplinaHistoricos/$id';
  ///GET: /api/disciplinaHistorico/getDisciplinaHistorico/{numeroBanco}/{id}
  static String getDisciplinaHistorico({required String idBancoDeDados, required String idDisciplinaHistorico}) => '${urlBase}disciplinaHistorico/getDisciplinaHistorico/$idBancoDeDados/$idDisciplinaHistorico';
  ///POST: /api/disciplinaHistorico/setDisciplinaHistorico/{numeroBanco}
  static String setDisciplinaHistorico({required String idBancoDeDados}) => '${urlBase}disciplinaHistorico/setDisciplinaHistorico/$idBancoDeDados';
  ///PUT: /api/disciplinaHistorico/atualizarDisciplinaHistorico/{numeroBanco}/{id}
  static String atualizarDisciplinaHistorico({required String idBancoDeDados, required String idDisciplinaHistorico}) => '${urlBase}disciplinaHistorico/atualizarDisciplinaHistorico/$idBancoDeDados/$idDisciplinaHistorico';
  ///DELETE: /api/disciplinaHistorico/deletarDisciplinaHistorico/{numeroBanco}/{id}
  static String deletarDisciplinaHistorico({required String idBancoDeDados, required String idDisciplinaHistorico}) => '${urlBase}disciplinaHistorico/deletarDisciplinaHistorico/$idBancoDeDados/$idDisciplinaHistorico';

  //ATIVIDADE COMPLEMENTAR
  ///GET: /api/atividadeComplementar/getAtividadesComplementares/{numeroBanco}
  static String getAtividadesComplementares({required String id}) => '${urlBase}atividadeComplementar/getAtividadesComplementares/$id';
  ///GET: /api/atividadeComplementar/getAtividadeComplementar/{numeroBanco}/{id}
  static String getAtividadeComplementar({required String idBancoDeDados, required String idAtividadeComplementar}) => '${urlBase}atividadeComplementar/getAtividadeComplementar/$idBancoDeDados/$idAtividadeComplementar';
  ///POST: /api/atividadeComplementar/setAtividadeComplementar/{numeroBanco}
  static String setAtividadeComplementar({required String idBancoDeDados}) => '${urlBase}atividadeComplementar/setAtividadeComplementar/$idBancoDeDados';
  ///PUT: /api/atividadeComplementar/atualizarAtividadeComplementar/{numeroBanco}/{id}
  static String atualizarAtividadeComplementar({required String idBancoDeDados, required String idAtividadeComplementar}) => '${urlBase}atividadeComplementar/atualizarAtividadeComplementar/$idBancoDeDados/$idAtividadeComplementar';
  ///DELETE: /api/atividadeComplementar/deletarAtividadeComplementar/{numeroBanco}/{id}
  static String deletarAtividadeComplementar({required String idBancoDeDados, required String idAtividadeComplementar}) => '${urlBase}atividadeComplementar/deletarAtividadeComplementar/$idBancoDeDados/$idAtividadeComplementar';

  //REGISTRO DIPLOMA
  ///GET: /api/registroDiploma/getRegistrosDiplomas/{numeroBanco}
  static String getRegistrosDiplomas({required String id}) => '${urlBase}registroDiploma/getRegistrosDiploma/$id';
  ///GET: /api/registroDiploma/getRegistroDiploma/{numeroBanco}/{id}
  static String getRegistroDiploma({required String idBancoDeDados, required String idRegistroDiploma}) => '${urlBase}registroDiploma/getRegistroDiploma/$idBancoDeDados/$idRegistroDiploma';
  ///POST: /api/registroDiploma/setRegistroDiploma/{numeroBanco}
  static String setRegistroDiploma({required String idBancoDeDados}) => '${urlBase}registroDiploma/setRegistroDiploma/$idBancoDeDados';
  ///PUT: /api/registroDiploma/atualizarRegistroDiploma/{numeroBanco}/{id}
  static String atualizarRegistroDiploma({required String idBancoDeDados, required String idRegistroDiploma}) => '${urlBase}registroDiploma/atualizarRegistroDiploma/$idBancoDeDados/$idRegistroDiploma';
  ///DELETE: /api/registroDiploma/deletarRegistroDiploma/{numeroBanco}/{id}
  static String deletarRegistroDiploma({required String idBancoDeDados, required String idRegistroDiploma}) => '${urlBase}registroDiploma/deletarRegistroDiploma/$idBancoDeDados/$idRegistroDiploma';

  //CONSOLIDATED DATA
  ///GET: /api/ConsolidatedData/GetConsolidatedDataByTurma/{numeroBanco}/{turmaId}
  static String getDadosCompletosPorTurma({required String idBancoDeDados, required String turmaId}) => '${urlBase}dadoscompletos/buscarPorTurma/$idBancoDeDados/$turmaId';
}

enum TipoDocumentoBase64 {
  base64DocumentoIdentidade,
  base64ProvaConclusaoEnsinoMedio,
  base64ProvaColacao,
  base64ComprovacaoEstagioCurricular,
  base64CertidaoNascimento,
  base64CertidaoCasamento,
  base64TituloEleitor,
  base64AtoNaturalizacao,
  base64Gru,
  base64CertificadoConclusaoEnsinoSuperior,
  base64OficioEncaminhamento,
  base64TermoResponsabilidade,
}