/// Interface for HTTP header service
/// Responsible for building HTTP headers including authentication tokens
abstract interface class HeaderBuilder {
  /// Get standard headers with optional authentication
  ///
  /// [includeAuth] - If true, includes Bearer token in Authorization header
  /// Returns a map of header key-value pairs
  Future<Map<String, String>> getHeaders({bool includeAuth = true});

  /// Get headers with custom Prefer header value
  /// Commonly used for Supabase operations like 'return=representation'
  ///
  /// [preferValue] - The value for the Prefer header
  /// Returns a map of header key-value pairs including the Prefer header
  Future<Map<String, String>> getHeadersWithPrefer(String preferValue);

  /// Get headers with Range header for pagination
  /// Used for Supabase pagination to specify the range of records to fetch
  ///
  /// [start] - The starting index (0-based)
  /// [end] - The ending index (0-based)
  /// Returns a map of header key-value pairs including the Range header
  ///
  /// Example:
  /// ```dart
  /// final headers = await headerBuilder.getHeadersWithRange(start: 0, end: 19);
  /// // Returns headers with: 'Range': '0-19'
  /// ```
  Future<Map<String, String>> getHeadersWithRange({
    required int start,
    required int end,
  });
}
