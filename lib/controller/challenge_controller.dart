import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/utils/error_logger.dart';

class ChallengeController {
  List<Challenge> getChallengesForLevel(UserProgress progress) {
    final now = DateTime.now();
    final challenges = levelChallenges[progress.level]
            ?.where((c) => c.isActive(now))
            .toList() ??
        [];
    log('Level ${progress.level} challenges: ${challenges.map((c) => "${c.title} (${c.type})").toList()}',
        level: 'info');
    return challenges;
  }

  UserProgress updateChallengeProgress({
    required UserProgress progress,
    required String activityType,
    required DateTime now,
    String? completedRelaxation,
  }) {
    final activeChallenges = getChallengesForLevel(progress)
        .where((c) => c.isActive(now) && c.type == activityType)
        .toList();

    log('Active challenges for $activityType: ${activeChallenges.map((c) => "${c.title} (${c.type})").toList()}',
        level: 'info');

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
          log('Challenge ${challenge.id}: Progress $currentProgress -> $newProgress (Goal: ${challenge.goal}, Relaxation: $completedRelaxation)',
              level: 'info');
          updatedProgress = updatedProgress.copyWith(
            challengeProgress: {
              ...updatedProgress.challengeProgress,
              challenge.id: newProgress,
            },
          );
          if (newProgress >= challenge.goal &&
              !updatedProgress.completedChallenges.contains(challenge.id)) {
            log('Challenge ${challenge.id} completed! Points added: ${challenge.points}',
                level: 'info');
            updatedProgress = updatedProgress.copyWith(
              totalPoints: updatedProgress.totalPoints + challenge.points,
              completedChallenges: [
                ...updatedProgress.completedChallenges,
                challenge.id
              ],
            );
          }
        } else {
          log('Challenge ${challenge.id}: No increment (Activity: $activityType, Relaxation: $completedRelaxation)',
              level: 'info');
        }
      }
    }
    return updatedProgress;
  }
}