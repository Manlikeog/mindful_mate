import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/repository/database_helper.dart';
import 'package:mindful_mate/screens/chanllenges/model/chanllenge.dart';

final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, UserProgress>((ref) {
  return GamificationNotifier();
});

class GamificationNotifier extends StateNotifier<UserProgress> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Map<String, int> _challengeProgress =
      {}; // Tracks progress per challenge

  GamificationNotifier() : super(UserProgress()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    state = await _dbHelper.getUserProgress();
  }

  void logActivity({required String activityType, Challenge? challenge}) {
    final now = DateTime.now();
    final isFirstLogToday =
        state.lastLogDate == null || !isSameDay(state.lastLogDate!, now);
    print(isFirstLogToday);
    int pointsEarned = 0;
    List<String> newBadges = List.from(state.badges);
    int newStreak = isFirstLogToday ? _updateStreak(now) : state.streakCount;

    if (isFirstLogToday) {
      pointsEarned = activityType == 'mood_log'
          ? 10
          : activityType == 'relaxation'
              ? 20
              : 0;
      print('Analytics: $activityType logged at $now');
    }

    // Handle challenge progress
    if (challenge != null && challenge.isActive(now)) {
      _challengeProgress[challenge.id] =
          (_challengeProgress[challenge.id] ?? 0) + 1;
      if (_challengeProgress[challenge.id]! >= challenge.goal) {
        pointsEarned += challenge.rewardPoints;
        newBadges.add('${challenge.title} Completed');
        _challengeProgress[challenge.id] = challenge.goal; // Cap progress
      }
    }

    int newPoints = state.totalPoints + pointsEarned;
    int newLevel = _calculateLevel(newPoints);
    newBadges = _awardBadges(newPoints, newStreak, newBadges, activityType);

    state = UserProgress(
      streakCount: newStreak,
      totalPoints: newPoints,
      level: newLevel,
      badges: newBadges,
      lastLogDate: now,
    );
    _dbHelper.updateUserProgress(state);
  }

  int _calculateLevel(int points) {
    if (points < 100) return 1;
    if (points < 300) return 2;
    if (points < 600) return 3;
    if (points < 1000) return 4;
    return 5 + ((points - 1000) ~/ 500);
  }

  List<String> _awardBadges(
      int points, int streak, List<String> currentBadges, String activityType) {
    List<String> updatedBadges = List.from(currentBadges);
    if (streak >= 3 && !updatedBadges.contains('StreakStarter'))
      updatedBadges.add('StreakStarter');
    if (streak >= 7 && !updatedBadges.contains('StreakMaster'))
      updatedBadges.add('StreakMaster');
    if (streak >= 14 && !updatedBadges.contains('StreakLegend'))
      updatedBadges.add('StreakLegend');
    if (points >= 50 && !updatedBadges.contains('MoodBeginner'))
      updatedBadges.add('MoodBeginner');
    if (points >= 200 && !updatedBadges.contains('MoodExplorer'))
      updatedBadges.add('MoodExplorer');
    if (points >= 500 && !updatedBadges.contains('MoodChampion'))
      updatedBadges.add('MoodChampion');
    if (activityType == 'relaxation' && !updatedBadges.contains('CalmSeeker'))
      updatedBadges.add('CalmSeeker');
    return updatedBadges;
  }

  int _updateStreak(DateTime logDate) {
    if (state.lastLogDate == null) return 1;
    final lastLog = state.lastLogDate!;
    final diff = logDate.difference(lastLog).inDays;
    if (diff == 1) return state.streakCount + 1;
    if (diff == 0) return state.streakCount;
    return 1;
  }

  int getChallengeProgress(String challengeId) =>
      _challengeProgress[challengeId] ?? 0;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
