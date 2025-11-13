import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:palliative_care/core/interfaces/logger.dart';
import 'package:palliative_care/data/services/local/local_secure_storage/local_secure_storage.dart';
import 'package:palliative_care/exceptions/app_exception.dart';
import 'package:palliative_care/utils/result.dart';

final class LocalSecureStorageImpl implements LocalSecureStorage {
  final FlutterSecureStorage _storage;
  final Logger _logger;
  static const String _logTag = 'LocalSecureStorage';

  LocalSecureStorageImpl({
    required FlutterSecureStorage storage,
    required Logger logger,
  })  : _storage = storage,
        _logger = logger;
  
  @override
  Future<Result<void>> delete({required String key}) async {
   try {
    // Verify if the key exists before attempting to delete
    final existingValue = await _storage.read(key: key);
    
    if (existingValue == null) {
      _logger.error('Key not found: $key', tag: _logTag);
      return Result.error(UnknownErrorException());
    }

    await _storage.delete(key: key);
    return Result.ok(null);
  } catch (e, s) {
    _logger.error('Failed to delete key: $e', error: e, stackTrace: s, tag: _logTag);
    return Result.error(UnknownErrorException());
  }
  }

  @override
  Future<Result<String>> read({required String key}) async {
    try {
      final value = await _storage.read(key: key);
      if (value == null) {
        _logger.error('Key not found: $key', tag: _logTag);
        return Result.error(UnknownErrorException());
      }
      return Result.ok(value);
    } catch (e, s) {
      _logger.error('Failed to read key: $e', error: e, stackTrace: s, tag: _logTag);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<void>> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
      return Result.ok(null);
    } catch (e, s) {
      _logger.error('Failed to write key: $e', error: e, stackTrace: s, tag: _logTag);
      return Result.error(UnknownErrorException());
    }
  }
  
  @override
  Future<Result<String>> getApiKey({required String key}) async {
    final response = dotenv.env[key] ?? '';
    return response.isNotEmpty ? Result.ok(response) : Result.error(UnknownErrorException());
  }
}

