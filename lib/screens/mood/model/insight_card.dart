import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/providers/mood_tracker_provider.dart'; // Imports extension methods
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';

class InsightsCard extends ConsumerWidget {
  const InsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodProvider);
    final currentWeekStart = ref.watch(currentDisplayedWeekProvider);
    final viewMode = ref.watch(calendarViewProvider);

    // Use extension methods directly on ref
    final insight = ref.getMoodInsight(currentWeekStart, viewMode);
    final suggestedExercise = _getRelaxationSuggestion(ref, currentWeekStart, viewMode);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Card(
          key: ValueKey('$currentWeekStart$viewMode${moods.hashCode}'),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade50,
                  Colors.blue.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.insights, color: Colors.purple.shade600),
                    const SizedBox(width: 12),
                    Text(
                      viewMode == CalendarViewMode.weekly
                          ? 'Weekly Insights'
                          : 'Monthly Insights',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  insight,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  viewMode == CalendarViewMode.weekly
                      ? _getFormattedDateRange(currentWeekStart)
                      : '${_monthAbbreviation(currentWeekStart.month)} ${currentWeekStart.year}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (suggestedExercise != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Suggested Relaxation: $suggestedExercise',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RelaxationScreen(suggestedExerciseId: suggestedExercise),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Try This Relaxation'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _getRelaxationSuggestion(WidgetRef ref, DateTime baseDate, CalendarViewMode viewMode) {
    final moods = ref.watch(moodProvider);
    final filteredData = viewMode == CalendarViewMode.weekly
        ? ref.filterWeeklyData(moods, baseDate)
        : ref.filterMonthlyData(moods, baseDate);

    if (filteredData.isEmpty) return null;

    final entries = filteredData.entries.toList();
    final averageMood = entries.map((e) => e.value.toDouble()).reduce((a, b) => a + b) / entries.length;

    // Suggest relaxation based on mood
    if (averageMood < 1.5) {
      return 'deep_breathing'; // Matches RelaxationExercise id
    } else if (averageMood < 2.5) {
      return 'mindfulness'; // Matches RelaxationExercise id
    }
    return null; // No suggestion for high mood
  }

  String _getFormattedDateRange(DateTime startDate) {
    final endDate = startDate.add(const Duration(days: 6));
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthAbbreviation(date.month)}';
  }

  String _monthAbbreviation(int month) {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
  }
}