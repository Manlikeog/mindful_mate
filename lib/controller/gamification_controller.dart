import 'package:flutter/material.dart';
import 'package:mindful_mate/controller/challenge_controller.dart';
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
    DateTime? activityDate, // Used for mood entry date
  }) {
    final now = DateTime.now();
    var updatedProgress = progress;

    if (activityType == 'mood_log' && activityDate != null) {
      final isToday = isSameDay(activityDate, now);
      final activityDay =
          DateTime(activityDate.year, activityDate.month, activityDate.day);
      final alreadyLoggedThisDay =
          progress.moodLogDates.any((d) => isSameDay(d, activityDay));

      // Update moodLogDates regardless of points or progress
      if (!alreadyLoggedThisDay) {
        updatedProgress = updatedProgress.copyWith(
          moodLogDates: [...updatedProgress.moodLogDates, activityDay],
        );
      }

      if (isToday && !alreadyLoggedThisDay) {
        // First mood log today: award points and update challenges
        updatedProgress = updatedProgress.copyWith(
          totalPoints: updatedProgress.totalPoints + 2,
        );
        updatedProgress = _challengeController.updateChallengeProgress(
          progress: updatedProgress,
          activityType: activityType,
          now: now,
        );
      } else if (isToday && alreadyLoggedThisDay) {
        // Overwriting today’s mood: no points or challenge update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Mood updated for today, no additional points awarded.'),
            backgroundColor: Colors.grey,
          ),
        );
      } else if (activityDate.isBefore(now)) {
        // Past date: no points or challenge update
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
    final pointsToAward = (suggestedRelaxation == completedRelaxation) ? 5 : 2; // 5 for suggested, 2 for others
    updatedProgress = updatedProgress.copyWith(
      totalPoints: updatedProgress.totalPoints + pointsToAward,
      completedRelaxations: {
        ...updatedProgress.completedRelaxations,
        completedRelaxation: now,
      },
    );
    updatedProgress = _challengeController.updateChallengeProgress(
      progress: updatedProgress,
      activityType: activityType,
      now: now,
    );
  }
} else if (activityType == 'journal') {
      updatedProgress = updatedProgress.copyWith(
        totalPoints: updatedProgress.totalPoints + 3,
      );
      updatedProgress = _challengeController.updateChallengeProgress(
        progress: updatedProgress,
        activityType: activityType,
        now: now,
      );
    }

    updatedProgress = updatedProgress.copyWith(
      streakCount: progress.lastLogDate == null
          ? 1
          : now.difference(progress.lastLogDate!).inDays == 1
              ? updatedProgress.streakCount + 1
              : now.difference(progress.lastLogDate!).inDays > 1
                  ? 1
                  : updatedProgress.streakCount,
      lastLogDate: now,
      lastMoodLogDate:
          activityType == 'mood_log' ? now : progress.lastMoodLogDate,
      lastRelaxationLogDate:
          activityType == 'relaxation' ? now : progress.lastRelaxationLogDate,
    );

    if (updatedProgress.badges.length > progress.badges.length) {
      RewardPopup.show(context, updatedProgress.badges.last);
    }

    return updatedProgress;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
