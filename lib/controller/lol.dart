import 'package:flutter/material.dart';
import 'package:mindful_mate/controller/challenge_controller.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/utils/date_utils.dart';
import 'package:mindful_mate/utils/error_logger.dart';
import 'package:mindful_mate/utils/metrics_tricker.dart';
import 'package:mindful_mate/utils/reward_popup.dart';

class GamificationController {
  final ChallengeController _challengeController;

  GamificationController() : _challengeController = ChallengeController();

  UserProgress logActivity({
    required UserProgress progress,
    required String activityType,
    String? suggestedRelaxation,
    String? completedRelaxation,
    DateTime? activityDate,
    required bool isSuggested,
  }) {
    final stopwatch = Stopwatch()..start();
    try {
      final effectiveLogDate = activityDate ?? DateTime.now();
      final activityDay = DateTime(
        effectiveLogDate.year,
        effectiveLogDate.month,
        effectiveLogDate.day,
      );

      var updatedProgress = progress;

      if (activityType == 'mood_log') {
        updatedProgress = _logMood(updatedProgress, activityDay, effectiveLogDate);
      } else if (activityType == 'relaxation' && completedRelaxation != null) {
        updatedProgress = _logRelaxation(
          updatedProgress,
          completedRelaxation,
          effectiveLogDate,
          isSuggested,
        );
      } else if (activityType == 'journal') {
        updatedProgress = _logJournal(updatedProgress, activityDay, effectiveLogDate);
      }

      updatedProgress = _updateMonotonicStreak(updatedProgress, effectiveLogDate);
      updatedProgress = _updateLevel(updatedProgress);

      ErrorLogger.logInfo('Logged activity in ${stopwatch.elapsedMilliseconds}ms: ${updatedProgress.totalPoints} points');
      ErrorLogger.logInfo('Final progress: Points=${updatedProgress.totalPoints}, '
          'Streak=${updatedProgress.streakCount}, '
          'ChallengeProgress=${updatedProgress.challengeProgress}');
          metricsTracker.record(true);
      return updatedProgress;
    } catch (e) {
      ErrorLogger.logError('Failed to log activity in ${stopwatch.elapsedMilliseconds}ms: $e');
      metricsTracker.record(false);
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  UserProgress _logMood(
    UserProgress progress,
    DateTime activityDay,
    DateTime effectiveLogDate,
  ) {
    final alreadyLogged = progress.moodLogDates.any((d) => isSameDay(d, activityDay));
    ErrorLogger.logInfo('Mood already logged today: $alreadyLogged');
    if (!alreadyLogged) {
      var updatedProgress = progress.copyWith(
        moodLogDates: [...progress.moodLogDates, activityDay],
        lastMoodLogDate: activityDay,
        totalPoints: progress.totalPoints + 2,
      );
      updatedProgress = _challengeController.updateChallengeProgress(
        progress: updatedProgress,
        activityType: 'mood_log',
        now: effectiveLogDate,
        completedRelaxation: null,
      );
      ErrorLogger.logInfo('Mood points added: 2, Total: ${updatedProgress.totalPoints}, '
          'ChallengeProgress: ${updatedProgress.challengeProgress}');
      return updatedProgress;
    }
    ErrorLogger.logInfo('Skipping mood challenge update: already logged today');
    return progress;
  }

  UserProgress _logRelaxation(
    UserProgress progress,
    String completedRelaxation,
    DateTime effectiveLogDate,
    bool isSuggested,
  ) {
    final activityDay = DateTime(
      effectiveLogDate.year,
      effectiveLogDate.month,
      effectiveLogDate.day,
    );
    final alreadyLogged = progress.relaxationLogDates.any((d) => isSameDay(d, activityDay));
    ErrorLogger.logInfo('Relaxation already logged today: $alreadyLogged');
    if (!alreadyLogged) {
      final pointsToAdd = isSuggested ? 5 : 2;
      var updatedProgress = progress.copyWith(
        totalPoints: progress.totalPoints + pointsToAdd,
        completedRelaxations: {
          ...progress.completedRelaxations,
          completedRelaxation: effectiveLogDate,
        },
        relaxationLogDates: [...progress.relaxationLogDates, effectiveLogDate],
        lastRelaxationLogDate: effectiveLogDate,
      );
      updatedProgress = _challengeController.updateChallengeProgress(
        progress: updatedProgress,
        activityType: 'relaxation',
        now: effectiveLogDate,
        completedRelaxation: completedRelaxation,
      );
      ErrorLogger.logInfo('Relaxation points added: $pointsToAdd, Total: ${updatedProgress.totalPoints}, '
          'ChallengeProgress: ${updatedProgress.challengeProgress}');
      return updatedProgress;
    }
    ErrorLogger.logInfo('Skipping relaxation challenge update: already logged today');
    return progress;
  }

  UserProgress _logJournal(
    UserProgress progress,
    DateTime activityDay,
    DateTime effectiveLogDate,
  ) {
    final alreadyLogged = progress.journalLogDates.any((d) => isSameDay(d, activityDay));
    ErrorLogger.logInfo('Journal already logged today: $alreadyLogged');
    if (!alreadyLogged) {
      var updatedProgress = progress.copyWith(
        totalPoints: progress.totalPoints + 3,
        journalLogDates: [...progress.journalLogDates, activityDay],
      );
      updatedProgress = _challengeController.updateChallengeProgress(
        progress: updatedProgress,
        activityType: 'journal',
        now: effectiveLogDate,
        completedRelaxation: null,
      );
      ErrorLogger.logInfo('Journal points added: 3, Total: ${updatedProgress.totalPoints}, '
          'ChallengeProgress: ${updatedProgress.challengeProgress}');
      return updatedProgress;
    }
    ErrorLogger.logInfo('Skipping journal challenge update: already logged today');
    return progress;
  }

  UserProgress _updateMonotonicStreak(
    UserProgress progress,
    DateTime effectiveLogDate,
  ) {
    final isTodayLogged = progress.lastLogDate != null && isSameDay(progress.lastLogDate!, effectiveLogDate);
    ErrorLogger.logInfo('Is today logged: $isTodayLogged, Last Log: ${progress.lastLogDate}, Effective: $effectiveLogDate');
    if (!isTodayLogged) {
      final newStreak = progress.lastLogDate == null
          ? 1
          : isSameDay(effectiveLogDate, progress.lastLogDate!.add(Duration(days: 1)))
              ? progress.streakCount + 1
              : effectiveLogDate.isAfter(progress.lastLogDate!) ? 1 : progress.streakCount;
      ErrorLogger.logInfo('Streak updated to: $newStreak');
      return progress.copyWith(
        streakCount: newStreak,
        lastLogDate: effectiveLogDate,
      );
    }
    ErrorLogger.logInfo('No streak update: already logged today');
    return progress;
  }

  UserProgress _updateLevel(UserProgress progress) {
    if (progress.totalPoints >= passMarks[progress.level]!) {
      final newLevel = progress.level + 1;
      final newBadge = 'Level $newLevel Achieved';
      final updatedProgress = progress.copyWith(
        level: newLevel,
        badges: [...progress.badges, newBadge],
      );
      ErrorLogger.logInfo('Level up! New level: $newLevel');
      return updatedProgress;
    }
    return progress;
  }

}