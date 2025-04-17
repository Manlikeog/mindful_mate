import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/progress_card/progress_card.dart';
import 'package:mindful_mate/providers/challenge_provider.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'package:mindful_mate/utils/error_logger.dart';

final progressCardDataProvider = Provider<ProgressCardData>((ref) {
  final progress = ref.watch(userProgressProvider);
  final challenges = ref.watch(challengesProvider);
  final currentLevel = progress.level;
  final now = DateTime.now();
  final activeChallenges = challenges.where((c) => c.isActive(now)).toList();
  final levelName = getLevelName(progress.level);
  final levelTotalPoints = getLevelTotalPoints(progress.level);
  final passMark = getPassMark(progress.level);
  final progressPercentage = levelTotalPoints > 0
      ? (progress.totalPoints / levelTotalPoints).clamp(0.0, 1.0)
      : 0.0;

  ErrorLogger.logInfo('ProgressCardData: Level $currentLevel, Active Challenges: ${activeChallenges.length}');
  return ProgressCardData(
    levelName: levelName,
    levelTotalPoints: levelTotalPoints,
    passMark: passMark,
    userProgress: progress,
    progressPercentage: progressPercentage,
    activeChallenges: activeChallenges,
    level: currentLevel,
  );
});

String getLevelName(int level) {
  switch (level) {
    case 1:
      return 'Beginner';
    case 2:
      return 'Explorer';
    case 3:
      return 'Champion';
    default:
      return 'Legend ${level - 3}';
  }
}

int getLevelTotalPoints(int level) {
  return levelPoints[level] ?? 0;
}

int getPassMark(int level) {
  return passMarks[level] ?? 0;
}