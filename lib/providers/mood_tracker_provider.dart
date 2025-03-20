import 'dart:math';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/screens/mood/model/mood_entry.dart';

final calendarViewProvider =
    StateProvider<CalendarViewMode>((ref) => CalendarViewMode.weekly);
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

enum CalendarViewMode { weekly, monthly }

extension MoodAnalysis on WidgetRef {
  String getMoodInsight(DateTime baseDate, CalendarViewMode viewMode) {
  final moods = watch(moodProvider);
  if (moods.isEmpty) return "Start tracking your mood to see insights! 🌱";

  final filteredData = viewMode == CalendarViewMode.weekly
      ? _filterWeeklyData(moods, baseDate)
      : _filterMonthlyData(moods, baseDate);

  if (filteredData.isEmpty) {
    return viewMode == CalendarViewMode.weekly
        ? "No mood data this week yet—log today! 📅"
        : "No mood data this month—let’s get started! 🌟";
  }

  final entries = filteredData.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final moodValues = entries.map((e) => e.value.toDouble()).toList();
  final averageMood = moodValues.reduce((a, b) => a + b) / moodValues.length;
  final happyDays = entries.where((e) => e.value >= 2).length;
  final variance = _calculateVariance(moodValues, averageMood);
  final bestDay = entries.reduce((a, b) => a.value > b.value ? a : b);
  // final worstDay = entries.reduce((a, b) => a.value < b.value ? a : b);

  String getShortTermTrend() {
    if (happyDays > entries.length * 0.8) {
      return "Wow, ${((happyDays / entries.length) * 100).round()}% happy days! You’re shining bright! 🌞 Keep it up!";
    }
    if (averageMood < 1.5) {
      return "Mood avg: ${averageMood.toStringAsFixed(1)}. Tough ${viewMode == CalendarViewMode.weekly ? 'week' : 'month'}? Try a relaxation exercise! 🧘‍♀️";
    }
    if (variance > 1.0) {
      return "Your mood’s been a rollercoaster (var: ${variance.toStringAsFixed(1)})! Best day: ${_weekdayName(bestDay.key.weekday)} (${_moodEmoji(bestDay.value)}).";
    }
    if (_isWeekendHappier(entries)) {
      return "Weekends lift your spirits! Best: ${_weekdayName(bestDay.key.weekday)} (${_moodEmoji(bestDay.value)}). Plan some weekday joy! 🎉";
    }
    return "Stable vibes (avg: ${averageMood.toStringAsFixed(1)}). Your peak was ${_weekdayName(bestDay.key.weekday)} (${_moodEmoji(bestDay.value)})! 😊";
  }

  String getLongTermTrend() {
    if (moods.length < 14) return "Keep logging for long-term insights!";
    final lastMonth = moods.entries
        .where((e) => e.key.isAfter(DateTime.now().subtract(Duration(days: 30))))
        .toList();
    final prevMonth = moods.entries
        .where((e) =>
            e.key.isAfter(DateTime.now().subtract(Duration(days: 60))) &&
            e.key.isBefore(DateTime.now().subtract(Duration(days: 30))))
        .toList();
    final lastAvg = lastMonth.isEmpty
        ? 0
        : lastMonth.map((e) => e.value.moodRating).reduce((a, b) => a + b) / lastMonth.length;
    final prevAvg = prevMonth.isEmpty
        ? 0
        : prevMonth.map((e) => e.value.moodRating).reduce((a, b) => a + b) / prevMonth.length;
    if (lastAvg > prevAvg) {
      return "Your mood improved by ${(lastAvg - prevAvg).toStringAsFixed(1)} points this month! 🌟";
    }
    return "Your mood dipped slightly. Try a challenge! 📈";
  }

  return viewMode == CalendarViewMode.weekly ? getShortTermTrend() : getLongTermTrend();
}

  double _calculateVariance(List<double> values, double mean) {
    if (values.length < 2) return 0;
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

  String _weekdayName(int weekday) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];
  String _moodEmoji(int rating) => ['😢', '😐', '😊', '😄', '🌟'][rating];

Map<DateTime, int> _filterWeeklyData(Map<DateTime, MoodEntry> moods, DateTime baseDate) {
  final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
  final end = start.add(const Duration(days: 6));
  return Map.fromEntries(
    moods.entries.where((e) =>
        e.key.isAfter(start.subtract(const Duration(days: 1))) &&
        e.key.isBefore(end.add(const Duration(days: 1)))).map((e) => MapEntry(e.key, e.value.moodRating)),
  );
}

Map<DateTime, int> _filterMonthlyData(Map<DateTime, MoodEntry> moods, DateTime baseDate) {
  final start = DateTime(baseDate.year, baseDate.month, 1);
  final end = DateTime(baseDate.year, baseDate.month + 1, 0);
  return Map.fromEntries(
    moods.entries.where((e) =>
        e.key.isAfter(start.subtract(const Duration(days: 1))) &&
        e.key.isBefore(end.add(const Duration(days: 1)))).map((e) => MapEntry(e.key, e.value.moodRating)),
  );
}
}

final currentDisplayedWeekProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return now.subtract(Duration(days: now.weekday % 7));
});
