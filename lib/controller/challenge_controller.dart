import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/utils/error_logger.dart';

/// Manages challenge-related operations and progress updates.
class ChallengeController {
  /// Retrieves active challenges for the user's level.
  List<Challenge> getChallengesForLevel(UserProgress progress) {
    final now = DateTime.now();
    final challenges = levelChallenges[progress.level]
            ?.where((c) => c.isActive(now))
            .toList() ??
        [];
    ErrorLogger.logError(
        'Level ${progress.level} challenges: ${challenges.map((c) => "${c.title} (${c.type})").toList()}');
    return challenges;
  }

  /// Updates challenge progress based on activity.
  UserProgress updateChallengeProgress({
    required UserProgress progress,
    required String activityType,
    required DateTime now,
    String? completedRelaxation,
  }) {
    final activeChallenges = getChallengesForLevel(progress)
        .where((c) => c.isActive(now) && c.type == activityType)
        .toList();

    ErrorLogger.logError(
        'Active challenges for $activityType: ${activeChallenges.map((c) => "${c.title} (${c.type})").toList()}');

    var updatedProgress = progress;

    for (var challenge in activeChallenges) {
      final currentProgress =
          updatedProgress.challengeProgress[challenge.id] ?? 0;
      if (currentProgress < challenge.goal) {
        bool shouldIncrement = false;

        if (challenge.type == 'relaxation' && completedRelaxation != null) {
          final challengePrefix = challenge.id.split('_')[0];
          final relaxationPrefix = completedRelaxation.split('_')[0];
          if (challengePrefix == 'relax') {
            shouldIncrement = levelRelaxations[progress.level]
                    ?.any((r) => r.id == completedRelaxation) ??
                false;
          } else {
            shouldIncrement = challengePrefix == relaxationPrefix;
          }
        } else {
          shouldIncrement = true;
        }

        if (shouldIncrement) {
          final newProgress = currentProgress + 1;
          ErrorLogger.logError(
              'Challenge ${challenge.id}: Progress $currentProgress -> $newProgress (Goal: ${challenge.goal}, Relaxation: $completedRelaxation)');
          updatedProgress = updatedProgress.copyWith(
            challengeProgress: {
              ...updatedProgress.challengeProgress,
              challenge.id: newProgress,
            },
          );
          if (newProgress >= challenge.goal &&
              !updatedProgress.completedChallenges.contains(challenge.id)) {
            ErrorLogger.logError(
                'Challenge ${challenge.id} completed! Points added: ${challenge.points}');
            updatedProgress = updatedProgress.copyWith(
              totalPoints: updatedProgress.totalPoints + challenge.points,
              completedChallenges: [
                ...updatedProgress.completedChallenges,
                challenge.id
              ],
            );
          }
        } else {
          ErrorLogger.logError(
              'Challenge ${challenge.id}: No increment (Activity: $activityType, Relaxation: $completedRelaxation)');
        }
      }
    }
    return updatedProgress;
  }
}
