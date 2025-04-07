// lib/utils/network_error_handler.dart
import 'package:flutter/material.dart';
import 'package:mindful_mate/utils/error_logger.dart';
import 'dart:io';

class NetworkErrorHandler {
  static Future<T> withRetry<T>(
    BuildContext context,
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
    String errorMessage = 'Network error occurred',
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await operation();
      } catch (e, stackTrace) {
        attempt++;
        if (e is SocketException || e is HttpException) {
          if (attempt >= maxRetries) {
            ErrorLogger.showAndLogError(context, '$errorMessage after $maxRetries attempts', e, stackTrace);
            rethrow;
          }
          ErrorLogger.logError('Attempt $attempt failed, retrying...', e, stackTrace);
          await Future.delayed(delay);
        } else {
          ErrorLogger.showAndLogError(context, errorMessage, e, stackTrace);
          rethrow;
        }
      }
    }
  }

  static void showRetryDialog(BuildContext context, VoidCallback onRetry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Network Error'),
        content: const Text('Failed to connect. Would you like to retry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onRetry();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}