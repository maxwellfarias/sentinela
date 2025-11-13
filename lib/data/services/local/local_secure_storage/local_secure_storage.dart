import 'package:palliative_care/utils/result.dart';

abstract interface class LocalSecureStorage {
  Future<Result<dynamic>> write({required String key, required String value});
  Future<Result<String>> read({required String key});
  Future<Result<dynamic>> delete({required String key});
  Future<Result<String>> getApiKey({required String key});
}