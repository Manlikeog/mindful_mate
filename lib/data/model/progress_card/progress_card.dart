import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';

/// Represents data for a progress card UI component.
class ProgressCardData {
  final String levelName;
  final int levelTotalPoints;
  final int passMark;
  final UserProgress userProgress;
  final List<Challenge> activeChallenges;
  final double progressPercentage;
  final int level;

  ProgressCardData({
    required this.levelName,
    required this.levelTotalPoints,
    required this.passMark,
    required this.userProgress,
    required this.activeChallenges,
    required this.progressPercentage,
    required this.level,
  });
}