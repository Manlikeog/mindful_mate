// 2. providers/mood_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';

final calendarViewProvider =
    StateProvider<CalendarViewMode>((ref) => CalendarViewMode.weekly);
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

enum CalendarViewMode { weekly, monthly }

extension MoodAnalysis on WidgetRef {
  String getMoodInsight(DateTime baseDate, CalendarViewMode viewMode) {
    final moods = watch(moodProvider);
    if (moods.isEmpty) return "Start tracking your mood to see insights! 🌱";

    // Filter data based on view mode
    final filteredData = viewMode == CalendarViewMode.weekly
        ? _filterWeeklyData(moods, baseDate)
        : _filterMonthlyData(moods, baseDate);

    if (filteredData.isEmpty) {
      return viewMode == CalendarViewMode.weekly
          ? "No mood data for this week"
          : "No mood data for this month";
    }

    final entries = filteredData.entries;
    final happyDays = entries.where((entry) => entry.value >= 2).length;
    final averageMood = entries.isEmpty
        ? 0
        : entries.map((e) => e.value).reduce((a, b) => a + b) / entries.length;

    if (happyDays > entries.length * 0.8) {
      return "You're consistently positive! 🌟";
    }
    if (averageMood < 1.5) return "Let's focus on self-care this week 💆♀️";
    return "You felt happiest on weekends! 🎉";
  }

  Map<DateTime, int> _filterWeeklyData(
      Map<DateTime, int> moods, DateTime baseDate) {
    final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
    final end = start.add(const Duration(days: 6));
    return Map.fromEntries(
      moods.entries.where((e) =>
          e.key.isAfter(start.subtract(const Duration(days: 1))) &&
          e.key.isBefore(end.add(const Duration(days: 1)))),
    );
  }

  Map<DateTime, int> _filterMonthlyData(
      Map<DateTime, int> moods, DateTime baseDate) {
    final start = DateTime(baseDate.year, baseDate.month, 1);
    final end = DateTime(baseDate.year, baseDate.month + 1, 0);
    return Map.fromEntries(
      moods.entries.where((e) =>
          e.key.isAfter(start.subtract(const Duration(days: 1))) &&
          e.key.isBefore(end.add(const Duration(days: 1)))),
    );
  }
}

// Tracks the currently displayed period (week/month start)
final currentDisplayedWeekProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return now
      .subtract(Duration(days: now.weekday % 7)); // Default to current week
});
