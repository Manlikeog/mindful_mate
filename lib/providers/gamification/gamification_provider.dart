// lib/providers/gamification_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/repository/database_Helper.dart';

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
    int pointsEarned = activityType == 'mood_log' ? 10 : 20;
    int newPoints = state.totalPoints + pointsEarned;
    int newLevel = (newPoints ~/ 100) + 1;
    List<String> newBadges = List.from(state.badges);

    // Update streak
    int newStreak = _updateStreak(now);

    // Award badges
    if (newStreak >= 7 && !newBadges.contains('StreakMaster')) {
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
      return state.streakCount; // Same day, no increment
    } else {
      return 1; // Missed a day, reset streak
    }
  }
}
