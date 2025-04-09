// lib/screens/progress/providers/insights_card_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/data/model/insight/insight_card.dart';
import 'package:mindful_mate/providers/calendar_provider.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/providers/insight/insight_provider.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';

final insightsCardProvider = Provider((ref) {
  final viewMode = ref.watch(calendarViewProvider);
  final baseDate = ref.watch(currentDisplayedWeekProvider);
  final progress = ref.watch(gamificationProvider);
  final insights = ref.watch(insightsProvider);

  final title = getTitle(viewMode);
  final insightText = insights.getMoodInsight(baseDate, viewMode);
  final dateRange = getDateRange(viewMode, baseDate);
  final suggestedExercise = getSuggestedExercise(insights);
  final isExerciseCompleted =
      getIsExerciseCompleted(suggestedExercise, progress);

  return InsightCardData(
    title: title,
    insightText: insightText,
    dateRange: dateRange,
    suggestedExercise: suggestedExercise,
    isExerciseCompleted: isExerciseCompleted,
  );
});

String getTitle(CalendarViewMode viewMode) =>
    viewMode == CalendarViewMode.weekly
        ? 'Weekly Insights'
        : 'Monthly Insights';

String getDateRange(CalendarViewMode viewMode, DateTime baseDate) {
  if (viewMode == CalendarViewMode.weekly) {
    final endDate = baseDate.add(const Duration(days: 6));
    return '${_formatDate(baseDate)} - ${_formatDate(endDate)}';
  }
  return '${_monthAbbreviation(baseDate.month)} ${baseDate.year}';
}

String? getSuggestedExercise(InsightsProvider insights) {
  final avgMood = insights.getAverageMood();
  print(avgMood);
  if (avgMood == null) return null;
  if (avgMood < 1.5) return 'deep_breathing';
  if (avgMood < 2.5) return 'mindfulness';
  return null;
}

bool getIsExerciseCompleted(String? exercise, UserProgress progress) {
  if (exercise == null) return false;
  final lastCompletion = progress.completedRelaxations[exercise];
  return lastCompletion != null && _isSameDay(lastCompletion, DateTime.now());
}

void onTryRelaxationPressed(BuildContext context, String? exercise) {
  if (exercise != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => RelaxationScreen(suggestedExerciseId: exercise)),
    );
  }
}

// Helper functions
String _formatDate(DateTime date) =>
    '${date.day} ${_monthAbbreviation(date.month)}';
String _monthAbbreviation(int month) => [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][month - 1];
bool _isSameDay(DateTime date1, DateTime date2) =>
    date1.year == date2.year &&
    date1.month == date2.month &&
    date1.day == date2.day;
