import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';
import 'package:mindful_mate/utils/date_utils.dart';
import 'package:mindful_mate/utils/error_logger.dart';

/// Manages mood logging and retrieval operations.
class MoodController {
  final DatabaseHelper _databaseHelper;
  final Ref providerRef;

  MoodController(
    this._databaseHelper,
    this.providerRef,
  );

  /// Fetches all mood entries from the database.
  Future<List<MoodEntry>> fetchMoodEntries() async {
    return await _databaseHelper.getMoodEntries();
  }

  /// Logs a mood entry and updates user progress.
  Future<void> logMood({
    required MoodEntry entry,
    required BuildContext context,
    required UserProgress progress,
    required Function(String) onFeedback,
  }) async {
    try {
      await _databaseHelper.saveMoodEntry(entry);
      final updatedProgress =
          await providerRef.read(gamificationProvider).logActivity(
                context,
                activityType: 'mood_log',
                activityDate: entry.date,
              );
      final isToday = isSameDay(entry.date, DateTime.now());
      final pointsAwarded = updatedProgress.totalPoints - progress.totalPoints;
      final feedback = isToday
          ? pointsAwarded <= 0
              ? 'Mood updated for today, no additional points awarded.'
              : 'Mood logged successfully! Check your challenge progress!'
          : 'Previous day mood logged but no points awarded.';
      onFeedback(feedback);
    } catch (e) {
      ErrorLogger.logError(
        'Failed to log mood: $e',
      );
      onFeedback('Failed to log mood:');
    }
  }
}
