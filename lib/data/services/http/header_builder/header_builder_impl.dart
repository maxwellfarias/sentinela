import 'package:palliative_care/core/interfaces/logger.dart';
import 'package:palliative_care/data/model/login_response_api_model.dart';
import 'package:palliative_care/data/services/api/auth_api_client/auth_api_client.dart';
import 'package:palliative_care/data/services/api/http/header_builder/header_builder.dart';
import 'package:palliative_care/data/services/local/local_secure_storage/local_secure_storage.dart';
import 'package:palliative_care/utils/result.dart';

/// Implementation of HttpHeaderService
/// Manages HTTP headers including API keys and authentication tokens
final class HeaderBuilderImpl implements HeaderBuilder {
  final LocalSecureStorage _storage;
  final Logger _logger;
  final AuthApiClient _authApiClient;
  final String _logTag = 'HttpHeaderServiceImpl';

  // Cache API key since it doesn't change during app lifecycle
  String? _cachedApiKey;

  HeaderBuilderImpl({
    required LocalSecureStorage storage,
    required Logger logger,
    required AuthApiClient authApiClient,
  })  : _storage = storage,
        _logger = logger,
        _authApiClient = authApiClient;

  @override
  Future<Map<String, String>> getHeaders({bool includeAuth = true}) async {
    final apiKey = await _getApiKey();

    final headers = <String, String>{
      'apikey': apiKey,
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await _getBearerToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  @override
  Future<Map<String, String>> getHeadersWithPrefer(String preferValue) async {
    final headers = await getHeaders();
    headers['Prefer'] = preferValue;
    return headers;
  }

  @override
  Future<Map<String, String>> getHeadersWithRange({
    required int start,
    required int end,
  }) async {
    final headers = await getHeaders();
    headers['Range'] = '$start-$end';
    return headers;
  }

  /// Get API key from storage with caching
  Future<String> _getApiKey() async {
    // Return cached value if available
    if (_cachedApiKey != null) {
      return _cachedApiKey!;
    }

    // Fetch from storage
    final result = await _storage.getApiKey(key: 'SUPABASE_PUBLISHABLE_KEY');

    return result.fold(
      onOk: (key) {
        _cachedApiKey = key;
        _logger.info('API key loaded successfully', tag: _logTag);
        return key;
      },
      onError: (exception) {
        _logger.error(
          'Failed to load API key from storage',
          error: exception,
          tag: _logTag,
        );
        return '';
      },
    );
  }

  /// Get bearer token from secure storage
  /// Returns null if token doesn't exist (user not logged in)
  /// Automatically refreshes token if expired
  Future<String?> _getBearerToken() async {
    final tokenResult = await _storage.read(key: 'bearer_token');
    final expiresAtResult = await _storage.read(key: 'token_expires_at');

    // Check if token exists
    final token = tokenResult.fold(
      onOk: (value) => value,
      onError: (_) => null,
    );

    if (token == null) {
      _logger.info('No bearer token found in storage', tag: _logTag);
      return null;
    }

    // Check if token is expired
    final isExpired = await _isTokenExpired(expiresAtResult);

    if (isExpired) {
      _logger.info('Token expired, attempting to refresh', tag: _logTag);
      return await _refreshAndGetToken();
    }

    return token;
  }

  /// Check if the token is expired based on the stored expiration timestamp
  Future<bool> _isTokenExpired(Result<String?> expiresAtResult) async {
    return expiresAtResult.fold(
      onOk: (expiresAtStr) {
        if (expiresAtStr == null) return true;

        try {
          final expiresAt = int.parse(expiresAtStr);
          final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

          // Add 60 second buffer - refresh token if it expires in less than 1 minute
          return currentTimestamp >= (expiresAt - 60);
        } catch (e) {
          _logger.error('Error parsing token expiration time', error: e, tag: _logTag);
          return true; // Consider expired if we can't parse
        }
      },
      onError: (_) => true, // Consider expired if no expiration info
    );
  }

  /// Refresh the authentication token and update storage
  /// Returns the new access token or null if refresh failed
  Future<String?> _refreshAndGetToken() async {
    final refreshTokenResult = await _storage.read(key: 'refresh_token');

    // Get refresh token from result
    final refreshToken = refreshTokenResult.fold(
      onOk: (value) => value,
      onError: (_) => null,
    );

    if (refreshToken == null) {
      _logger.warning('No refresh token found, cannot refresh', tag: _logTag);
      await _clearTokens();
      return null;
    }

    // Call the refresh token API
    final result = await _authApiClient.refreshToken(refreshToken: refreshToken);

    return result.fold(
      onOk: (response) async {
        try {
          final loginModel = LoginResponseApiModel.fromJson(response);

          // Update all tokens in secure storage
          await _storage.write(key: 'bearer_token', value: loginModel.accessToken);
          await _storage.write(key: 'refresh_token', value: loginModel.refreshToken);
          await _storage.write(key: 'token_expires_at', value: loginModel.expiresAt.toString());

          _logger.info('Token refreshed and saved successfully', tag: _logTag);
          return loginModel.accessToken;
        } catch (e, s) {
          _logger.error('Error parsing refresh token response', error: e, stackTrace: s, tag: _logTag);
          await _clearTokens();
          return null;
        }
      },
      onError: (error) async {
        _logger.error('Failed to refresh token', error: error, tag: _logTag);
        await _clearTokens();
        return null;
      },
    );
  }

  /// Clear all authentication tokens from storage
  Future<void> _clearTokens() async {
    await _storage.delete(key: 'bearer_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'token_expires_at');
    _logger.info('All tokens cleared from storage', tag: _logTag);
  }
}
