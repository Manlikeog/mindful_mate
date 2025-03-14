import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/repository/database_helper.dart';

final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, UserProgress>((ref) {
  return GamificationNotifier();
});

class GamificationNotifier extends StateNotifier<UserProgress> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  GamificationNotifier() : super(UserProgress()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    state = await _dbHelper.getUserProgress();
  }

  void logActivity({required String activityType}) {
    final now = DateTime.now();
    final isFirstLogToday =
        state.lastLogDate == null || !isSameDay(state.lastLogDate!, now);

    int pointsEarned = (activityType == 'mood_log' && isFirstLogToday) ? 10 : 0;
    int newPoints = state.totalPoints + pointsEarned;
    int newLevel = (newPoints ~/ 100) + 1;
    List<String> newBadges = List.from(state.badges);

    // Update streak only if it's the first log of the day
    int newStreak = isFirstLogToday ? _updateStreak(now) : state.streakCount;

    // Award badges based on streak (only on first log)
    if (isFirstLogToday &&
        newStreak >= 7 &&
        !newBadges.contains('StreakMaster')) {
      newBadges.add('StreakMaster');
    }

    state = UserProgress(
      streakCount: newStreak,
      totalPoints: newPoints,
      level: newLevel,
      badges: newBadges,
      lastLogDate: now,
    );
    _dbHelper.updateUserProgress(state);
  }

  int _updateStreak(DateTime logDate) {
    if (state.lastLogDate == null) {
      return 1; // First log ever
    }
    final lastLog = state.lastLogDate!;
    final diff = logDate.difference(lastLog).inDays;
    if (diff == 1) {
      return state.streakCount + 1; // Consecutive day
    } else if (diff == 0) {
      return state.streakCount; // Same day, no change
    } else {
      return 1; // Missed a day, reset streak
    }
  }
}

// Utility function to compare days
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
