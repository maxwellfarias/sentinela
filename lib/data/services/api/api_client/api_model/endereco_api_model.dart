final class EnderecoApiModel {
  /// Rua, Avenida, etc.
  final String logradouro;
  final String bairro;
  final String estado;
  /// Cidade
  final String localidade;
  final String uf;
  final String codigoMunicipio;
  final String cep;

  EnderecoApiModel({
    required this.logradouro,
    required this.bairro,
    required this.estado,
    required this.localidade,
    required this.uf,
    required this.codigoMunicipio,
    required this.cep,
  });

  EnderecoApiModel.fromJson(dynamic json)
    : logradouro = json['logradouro'],
      bairro = json['bairro'],
      estado = json['estado'],
      localidade = json['localidade'],
      uf = json['uf'],
      codigoMunicipio = json['ibge'],
      cep = json['cep'];
}
