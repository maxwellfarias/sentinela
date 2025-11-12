import 'dart:developer' as dev;
/// Esta classe é responsável por registrar logs da aplicação.
/// Ela fornece métodos para registrar mensagens de informação, aviso, erro e depuração.
/// `info`, `warning`, `error` e `debug` são os métodos principais para registrar mensagens com diferentes níveis de severidade.
/// `name:` Geralmente é utilizado o nome do componente/classe que está registrando o log.
class AppLogger {
  static void info(String message, {String? tag}) {
    dev.log(message, name: tag ?? 'App', level: 800);
  }

  static void warning(String message, {String? tag, Object? error}) {
    dev.log(message, name: tag ?? 'App', error: error, level: 900);
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    dev.log(
      message,
      name: tag ?? 'App',
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
      level: 1000,
    );
  }

  static void debug(String message, {String? tag}) {
    dev.log(message, name: tag ?? 'App', level: 700);
  }
}