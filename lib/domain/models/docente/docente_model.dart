/// Modelo de domínio para Docente
///
/// Representa um docente no sistema com todos os dados necessários
/// conforme a tabela SQL docente.
final class DocenteModel {
  final int id;
  final String nome;
  final String titulacao;
  final String? cpf;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  const DocenteModel({
    required this.id,
    required this.nome,
    required this.titulacao,
    this.cpf,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  factory DocenteModel.fromJson(dynamic json) {
    return DocenteModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nome: json['nome'] as String,
      titulacao: json['titulacao'] as String,
      cpf: json['cpf'] as String?,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
      dataAtualizacao: DateTime.parse(json['dataAtualizacao'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'titulacao': titulacao,
      'cpf': cpf,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataAtualizacao': dataAtualizacao.toIso8601String(),
    };
  }

  DocenteModel copyWith({
    int? id,
    String? nome,
    String? titulacao,
    String? cpf,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    return DocenteModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      titulacao: titulacao ?? this.titulacao,
      cpf: cpf ?? this.cpf,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return 'DocenteModel('
        'id: $id, '
        'nome: $nome, '
        'titulacao: $titulacao, '
        'cpf: $cpf, '
        'dataCriacao: $dataCriacao, '
        'dataAtualizacao: $dataAtualizacao'
        ')';
  }
}
