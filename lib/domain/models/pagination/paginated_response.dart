/// Modelo genérico para respostas paginadas da API
///
/// Representa a estrutura padrão de paginação retornada pelo backend:
/// ```json
/// {
///   "data": [...],
///   "page": 1,
///   "pageSize": 10,
///   "totalRecords": 100,
///   "totalPages": 10,
///   "hasNextPage": true,
///   "hasPreviousPage": false
/// }
/// ```
///
/// Exemplo de uso:
/// ```dart
/// final response = PaginatedResponse<AlunoModel>.fromJson(
///   jsonData,
///   (json) => AlunoModel.fromJson(json),
/// );
/// ```
final class PaginatedResponse<T> {
  /// Lista de dados da página atual
  final List<T> data;

  /// Número da página atual (começa em 1)
  final int page;

  /// Quantidade de itens por página
  final int pageSize;

  /// Total de registros em todas as páginas
  final int totalRecords;

  /// Total de páginas disponíveis
  final int totalPages;

  /// Indica se existe próxima página
  final bool hasNextPage;

  /// Indica se existe página anterior
  final bool hasPreviousPage;

  const PaginatedResponse({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Cria uma instância de PaginatedResponse a partir de um JSON
  ///
  /// [json] - Mapa JSON com a estrutura de paginação
  /// [fromJsonT] - Função para converter cada item do array data para o tipo T
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalRecords: json['totalRecords'] as int,
      totalPages: json['totalPages'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
    );
  }

  /// Converte a instância para um mapa JSON
  ///
  /// [toJsonT] - Função para converter cada item do tipo T para Map
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'data': data.map((item) => toJsonT(item)).toList(),
      'page': page,
      'pageSize': pageSize,
      'totalRecords': totalRecords,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  /// Cria uma cópia da instância com os valores especificados alterados
  PaginatedResponse<T> copyWith({
    List<T>? data,
    int? page,
    int? pageSize,
    int? totalRecords,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginatedResponse<T>(
      data: data ?? this.data,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalRecords: totalRecords ?? this.totalRecords,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }

  /// Mapeia os dados para um novo tipo mantendo as informações de paginação
  ///
  /// Útil para transformar os dados sem recriar toda a estrutura de paginação
  PaginatedResponse<R> map<R>(R Function(T) transform) {
    return PaginatedResponse<R>(
      data: data.map(transform).toList(),
      page: page,
      pageSize: pageSize,
      totalRecords: totalRecords,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginatedResponse<T> &&
        other.data == data &&
        other.page == page &&
        other.pageSize == pageSize &&
        other.totalRecords == totalRecords &&
        other.totalPages == totalPages &&
        other.hasNextPage == hasNextPage &&
        other.hasPreviousPage == hasPreviousPage;
  }

  @override
  int get hashCode {
    return Object.hash(
      data,
      page,
      pageSize,
      totalRecords,
      totalPages,
      hasNextPage,
      hasPreviousPage,
    );
  }

  @override
  String toString() {
    return 'PaginatedResponse<$T>(page: $page/$totalPages, items: ${data.length}/$totalRecords, hasNext: $hasNextPage, hasPrevious: $hasPreviousPage)';
  }
}
