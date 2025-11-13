import 'dart:developer' as dev;

import 'package:sentinela/data/services/logger/logger.dart';

/// Implementação concreta do Logger usando dart:developer.
///
/// Esta classe registra logs utilizando o pacote nativo do Dart para logging.
/// Os logs são categorizados por níveis de severidade:
/// - debug: 700
/// - info: 800
/// - warning: 900
/// - error: 1000
class AppLoggerImpl implements Logger {
  @override
  void info(String message, {String? tag}) {
    dev.log(message, name: tag ?? 'App', level: 800);
  }

  @override
  void warning(String message, {String? tag, Object? error}) {
    dev.log(message, name: tag ?? 'App', error: error, level: 900);
  }

  @override
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    dev.log(
      message,
      name: tag ?? 'App',
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
      level: 1000,
    );
  }

  @override
  void debug(String message, {String? tag}) {
    dev.log(message, name: tag ?? 'App', level: 700);
  }
}
