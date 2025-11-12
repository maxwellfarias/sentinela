/// Modelo de domínio para IES Emissora
///
/// Representa uma Instituição de Ensino Superior emissora no sistema
/// conforme a tabela SQL ies_emissora.
final class IesEmissoraModel {
  final int iesEmissoraID;
  final String nome;
  final int codigoMec;
  final String cnpj;
  final String enderecoLogradouro;
  final String enderecoBairro;
  final String enderecoCodigoMunicipio;
  final String enderecoNomeMunicipio;
  final String enderecoUf;
  final String enderecoCep;
  final String credenciamentoTipo;
  final String credenciamentoNumero;
  final DateTime credenciamentoData;
  final String? numeroProcessoIesSemCodigoEmec;
  final String? tipoProcessoIesSemCodigoEmec;
  final DateTime? dataCadastroIesSemCodigoEmec;
  final DateTime? dataProtocoloIesSemCodigoEmec;
  final String perfilTipoMedia;
  final String nomeAssinanteTermoResponsabilidade;
  final String cpfAssinanteTermoResponsabilidade;
  final String cargoAssinanteTermoResponsabilidade;
  final DateTime createdAt;
  final DateTime updatedAt;

  IesEmissoraModel({
    required this.iesEmissoraID,
    required this.nome,
    required this.codigoMec,
    required this.cnpj,
    required this.enderecoLogradouro,
    required this.enderecoBairro,
    required this.enderecoCodigoMunicipio,
    required this.enderecoNomeMunicipio,
    required this.enderecoUf,
    required this.enderecoCep,
    required this.credenciamentoTipo,
    required this.credenciamentoNumero,
    required this.credenciamentoData,
    this.numeroProcessoIesSemCodigoEmec,
    this.tipoProcessoIesSemCodigoEmec,
    this.dataCadastroIesSemCodigoEmec,
    this.dataProtocoloIesSemCodigoEmec,
    this.perfilTipoMedia = 'media1',
    required this.nomeAssinanteTermoResponsabilidade,
    required this.cpfAssinanteTermoResponsabilidade,
    required this.cargoAssinanteTermoResponsabilidade,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory IesEmissoraModel.fromJson(dynamic json) {
    return IesEmissoraModel(
      iesEmissoraID: json['iesEmissoraID'] ?? 0,
      nome: json['nome'] ?? '',
      codigoMec: json['codigoMec'] ?? 0,
      cnpj: json['cnpj'] ?? '',
      enderecoLogradouro: json['enderecoLogradouro'] ?? '',
      enderecoBairro: json['enderecoBairro'] ?? '',
      enderecoCodigoMunicipio: json['enderecoCodigoMunicipio'] ?? '',
      enderecoNomeMunicipio: json['enderecoNomeMunicipio'] ?? '',
      enderecoUf: json['enderecoUf'] ?? '',
      enderecoCep: json['enderecoCep'] ?? '',
      credenciamentoTipo: json['credenciamentoTipo'] ?? '',
      credenciamentoNumero: json['credenciamentoNumero'] ?? '',
      credenciamentoData: json['credenciamentoData'] != null
          ? DateTime.parse(json['credenciamentoData'])
          : DateTime.now(),
      numeroProcessoIesSemCodigoEmec: json['numeroProcessoIesSemCodigoEmec'],
      tipoProcessoIesSemCodigoEmec: json['tipoProcessoIesSemCodigoEmec'],
      dataCadastroIesSemCodigoEmec: json['dataCadastroIesSemCodigoEmec'] != null
          ? DateTime.parse(json['dataCadastroIesSemCodigoEmec'])
          : null,
      dataProtocoloIesSemCodigoEmec: json['dataProtocoloIesSemCodigoEmec'] != null
          ? DateTime.parse(json['dataProtocoloIesSemCodigoEmec'])
          : null,
      perfilTipoMedia: json['perfilTipoMedia'] ?? 'media1',
      nomeAssinanteTermoResponsabilidade: json['nomeAssinanteTermoResponsabilidade'] ?? '',
      cpfAssinanteTermoResponsabilidade: json['cpfAssinanteTermoResponsabilidade'] ?? '',
      cargoAssinanteTermoResponsabilidade: json['cargoAssinanteTermoResponsabilidade'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iesEmissoraID': iesEmissoraID,
      'nome': nome,
      'codigoMec': codigoMec,
      'cnpj': cnpj,
      'enderecoLogradouro': enderecoLogradouro,
      'enderecoBairro': enderecoBairro,
      'enderecoCodigoMunicipio': enderecoCodigoMunicipio,
      'enderecoNomeMunicipio': enderecoNomeMunicipio,
      'enderecoUf': enderecoUf,
      'enderecoCep': enderecoCep,
      'credenciamentoTipo': credenciamentoTipo,
      'credenciamentoNumero': credenciamentoNumero,
      'credenciamentoData': credenciamentoData.toIso8601String(),
      'numeroProcessoIesSemCodigoEmec': numeroProcessoIesSemCodigoEmec,
      'tipoProcessoIesSemCodigoEmec': tipoProcessoIesSemCodigoEmec,
      'dataCadastroIesSemCodigoEmec': dataCadastroIesSemCodigoEmec?.toIso8601String(),
      'dataProtocoloIesSemCodigoEmec': dataProtocoloIesSemCodigoEmec?.toIso8601String(),
      'perfilTipoMedia': perfilTipoMedia,
      'nomeAssinanteTermoResponsabilidade': nomeAssinanteTermoResponsabilidade,
      'cpfAssinanteTermoResponsabilidade': cpfAssinanteTermoResponsabilidade,
      'cargoAssinanteTermoResponsabilidade': cargoAssinanteTermoResponsabilidade,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  IesEmissoraModel copyWith({
    int? iesEmissoraID,
    String? nome,
    int? codigoMec,
    String? cnpj,
    String? enderecoLogradouro,
    String? enderecoBairro,
    String? enderecoCodigoMunicipio,
    String? enderecoNomeMunicipio,
    String? enderecoUf,
    String? enderecoCep,
    String? credenciamentoTipo,
    String? credenciamentoNumero,
    DateTime? credenciamentoData,
    String? numeroProcessoIesSemCodigoEmec,
    String? tipoProcessoIesSemCodigoEmec,
    DateTime? dataCadastroIesSemCodigoEmec,
    DateTime? dataProtocoloIesSemCodigoEmec,
    String? perfilTipoMedia,
    String? nomeAssinanteTermoResponsabilidade,
    String? cpfAssinanteTermoResponsabilidade,
    String? cargoAssinanteTermoResponsabilidade,
  }) {
    return IesEmissoraModel(
      iesEmissoraID: iesEmissoraID ?? this.iesEmissoraID,
      nome: nome ?? this.nome,
      codigoMec: codigoMec ?? this.codigoMec,
      cnpj: cnpj ?? this.cnpj,
      enderecoLogradouro: enderecoLogradouro ?? this.enderecoLogradouro,
      enderecoBairro: enderecoBairro ?? this.enderecoBairro,
      enderecoCodigoMunicipio: enderecoCodigoMunicipio ?? this.enderecoCodigoMunicipio,
      enderecoNomeMunicipio: enderecoNomeMunicipio ?? this.enderecoNomeMunicipio,
      enderecoUf: enderecoUf ?? this.enderecoUf,
      enderecoCep: enderecoCep ?? this.enderecoCep,
      credenciamentoTipo: credenciamentoTipo ?? this.credenciamentoTipo,
      credenciamentoNumero: credenciamentoNumero ?? this.credenciamentoNumero,
      credenciamentoData: credenciamentoData ?? this.credenciamentoData,
      numeroProcessoIesSemCodigoEmec: numeroProcessoIesSemCodigoEmec ?? this.numeroProcessoIesSemCodigoEmec,
      tipoProcessoIesSemCodigoEmec: tipoProcessoIesSemCodigoEmec ?? this.tipoProcessoIesSemCodigoEmec,
      dataCadastroIesSemCodigoEmec: dataCadastroIesSemCodigoEmec ?? this.dataCadastroIesSemCodigoEmec,
      dataProtocoloIesSemCodigoEmec: dataProtocoloIesSemCodigoEmec ?? this.dataProtocoloIesSemCodigoEmec,
      perfilTipoMedia: perfilTipoMedia ?? this.perfilTipoMedia,
      nomeAssinanteTermoResponsabilidade: nomeAssinanteTermoResponsabilidade ?? this.nomeAssinanteTermoResponsabilidade,
      cpfAssinanteTermoResponsabilidade: cpfAssinanteTermoResponsabilidade ?? this.cpfAssinanteTermoResponsabilidade,
      cargoAssinanteTermoResponsabilidade: cargoAssinanteTermoResponsabilidade ?? this.cargoAssinanteTermoResponsabilidade,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'IesEmissoraModel('
        'iesEmissoraID: $iesEmissoraID, '
        'nome: $nome, '
        'codigoMec: $codigoMec, '
        'cnpj: $cnpj, '
        'enderecoLogradouro: $enderecoLogradouro, '
        'enderecoBairro: $enderecoBairro, '
        'enderecoCodigoMunicipio: $enderecoCodigoMunicipio, '
        'enderecoNomeMunicipio: $enderecoNomeMunicipio, '
        'enderecoUf: $enderecoUf, '
        'enderecoCep: $enderecoCep, '
        'credenciamentoTipo: $credenciamentoTipo, '
        'credenciamentoNumero: $credenciamentoNumero, '
        'credenciamentoData: $credenciamentoData, '
        'numeroProcessoIesSemCodigoEmec: $numeroProcessoIesSemCodigoEmec, '
        'tipoProcessoIesSemCodigoEmec: $tipoProcessoIesSemCodigoEmec, '
        'dataCadastroIesSemCodigoEmec: $dataCadastroIesSemCodigoEmec, '
        'dataProtocoloIesSemCodigoEmec: $dataProtocoloIesSemCodigoEmec, '
        'perfilTipoMedia: $perfilTipoMedia, '
        'nomeAssinanteTermoResponsabilidade: $nomeAssinanteTermoResponsabilidade, '
        'cpfAssinanteTermoResponsabilidade: $cpfAssinanteTermoResponsabilidade, '
        'cargoAssinanteTermoResponsabilidade: $cargoAssinanteTermoResponsabilidade'
        ')';
  }
}
