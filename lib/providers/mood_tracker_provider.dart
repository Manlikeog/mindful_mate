

// 2. providers/mood_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';

final calendarViewProvider = StateProvider<CalendarViewMode>((ref) => CalendarViewMode.weekly);
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

enum CalendarViewMode { weekly, monthly }

extension MoodAnalysis on WidgetRef {
  String getMoodInsight() {
    final moods = read(moodProvider);
    if (moods.isEmpty) return "Start tracking your mood to see insights! 🌱";
    
    final entries = moods.entries;
    final happyDays = entries.where((entry) => entry.value >= 2).length;
    final averageMood = entries.isEmpty 
        ? 0 
        : entries.map((e) => e.value).reduce((a, b) => a + b) / entries.length;
    
    if (happyDays > entries.length * 0.8) return "You're consistently positive! 🌟";
    if (averageMood < 1.5) return "Let's focus on self-care this week 💆♀️";
    return "You felt happiest on weekends! 🎉";
  }
}