import 'dart:convert';
import 'dart:math' as math;

import 'package:w3_diploma/domain/models/aluno/aluno_model.dart';
import 'package:w3_diploma/domain/models/curso/curso_model.dart';
// import 'package:w3_diploma/domain/models/curso_model.dart';
import 'package:w3_diploma/domain/models/ies_emissora_model.dart';
import 'package:w3_diploma/domain/models/turma/turma_model.dart';
// import 'package:w3_diploma/domain/models/turma_model.dart';
import 'package:w3_diploma/domain/usecases/gerar_xml_academico/gerar_xml_academico_usecase.dart';
import 'package:w3_diploma/utils/extensions/string.dart';
// import 'package:w3_diploma/utils/mocks/atividade_complementar_mock.dart';
// import 'package:w3_diploma/utils/mocks/disciplinas_historico_aluno_diploma_mock.dart';
// import 'package:w3_diploma/utils/mocks/docente_atividade_complementar_mock.dart';
// import 'package:w3_diploma/utils/mocks/docente_estagio_mock.dart';
// import 'package:w3_diploma/utils/mocks/estagio_mock.dart';
import 'package:w3_diploma/utils/mocks/pdf_base64_mock.dart';
import 'package:w3_diploma/utils/result.dart';
import 'package:xml/xml.dart';

import '../../../utils/result.dart';

final class GerarXmlAcademicoUseCaseImpl implements GerarXmlAcademicoUseCase {


 //DADOS MOCADOS AGUARDANDO IMPLEMENTAÇÃO DO BACKEND
// ========================================================================================================
 
  final _dataConclusaoCurso = DateTime.now();

  //Dados Privados do Diplomado
  final _perfilInstituicao = 'media1';

  // final _lstDisciplinasHistoricoAlunoDiploma = gerarMockDisciplinasHistoricoAlunoDiploma();
  // final _lstAtividadeComplementarAluno = gerarMockAtividadeComplementar();
  // final _lstDocentesOrientadores = gerarMockDocenteAtividadeComplementar();
  // final _lstEstagioAluno = gerarMockEstagio();
  // final _lstDocentesOrientadoresEstagio = gerarMockDocenteEstagio();

  //Situacao Discente
  final _periodoEC = 'periodoEC';
  final _situacaoVinculoFormadoDataEC = DateTime.now().toString();
  final _colacaoGrauDataEC = DateTime.now().toString();
  final _dataExpedicaoDiplomaEC = DateTime.now().toString();

  //Habilitacao
  final _nomeHabilitacaoDocumentacaoAcademicaEC = 'nomeHabilitacaoDocumentacaoAcademicaEC';
  final _dataHabilitacaoDocumentacaoAcademicaEC = DateTime.now().toString();

  //TermoResponsabilidadeEmissora
  final _nomeAssinanteTermoResponsabilidadeEC = 'nomeAssinanteTermoResponsabilidadeEC';
  final _cpfAssinanteTermoResponsabilidadeEC = '123.456.789-00';
  final _dpdCargoAssinanteTermoResponsabilidade = '_dpdCargoAssinanteTermoResponsabilidade';

  //Documentos Anexos em Base64
  final _base64IdentidadeAluno = pdfBase64Mock;
  final _base64ProvaConclusaoEnsinoMedio = pdfBase64Mock;
  final _base64ProvaColacao = pdfBase64Mock;
  final _base64ComprovacaoEstagioCurricular = pdfBase64Mock;
  final _base64CertidaoCasamento = pdfBase64Mock;
  final _base64CertidaoNascimento = pdfBase64Mock;
  final _base64TituloEleitor = pdfBase64Mock;
  final _base64AtoNaturalizacao = pdfBase64Mock;

// ========================================================================================================





  @override
  Future<Result<dynamic>> call({
    required AlunoModel aluno,
    required TurmaModel turma,
    required CursoModel curso,
    required IesEmissoraModel iesEmissora,
  }) async {
    final builder = XmlBuilder();
    final nonceBase = _gerarNonceNumerico();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element(
      'DocumentacaoAcademicaRegistro',
      attributes: {
        'xmlns:ds': 'http://www.w3.org/2000/09/xmldsig#',
        'xmlns:xs': 'http://www.w3.org/2001/XMLSchema',
        'xmlns': 'http://portal.mec.gov.br/diplomadigital/arquivos-em-xsd',
        'targetNamespace': 'http://portal.mec.gov.br/diplomadigital/arquivos-em-xsd',
        'elementFormDefault': 'qualified',
        'attributeFormDefault': 'unqualified',
      },
      nest: () {
        builder.element(
          'RegistroReq',
          attributes: {
            'id': 'ReqDip$nonceBase',
            'versao': '1.05',
            'ambiente': 'Produção',
          },
          nest: () {
            builder.element(
              'DadosDiploma',
              attributes: {'id': 'Dip$nonceBase'},
              nest: () {
                builder.element(
                  'Diplomado',
                  nest: () {
                    builder.element('ID', nest: aluno.alunoID.toString());
                    builder.element('Nome', nest: aluno.nome.trim());
                    builder.element('Sexo', nest: aluno.sexo.trim());
                    builder.element('Nacionalidade', nest: aluno.nacionalidade.trim());
                    builder.element(
                      'Naturalidade',
                      nest: () {
                        builder.element('CodigoMunicipio', nest: aluno.codigoMunicipio);
                        builder.element('NomeMunicipio', nest: aluno.nomeMunicipio.trim().toCapitalize());
                        builder.element('UF', nest: aluno.uf.trim().toUpperCase());
                      },
                    );
                    builder.element('CPF', nest: _limparFormatacao(aluno.cpf));
                    builder.element(
                      'RG',
                      nest: () {
                        builder.element('Numero', nest: _limparFormatacao(aluno.rgNumero));
                        builder.element('OrgaoExpedidor', nest: aluno.rgOrgaoExpedidor);
                        builder.element('UF', nest: aluno.rgUf.trim());
                      },
                    );
                    builder.element('DataNascimento', nest: _formatarDataPadraoBancoDados(stringData: aluno.dataNascimento.toString()));
                  },
                );
                builder.element('DataConclusao', nest: _formatarDataPadraoBancoDados(stringData: _dataConclusaoCurso.toString()));
                builder.element(
                  'DadosCurso',
                  nest: () {
                    builder.element('NomeCurso', nest: curso.nomeCurso);
                    if (curso.codigoCursoEMEC != 0) {
                      builder.element('CodigoCursoEMEC', nest: curso.codigoCursoEMEC.toString());
                    } else {
                      builder.element(
                        'SemCodigoCursoEMEC',
                        nest: () {
                          builder.element('NumeroProcesso', nest: curso.numeroProcesso);
                          builder.element('TipoProcesso', nest: curso.tipoProcesso ?? '');
                          builder.element('DataCadastro', nest: _formatarDataPadraoBancoDados(stringData: curso.dataCadastro!.toString()));
                          builder.element('DataProtocolo', nest: _formatarDataPadraoBancoDados(stringData: curso.dataProtocolo!.toString()));
                        },
                      );
                    }
                    builder.element('Modalidade', nest: curso.modalidade);
                    builder.element(
                      'TituloConferido',
                      nest: () {
                        builder.element('Titulo', nest: _retornarTituloConferido(grauConferido: curso.grauConferido));
                      },
                    );
                    builder.element('GrauConferido', nest: curso.grauConferido);
                    builder.element(
                      'EnderecoCurso',
                      nest: () {
                        builder.element('Logradouro', nest: curso.logradouro);
                        builder.element('Bairro', nest: curso.bairro);
                        builder.element('CodigoMunicipio', nest: curso.codigoMunicipio);
                        builder.element('NomeMunicipio', nest: curso.nomeMunicipio);
                        builder.element('UF', nest: curso.uf);
                        builder.element('CEP', nest: _limparFormatacao(curso.cep));
                      },
                    );
                    builder.element(
                      'Autorizacao',
                      nest: () {
                        builder.element('Tipo', nest: curso.autorizacaoTipo);
                        builder.element('Numero', nest: curso.autorizacaoNumero);
                        builder.element('Data', nest: _formatarDataPadraoBancoDados(stringData: curso.autorizacaoData.toString()));
                      },
                    );
                    builder.element(
                      'Reconhecimento',
                      nest: () {
                        builder.element('Tipo', nest: curso.reconhecimentoTipo);
                        builder.element('Numero', nest: curso.reconhecimentoNumero);
                        builder.element('Data', nest: _formatarDataPadraoBancoDados(stringData: curso.reconhecimentoData.toString()));
                      },
                    );
                  },
                );
                builder.element(
                  'IesEmissora',
                  nest: () {
                    builder.element('Nome', nest: iesEmissora.nome);
                  if (iesEmissora.codigoMec != 0) {
                      builder.element('CodigoCursoEMEC', nest: iesEmissora.codigoMec.toString());
                    } else {
                      builder.element(
                        'SemCodigoCursoEMEC',
                        nest: () {
                          builder.element('NumeroProcesso', nest: iesEmissora.numeroProcessoIesSemCodigoEmec);
                          builder.element('TipoProcesso', nest: iesEmissora.tipoProcessoIesSemCodigoEmec ?? '');
                          builder.element('DataCadastro', nest: _formatarDataPadraoBancoDados(stringData: iesEmissora.dataCadastroIesSemCodigoEmec!.toString()));
                          builder.element('DataProtocolo', nest: _formatarDataPadraoBancoDados(stringData: iesEmissora.dataProtocoloIesSemCodigoEmec!.toString()));
                        },
                      );
                    }
                    builder.element('CNPJ', nest: _limparFormatacao(iesEmissora.cnpj));
                    builder.element(
                      'Endereco',
                      nest: () {
                        builder.element('Logradouro', nest: iesEmissora.enderecoLogradouro);
                        builder.element('Bairro', nest: iesEmissora.enderecoBairro);
                        builder.element('CodigoMunicipio', nest: iesEmissora.enderecoCodigoMunicipio);
                        builder.element('NomeMunicipio', nest: iesEmissora.enderecoNomeMunicipio);
                        builder.element('UF', nest: iesEmissora.enderecoUf);
                        builder.element('CEP', nest: _limparFormatacao(iesEmissora.enderecoCep));
                      },
                    );
                    builder.element(
                      'Credenciamento',
                      nest: () {
                        builder.element('Tipo', nest: iesEmissora.credenciamentoTipo);
                        builder.element('Numero', nest: iesEmissora.credenciamentoNumero);
                        builder.element('Data', nest: _formatarDataPadraoBancoDados(stringData: iesEmissora.credenciamentoData.toString()));
                      },
                    );
                  },
                );
              },
            );
            builder.element(
              'DadosPrivadosDiplomado',
              nest: () {
                builder.element(
                  'Filiacao',
                  nest: () {
                    if(aluno.filiacaoMaeNome != null){
                      builder.element(
                        'Genitor',
                        nest: () {
                          builder.element(
                            'Nome',
                            nest: aluno.filiacaoMaeNome ?? '',
                          );
                          builder.element('Sexo', nest: 'F');
                        },
                      );
                    }
                   if(aluno.filiacaoPaiNome != null){
                    builder.element(
                      'Genitor',
                      nest: () {
                        builder.element(
                          'Nome',
                          nest: aluno.filiacaoPaiNome,
                        );
                        builder.element('Sexo', nest: 'M');
                      },
                    );
                   }
                  },
                );
              //   builder.element(
              //     'HistoricoEscolar',
              //     nest: () {
              //       builder.element(
              //         'ElementosHistorico',
              //         nest: () {
              //           for (
              //             var i = 0;
              //             i < _lstDisciplinasHistoricoAlunoDiploma.length;
              //             i++
              //           ) {
              //             builder.element(
              //               'Disciplina',
              //               nest: () {
              //                 builder.element(
              //                   'CodigoDisciplina',
              //                   nest: _lstDisciplinasHistoricoAlunoDiploma[i]
              //                       .codigo,
              //                 );
              //                 builder.element(
              //                   'NomeDisciplina',
              //                   nest: _lstDisciplinasHistoricoAlunoDiploma[i]
              //                       .nomeDisciplina,
              //                 );
              //                 builder.element(
              //                   'PeriodoLetivo',
              //                   nest: _lstDisciplinasHistoricoAlunoDiploma[i]
              //                       .periodo,
              //                 );
              //                 builder.element(
              //                   'CargaHoraria',
              //                   nest: _lstDisciplinasHistoricoAlunoDiploma[i]
              //                       .cargaHoraria,
              //                 );
              //                 builder.element(
              //                   'Nota',
              //                   nest: notaDisciplina1a10(i),
              //                 );
              //                 //! Aprovado
              //                 if (_lstDisciplinasHistoricoAlunoDiploma[i]
              //                         .disciplinaSituacaoID ==
              //                     4) {
              //                   builder.element(
              //                     'Aprovado',
              //                     nest: () {
              //                       builder.element(
              //                         'FormaIntegralizacao',
              //                         nest: 'Cursado',
              //                       );
              //                     },
              //                   );
              //                 }
              //                 //! Reprovado
              //                 if (_lstDisciplinasHistoricoAlunoDiploma[i]
              //                         .disciplinaSituacaoID ==
              //                     3) {
              //                   builder.element('Pendente', nest: '');
              //                 }
              //                 //! Reprovado
              //                 if (_lstDisciplinasHistoricoAlunoDiploma[i]
              //                         .disciplinaSituacaoID ==
              //                     5) {
              //                   builder.element('Reprovado', nest: '');
              //                 }
              //                 builder.element(
              //                   'Docentes',
              //                   nest: () {
              //                     builder.element(
              //                       'Nome',
              //                       nest:
              //                           _lstDisciplinasHistoricoAlunoDiploma[i]
              //                               .nome,
              //                     );
              //                     builder.element(
              //                       'Titulacao',
              //                       nest: 'Graduação',
              //                     );
              //                   },
              //                 );
              //               },
              //             );
              //           }
              //           builder.element(
              //             'AtividadeComplementar',
              //             nest: () async {
              //               for (
              //                 var i = 0;
              //                 i < _lstAtividadeComplementarAluno.length;
              //                 i++
              //               ) {
              //                 builder.element(
              //                   'CodigoAtividadeComplementar',
              //                   nest: _lstAtividadeComplementarAluno[i]
              //                       .atividadeComplementarID,
              //                 );
              //                 builder.element(
              //                   'DataInicio',
              //                   nest: _formatarDataPadraoBancoDados(stringData: _lstAtividadeComplementarAluno[i].dataInicio.toString(),
              //                   ),
              //                 );
              //                 builder.element(
              //                   'DataFim',
              //                   nest: _formatarDataPadraoBancoDados(stringData: _lstAtividadeComplementarAluno[i].dataFim.toString(),
              //                   ),
              //                 );
              //                 builder.element(
              //                   'DataRegistro',
              //                   nest: _formatarDataPadraoBancoDados(stringData: _lstAtividadeComplementarAluno[i].dataRegistro.toString(),
              //                   ),
              //                 );
              //                 builder.element(
              //                   'TipoAtividadeComplementar',
              //                   nest: _lstAtividadeComplementarAluno[i]
              //                       .tipoAtividadeComplementar,
              //                 );
              //                 builder.element(
              //                   'Descricao',
              //                   nest:
              //                       _lstAtividadeComplementarAluno[i].descricao,
              //                 );
              //                 builder.element(
              //                   'CargaHorariaEmHoraRelogio',
              //                   nest: _lstAtividadeComplementarAluno[i]
              //                       .cargaHorariaEmHoraRelogio,
              //                 );
              //                 for (
              //                   var i = 0;
              //                   i < _lstDocentesOrientadores.length;
              //                   i++
              //                 ) {
              //                   builder.element(
              //                     'DocentesResponsaveisPelaValidacao',
              //                     nest: () {
              //                       builder.element(
              //                         'Nome',
              //                         nest: _lstDocentesOrientadores[i].nome,
              //                       );
              //                       builder.element(
              //                         'Titulacao',
              //                         nest:
              //                             _lstDocentesOrientadores[i].titulacao,
              //                       );
              //                     },
              //                   );
              //                 }
              //               }
              //             },
              //           );
              //           builder.element(
              //             'Estagio',
              //             nest: () async {
              //               for (var i = 0; i < _lstEstagioAluno.length; i++) {
              //                 builder.element(
              //                   'CodigoUnidadeCurricular',
              //                   nest:
              //                       _lstEstagioAluno[i].codigoUnidadeCurricular,
              //                 );
              //                 builder.element(
              //                   'DataInicio',
              //                   nest: _formatarDataPadraoBancoDados(stringData: _lstEstagioAluno[i].dataInicio?.toString() ?? ''),
              //                 );
              //                 builder.element(
              //                   'DataFim',
              //                   nest: _formatarDataPadraoBancoDados(stringData: 
              //                     _lstEstagioAluno[i].dataFim ?? '',
              //                   ),
              //                 );
              //                 builder.element(
              //                   'Concedente',
              //                   nest: () {
              //                     builder.element(
              //                       'RazaoSocial',
              //                       nest: _lstEstagioAluno[i]
              //                           .concedenteRazaoSocial,
              //                     );
              //                     builder.element(
              //                       'NomeFantasia',
              //                       nest: _lstEstagioAluno[i]
              //                           .concedenteNomeFantasia,
              //                     );
              //                     builder.element(
              //                       'CNPJ',
              //                       nest: _lstEstagioAluno[i].concedenteCNPJ,
              //                     );
              //                     builder.element(
              //                       'Nome',
              //                       nest: _lstEstagioAluno[i].concedenteNome,
              //                     );
              //                     builder.element(
              //                       'CPF',
              //                       nest: _lstEstagioAluno[i].concedenteCPF,
              //                     );
              //                   },
              //                 );
              //                 builder.element(
              //                   'Descricao',
              //                   nest: _lstEstagioAluno[i].descricao,
              //                 );
              //                 builder.element(
              //                   'CargaHorariaEmHorasRelogio',
              //                   nest: _lstEstagioAluno[i]
              //                       .cargaHorariaEmHorasRelogio,
              //                 );
              //                 builder.element(
              //                   'DocentesOrientadores',
              //                   nest: () {
              //                     for (
              //                       var j = 0;
              //                       j < _lstDocentesOrientadoresEstagio.length;
              //                       j++
              //                     ) {
              //                       builder.element(
              //                         'Nome',
              //                         nest: _lstDocentesOrientadoresEstagio[j]
              //                             .nome,
              //                       );
              //                       builder.element(
              //                         'Titulacao',
              //                         nest: _lstDocentesOrientadoresEstagio[j]
              //                             .titulacao,
              //                       );
              //                     }
              //                   },
              //                 );
              //               }
              //             },
              //           );
              //           builder.element(
              //             'SituacaoDiscente',
              //             nest: () {
              //               builder.element(
              //                 'PeriodoLetivo',
              //                 nest: _periodoEC,
              //               );
              //               builder.element(
              //                 'Formado',
              //                 nest: () {
              //                   builder.element(
              //                     'DataConclusaoCurso',
              //                     nest: _formatarDataPadraoBancoDados(stringData: _situacaoVinculoFormadoDataEC),
              //                   ); //  tem no banco de dados alunoMatricula
              //                   builder.element(
              //                     'DataColacaoGrau',
              //                     nest: _formatarDataPadraoBancoDados(stringData: _colacaoGrauDataEC),
              //                   );
              //                   builder.element(
              //                     'DataExpedicaoDiploma',
              //                     nest: _formatarDataPadraoBancoDados(stringData: _dataExpedicaoDiplomaEC,
              //                     ),
              //                   ); // Campo de texto ao clicar em gerar XML
              //                 },
              //               );
              //             },
              //           );
              //         },
              //       );
              //     },
              //   );
               },
            );
            builder.element(
              'Habilitacao',
              nest: () {
                builder.element(
                  'NomeHabilitacao',
                  nest: _nomeHabilitacaoDocumentacaoAcademicaEC,
                );
                builder.element(
                  'DataHabilitacao',
                  nest: _formatarDataPadraoBancoDados(stringData: _dataHabilitacaoDocumentacaoAcademicaEC),
                );
              },
            );
            builder.element(
              'TermoResponsabilidadeEmissora',
              nest: () {
                builder.element(
                  'Nome',
                  nest: _nomeAssinanteTermoResponsabilidadeEC,
                );
                builder.element(
                  'CPF',
                  nest: _limparFormatacao(_cpfAssinanteTermoResponsabilidadeEC),
                );
                builder.element(
                  'Cargo',
                  nest: _dpdCargoAssinanteTermoResponsabilidade,
                );
              },
            );
            builder.element(
              'DocumentacaoComprobatoria',
              nest: () {
                //! Adicionar campo e botão de upload da documentação
                //! O documento comprobatório deve ser armazenado como Base64 dos bytes
                builder.element(
                  'DocumentoIdentidadeDoAluno',
                  nest: _base64IdentidadeAluno,
                );
                builder.element(
                  'ProvaConclusaoEnsinoMedio',
                  nest: _base64ProvaConclusaoEnsinoMedio,
                );
                builder.element('ProvaColacao', nest: _base64ProvaColacao);
                builder.element(
                  'ComprovacaoEstagioCurricular',
                  nest: _base64ComprovacaoEstagioCurricular,
                );
                builder.element(
                  'CertidaoNascimento',
                  nest: _base64CertidaoNascimento,
                );
                builder.element(
                  'CertidaoCasamento',
                  nest: _base64CertidaoCasamento,
                );
                builder.element('TituloEleitor', nest: _base64TituloEleitor);
                builder.element(
                  'AtoNaturalizacao',
                  nest: _base64AtoNaturalizacao,
                );
              },
            );
          },
        );
      },
    );

    final document = builder.buildDocument();
    final xmlString = document.toXmlString(pretty: true);
    final xmlStringBytes = utf8.encode(xmlString);

    await arquivarDocumentoXmlDocAcademica(
      'documentacao_academica_alunoID${aluno.alunoID}.xml',
      xmlStringBytes,
    );

    return Result.ok(null);
  }

  Future<void> arquivarDocumentoXmlDocAcademica(
      String nomeArquivoXml, List<int> documentoBytes) async {

        //TODO: Implementar o arquivamento do XML no backend

    // try {
    //   _status = GerarXmlDocAcademicaStateStatus.loading;
    //   await _assinarDiplomaRepositoryImpl.arquivarDocumentos(
    //     DocumentosXmlEnviarModel(
    //       alunoCPF: cpfEC.text,
    //       turmaID: _dpdTurmas.getValue(),
    //       documentoNome: nomeArquivoXml,
    //       documentoTipo: 'Documentação Acadêmica',
    //       documentoBytes: documentoBytes,
    //     ),
    //   );
    //   _status = GerarXmlDocAcademicaStateStatus.updateScreen;
    // } catch (e, s) {
    //   debugPrint(e.toString());
    //   log(
    //     'Erro ao arquivar documentos!',
    //     error: e,
    //     stackTrace: s,
    //   );
    //   _status = GerarXmlDocAcademicaStateStatus.error;
    //   _errorMessage = 'Erro ao arquivar documentos!';
    // }
  }

  String _gerarNonceNumerico() {
    final random = math.Random.secure();
    final nonce = List.generate(44, (_) => random.nextInt(10));
    final String nonceFormatado = nonce.join(',');
    return nonceFormatado.replaceAll(',', '');
  }

  String _limparFormatacao(String dado) {
    return dado.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String _formatarDataPadraoBancoDados({required String stringData}) {
    return stringData.substring(0, 10);
  }

  String _retornarTituloConferido({required String grauConferido}) {
    return switch (grauConferido) {
      'Bacharelado' => 'Bacharel',
      'Licenciatura' => 'Licenciado',
      'Tecnólogo' => 'Tecnólogo',
      _ => 'Bacharel',
    };
  }

  // double notaDisciplina1a10(int index) {
  //   switch (_perfilInstituicao) {
  //     case 'media1':
  //       return _lstDisciplinasHistoricoAlunoDiploma[index].media1 ?? -1;
  //     case 'media2':
  //       return _lstDisciplinasHistoricoAlunoDiploma[index].media2 ?? -1;
  //     default:
  //       return -1;
  //   }
  // }
}