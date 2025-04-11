import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';

class ChallengeController {
  List<Challenge> getChallengesForLevel(UserProgress progress) {
    final now = DateTime.now();
    final challenges = levelChallenges[progress.level]
            ?.where((c) => c.isActive(now))
            .toList() ??
        [];
    print('Level ${progress.level} challenges: ${challenges.map((c) => "${c.title} (${c.type})").toList()}');
    return challenges;
  }

  UserProgress updateChallengeProgress({
    required UserProgress progress,
    required String activityType,
    required DateTime now,
    String? completedRelaxation,
  }) {
    // Only include challenges that exactly match the activity type
    final activeChallenges = getChallengesForLevel(progress)
        .where((c) => c.isActive(now) && c.type == activityType)
        .toList();

    print('Active challenges for $activityType: ${activeChallenges.map((c) => "${c.title} (${c.type})").toList()}');

    var updatedProgress = progress;

    for (var challenge in activeChallenges) {
      final currentProgress = updatedProgress.challengeProgress[challenge.id] ?? 0;
      if (currentProgress < challenge.goal) {
        bool shouldIncrement = false;

        if (challenge.type == 'relaxation' && completedRelaxation != null) {
          final challengePrefix = challenge.id.split('_')[0];
          final relaxationPrefix = completedRelaxation.split('_')[0];
          if (challengePrefix == 'relax') {
            // General relaxation challenge (e.g., 'relax_l3')
            shouldIncrement = levelRelaxations[progress.level]?.any((r) => r.id == completedRelaxation) ?? false;
          } else {
            // Specific relaxation challenge (e.g., 'mindful_l3')
            shouldIncrement = challengePrefix == relaxationPrefix;
          }
        } else {
          shouldIncrement = true; // Exact type match (mood_log, journal)
        }

        if (shouldIncrement) {
          final newProgress = currentProgress + 1;
          print('Challenge ${challenge.id}: Progress $currentProgress -> $newProgress (Goal: ${challenge.goal}, Relaxation: $completedRelaxation)');
          updatedProgress = updatedProgress.copyWith(
            challengeProgress: {
              ...updatedProgress.challengeProgress,
              challenge.id: newProgress,
            },
          );
          if (newProgress >= challenge.goal && !updatedProgress.completedChallenges.contains(challenge.id)) {
            print('Challenge ${challenge.id} completed! Points added: ${challenge.points}');
            updatedProgress = updatedProgress.copyWith(
              totalPoints: updatedProgress.totalPoints + challenge.points,
              completedChallenges: [...updatedProgress.completedChallenges, challenge.id],
            );
          }
        } else {
          print('Challenge ${challenge.id}: No increment (Activity: $activityType, Relaxation: $completedRelaxation)');
        }
      }
    }
    return updatedProgress;
  }
}