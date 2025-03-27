import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/repository/database_helper.dart';
import 'package:mindful_mate/screens/chanllenges/model/chanllenge.dart';
import 'package:mindful_mate/screens/relaxations/model/relaxation.dart';

final gamificationProvider = StateNotifierProvider<GamificationNotifier, UserProgress>((ref) {
  return GamificationNotifier();
});

class GamificationNotifier extends StateNotifier<UserProgress> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  GamificationNotifier() : super(UserProgress()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final loadedProgress = await _dbHelper.getUserProgress();
      state = loadedProgress;
      print('Loaded progress from DB: ${state.toMap()}');
    } catch (e) {
      print('Error loading progress: $e');
      state = UserProgress();
    }
  }

  void logActivity({
    required String activityType,
    String? suggestedRelaxation,
    String? completedRelaxation,
  }) {
    final now = DateTime.now();
    int pointsEarned = 0;
    List<String> newBadges = List.from(state.badges);
    int newStreak = _updateStreak(now);

    final currentLevel = state.level;
    final challenges = levelChallenges[currentLevel] ?? [];

    // Update challenge progress
    for (var challenge in challenges) {
      if (challenge.type == activityType && challenge.isActive(now)) {
        final challengeId = challenge.id;
        final currentProgress = state.challengeProgress[challengeId] ?? 0;
        bool shouldIncrement = true;

        // Prevent multiple mood logs on the same day from incrementing progress
        if (activityType == 'mood_log') {
          final lastMoodLog = state.lastMoodLogDate;
          if (lastMoodLog != null && isSameDay(lastMoodLog, now)) {
            shouldIncrement = false; // Already logged mood today
            print('Mood already logged today, not incrementing challenge progress');
          }
        }

        if (shouldIncrement && currentProgress < challenge.goal) {
          final newProgress = currentProgress + 1;
          state = state.copyWith(
            challengeProgress: {...state.challengeProgress, challengeId: newProgress},
          );
          if (newProgress == challenge.goal && !state.completedChallenges.contains(challengeId)) {
            pointsEarned += challenge.points;
            newBadges.add('${challenge.title} Completed');
            state = state.copyWith(
              completedChallenges: [...state.completedChallenges, challengeId],
            );
            print('Challenge ${challenge.title} completed - ${challenge.points} points');
          }
        }
      }
    }

    // Booster: Suggested Relaxation
    if (activityType == 'relaxation' && suggestedRelaxation != null && suggestedRelaxation == completedRelaxation) {
      final levelRelaxationsList = levelRelaxations[currentLevel] ?? [];
      if (levelRelaxationsList.any((r) => r.id == completedRelaxation)) {
        final lastCompletion = state.completedRelaxations[completedRelaxation!];
        if (lastCompletion == null || !isSameDay(lastCompletion, now)) {
          pointsEarned += 5;
          state = state.copyWith(
            completedRelaxations: {
              ...state.completedRelaxations,
              completedRelaxation: now,
            },
          );
          print('Booster: Suggested Relaxation ($completedRelaxation) completed - 5 points');
        }
      }
    }

    // Level up check
    final levelTotalPoints = levelPoints[currentLevel] ?? 0;
    final passMark = passMarks[currentLevel] ?? 0;
    final newTotalPoints = state.totalPoints + pointsEarned;
    if (newTotalPoints >= passMark && newTotalPoints < levelTotalPoints + (levelPoints[currentLevel + 1] ?? 0)) {
      state = state.copyWith(level: currentLevel + 1);
      print('Level up! Now at Level ${state.level}');
    }

    // Update state with new values
    state = state.copyWith(
      streakCount: newStreak,
      totalPoints: state.totalPoints + pointsEarned,
      badges: newBadges,
      lastMoodLogDate: activityType == 'mood_log' ? now : state.lastMoodLogDate,
      lastRelaxationLogDate: activityType == 'relaxation' ? now : state.lastRelaxationLogDate,
      lastLogDate: now,
    );

    print('New state before save: ${state.toMap()}');
    _saveProgress();
  }

  Future<void> _saveProgress() async {
    try {
      await _dbHelper.updateUserProgress(state);
      print('Progress saved to DB: ${state.toMap()}');
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  int getChallengeProgress(String challengeId) => state.challengeProgress[challengeId] ?? 0;

  int _updateStreak(DateTime logDate) {
    if (state.lastLogDate == null) return 1;
    final lastLog = state.lastLogDate!;
    final diff = logDate.difference(lastLog).inDays;
    if (diff == 1) return state.streakCount + 1;
    if (diff == 0) return state.streakCount;
    return 1;
  }
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}