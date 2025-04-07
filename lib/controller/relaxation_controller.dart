// lib/controllers/relaxation_controller.dart
import 'package:flutter/material.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';

import 'package:mindful_mate/data/model/relaxation/relaxation.dart';

import 'package:mindful_mate/data/model/progress_card/user_progress.dart';

import 'package:mindful_mate/utils/network_error_handler.dart';

class RelaxationController {
  final GamificationController _gamificationController;

  RelaxationController(this._gamificationController);

  bool isCompletedToday(UserProgress progress, String exerciseId) {
    final lastCompletion = progress.completedRelaxations[exerciseId];
    return lastCompletion != null && _isSameDay(lastCompletion, DateTime.now());
  }

  void completeRelaxation({
    required BuildContext context,
    required UserProgress progress,
    required Relaxation exercise,
    required bool isSuggested,
    required Function(String) onFeedback, // Callback for UI feedback
  }) {
    NetworkErrorHandler.withRetry(
      context,
      () async {
        final updatedProgress = _gamificationController.logActivity(
          context: context,
          progress: progress,
          activityType: 'relaxation',
          suggestedRelaxation: isSuggested ? exercise.id : null,
          completedRelaxation: exercise.id,
        );

        final pointsAwarded = isSuggested && !isCompletedToday(updatedProgress, exercise.id) ? 5 : 2;
        final feedback = pointsAwarded > 0
            ? 'Relaxation completed! +$pointsAwarded booster points'
            : 'Relaxation completed! Check your challenge progress!';
        onFeedback(feedback);

        // Log analytics event (uncomment if you have AnalyticsService implemented)
        // await AnalyticsService.logRelaxationCompletion(exercise.title);
        _gamificationController.saveUserProgress(updatedProgress); // Fix: Save updated progress 
        return updatedProgress;
      },
      errorMessage: 'Failed to complete relaxation',
    ).catchError((e) {
      NetworkErrorHandler.showRetryDialog(context, () {
        completeRelaxation(
          context: context,
          progress: progress,
          exercise: exercise,
          isSuggested: isSuggested,
          onFeedback: onFeedback,
        );
      });
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}