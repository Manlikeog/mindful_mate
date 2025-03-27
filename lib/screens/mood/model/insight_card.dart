import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/providers/mood_tracker_provider.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';
import 'package:mindful_mate/providers/gamification/gamification_provider.dart'; // Add this import

class InsightsCard extends ConsumerWidget {
  const InsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodProvider);
    final currentWeekStart = ref.watch(currentDisplayedWeekProvider);
    final viewMode = ref.watch(calendarViewProvider);
    final progress = ref.watch(gamificationProvider); // Watch gamification state

    final insight = ref.getMoodInsight(currentWeekStart, viewMode);
    final suggestedExercise = _getRelaxationSuggestion(ref);

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
                  Row(
                    children: [
                      Text(
                        'Suggested Relaxation: $suggestedExercise',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.purple.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_isSuggestedCompletedToday(suggestedExercise, progress))
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                    ],
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

  String? _getRelaxationSuggestion(WidgetRef ref) {
    final moods = ref.watch(moodProvider);
    final recentMoods = moods.entries
        .where((e) => e.key.isAfter(DateTime.now().subtract(const Duration(days: 2))))
        .toList();

    if (recentMoods.isEmpty) return null;

    final averageRecentMood = recentMoods
        .map((e) => e.value.moodRating.toDouble())
        .reduce((a, b) => a + b) / recentMoods.length;

    if (averageRecentMood < 1.5) {
      return 'deep_breathing';
    } else if (averageRecentMood < 2.5) {
      return 'mindfulness';
    }
    return null;
  }

  bool _isSuggestedCompletedToday(String suggestedExercise, UserProgress progress) {
    final lastCompletion = progress.completedRelaxations[suggestedExercise];
    return lastCompletion != null && _isSameDay(lastCompletion, DateTime.now());
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

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}