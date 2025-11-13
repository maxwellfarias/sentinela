/// Interface de logging da aplicação.
/// Define os contratos para registrar logs com diferentes níveis de severidade.
///
/// Implementações desta interface podem usar diferentes estratégias de logging
/// (console, arquivo, serviços remotos, etc.).
abstract interface class Logger {
  /// Registra uma mensagem informativa.
  ///
  /// [message] A mensagem a ser registrada.
  /// [tag] Tag opcional para categorizar o log (geralmente o nome da classe).
  void info(String message, {String? tag});

  /// Registra uma mensagem de aviso.
  ///
  /// [message] A mensagem a ser registrada.
  /// [tag] Tag opcional para categorizar o log (geralmente o nome da classe).
  /// [error] Objeto de erro opcional associado ao aviso.
  void warning(String message, {String? tag, Object? error});

  /// Registra uma mensagem de erro.
  ///
  /// [message] A mensagem a ser registrada.
  /// [tag] Tag opcional para categorizar o log (geralmente o nome da classe).
  /// [error] Objeto de erro opcional associado.
  /// [stackTrace] Stack trace opcional para rastreamento de erro.
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace});

  /// Registra uma mensagem de depuração.
  ///
  /// [message] A mensagem a ser registrada.
  /// [tag] Tag opcional para categorizar o log (geralmente o nome da classe).
  void debug(String message, {String? tag});
}
