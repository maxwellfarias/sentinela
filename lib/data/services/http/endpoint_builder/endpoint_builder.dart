

import 'package:sentinela/config/constants/http_types.dart';

/// Interface for building API endpoints
///
/// Implementations of this interface are responsible for constructing
/// URLs and HTTP methods for CRUD operations on specific Supabase tables.
///
/// Each implementation should focus on a single endpoint/table,
/// receiving the endpoint type in the constructor.
abstract interface class EndpointBuilder {
  /// Create a new record (POST)
  ///
  /// Returns URL and method for creating a new record.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = builder.create();
  /// // Returns: (url: 'https://...supabase.co/rest/v1/medications', method: HttpMethod.post)
  /// ```
  ({String url, HttpMethod method}) create();

  /// Update an existing record (PATCH)
  ///
  /// Returns URL and method for updating a record by ID.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = builder.update(id: '123');
  /// // Returns: (url: 'https://...supabase.co/rest/v1/medications?id=eq.123', method: HttpMethod.patch)
  /// ```
  ({String url, HttpMethod method}) update({required String id});

  /// Get all records (GET)
  ///
  /// Returns URL and method for fetching all records.
  /// Optionally accepts filters to narrow down results.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = builder.getAll();
  /// // or with filters
  /// final filtered = builder.getAll(filters: {'user_id': '456'});
  /// ```
  ({String url, HttpMethod method}) getAll({Map<String, String>? filters});

  /// Delete a record (DELETE)
  ///
  /// Returns URL and method for deleting a record by ID.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = builder.delete(id: '123');
  /// ```
  ({String url, HttpMethod method}) delete({required String id});

  /// Get records with filters (GET)
  ///
  /// Returns URL and method for fetching records matching the specified filters.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = builder.getFilter(queryParameters: {'id': '123'});
  /// ```
  ({String url, HttpMethod method}) getFilter({
    required Map<String, String> queryParameters,
  });

  /// Get all records with pagination (GET)
  ///
  /// Returns URL and method for fetching paginated records.
  /// Uses offset and limit for pagination.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = builder.getAllPaginated(
  ///   offset: 0,
  ///   limit: 20,
  ///   filters: {'user_id': '456'},
  /// );
  /// // Returns: (url: 'https://...supabase.co/rest/v1/medications?select=*&user_id=eq.456&offset=0&limit=20', method: HttpMethod.get)
  /// ```
  ({String url, HttpMethod method}) getAllPaginated({
    required int offset,
    required int limit,
    Map<String, String>? filters,
  });

  ({String url, HttpMethod method}) getSummary({
    required String patientId,
  });
}
