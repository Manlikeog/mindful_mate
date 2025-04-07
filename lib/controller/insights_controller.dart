// lib/controllers/insights_controller.dart
import 'dart:math';

import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/providers/calendar_provider.dart';

class InsightsController {
  String getMoodInsight(Map<DateTime, MoodEntry> moods, DateTime baseDate,
      CalendarViewMode viewMode) {
    if (moods.isEmpty) return "Start tracking your mood to see insights! 🌱";

    final filteredData = viewMode == CalendarViewMode.weekly
        ? _filterWeeklyData(moods, baseDate)
        : _filterMonthlyData(moods, baseDate);

    if (filteredData.isEmpty) {
      return viewMode == CalendarViewMode.weekly
          ? "No mood data this week yet—log today! 📅"
          : "No mood data this month—let’s get started! 🌟";
    }

    return viewMode == CalendarViewMode.weekly
        ? _getShortTermTrend(filteredData)
        : _getLongTermTrend(moods);
  }

  String _getShortTermTrend(Map<DateTime, int> filteredData) {
    final entries = filteredData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final moodValues = entries.map((e) => e.value.toDouble()).toList();
    final averageMood = moodValues.reduce((a, b) => a + b) / moodValues.length;
    final happyDays = entries.where((e) => e.value >= 2).length;
    final variance = _calculateVariance(moodValues, averageMood);
    final bestDay = entries.reduce((a, b) => a.value > b.value ? a : b);

    if (happyDays > entries.length * 0.8) {
      return "Wow, ${((happyDays / entries.length) * 100).round()}% happy days! You’re shining bright! 🌞 Keep it up!";
    }
    if (averageMood < 1.5) {
      return "Mood avg: ${averageMood.toStringAsFixed(1)}. Tough week? Try a relaxation exercise! 🧘‍♀️";
    }
    if (variance > 1.0) {
      return "Your mood’s been a rollercoaster (var: ${variance.toStringAsFixed(1)})! Best day: ${_weekdayName(bestDay.key.weekday)} (${_moodEmoji(bestDay.value)}).";
    }
    if (_isWeekendHappier(entries)) {
      return "Weekends lift your spirits! Best: ${_weekdayName(bestDay.key.weekday)} (${_moodEmoji(bestDay.value)}). Plan some weekday joy! 🎉";
    }
    return "Stable vibes (avg: ${averageMood.toStringAsFixed(1)}). Your peak was ${_weekdayName(bestDay.key.weekday)} (${_moodEmoji(bestDay.value)})! 😊";
  }

  double _calculateVariance(List<double> values, double mean) {
    if (values.length < 2) return 0.0;
    final sumSquaredDiff =
        values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b);
    return sumSquaredDiff / (values.length - 1);
  }

  bool _isWeekendHappier(List<MapEntry<DateTime, int>> entries) {
    final weekendMoods =
        entries.where((e) => e.key.weekday >= 6).map((e) => e.value);
    final weekdayMoods =
        entries.where((e) => e.key.weekday < 6).map((e) => e.value);
    if (weekendMoods.isEmpty || weekdayMoods.isEmpty) return false;
    final weekendAvg =
        weekendMoods.reduce((a, b) => a + b) / weekendMoods.length;
    final weekdayAvg =
        weekdayMoods.reduce((a, b) => a + b) / weekdayMoods.length;
    return weekendAvg > weekdayAvg + 0.5;
  }

  Map<DateTime, int> _filterWeeklyData(
      Map<DateTime, MoodEntry> moods, DateTime baseDate) {
    final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
    final end = start.add(const Duration(days: 6));
    return Map.fromEntries(
      moods.entries
          .where((e) =>
              e.key.isAfter(start.subtract(const Duration(days: 1))) &&
              e.key.isBefore(end.add(const Duration(days: 1))))
          .map((e) => MapEntry(e.key, e.value.moodRating)),
    );
  }

  Map<DateTime, int> _filterMonthlyData(
      Map<DateTime, MoodEntry> moods, DateTime baseDate) {
    final start = DateTime(baseDate.year, baseDate.month, 1);
    final end = DateTime(baseDate.year, baseDate.month + 1, 0);
    return Map.fromEntries(
      moods.entries
          .where((e) =>
              e.key.isAfter(start.subtract(const Duration(days: 1))) &&
              e.key.isBefore(end.add(const Duration(days: 1))))
          .map((e) => MapEntry(e.key, e.value.moodRating)),
    );
  }

  String _weekdayName(int weekday) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];
  String _moodEmoji(int rating) => ['😢', '😐', '😊', '😄', '🌟'][rating];

  String _getLongTermTrend(Map<DateTime, MoodEntry> moods) {
    if (moods.length < 14) return "Keep logging for long-term insights!";
    final lastMonth = moods.entries
        .where((e) =>
            e.key.isAfter(DateTime.now().subtract(const Duration(days: 30))))
        .toList();
    final prevMonth = moods.entries
        .where((e) =>
            e.key.isAfter(DateTime.now().subtract(const Duration(days: 60))) &&
            e.key.isBefore(DateTime.now().subtract(const Duration(days: 30))))
        .toList();

    final lastAvg = lastMonth.isEmpty
        ? 0.0
        : lastMonth.map((e) => e.value.moodRating).reduce((a, b) => a + b) /
            lastMonth.length;
    final prevAvg = prevMonth.isEmpty
        ? 0.0
        : prevMonth.map((e) => e.value.moodRating).reduce((a, b) => a + b) /
            prevMonth.length;

    if (lastAvg > prevAvg) {
      return "Your mood improved by ${(lastAvg - prevAvg).toStringAsFixed(1)} points this month! 🌟";
    }
    return "Your mood dipped slightly. Try a challenge! 📈";
  }

  double calculateAverageMood(Map<DateTime, MoodEntry> moods) {
    if (moods.isEmpty) return 0;
    return moods.values.map((e) => e.moodRating).reduce((a, b) => a + b) /
        moods.length;
  }

  // int getStreakCount(Map<DateTime, MoodEntry> moods) {
  //   if (moods.isEmpty) return 0;
  //   final sortedDates = moods.keys.toList()..sort((a, b) => b.compareTo(a));
  //   int streak = 0;
  //   DateTime? previous;

  //   for (var date in sortedDates) {
  //     if (previous == null || previous.difference(date).inDays == 1) {
  //       streak++;
  //       previous = date;
  //     } else if (previous.difference(date).inDays > 1) {
  //       break;
  //     }
  //   }
  //   return streak;
  // }
}
