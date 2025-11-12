/// Modelo de domínio para documento em formato Base64
///
/// Representa um documento armazenado em Base64 associado a um aluno,
/// incluindo informações de criação e atualização.
final class DocumentoBase64Model {
  final int alunoId;
  final String base64Conteudo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentoBase64Model({
    required this.alunoId,
    required this.base64Conteudo,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância a partir de um JSON
  factory DocumentoBase64Model.fromJson(dynamic json) {
    return DocumentoBase64Model(
      alunoId: json['aluno_id'] ?? 0,
      base64Conteudo: json['base64Conteudo'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  /// Converte a instância para JSON
  Map<String, dynamic> toJson() {
    return {
      'aluno_id': alunoId,
      'base64_conteudo': base64Conteudo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Cria uma cópia do modelo com alguns campos atualizados
  DocumentoBase64Model copyWith({
    int? alunoId,
    String? base64Conteudo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentoBase64Model(
      alunoId: alunoId ?? this.alunoId,
      base64Conteudo: base64Conteudo ?? this.base64Conteudo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'DocumentoBase64Model('
        'alunoId: $alunoId, '
        'base64Conteudo: ${base64Conteudo.length > 50 ? '${base64Conteudo.substring(0, 50)}...' : base64Conteudo}, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}