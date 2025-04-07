import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/mood_controller.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/providers/calendar_provider.dart';
import 'package:mindful_mate/providers/data_provider.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';

final moodControllerProvider = Provider((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return MoodController(dbHelper, ref: ref);
});

final moodProvider = StateNotifierProvider<MoodNotifier, Map<DateTime, MoodEntry>>((ref) {
  return MoodNotifier(ref);
});

final filteredMoodProvider = Provider<Map<DateTime, int>>((ref) {
  final moodData = ref.watch(moodProvider);
  final viewMode = ref.watch(calendarViewProvider);
  final currentWeekStart = ref.watch(currentDisplayedWeekProvider);
  return filterMoodData(moodData, currentWeekStart, viewMode);
});

Map<DateTime, int> filterMoodData(
  Map<DateTime, MoodEntry> moods,
  DateTime baseDate,
  CalendarViewMode viewMode,
) {
  if (viewMode == CalendarViewMode.weekly) {
    final startOfWeek = baseDate.subtract(Duration(days: baseDate.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return Map.fromEntries(
      moods.entries
          .where((e) =>
              e.key.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              e.key.isBefore(endOfWeek.add(const Duration(days: 1))))
          .map((e) => MapEntry(e.key, e.value.moodRating)),
    );
  } else {
    final startOfMonth = DateTime(baseDate.year, baseDate.month, 1);
    final endOfMonth = DateTime(baseDate.year, baseDate.month + 1, 0);
    return Map.fromEntries(
      moods.entries
          .where((e) =>
              e.key.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
              e.key.isBefore(endOfMonth.add(const Duration(days: 1))))
          .map((e) => MapEntry(e.key, e.value.moodRating)),
    );
  }
}

class MoodNotifier extends StateNotifier<Map<DateTime, MoodEntry>> {
  final Ref ref;

  MoodNotifier(this.ref) : super({}) {
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final controller = ref.read(moodControllerProvider);
    final entries = await controller.fetchMoodEntries();
    state = {for (var entry in entries) entry.date: entry};
  }

  Future<void> logMood(MoodEntry entry, BuildContext context) async {
    final controller = ref.read(moodControllerProvider);
    final progress = ref.read(gamificationProvider);
    await controller.logMood(
      entry: entry,
      context: context,
      progress: progress,
      onFeedback: (message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: message.contains('booster') ? Colors.green : Colors.grey,
        ),
      ),
    );
    state = {...state, entry.date: entry};
  }
}