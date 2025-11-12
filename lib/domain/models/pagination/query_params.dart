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
