import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/providers/data_provider.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';

class MoodController {
  final DatabaseHelper _db;
  final GamificationController _gamificationController;
  final Ref? ref;

  MoodController(this._db, {this.ref})
      : _gamificationController = GamificationController(_db);

  Future<List<MoodEntry>> fetchMoodEntries() async {
    return await _db.getMoodEntries();
  }

  Future<void> logMood({
    required MoodEntry entry,
    required BuildContext context,
    required UserProgress progress,
    required Function(String) onFeedback,
  }) async {
    try {
      await _db.saveMoodEntry(entry); // Save or overwrite the mood entry

      final updatedProgress = _gamificationController.logActivity(
        context: context,
        progress: progress,
        activityType: 'mood_log',
        activityDate: entry.date,
      );
      await _gamificationController.saveUserProgress(updatedProgress);
      if (ref != null) {
        ref!.read(gamificationProvider.notifier).state = updatedProgress;
      }
      print('lol');
      final isToday = isSameDay(entry.date, DateTime.now());
      final pointsAwarded = updatedProgress.totalPoints - progress.totalPoints;
      final feedback = isToday
          ? pointsAwarded <= 0
              ? 'Mood updated for today, no additional points awarded.'
              : 'Mood logged successfully! Check your challenge progress!'
          : 'Previous day mood logged but no points awarded.';
      onFeedback(feedback);
    } catch (e) {
      onFeedback('Failed to log mood: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log mood: $e')),
      );
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

final moodControllerProvider = Provider((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return MoodController(dbHelper, ref: ref);
});
