// lib/utils/error_logger.dart
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mindful_mate/utils/error_handler.dart';

class ErrorLogger {
  static final Logger _logger = Logger();

  static void logError(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void showAndLogError(BuildContext context, String message, [Object? error, StackTrace? stackTrace]) {
    ErrorHandler.showError(context, message);
    logError(message, error, stackTrace);
  }

  static Future<T> handleAsyncWithLogging<T>(
  BuildContext context,
  Future<T> Function() operation, {
  String errorMessage = 'An error occurred',
}) async {
  try {
    return await operation();
  } catch (e, stackTrace) {
    showAndLogError(context, '$errorMessage: $e', e, stackTrace);
    rethrow;
  }
}
}