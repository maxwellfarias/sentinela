import 'package:w3_diploma/utils/result.dart';

enum DioErros implements Exception {
  badRequest,
  notFound,
  serverError,
  unauthorized,
  forbidden,
  invalidData,
  methodNotAllowed,
}

enum MetodoHttp {
  get,
  post,
  put,
  delete,
}

abstract interface class ApiClient {
  Future<Result<dynamic>> request({required String url, required MetodoHttp metodo, Map? body, Map? headers});
}