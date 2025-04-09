import 'package:flutter/material.dart';
import 'package:mindful_mate/controller/challenge_controller.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/utils/reward_popup.dart';

class GamificationController {
  final DatabaseHelper _dbHelper;
  final ChallengeController _challengeController;

  GamificationController(this._dbHelper)
      : _challengeController = ChallengeController();

  Future<UserProgress> fetchUserProgress() async {
    return await _dbHelper.getUserProgress();
  }

  Future<void> saveUserProgress(UserProgress progress) async {
    await _dbHelper.updateUserProgress(progress);
  }

  UserProgress logActivity({
  required BuildContext context,
  required UserProgress progress,
  required String activityType,
  String? suggestedRelaxation,
  String? completedRelaxation,
  DateTime? activityDate,
}) {
  final now = DateTime.now();
  var updatedProgress = progress;

  if (activityType == 'mood_log' && activityDate != null) {
    final isToday = isSameDay(activityDate, now);
    final activityDay = DateTime(activityDate.year, activityDate.month, activityDate.day);
    final alreadyLoggedThisDay = progress.moodLogDates.any((d) => isSameDay(d, activityDay));

    if (!alreadyLoggedThisDay) {
      updatedProgress = updatedProgress.copyWith(
        moodLogDates: [...updatedProgress.moodLogDates, activityDay],
      );
    }

    if (isToday && !alreadyLoggedThisDay) {
      updatedProgress = updatedProgress.copyWith(
        totalPoints: updatedProgress.totalPoints + 2,
      );
      updatedProgress = _challengeController.updateChallengeProgress(
        progress: updatedProgress,
        activityType: activityType,
        now: now,
      );
    } else if (isToday && alreadyLoggedThisDay) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Mood updated for today, no additional points awarded.'),
            backgroundColor: Colors.grey,
          ),
        );
    } else if (activityDate.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Previous day mood logged but no points awarded.'),
            backgroundColor: Colors.grey,
          ),
        );
    }
  } else if (activityType == 'relaxation' && completedRelaxation != null) {
    final lastCompletion = progress.completedRelaxations[completedRelaxation];
    if (lastCompletion == null || !isSameDay(lastCompletion, now)) {
      updatedProgress = updatedProgress.copyWith(
        totalPoints: updatedProgress.totalPoints + 5,
        completedRelaxations: {
          ...updatedProgress.completedRelaxations,
          completedRelaxation: now,
        },
      );
      updatedProgress = _challengeController.updateChallengeProgress( progress: updatedProgress,
          activityType: activityType,
          now: now,);
    }
  } else if (activityType == 'journal') {
    updatedProgress = updatedProgress.copyWith(
      totalPoints: updatedProgress.totalPoints + 3,
    );
    updatedProgress = _challengeController.updateChallengeProgress( progress: updatedProgress,
          activityType: activityType,
          now: now,);
  }

  // Use activityDate for mood logs, otherwise use now
  final effectiveLogDate = (activityType == 'mood_log' && activityDate != null) ? activityDate : now;

  updatedProgress = updatedProgress.copyWith(
    streakCount: progress.lastLogDate == null
        ? 1
        : effectiveLogDate.difference(progress.lastLogDate!).inDays == 1
            ? updatedProgress.streakCount + 1
            : effectiveLogDate.difference(progress.lastLogDate!).inDays > 1
                ? 1
                : updatedProgress.streakCount,
    lastLogDate: effectiveLogDate,
    lastMoodLogDate: activityType == 'mood_log' ? effectiveLogDate : progress.lastMoodLogDate,
    lastRelaxationLogDate: activityType == 'relaxation' ? now : progress.lastRelaxationLogDate,
  );

  // Check for level-up after any point update
  if (updatedProgress.totalPoints >= passMarks[updatedProgress.level]!) {
    updatedProgress = updatedProgress.copyWith(
      level: updatedProgress.level + 1,
      badges: [...updatedProgress.badges, 'Level ${updatedProgress.level} Achieved'],
    );
  }

  if (updatedProgress.badges.length > progress.badges.length) {
    RewardPopup.show(context, updatedProgress.badges.last);
  }

  // Debugging prints
  print('Total Points: ${updatedProgress.totalPoints}, Level: ${updatedProgress.level}');
  print('LastLogDate: ${progress.lastLogDate}, EffectiveLogDate: $effectiveLogDate, Streak: ${updatedProgress.streakCount}');

  return updatedProgress;
}

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
