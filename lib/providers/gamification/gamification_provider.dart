// lib/providers/gamification_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/repository/database_Helper.dart';


final gamificationProvider = StateNotifierProvider<GamificationNotifier, UserProgress>((ref) {
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
    int pointsEarned = activityType == 'mood_log' ? 10 : 20; // Example: mood log = 10, relaxation = 20
    int newPoints = state.totalPoints + pointsEarned;
    int newLevel = (newPoints ~/ 100) + 1; // Level up every 100 points
    List<String> newBadges = List.from(state.badges);

    // Award badges
    if (activityType == 'mood_log' && state.streakCount >= 7 && !newBadges.contains('StreakMaster')) {
      newBadges.add('StreakMaster');
    }
    // if (newStreak == 3 && !newBadges.contains('StreakMaster')) {
    //   newBadges.add('StreakMaster');
    // }
    // if (newPoints >= 50 && !newBadges.contains('Beginner')) {
    //   newBadges.add('Beginner');
    // }

   state = UserProgress(
      streakCount: _updateStreak(),
      totalPoints: newPoints,
      level: newLevel,
      badges: newBadges,
    );
    _dbHelper.updateUserProgress(state);
  }

  int _updateStreak() {
    final now = DateTime.now();
    final lastActivity = DateTime.fromMillisecondsSinceEpoch(state.totalPoints); // Simplified
    if (now.difference(lastActivity).inDays <= 1) {
      return state.streakCount + 1;
    }
    return 1; // Reset streak if more than a day has passed
  }
}