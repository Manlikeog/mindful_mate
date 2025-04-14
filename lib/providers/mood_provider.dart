import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/controller/mood_controller.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/providers/calendar_provider.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'package:mindful_mate/utils/date_utils.dart';
/// Provides access to the mood controller.
final moodControllerProvider = Provider((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return MoodController(dbHelper, ref, );
});

/// Manages the state of mood entries.
final moodProvider =
    StateNotifierProvider<MoodNotifier, Map<DateTime, MoodEntry>>((ref) {
  return MoodNotifier(ref);
});

/// Provides filtered mood data for display.
final filteredMoodProvider = Provider<Map<DateTime, int>>((ref) {
  final moodData = ref.watch(moodProvider);
  final viewMode = ref.watch(calendarViewProvider);
  final currentWeekStart = ref.watch(currentDisplayedWeekProvider);
  return filterMoodData(moodData, currentWeekStart, viewMode);
});

/// Notifier for managing mood entries.
class MoodNotifier extends StateNotifier<Map<DateTime, MoodEntry>> {
  final Ref providerRef;

  MoodNotifier(this.providerRef) : super({}) {
    _loadMoods();
  }

  /// Loads all mood entries from the database.
  Future<void> _loadMoods() async {
    final controller = providerRef.read(moodControllerProvider);
    final entries = await controller.fetchMoodEntries();
    state = {for (var entry in entries) entry.date: entry};
  }

  /// Logs a mood entry and updates state.
  Future<void> logMood(MoodEntry entry, BuildContext context) async {
    final controller = providerRef.read(moodControllerProvider);
    final progress = providerRef.read(userProgressProvider);
    await controller.logMood(
      entry: entry,
      context: context,
      progress: progress,
      onFeedback: (message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: message.contains('no ') ? Colors.black : Colors.green,
        ),
      ),
    );
    state = {...state, entry.date: entry};
  }
}