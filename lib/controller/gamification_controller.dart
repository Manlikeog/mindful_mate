import 'package:flutter/material.dart';
import 'package:mindful_mate/controller/challenge_controller.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/utils/date_utils.dart';
import 'package:mindful_mate/utils/error_logger.dart';
import 'package:mindful_mate/utils/reward_popup.dart';

/// Manages gamification logic, including points, streaks, and levels.
class GamificationController {
  final ChallengeController _challengeController;

  GamificationController() : _challengeController = ChallengeController();

  /// Logs an activity and updates progress accordingly.
  UserProgress logActivity({
    required BuildContext context,
    required UserProgress progress,
    required String activityType,
    String? suggestedRelaxation,
    String? completedRelaxation,
    DateTime? activityDate,
    required bool isSuggested,
  }) {
    final now = DateTime.now();
    final effectiveLogDate = activityDate ?? now;
    final activityDay = DateTime(
      effectiveLogDate.year,
      effectiveLogDate.month,
      effectiveLogDate.day,
    );

    var updatedProgress = progress;

    if (activityType == 'mood_log') {
      updatedProgress = _logMood(updatedProgress, activityDay, now);
    } else if (activityType == 'relaxation' && completedRelaxation != null) {
      updatedProgress = _logRelaxation(
        updatedProgress,
        completedRelaxation,
        now,
        isSuggested,
      );
    } else if (activityType == 'journal') {
      updatedProgress = _logJournal(updatedProgress, activityDay, now);
    }

    updatedProgress = _updateStreak(updatedProgress, effectiveLogDate, now);
    updatedProgress = _updateLevel(updatedProgress, context);

    ErrorLogger.logError(
      'Final progress: Points=${updatedProgress.totalPoints}, '
      'Streak=${updatedProgress.streakCount}, '
      'ChallengeProgress=${updatedProgress.challengeProgress}',
    );
    return updatedProgress;
  }

  /// Logs a mood activity and awards points and challenge progress if applicable.
  UserProgress _logMood(
    UserProgress progress,
    DateTime activityDay,
    DateTime now,
  ) {
    final alreadyLogged = progress.moodLogDates.any((d) => isSameDay(d, activityDay));
    ErrorLogger.logError('Mood already logged today: $alreadyLogged');
    if (!alreadyLogged) {
      var updatedProgress = progress.copyWith(
        moodLogDates: [...progress.moodLogDates, activityDay],
        lastMoodLogDate: activityDay,
      );
      if (isSameDay(activityDay, now)) {
        updatedProgress = updatedProgress.copyWith(
          totalPoints: updatedProgress.totalPoints + 2,
        );
        updatedProgress = _challengeController.updateChallengeProgress(
          progress: updatedProgress,
          activityType: 'mood_log',
          now: now,
        );
        ErrorLogger.logError('Mood points added: 2, Total: ${updatedProgress.totalPoints}, '
            'ChallengeProgress: ${updatedProgress.challengeProgress}');
      }
      return updatedProgress;
    }
    ErrorLogger.logError('Skipping mood challenge update: already logged today');
    return progress;
  }

  /// Logs a relaxation activity and awards points and challenge progress if applicable.
  UserProgress _logRelaxation(
    UserProgress progress,
    String completedRelaxation,
    DateTime now,
    bool isSuggested,
  ) {
    final alreadyLogged = progress.relaxationLogDates.any((d) => isSameDay(d, now));
    ErrorLogger.logError('Relaxation already logged today: $alreadyLogged');
    if (!alreadyLogged) {
      final pointsToAdd = isSuggested ? 5 : 2;
      var updatedProgress = progress.copyWith(
        totalPoints: progress.totalPoints + pointsToAdd,
        completedRelaxations: {
          ...progress.completedRelaxations,
          completedRelaxation: now,
        },
        relaxationLogDates: [...progress.relaxationLogDates, now],
        lastRelaxationLogDate: now,
      );
      updatedProgress = _challengeController.updateChallengeProgress(
        progress: updatedProgress,
        activityType: 'relaxation',
        now: now,
        completedRelaxation: completedRelaxation,
      );
      ErrorLogger.logError('Relaxation points added: $pointsToAdd, Total: ${updatedProgress.totalPoints}, '
          'ChallengeProgress: ${updatedProgress.challengeProgress}');
      return updatedProgress;
    }
    ErrorLogger.logError('Skipping relaxation challenge update: already logged today');
    return progress;
  }

  /// Logs a journal activity and awards points and challenge progress if applicable.
  UserProgress _logJournal(
    UserProgress progress,
    DateTime activityDay,
    DateTime now,
  ) {
    final alreadyLogged = progress.journalLogDates.any((d) => isSameDay(d, activityDay));
    ErrorLogger.logError('Journal already logged today: $alreadyLogged');
    if (!alreadyLogged) {
      var updatedProgress = progress.copyWith(
        totalPoints: progress.totalPoints + 3,
        journalLogDates: [...progress.journalLogDates, activityDay],
      );
      updatedProgress = _challengeController.updateChallengeProgress(
        progress: updatedProgress,
        activityType: 'journal',
        now: now,
      );
      ErrorLogger.logError('Journal points added: 3, Total: ${updatedProgress.totalPoints}, '
          'ChallengeProgress: ${updatedProgress.challengeProgress}');
      return updatedProgress;
    }
    ErrorLogger.logError('Skipping journal challenge update: already logged today');
    return progress;
  }

  /// Updates streak based on activity date.
  UserProgress _updateStreak(
    UserProgress progress,
    DateTime effectiveLogDate,
    DateTime now,
  ) {
    final alreadyLogged = progress.lastLogDate != null && isSameDay(progress.lastLogDate!, now);
    ErrorLogger.logError('Already logged today: $alreadyLogged, Last Log: ${progress.lastLogDate}');
    if (!alreadyLogged) {
      final newStreak = progress.lastLogDate == null
          ? 1
          : effectiveLogDate.difference(progress.lastLogDate!).inDays == 1
              ? progress.streakCount + 1
              : 1;
      ErrorLogger.logError('Streak updated to: $newStreak');
      return progress.copyWith(
        streakCount: newStreak,
        lastLogDate: effectiveLogDate,
      );
    }
    return progress;
  }

  /// Updates user level and awards badges if applicable.
  UserProgress _updateLevel(UserProgress progress, BuildContext context) {
    if (progress.totalPoints >= passMarks[progress.level]!) {
      final newLevel = progress.level + 1;
      final newBadge = 'Level $newLevel Achieved';
      final updatedProgress = progress.copyWith(
        level: newLevel,
        badges: [...progress.badges, newBadge],
      );
      ErrorLogger.logError('Level up! New level: $newLevel');
      RewardPopup.show(context, newBadge);
      return updatedProgress;
    }
    return progress;
  }
}