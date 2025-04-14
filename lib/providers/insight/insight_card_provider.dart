import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/data/model/insight/insight_card.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/providers/calendar_provider.dart';
import 'package:mindful_mate/providers/insight/insight_provider.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';
import 'package:mindful_mate/utils/date_utils.dart';

/// Provides data for the insights card UI.
final insightsCardProvider = Provider((ref) {
  final viewMode = ref.watch(calendarViewProvider);
  final baseDate = ref.watch(currentDisplayedWeekProvider);
  final progress = ref.watch(userProgressProvider);
  final insights = ref.watch(insightsProvider);

  final title = getTitle(viewMode);
  final insightText = insights.getMoodInsight(baseDate, viewMode);
  final dateRange = getDateRange(viewMode, baseDate);
  final suggestedExercise = getSuggestedExercise(insights, progress.level);
  final isExerciseCompleted = getIsExerciseCompleted(suggestedExercise, progress);

  return InsightCardData(
    title: title,
    insightText: insightText,
    dateRange: dateRange,
    suggestedExercise: suggestedExercise,
    isExerciseCompleted: isExerciseCompleted,
  );
});

/// Returns the title for the insights card based on view mode.
String getTitle(CalendarViewMode viewMode) =>
    viewMode == CalendarViewMode.weekly ? 'Weekly Insights' : 'Monthly Insights';

/// Returns the date range string for the insights card.
String getDateRange(CalendarViewMode viewMode, DateTime baseDate) {
  if (viewMode == CalendarViewMode.weekly) {
    final endDate = baseDate.add(const Duration(days: 6));
    return '${_formatDate(baseDate)} - ${_formatDate(endDate)}';
  }
  return '${_monthAbbreviation(baseDate.month)} ${baseDate.year}';
}

/// Suggests a relaxation exercise based on average mood and level.
String? getSuggestedExercise(InsightsProvider insights, int userLevel) {
  final avgMood = insights.getAverageMood();
  if (avgMood == null) return null;

  final availableExercises = levelRelaxations[userLevel] ?? [];
  if (availableExercises.isEmpty) return null;

  const lowMoodTypes = ['breath', 'body', 'progressive'];
  const mediumMoodTypes = ['mindfulness', 'meditate', 'tense', 'visualize', 'count'];
  const highMoodTypes = ['yoga', 'stretch', 'gratitude', 'kindness'];

  final targetTypes = avgMood < 1.5
      ? lowMoodTypes
      : avgMood < 2.5
          ? mediumMoodTypes
          : highMoodTypes;

  return availableExercises.firstWhere(
    (r) => targetTypes.any((type) => r.id.contains(type)),
    orElse: () => availableExercises.first,
  ).id;
}

/// Checks if the suggested exercise is completed today.
bool getIsExerciseCompleted(String? exercise, UserProgress progress) {
  if (exercise == null) return false;
  final lastCompletion = progress.completedRelaxations[exercise];
  return lastCompletion != null && isSameDay(lastCompletion, DateTime.now());
}

/// Navigates to the relaxation screen for the given exercise.
void onTryRelaxationPressed(BuildContext context, String? exercise) {
  if (exercise != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RelaxationScreen(suggestedExerciseId: exercise),
      ),
    );
  }
}

/// Formats a date as "day monthAbbreviation".
String _formatDate(DateTime date) => '${date.day} ${_monthAbbreviation(date.month)}';

/// Returns the abbreviated month name.
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
      'Dec',
    ][month - 1];