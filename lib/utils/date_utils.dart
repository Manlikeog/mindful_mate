/// Utility functions for date operations.
library date_utils;

import 'package:mindful_mate/data/model/mood/mood_entry.dart';

/// Checks if two dates are on the same day.
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Filters mood data by weekly or monthly view.
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

enum CalendarViewMode { weekly, monthly }