/// Utility class for parsing HTTP response headers and metadata.
///
/// This class provides static methods for extracting pagination information
/// from HTTP response headers, particularly for Supabase's Range-based pagination.
final class ResponseParser {
  ResponseParser._();

  /// Parses the Content-Range header to extract pagination metadata.
  ///
  /// Supabase returns pagination information in the Content-Range header with format:
  /// - `Content-Range: 0-19/100` means items 0-19 of 100 total
  /// - `Content-Range: 20-39/100` means items 20-39 of 100 total
  /// - `Content-Range: */0` means no items available
  ///
  /// Returns a record with:
  /// - `start`: The starting index (0-based)
  /// - `end`: The ending index (0-based)
  /// - `total`: The total number of items available
  ///
  /// Example:
  /// ```dart
  /// final headers = {'content-range': '0-19/100'};
  /// final result = ResponseParser.parseContentRange(headers);
  /// print(result.start); // 0
  /// print(result.end); // 19
  /// print(result.total); // 100
  /// ```
  ///
  /// Throws [FormatException] if the header format is invalid.
  static ({int start, int end, int total}) parseContentRange(
    Map<String, dynamic> headers,
  ) {
    // Try different header key variations (case-insensitive)
    final contentRange =
        headers['content-range'] ??
        headers['Content-Range'] ??
        headers['CONTENT-RANGE'];

    if (contentRange == null) {
      throw FormatException(
        'Content-Range header not found in response headers',
      );
    }

    final rangeString = contentRange.toString();

    // Handle empty result case: */0
    if (rangeString.startsWith('*/')) {
      final total = int.tryParse(rangeString.substring(2)) ?? 0;
      return (start: 0, end: -1, total: total);
    }

    // Parse format: start-end/total
    final parts = rangeString.split('/');
    if (parts.length != 2) {
      throw FormatException(
        'Invalid Content-Range format: $rangeString. Expected format: start-end/total',
      );
    }

    final rangePart = parts[0];
    final totalPart = parts[1];

    final rangeParts = rangePart.split('-');
    if (rangeParts.length != 2) {
      throw FormatException(
        'Invalid Content-Range format: $rangeString. Expected format: start-end/total',
      );
    }

    final start = int.tryParse(rangeParts[0]);
    final end = int.tryParse(rangeParts[1]);
    final total = int.tryParse(totalPart);

    if (start == null || end == null || total == null) {
      throw FormatException(
        'Invalid Content-Range format: $rangeString. Could not parse integers',
      );
    }

    return (start: start, end: end, total: total);
  }

  /// Calculates whether there are more items to fetch based on Content-Range.
  ///
  /// Example:
  /// ```dart
  /// final headers = {'content-range': '0-19/100'};
  /// final hasMore = ResponseParser.hasMoreItems(headers);
  /// print(hasMore); // true (because end=19 < total=100)
  /// ```
  static bool hasMoreItems(Map<String, dynamic> headers) {
    try {
      final range = parseContentRange(headers);
      return range.end < range.total - 1;
    } catch (_) {
      return false;
    }
  }

  /// Extracts the total count from Content-Range header.
  ///
  /// Example:
  /// ```dart
  /// final headers = {'content-range': '0-19/100'};
  /// final total = ResponseParser.getTotalCount(headers);
  /// print(total); // 100
  /// ```
  static int getTotalCount(Map<String, dynamic> headers) {
    try {
      final range = parseContentRange(headers);
      return range.total;
    } catch (_) {
      return 0;
    }
  }
}
