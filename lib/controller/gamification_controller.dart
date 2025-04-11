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
    bool isSuggested = false,
  }) {
    final now = DateTime.now();
    var updatedProgress = progress;
    final effectiveLogDate = activityDate ?? now;
    final activityDay = DateTime(
        effectiveLogDate.year, effectiveLogDate.month, effectiveLogDate.day);
    final isToday = isSameDay(activityDay, now);
    DateTime? lastCompletion;

    print('Logging $activityType on $activityDay (isToday: $isToday)');

    if (activityType == 'mood_log' && activityDate != null) {
      final alreadyLoggedThisDay =
          progress.moodLogDates.any((d) => isSameDay(d, activityDay));
      print('Mood already logged today: $alreadyLoggedThisDay');
      if (!alreadyLoggedThisDay) {
        updatedProgress = updatedProgress.copyWith(
          moodLogDates: [...updatedProgress.moodLogDates, activityDay],
        );
        if (isToday) {
          updatedProgress = updatedProgress.copyWith(
            totalPoints: updatedProgress.totalPoints + 2,
          );
          updatedProgress = _challengeController.updateChallengeProgress(
            progress: updatedProgress,
            activityType: activityType,
            now: now,
          );
          print('Mood points added: 2, Total: ${updatedProgress.totalPoints}');
        }
      }
    } else if (activityType == 'relaxation' && completedRelaxation != null) {
      lastCompletion = progress.completedRelaxations[completedRelaxation];
      final alreadyLoggedThisDay =
          progress.relaxationLogDates.any((d) => isSameDay(d, now));
      print(
          'Relaxation already logged today (any exercise): $alreadyLoggedThisDay');
      if (!alreadyLoggedThisDay) {
        final pointsToAdd = isSuggested ? 5 : 2;
        updatedProgress = updatedProgress.copyWith(
          totalPoints: updatedProgress.totalPoints + pointsToAdd,
          completedRelaxations: {
            ...updatedProgress.completedRelaxations,
            completedRelaxation: now, // Still track individual completions
          },
          relaxationLogDates: [
            ...updatedProgress.relaxationLogDates,
            now
          ], // Track day globally
        );
        updatedProgress = _challengeController.updateChallengeProgress(
          progress: updatedProgress,
          activityType: activityType,
          now: now,
          completedRelaxation: completedRelaxation,
        );
        print(
            'Relaxation points added: $pointsToAdd, Total: ${updatedProgress.totalPoints}');
      }
    } else if (activityType == 'journal') {
      final alreadyLoggedThisDay =
          progress.journalLogDates.any((d) => isSameDay(d, activityDay));
      print('Journal already logged today: $alreadyLoggedThisDay');
      if (!alreadyLoggedThisDay) {
        updatedProgress = updatedProgress.copyWith(
          totalPoints: updatedProgress.totalPoints + 3,
          journalLogDates: [...updatedProgress.journalLogDates, activityDay],
        );
        updatedProgress = _challengeController.updateChallengeProgress(
          progress: updatedProgress,
          activityType: activityType,
          now: now,
        );
        print('Journal points added: 3, Total: ${updatedProgress.totalPoints}');
      }
    }

    // Streak only updates for the first activity of the day across types
    final alreadyLoggedToday =
        progress.lastLogDate != null && isSameDay(progress.lastLogDate!, now);
    print(
        'Already logged today (any type): $alreadyLoggedToday, Last Log: ${progress.lastLogDate}');
    if (!alreadyLoggedToday) {
      updatedProgress = updatedProgress.copyWith(
        streakCount: progress.lastLogDate == null
            ? 1
            : effectiveLogDate.difference(progress.lastLogDate!).inDays == 1
                ? updatedProgress.streakCount + 1
                : effectiveLogDate.difference(progress.lastLogDate!).inDays > 1
                    ? 1
                    : updatedProgress.streakCount,
        lastLogDate: effectiveLogDate,
      );
      print('Streak updated to: ${updatedProgress.streakCount}');
    }

    updatedProgress = updatedProgress.copyWith(
      lastMoodLogDate: activityType == 'mood_log' &&
              !progress.moodLogDates.any((d) => isSameDay(d, activityDay))
          ? effectiveLogDate
          : progress.lastMoodLogDate,
      lastRelaxationLogDate: activityType == 'relaxation' &&
              !progress.relaxationLogDates.any((d) => isSameDay(d, now))
          ? now
          : progress.lastRelaxationLogDate,
    );

    if (updatedProgress.totalPoints >= passMarks[updatedProgress.level]!) {
      updatedProgress = updatedProgress.copyWith(
        level: updatedProgress.level + 1,
        badges: [
          ...updatedProgress.badges,
          'Level ${updatedProgress.level} Achieved'
        ],
      );
      print('Level up! New level: ${updatedProgress.level}');
    }

    if (updatedProgress.badges.length > progress.badges.length) {
      RewardPopup.show(context, updatedProgress.badges.last);
    }

    print(
        'Final progress: Points=${updatedProgress.totalPoints}, Streak=${updatedProgress.streakCount}');
    return updatedProgress;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
