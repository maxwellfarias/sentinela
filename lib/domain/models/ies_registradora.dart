/// Modelo de domínio para IES Registradora
///
/// Representa uma Instituição de Ensino Superior Registradora com todos os dados necessários
/// para a lógica de negócio.
final class IESRegistradoraModel {
  final int iesRegistradoraID;
  final String nome;
  final int? codigoMec;
  final String cnpj;
  final String? enderecoLogradouro;
  final String? enderecoNumero;
  final String? enderecoBairro;
  final int? enderecoCodigoMunicipio;
  final String? enderecoNomeMunicipio;
  final String? enderecoUf;
  final String? enderecoCep;
  final String? credenciamentoTipo;
  final int? credenciamentoNumero;
  final DateTime? credenciamentoData;
  final DateTime? credenciamentoDataPublicacao;
  final int? credenciamentoPaginaPublicacao;
  final String? mantenedoraRazaoSocial;
  final String? mantenedoraCnpj;
  final String? mantenedoraEnderecoLogradouro;
  final String? mantenedoraEnderecoNumero;
  final String? mantenedoraEnderecoBairro;
  final int? mantenedoraEnderecoCodigoMunicipio;
  final String? mantenedoraEnderecoNomeMunicipio;
  final String? mantenedoraEnderecoUf;
  final String? mantenedoraEnderecoCep;
  final String? recredenciamentoTipo;
  final int? recredenciamentoNumero;
  final DateTime? recredenciamentoData;
  final DateTime? recredenciamentoDataPublicacao;
  final int? recredenciamentoSecaoPublicacao;
  final int? recredenciamentoPaginaPublicacao;
  final int? recredenciamentoNumeroDou;

  IESRegistradoraModel({
    required this.iesRegistradoraID,
    required this.nome,
    this.codigoMec,
    required this.cnpj,
    this.enderecoLogradouro,
    this.enderecoNumero,
    this.enderecoBairro,
    this.enderecoCodigoMunicipio,
    this.enderecoNomeMunicipio,
    this.enderecoUf,
    this.enderecoCep,
    this.credenciamentoTipo,
    this.credenciamentoNumero,
    this.credenciamentoData,
    this.credenciamentoDataPublicacao,
    this.credenciamentoPaginaPublicacao,
    this.mantenedoraRazaoSocial,
    this.mantenedoraCnpj,
    this.mantenedoraEnderecoLogradouro,
    this.mantenedoraEnderecoNumero,
    this.mantenedoraEnderecoBairro,
    this.mantenedoraEnderecoCodigoMunicipio,
    this.mantenedoraEnderecoNomeMunicipio,
    this.mantenedoraEnderecoUf,
    this.mantenedoraEnderecoCep,
    this.recredenciamentoTipo,
    this.recredenciamentoNumero,
    this.recredenciamentoData,
    this.recredenciamentoDataPublicacao,
    this.recredenciamentoSecaoPublicacao,
    this.recredenciamentoPaginaPublicacao,
    this.recredenciamentoNumeroDou,
  });

  factory IESRegistradoraModel.fromJson(dynamic json) {
    return IESRegistradoraModel(
      iesRegistradoraID: json['iesRegistradoraID'] as int,
      nome: json['nome'] as String,
      codigoMec: json['codigoMec'] as int?,
      cnpj: json['cnpj'] as String,
      enderecoLogradouro: json['enderecoLogradouro'] as String?,
      enderecoNumero: json['enderecoNumero'] as String?,
      enderecoBairro: json['enderecoBairro'] as String?,
      enderecoCodigoMunicipio: json['enderecoCodigoMunicipio'] as int?,
      enderecoNomeMunicipio: json['enderecoNomeMunicipio'] as String?,
      enderecoUf: json['enderecoUf'] as String?,
      enderecoCep: json['enderecoCep'] as String?,
      credenciamentoTipo: json['credenciamentoTipo'] as String?,
      credenciamentoNumero: json['credenciamentoNumero'] as int?,
      credenciamentoData: json['credenciamentoData'] != null
          ? DateTime.parse(json['credenciamentoData'] as String)
          : null,
      credenciamentoDataPublicacao: json['credenciamentoDataPublicacao'] != null
          ? DateTime.parse(json['credenciamentoDataPublicacao'] as String)
          : null,
      credenciamentoPaginaPublicacao: json['credenciamentoPaginaPublicacao'] as int?,
      mantenedoraRazaoSocial: json['mantenedoraRazaoSocial'] as String?,
      mantenedoraCnpj: json['mantenedoraCnpj'] as String?,
      mantenedoraEnderecoLogradouro: json['mantenedoraEnderecoLogradouro'] as String?,
      mantenedoraEnderecoNumero: json['mantenedoraEnderecoNumero'] as String?,
      mantenedoraEnderecoBairro: json['mantenedoraEnderecoBairro'] as String?,
      mantenedoraEnderecoCodigoMunicipio: json['mantenedoraEnderecoCodigoMunicipio'] as int?,
      mantenedoraEnderecoNomeMunicipio: json['mantenedoraEnderecoNomeMunicipio'] as String?,
      mantenedoraEnderecoUf: json['mantenedoraEnderecoUf'] as String?,
      mantenedoraEnderecoCep: json['mantenedoraEnderecoCep'] as String?,
      recredenciamentoTipo: json['recredenciamentoTipo'] as String?,
      recredenciamentoNumero: json['recredenciamentoNumero'] as int?,
      recredenciamentoData: json['recredenciamentoData'] != null
          ? DateTime.parse(json['recredenciamentoData'] as String)
          : null,
      recredenciamentoDataPublicacao: json['recredenciamentoDataPublicacao'] != null
          ? DateTime.parse(json['recredenciamentoDataPublicacao'] as String)
          : null,
      recredenciamentoSecaoPublicacao: json['recredenciamentoSecaoPublicacao'] as int?,
      recredenciamentoPaginaPublicacao: json['recredenciamentoPaginaPublicacao'] as int?,
      recredenciamentoNumeroDou: json['recredenciamentoNumeroDou'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iesRegistradoraID': iesRegistradoraID,
      'nome': nome,
      'codigoMec': codigoMec,
      'cnpj': cnpj,
      'enderecoLogradouro': enderecoLogradouro,
      'enderecoNumero': enderecoNumero,
      'enderecoBairro': enderecoBairro,
      'enderecoCodigoMunicipio': enderecoCodigoMunicipio,
      'enderecoNomeMunicipio': enderecoNomeMunicipio,
      'enderecoUf': enderecoUf,
      'enderecoCep': enderecoCep,
      'credenciamentoTipo': credenciamentoTipo,
      'credenciamentoNumero': credenciamentoNumero,
      'credenciamentoData': credenciamentoData?.toIso8601String(),
      'credenciamentoDataPublicacao': credenciamentoDataPublicacao?.toIso8601String(),
      'credenciamentoPaginaPublicacao': credenciamentoPaginaPublicacao,
      'mantenedoraRazaoSocial': mantenedoraRazaoSocial,
      'mantenedoraCnpj': mantenedoraCnpj,
      'mantenedoraEnderecoLogradouro': mantenedoraEnderecoLogradouro,
      'mantenedoraEnderecoNumero': mantenedoraEnderecoNumero,
      'mantenedoraEnderecoBairro': mantenedoraEnderecoBairro,
      'mantenedoraEnderecoCodigoMunicipio': mantenedoraEnderecoCodigoMunicipio,
      'mantenedoraEnderecoNomeMunicipio': mantenedoraEnderecoNomeMunicipio,
      'mantenedoraEnderecoUf': mantenedoraEnderecoUf,
      'mantenedoraEnderecoCep': mantenedoraEnderecoCep,
      'recredenciamentoTipo': recredenciamentoTipo,
      'recredenciamentoNumero': recredenciamentoNumero,
      'recredenciamentoData': recredenciamentoData?.toIso8601String(),
      'recredenciamentoDataPublicacao': recredenciamentoDataPublicacao?.toIso8601String(),
      'recredenciamentoSecaoPublicacao': recredenciamentoSecaoPublicacao,
      'recredenciamentoPaginaPublicacao': recredenciamentoPaginaPublicacao,
      'recredenciamentoNumeroDou': recredenciamentoNumeroDou,
    };
  }

  IESRegistradoraModel copyWith({
    int? iesRegistradoraID,
    String? nome,
    int? codigoMec,
    String? cnpj,
    String? enderecoLogradouro,
    String? enderecoNumero,
    String? enderecoBairro,
    int? enderecoCodigoMunicipio,
    String? enderecoNomeMunicipio,
    String? enderecoUf,
    String? enderecoCep,
    String? credenciamentoTipo,
    int? credenciamentoNumero,
    DateTime? credenciamentoData,
    DateTime? credenciamentoDataPublicacao,
    int? credenciamentoPaginaPublicacao,
    String? mantenedoraRazaoSocial,
    String? mantenedoraCnpj,
    String? mantenedoraEnderecoLogradouro,
    String? mantenedoraEnderecoNumero,
    String? mantenedoraEnderecoBairro,
    int? mantenedoraEnderecoCodigoMunicipio,
    String? mantenedoraEnderecoNomeMunicipio,
    String? mantenedoraEnderecoUf,
    String? mantenedoraEnderecoCep,
    String? recredenciamentoTipo,
    int? recredenciamentoNumero,
    DateTime? recredenciamentoData,
    DateTime? recredenciamentoDataPublicacao,
    int? recredenciamentoSecaoPublicacao,
    int? recredenciamentoPaginaPublicacao,
    int? recredenciamentoNumeroDou,
  }) {
    return IESRegistradoraModel(
      iesRegistradoraID: iesRegistradoraID ?? this.iesRegistradoraID,
      nome: nome ?? this.nome,
      codigoMec: codigoMec ?? this.codigoMec,
      cnpj: cnpj ?? this.cnpj,
      enderecoLogradouro: enderecoLogradouro ?? this.enderecoLogradouro,
      enderecoNumero: enderecoNumero ?? this.enderecoNumero,
      enderecoBairro: enderecoBairro ?? this.enderecoBairro,
      enderecoCodigoMunicipio: enderecoCodigoMunicipio ?? this.enderecoCodigoMunicipio,
      enderecoNomeMunicipio: enderecoNomeMunicipio ?? this.enderecoNomeMunicipio,
      enderecoUf: enderecoUf ?? this.enderecoUf,
      enderecoCep: enderecoCep ?? this.enderecoCep,
      credenciamentoTipo: credenciamentoTipo ?? this.credenciamentoTipo,
      credenciamentoNumero: credenciamentoNumero ?? this.credenciamentoNumero,
      credenciamentoData: credenciamentoData ?? this.credenciamentoData,
      credenciamentoDataPublicacao: credenciamentoDataPublicacao ?? this.credenciamentoDataPublicacao,
      credenciamentoPaginaPublicacao: credenciamentoPaginaPublicacao ?? this.credenciamentoPaginaPublicacao,
      mantenedoraRazaoSocial: mantenedoraRazaoSocial ?? this.mantenedoraRazaoSocial,
      mantenedoraCnpj: mantenedoraCnpj ?? this.mantenedoraCnpj,
      mantenedoraEnderecoLogradouro: mantenedoraEnderecoLogradouro ?? this.mantenedoraEnderecoLogradouro,
      mantenedoraEnderecoNumero: mantenedoraEnderecoNumero ?? this.mantenedoraEnderecoNumero,
      mantenedoraEnderecoBairro: mantenedoraEnderecoBairro ?? this.mantenedoraEnderecoBairro,
      mantenedoraEnderecoCodigoMunicipio: mantenedoraEnderecoCodigoMunicipio ?? this.mantenedoraEnderecoCodigoMunicipio,
      mantenedoraEnderecoNomeMunicipio: mantenedoraEnderecoNomeMunicipio ?? this.mantenedoraEnderecoNomeMunicipio,
      mantenedoraEnderecoUf: mantenedoraEnderecoUf ?? this.mantenedoraEnderecoUf,
      mantenedoraEnderecoCep: mantenedoraEnderecoCep ?? this.mantenedoraEnderecoCep,
      recredenciamentoTipo: recredenciamentoTipo ?? this.recredenciamentoTipo,
      recredenciamentoNumero: recredenciamentoNumero ?? this.recredenciamentoNumero,
      recredenciamentoData: recredenciamentoData ?? this.recredenciamentoData,
      recredenciamentoDataPublicacao: recredenciamentoDataPublicacao ?? this.recredenciamentoDataPublicacao,
      recredenciamentoSecaoPublicacao: recredenciamentoSecaoPublicacao ?? this.recredenciamentoSecaoPublicacao,
      recredenciamentoPaginaPublicacao: recredenciamentoPaginaPublicacao ?? this.recredenciamentoPaginaPublicacao,
      recredenciamentoNumeroDou: recredenciamentoNumeroDou ?? this.recredenciamentoNumeroDou,
    );
  }

  @override
  String toString() {
    return 'IESRegistradora('
        'iesRegistradoraID: $iesRegistradoraID, '
        'nome: $nome, '
        'codigoMec: $codigoMec, '
        'cnpj: $cnpj, '
        'enderecoLogradouro: $enderecoLogradouro, '
        'enderecoNumero: $enderecoNumero, '
        'enderecoBairro: $enderecoBairro, '
        'enderecoCodigoMunicipio: $enderecoCodigoMunicipio, '
        'enderecoNomeMunicipio: $enderecoNomeMunicipio, '
        'enderecoUf: $enderecoUf, '
        'enderecoCep: $enderecoCep, '
        'credenciamentoTipo: $credenciamentoTipo, '
        'credenciamentoNumero: $credenciamentoNumero, '
        'credenciamentoData: $credenciamentoData, '
        'credenciamentoDataPublicacao: $credenciamentoDataPublicacao, '
        'credenciamentoPaginaPublicacao: $credenciamentoPaginaPublicacao, '
        'mantenedoraRazaoSocial: $mantenedoraRazaoSocial, '
        'mantenedoraCnpj: $mantenedoraCnpj, '
        'mantenedoraEnderecoLogradouro: $mantenedoraEnderecoLogradouro, '
        'mantenedoraEnderecoNumero: $mantenedoraEnderecoNumero, '
        'mantenedoraEnderecoBairro: $mantenedoraEnderecoBairro, '
        'mantenedoraEnderecoCodigoMunicipio: $mantenedoraEnderecoCodigoMunicipio, '
        'mantenedoraEnderecoNomeMunicipio: $mantenedoraEnderecoNomeMunicipio, '
        'mantenedoraEnderecoUf: $mantenedoraEnderecoUf, '
        'mantenedoraEnderecoCep: $mantenedoraEnderecoCep, '
        'recredenciamentoTipo: $recredenciamentoTipo, '
        'recredenciamentoNumero: $recredenciamentoNumero, '
        'recredenciamentoData: $recredenciamentoData, '
        'recredenciamentoDataPublicacao: $recredenciamentoDataPublicacao, '
        'recredenciamentoSecaoPublicacao: $recredenciamentoSecaoPublicacao, '
        'recredenciamentoPaginaPublicacao: $recredenciamentoPaginaPublicacao, '
        'recredenciamentoNumeroDou: $recredenciamentoNumeroDou)';
  }
}