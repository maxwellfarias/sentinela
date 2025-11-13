
import 'package:sentinela/config/constants/http_types.dart';
import 'package:sentinela/data/services/api/endpoint_builder/endpoint_builder.dart';

/// Implementation of EndpointBuilder for building Supabase API endpoints
///
/// This class is responsible for building URLs and HTTP methods for CRUD operations
/// against Supabase tables. The endpoint is fixed in the constructor, so callers
/// don't need to specify it for each method call.
///
/// Example usage:
/// ```dart
/// final builder = EndpointBuilderImpl(endpoint: Endpoint.medication);
/// final endpoint = builder.create();
/// // Returns: (url: 'https://...supabase.co/rest/v1/medications', method: HttpMethod.post)
/// ```
final class EndpointBuilderImpl implements EndpointBuilder {
  EndpointBuilderImpl({required Endpoint endpoint}) : _endpoint = endpoint;
  final Endpoint _endpoint;

  static const String _baseUrl = 'https://hqvximqtoskulhfltzvr.supabase.co';
  static const String _restUrl = '/rest/v1/';
  static const String _authUrl = '/auth/v1/';

  @override
  ({String url, HttpMethod method}) create() {
    return (
      url: '$_baseUrl$_restUrl${_endpoint.url}',
      method: HttpMethod.post,
    );
  }

  @override
  ({String url, HttpMethod method}) update({required String id}) {
    return (
      url: '$_baseUrl$_restUrl${_endpoint.url}?id=eq.$id',
      method: HttpMethod.patch,
    );
  }

  @override
  ({String url, HttpMethod method}) getAll({Map<String, String>? filters}) {
    var url = '$_baseUrl$_restUrl${_endpoint.url}?select=*';
    if (filters != null && filters.isNotEmpty) {
      url += '&${_buildFilters(filters)}';
    }
    return (url: url, method: HttpMethod.get);
  }

  @override
  ({String url, HttpMethod method}) delete({required String id}) {
    return (
      url: '$_baseUrl$_restUrl${_endpoint.url}?id=eq.$id',
      method: HttpMethod.delete,
    );
  }

  @override
  ({String url, HttpMethod method}) getFilter({
    required Map<String, String> queryParameters,
  }) {
    return (
      url: '$_baseUrl$_restUrl${_endpoint.url}?select=*&${_buildFilters(queryParameters)}',
      method: HttpMethod.get,
    );
  }

  @override
  ({String url, HttpMethod method}) getAllPaginated({
    required int offset,
    required int limit,
    Map<String, String>? filters,
  }) {
    var url = '$_baseUrl$_restUrl${_endpoint.url}?select=*';

    if (filters != null && filters.isNotEmpty) {
      url += '&${_buildFilters(filters)}';
    }

    // Add offset and limit for pagination
    url += '&offset=$offset&limit=$limit';

    return (url: url, method: HttpMethod.get);
  }


  /// Endpoint for Measurement
  


//Summary
@override
({String url, HttpMethod method}) getSummary({required String patientId}) {
    final url = switch (_endpoint) {
      Endpoint.heartRate => 'heart_rate_summary',
      Endpoint.bloodPressure => 'blood_pressure_summary',
      Endpoint.temperature => 'temperature_summary',
      Endpoint.respiratoryRate => 'respiratory_rate_summary',
      Endpoint.oxygenSaturation => 'oxygen_saturation_summary',
      Endpoint.glucose => 'glucose_summary',
      Endpoint.painLevel => 'pain_level_summary',
      Endpoint.medication => 'medication_summary',
    };

    return (
      url: '$_baseUrl$_restUrl$url?select=*&patient_id=eq.$patientId',
      method: HttpMethod.get,
    );
  }




  /// Sign in endpoint (POST)
  ///
  /// Returns URL and method for authenticating with email/password.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = builder.signIn;
  /// // url: 'https://...supabase.co/auth/v1/token?grant_type=password'
  /// // method: HttpMethod.post
  /// ```
  static ({String url, HttpMethod method}) get signIn => (
        url: '$_baseUrl${_authUrl}token?grant_type=password',
        method: HttpMethod.post,
      );

  /// Sign out endpoint (POST)
  ///
  /// Returns URL and method for logging out the current user.
  /// Requires Authorization Bearer token in headers.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = builder.signOut;
  /// // url: 'https://...supabase.co/auth/v1/logout'
  /// // method: HttpMethod.post
  /// ```
  static ({String url, HttpMethod method}) get signOut => (
        url: '$_baseUrl${_authUrl}logout',
        method: HttpMethod.post,
      );

  /// Refresh token endpoint (POST)
  ///
  /// Returns URL and method for refreshing the access token.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = builder.refreshToken;
  /// // url: 'https://...supabase.co/auth/v1/token?grant_type=refresh_token'
  /// // method: HttpMethod.post
  /// ```
  static ({String url, HttpMethod method}) get refreshToken => (
        url: '$_baseUrl${_authUrl}token?grant_type=refresh_token',
        method: HttpMethod.post,
      );

  /// Sign up endpoint (POST)
  ///
  /// Returns URL and method for creating a new user with email/password.
  ///
  /// Example:
  /// ```dart
  /// final endpoint = EndpointBuilderImpl.signUp;
  /// // url: 'https://...supabase.co/auth/v1/signup'
  /// // method: HttpMethod.post
  /// ```
  static ({String url, HttpMethod method}) get signUp => (
        url: '$_baseUrl${_authUrl}signup',
        method: HttpMethod.post,
      );

  /// Build filter query string
  ///
  /// Converts a map of filters into Supabase query format.
  /// Each filter uses the 'eq' (equals) operator.
  ///
  /// Example:
  /// ```dart
  /// _buildFilters({'user_id': '123', 'status': 'active'})
  /// // Returns: 'user_id=eq.123&status=eq.active'
  /// ```
  static String _buildFilters(Map<String, String> filters) {
    return filters.entries.map((e) => '${e.key}=eq.${e.value}').join('&');
  }
}
