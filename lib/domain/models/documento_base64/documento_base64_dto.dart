class SetDocumentoBase64Dto {
  final int alunoID;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, String> colunaEBase64;

  SetDocumentoBase64Dto({
    required this.alunoID,
    required this.createdAt,
    required this.updatedAt,
    required this.colunaEBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      'alunoID': alunoID,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'colunaEBase64': colunaEBase64,
    };
  }

  factory SetDocumentoBase64Dto.fromJson(Map<String, dynamic> json) {
    return SetDocumentoBase64Dto(
      alunoID: json['alunoID'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      colunaEBase64: Map<String, String>.from(json['colunaEBase64'] as Map),
    );
  }

  SetDocumentoBase64Dto copyWith({
    int? alunoID,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, String>? colunaEBase64,
  }) {
    return SetDocumentoBase64Dto(
      alunoID: alunoID ?? this.alunoID,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      colunaEBase64: colunaEBase64 ?? this.colunaEBase64,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SetDocumentoBase64Dto &&
        other.alunoID == alunoID &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        _mapEquals(other.colunaEBase64, colunaEBase64);
  }

  @override
  int get hashCode {
    return alunoID.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        colunaEBase64.hashCode;
  }

  bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (var key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'SetDocumentoBase64Dto(alunoID: $alunoID, createdAt: $createdAt, updatedAt: $updatedAt, colunaEBase64: $colunaEBase64)';
  }
}
