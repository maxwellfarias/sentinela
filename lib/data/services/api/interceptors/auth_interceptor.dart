import 'dart:async';
import 'package:dio/dio.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentinela/data/services/api/endpoint_builder/endpoint_builder_impl.dart';
import 'package:sentinela/data/services/local/local_secure_storage/local_secure_storage.dart';
import 'package:sentinela/data/services/logger/logger.dart';

/// Dio interceptor for automatic token management
///
/// This interceptor automatically:
/// - Adds Authorization Bearer token to all requests
/// - Refreshes tokens when expired (60s buffer)
/// - Handles 401 responses with automatic token refresh and retry
/// - Queues requests during token refresh to avoid race conditions
class AuthInterceptor extends QueuedInterceptorsWrapper {
  final LocalSecureStorage _storage;
  final Logger _logger;
  final Dio _dio;

  static const String _logTag = 'AuthInterceptor';
  static const int _tokenRefreshBufferSeconds = 60;

  /// Synchronization mechanism for token refresh operations
  ///
  /// These fields work together to prevent race conditions when multiple
  /// requests need to refresh tokens simultaneously:
  ///
  /// - `_isRefreshing`: A boolean flag that indicates if a token refresh
  ///   operation is currently in progress.
  ///
  /// - `_refreshCompleter`: A Completer that acts as a synchronization point.
  ///   When a refresh is in progress, other requests await the completer's
  ///   future. Once the refresh completes, the completer is completed,
  ///   releasing all waiting requests.
  ///
  /// How it works:
  /// 1. First request detects expired token, sets _isRefreshing = true
  /// 2. Creates a new Completer and starts the refresh operation
  /// 3. Subsequent requests see _isRefreshing = true and await the completer
  /// 4. When refresh finishes, the completer is completed (success or failure)
  /// 5. All waiting requests are released and can proceed with the new token
  /// 6. The completer is reset (set to null) for the next refresh cycle
  ///
  /// Important: The completer must be recreated for each refresh cycle because
  /// a Completer can only be completed once. Reusing the same completer would
  /// cause subsequent refresh operations to fail.
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  AuthInterceptor({
    required LocalSecureStorage storage,
    required Logger logger,
    required Dio dio,
  })  : _storage = storage,
        _logger = logger,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Skip token injection for auth endpoints (login, refresh)
      if (_isAuthEndpoint(options.path)) {
        _logger.info('Skipping token injection for auth endpoint', tag: _logTag);
        return handler.next(options);
      }

      // Wait if a refresh is in progress
      // This prevents race conditions where multiple requests try to refresh
      // the token simultaneously. Only the first request performs the refresh,
      // while others wait for it to complete.
      if (_isRefreshing) {
        final completer = _refreshCompleter;
        if (completer != null) {
          _logger.info('Waiting for token refresh to complete', tag: _logTag);
          await completer.future;
        }
      }

      // Check if token needs refresh
      final shouldRefresh = await _shouldRefreshToken();
      if (shouldRefresh) {
        _logger.info('Token expired or about to expire, refreshing', tag: _logTag);
        final refreshed = await _refreshToken();
        if (!refreshed) {
          _logger.error('Token refresh failed, clearing tokens', tag: _logTag);
          await _clearTokens();
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionTimeout,
              message: 'Session expired. Please login again.',
            ),
          );
        }
      }

      // Add Authorization header with bearer token
      final tokenResult = await _storage.read(key: 'bearer_token');
      if (tokenResult.isOk) {
        final token = tokenResult.getSuccessOrNull();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          _logger.info('Added Authorization header to request', tag: _logTag);
        }
      }

      return handler.next(options);
    } catch (e, s) {
      _logger.error('Error in request interceptor', tag: _logTag, error: e, stackTrace: s);
      return handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - attempt token refresh and retry
    if (err.response?.statusCode == 401) {
      _logger.warning('Received 401 Unauthorized, attempting token refresh', tag: _logTag);

      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the original request with new token
          final options = err.requestOptions;
          final tokenResult = await _storage.read(key: 'bearer_token');

          final token = tokenResult.getSuccessOrNull();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';

            _logger.info('Retrying request with new token', tag: _logTag);
            final response = await _dio.fetch(options);
            return handler.resolve(response);
          }
        }

        // Refresh failed, clear tokens
        _logger.error('Token refresh failed on 401, clearing session', tag: _logTag);
        await _clearTokens();
      } catch (e, s) {
        _logger.error('Error handling 401 response', tag: _logTag, error: e, stackTrace: s);
      }
    }

    return handler.next(err);
  }

  /// Check if the request is to an auth endpoint
  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/v1/token') ||
           path.contains('/auth/v1/logout') ||
           path.contains('/auth/v1/signup');
  }

  /// Check if token should be refreshed
  /// Returns true if token is expired or will expire in less than 60 seconds
  Future<bool> _shouldRefreshToken() async {
    try {
      final expiresAtResult = await _storage.read(key: 'token_expires_at');

      final expiresAtStr = expiresAtResult.getSuccessOrNull();
      if (expiresAtStr == null || expiresAtStr.isEmpty) {
        return false;
      }

      final expiresAt = int.tryParse(expiresAtStr) ?? 0;

      if (expiresAt == 0) {
        return false;
      }

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final shouldRefresh = (expiresAt - now) < _tokenRefreshBufferSeconds;

      if (shouldRefresh) {
        _logger.info('Token will expire in ${expiresAt - now}s, refreshing', tag: _logTag);
      }

      return shouldRefresh;
    } catch (e, s) {
      _logger.error('Error checking token expiration', tag: _logTag, error: e, stackTrace: s);
      return false;
    }
  }

  /// Refresh the access token using the refresh token
  ///
  /// This method implements a synchronization mechanism to prevent multiple
  /// simultaneous token refresh operations (race condition prevention):
  ///
  /// 1. If a refresh is already in progress (_isRefreshing = true), this
  ///    method waits for the existing refresh to complete rather than
  ///    starting a new one.
  ///
  /// 2. The first caller sets _isRefreshing = true and creates a new
  ///    Completer, which subsequent callers will await.
  ///
  /// 3. The refresh operation executes (HTTP request to refresh endpoint).
  ///
  /// 4. In the finally block:
  ///    - _isRefreshing is set to false
  ///    - The completer is completed, releasing all waiting requests
  ///    - The completer is reset to null for the next refresh cycle
  ///
  /// Returns true if refresh succeeded, false otherwise.
  Future<bool> _refreshToken() async {
    // Check if another request is already refreshing the token
    // If so, wait for it to complete instead of starting a new refresh
    if (_isRefreshing) {
      _logger.info('Token refresh already in progress, waiting', tag: _logTag);
      final completer = _refreshCompleter;
      if (completer != null) {
        await completer.future;
      }
      // Return true assuming the refresh was successful
      // The waiting request will use the newly refreshed token
      return true;
    }

    // Mark that we're starting a refresh operation
    _isRefreshing = true;

    // Create a new Completer for this refresh cycle
    // This MUST be created fresh for each refresh because a Completer
    // can only be completed once
    _refreshCompleter = Completer<void>();

    try {
      final refreshTokenResult = await _storage.read(key: 'refresh_token');
      final refreshToken = refreshTokenResult.getSuccessOrNull();
      if (refreshToken == null || refreshToken.isEmpty) {
        _logger.error('No refresh token available', tag: _logTag);
        return false;
      }
      final endpoint = EndpointBuilderImpl.refreshToken;
      final apiKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

      _logger.info('Refreshing token...', tag: _logTag);

      final response = await _dio.post(
        endpoint.url,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {
            'apikey': apiKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Parse and store new tokens
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;
        final expiresIn = data['expires_in'] as int?;

        if (newAccessToken != null && newRefreshToken != null && expiresIn != null) {
          await _storage.write(key: 'bearer_token', value: newAccessToken);
          await _storage.write(key: 'refresh_token', value: newRefreshToken);

          final expiresAt = DateTime.now().millisecondsSinceEpoch ~/ 1000 + expiresIn;
          await _storage.write(key: 'token_expires_at', value: expiresAt.toString());

          _logger.info('Token refreshed successfully', tag: _logTag);
          return true;
        }
      }

      _logger.error('Invalid response from token refresh', tag: _logTag);
      return false;
    } catch (e, s) {
      _logger.error('Token refresh failed', tag: _logTag, error: e, stackTrace: s);
      return false;
    } finally {
      // Reset the refresh flag to allow future refresh operations
      _isRefreshing = false;

      // Complete the completer to release all waiting requests
      // Check if it's not already completed to avoid errors
      final completer = _refreshCompleter;
      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }

      // Reset the completer to null for the next refresh cycle
      // This is crucial: a new Completer must be created for each refresh
      // because a Completer can only be completed once
      _refreshCompleter = null;
    }
  }

  /// Clear all stored tokens
  Future<void> _clearTokens() async {
    await _storage.delete(key: 'bearer_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'token_expires_at');
    _logger.info('Tokens cleared', tag: _logTag);
  }
}
