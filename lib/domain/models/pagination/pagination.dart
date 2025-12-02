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

/// Parâmetros de consulta para paginação, busca e ordenação
///
/// Representa os parâmetros que podem ser enviados para a API:
/// - Page: Número da página (default: 1)
/// - PageSize: Itens por página (default: 10)
/// - Search: Termo de busca (opcional)
/// - SortBy: Campo para ordenação (opcional)
/// - SortOrder: Direção da ordenação - "asc" ou "desc" (opcional)
///
/// Exemplo de uso:
/// ```dart
/// final params = QueryParams(
///   page: 2,
///   pageSize: 20,
///   search: 'Beatriz',
///   sortBy: 'nome',
///   sortOrder: 'desc',
/// );
///
/// final queryString = params.toQueryString();
/// // Resultado: "Page=2&PageSize=20&Search=Beatriz&SortBy=nome&SortOrder=desc"
/// ```
final class QueryParams {
  /// Número da página (começa em 1)
  final int page;

  /// Quantidade de itens por página
  final int pageSize;

  /// Termo de busca (opcional)
  final String? search;

  /// Campo para ordenação (opcional)
  /// Exemplos: "nome", "cpf", "dataNascimento"
  final String? sortBy;

  /// Direção da ordenação: "asc" (crescente) ou "desc" (decrescente)
  final String? sortOrder;

  const QueryParams({
    this.page = 1,
    this.pageSize = 20,
    this.search,
    this.sortBy,
    this.sortOrder,
  }) : assert(page > 0, 'Page deve ser maior que 0'),
       assert(pageSize > 0, 'PageSize deve ser maior que 0'),
       assert(sortOrder == null || sortOrder == 'asc' || sortOrder == 'desc',
           'SortOrder deve ser "asc" ou "desc"');

  /// Converte os parâmetros em uma query string para requisição HTTP
  ///
  /// Exemplo: "Page=1&PageSize=10&Search=Beatriz&SortBy=nome&SortOrder=desc"
  ///
  /// Parâmetros nulos ou vazios são omitidos da query string
  String toQueryString() {
    final params = <String, dynamic>{
      'Page': page,
      'PageSize': pageSize,
      if (search != null && search!.isNotEmpty) 'Search': search,
      if (sortBy != null && sortBy!.isNotEmpty) 'SortBy': sortBy,
      if (sortOrder != null && sortOrder!.isNotEmpty) 'SortOrder': sortOrder,
    };

    return params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }

  /// Cria uma cópia da instância com os valores especificados alterados
  QueryParams copyWith({
    int? page,
    int? pageSize,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) {
    return QueryParams(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Retorna true se há algum filtro de busca ou ordenação aplicado
  bool get hasFilters =>
      (search != null && search!.isNotEmpty) ||
      (sortBy != null && sortBy!.isNotEmpty);

  /// Reseta todos os filtros mantendo apenas page e pageSize
  QueryParams clearFilters() {
    return QueryParams(
      page: 1,
      pageSize: pageSize,
    );
  }

  /// Reseta para a primeira página mantendo os outros parâmetros
  QueryParams resetToFirstPage() {
    return copyWith(page: 1);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QueryParams &&
        other.page == page &&
        other.pageSize == pageSize &&
        other.search == search &&
        other.sortBy == sortBy &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    return Object.hash(
      page,
      pageSize,
      search,
      sortBy,
      sortOrder,
    );
  }

  @override
  String toString() {
    final filters = <String>[];
    filters.add('page: $page');
    filters.add('pageSize: $pageSize');
    if (search != null && search!.isNotEmpty) filters.add('search: "$search"');
    if (sortBy != null) filters.add('sortBy: $sortBy');
    if (sortOrder != null) filters.add('sortOrder: $sortOrder');

    return 'QueryParams(${filters.join(', ')})';
  }
}