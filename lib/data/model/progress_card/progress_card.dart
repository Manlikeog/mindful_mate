import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';

class ProgressCardData {
  final String levelName;
  final int levelTotalPoints;
  final int passMark;

  UserProgress userProgress;

  List<Challenge> activeChallenges;
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