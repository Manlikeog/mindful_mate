import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'package:mindful_mate/utils/date_utils.dart';
import 'package:mindful_mate/utils/error_logger.dart';

/// Manages relaxation exercise operations and completions.
class RelaxationController {
  final GamificationController _gamificationController;
  final Ref providerRef;
  RelaxationController(this._gamificationController, this.providerRef);

  /// Checks if a relaxation exercise was completed today.
  bool isCompletedToday(UserProgress progress, String exerciseId) {
    final lastCompletion = progress.completedRelaxations[exerciseId];
    return lastCompletion != null && isSameDay(lastCompletion, DateTime.now());
  }

  /// Marks a relaxation exercise as completed and updates progress.
  Future<void> completeRelaxation({
    required BuildContext context,
    required UserProgress progress,
    required Relaxation exercise,
    required bool isSuggested,
    required Function(String) onFeedback,
  }) async {

      try {
        final updatedProgress =
            await providerRef.read(gamificationProvider).logActivity(
                  context,
                  activityType: 'relaxation',
                  suggestedRelaxation: isSuggested ? exercise.id : null,
                  completedRelaxation: exercise.id,
                  isSuggested: isSuggested,
                );
        final pointsAwarded =
            updatedProgress.totalPoints - progress.totalPoints;
        final feedback = pointsAwarded > 0
            ? 'Relaxation completed! +$pointsAwarded points${isSuggested ? " (booster)" : ""}'
            : 'Relaxation already completed today, no additional points.';
        onFeedback(feedback);
      } catch (e) {
        ErrorLogger.logError(
          'Retry failed for relaxation: $e',
        );
        onFeedback('Failed to complete relaxation: $e');
      }
    
  }
}
