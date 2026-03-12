/// Structured logging service.
/// Only prints to console in debug mode. In production, logs are silent
/// (ready to be forwarded to Sentry/Crashlytics when integrated).
enum LogLevel { debug, info, warning, error }

class LoggerService {
  static void log(
    String message, {
    LogLevel level = LogLevel.info,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Only print in debug mode (assert blocks are stripped in release)
    assert(() {
      final prefix = '[${level.name.toUpperCase()}]';
      final dataStr = data != null ? ' $data' : '';
      final errorStr = error != null ? '\n  Error: $error' : '';
      final stackStr = stackTrace != null ? '\n  Stack: $stackTrace' : '';
      // ignore: avoid_print
      print('$prefix $message$dataStr$errorStr$stackStr');
      return true;
    }());
  }

  static void debug(String message, {Map<String, dynamic>? data}) =>
      log(message, level: LogLevel.debug, data: data);

  static void info(String message, {Map<String, dynamic>? data}) =>
      log(message, level: LogLevel.info, data: data);

  static void warning(String message, {Map<String, dynamic>? data}) =>
      log(message, level: LogLevel.warning, data: data);

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) =>
      log(
        message,
        level: LogLevel.error,
        error: error,
        stackTrace: stackTrace,
        data: data,
      );
}
