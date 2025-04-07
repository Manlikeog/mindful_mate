// lib/utils/error_handler.dart
import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static Future<T> handleAsync<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String errorMessage = 'An error occurred',
  }) async {
    try {
      return await operation();
    } catch (e) {
      showError(context, '$errorMessage: $e');
      rethrow;
    }
  }
}