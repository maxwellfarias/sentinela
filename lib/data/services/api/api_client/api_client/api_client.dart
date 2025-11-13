import 'package:sentinela/config/constants/http_types.dart';
import 'package:sentinela/utils/result.dart';

/// Response data for paginated requests
typedef PaginatedRequestResponse = ({
  dynamic data,
  Map<String, dynamic> headers,
});

abstract interface class ApiClient {
  Future<Result<dynamic>> request({required ({String url, HttpMethod method}) endpoint, Map<String, dynamic>? body, Map<String, String>? headers});

  /// Makes a paginated request and returns both data and headers
  ///
  /// This method is specifically for pagination requests where we need
  /// to access response headers (like Content-Range) to extract pagination metadata.
  ///
  /// Returns a Result containing a record with:
  /// - data: The response body
  /// - headers: The response headers (including Content-Range)
  Future<Result<PaginatedRequestResponse>> paginatedRequest({
    required ({String url, HttpMethod method}) endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });
}
