import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/repository/database_helper.dart';
import 'package:mindful_mate/screens/chanllenges/chanllenge_screen.dart';
import 'package:mindful_mate/screens/chanllenges/model/chanllenge.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';

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

  int logActivity({
    required String activityType,
    Challenge? challenge,
    String? suggestedRelaxation,
    String? completedRelaxation,
  }) {
    final now = DateTime.now();
    int pointsEarned = 0;
    List<String> newBadges = List.from(state.badges);
    int newStreak = _updateStreak(now);

    final isFirstMoodLogToday = state.lastMoodLogDate == null || !isSameDay(state.lastMoodLogDate!, now);
    final isFirstRelaxationToday = state.lastRelaxationLogDate == null || !isSameDay(state.lastRelaxationLogDate!, now);

    if (activityType == 'mood_log' && isFirstMoodLogToday) {
      pointsEarned += 10;
      _updateChallengeProgress('mood_log', now);
      print('Analytics: Mood logged at $now - 10 points');
    }

    if (activityType == 'relaxation' && isFirstRelaxationToday) {
      _updateChallengeProgress('relaxation', now);
      if (suggestedRelaxation != null && suggestedRelaxation == completedRelaxation) {
        final lastCompletion = state.completedRelaxations[completedRelaxation];
        if (lastCompletion == null || !isSameDay(lastCompletion, now)) {
          pointsEarned += 20;
          print('Analytics: Suggested Relaxation ($completedRelaxation) logged at $now - 20 points');
        } else {
          print('Analytics: Relaxation ($completedRelaxation) already rewarded today - 0 points');
        }
      } else {
        print('Analytics: Relaxation ($completedRelaxation) logged at $now - No points (not suggested)');
      }
    }

    if (activityType == 'journal') {
      _updateChallengeProgress('journal', now);
      pointsEarned += 5;
      print('Analytics: Journal entry logged at $now - 5 points');
    }

    if (challenge != null && challenge.isActive(now)) {
      final challengeId = challenge.id;
      final currentProgress = state.challengeProgress[challengeId] ?? 0;
      final newProgress = currentProgress + 1;
      state = state.copyWith(
        challengeProgress: {...state.challengeProgress, challengeId: newProgress},
      );
      if (newProgress >= challenge.goal && !state.completedChallenges.contains(challengeId)) {
        pointsEarned += challenge.rewardPoints;
        newBadges.add('${challenge.title} Completed');
        state = state.copyWith(
          completedChallenges: [...state.completedChallenges, challengeId],
        );
        print('Challenge ${challenge.title} completed - ${challenge.rewardPoints} points added');
      }
    }

    int newPoints = state.totalPoints + pointsEarned;
    int newLevel = _calculateLevel(newPoints);
    newBadges = _awardBadges(newPoints, newStreak, newBadges, activityType);

    Map<String, DateTime> updatedCompletedRelaxations = Map.from(state.completedRelaxations);
    if (activityType == 'relaxation' && completedRelaxation != null) {
      updatedCompletedRelaxations[completedRelaxation] = now;
    }

    state = state.copyWith(
      streakCount: newStreak,
      totalPoints: newPoints,
      level: newLevel,
      badges: newBadges,
      lastMoodLogDate: activityType == 'mood_log' ? now : state.lastMoodLogDate,
      lastRelaxationLogDate: activityType == 'relaxation' ? now : state.lastRelaxationLogDate,
      lastLogDate: now,
      completedRelaxations: updatedCompletedRelaxations,
    );

    print('New state before save: ${state.toMap()}');
    _saveProgress();
    return pointsEarned;
  }

  void _updateChallengeProgress(String type, DateTime now) {
    for (var challenge in ChallengesScreen.challenges) {
      if (challenge.type == type && challenge.isActive(now)) {
        final challengeId = challenge.id;
        final currentProgress = state.challengeProgress[challengeId] ?? 0;
        final newProgress = currentProgress + 1;
        if (newProgress <= challenge.goal) {
          state = state.copyWith(
            challengeProgress: {...state.challengeProgress, challengeId: newProgress},
          );
          if (newProgress == challenge.goal && !state.completedChallenges.contains(challengeId)) {
            state = state.copyWith(
              totalPoints: state.totalPoints + challenge.rewardPoints,
              badges: [...state.badges, '${challenge.title} Completed'],
              completedChallenges: [...state.completedChallenges, challengeId],
            );
            print('Challenge ${challenge.title} completed via $type - ${challenge.rewardPoints} points');
          }
        }
      }
    }
  }

  Future<void> _saveProgress() async {
    try {
      await _dbHelper.updateUserProgress(state);
      print('Progress saved to DB: ${state.toMap()}');
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  int _calculateLevel(int points) {
    if (points < 100) return 1;
    if (points < 300) return 2;
    if (points < 600) return 3;
    if (points < 1000) return 4;
    return 5 + ((points - 1000) ~/ 500);
  }

  List<String> _awardBadges(int points, int streak, List<String> currentBadges, String activityType) {
    List<String> updatedBadges = List.from(currentBadges);
    if (streak >= 3 && !updatedBadges.contains('StreakStarter')) updatedBadges.add('StreakStarter');
    if (streak >= 7 && !updatedBadges.contains('StreakMaster')) updatedBadges.add('StreakMaster');
    if (streak >= 14 && !updatedBadges.contains('StreakLegend')) updatedBadges.add('StreakLegend');
    if (points >= 50 && !updatedBadges.contains('MoodBeginner')) updatedBadges.add('MoodBeginner');
    if (points >= 200 && !updatedBadges.contains('MoodExplorer')) updatedBadges.add('MoodExplorer');
    if (points >= 500 && !updatedBadges.contains('MoodChampion')) updatedBadges.add('MoodChampion');
    if (activityType == 'relaxation' && !updatedBadges.contains('CalmSeeker')) updatedBadges.add('CalmSeeker');
    if (activityType == 'journal' && !updatedBadges.contains('Journalist')) updatedBadges.add('Journalist');
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

  int getChallengeProgress(String challengeId) => state.challengeProgress[challengeId] ?? 0;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}