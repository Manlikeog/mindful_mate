/// Represents data for an insight card UI component.
class InsightCardData {
  final String title;
  final String insightText;
  final String dateRange;
  final String? suggestedExercise;
  final bool isExerciseCompleted;

  InsightCardData({
    required this.title,
    required this.insightText,
    required this.dateRange,
    required this.suggestedExercise,
    required this.isExerciseCompleted,
  });
}