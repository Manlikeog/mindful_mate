import 'package:logger/logger.dart';

final Logger _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
  output: ConsoleOutput(),
);

void log(String message, {String level = 'info'}) {
  switch (level.toLowerCase()) {
    case 'error':
      _logger.e(message);
      break;
    case 'warning':
      _logger.w(message);
      break;
    case 'info':
    default:
      _logger.i(message);
      break;
  }
}

class ErrorLogger {
  static void logError(String message, [String? level]) {
    log(message, level: level ?? 'error');
  }

  static void logInfo(String message) {
    log(message, level: 'info');
  }
}