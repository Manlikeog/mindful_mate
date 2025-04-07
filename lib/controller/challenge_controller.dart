
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';

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
  }) {
    final activeChallenges = getChallengesForLevel(progress)
        .where((c) => c.type == activityType)
        .toList();
    print('Active challenges for $activityType: ${activeChallenges.map((c) => c.title).toList()}');

    var updatedProgress = progress;

    for (var challenge in activeChallenges) {
      final currentProgress = updatedProgress.challengeProgress[challenge.id] ?? 0;
      if (currentProgress < challenge.goal) {
        final newProgress = currentProgress + 1;
        updatedProgress = updatedProgress.copyWith(
          challengeProgress: {
            ...updatedProgress.challengeProgress,
            challenge.id: newProgress,
          },
        );
        print('Updated ${challenge.title} progress: $newProgress/${challenge.goal}');
        if (newProgress >= challenge.goal && !updatedProgress.completedChallenges.contains(challenge.id)) {
          updatedProgress = updatedProgress.copyWith(
            totalPoints: updatedProgress.totalPoints + challenge.points,
            completedChallenges: [...updatedProgress.completedChallenges, challenge.id],
          );
          if (updatedProgress.totalPoints >= passMarks[progress.level]!) {
            updatedProgress = updatedProgress.copyWith(
              level: updatedProgress.level + 1,
              badges: [...updatedProgress.badges, 'Level ${updatedProgress.level} Achieved'],
            );
          }
        }
      }
    }
    return updatedProgress;
  }
}