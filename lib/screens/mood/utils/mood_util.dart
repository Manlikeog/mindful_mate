// lib/utils/mood_utils.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/providers/calendar_provider.dart';
import 'package:mindful_mate/providers/mood_provider.dart';
import 'package:mindful_mate/screens/mood/widgets/mood_picker.dart';
import 'package:table_calendar/table_calendar.dart';




List<FlSpot> createMoodSpots(Map<DateTime, int> moods) {
  return moods.entries
      .map((e) => FlSpot(e.key.millisecondsSinceEpoch.toDouble(), e.value.toDouble()))
      .toList()
    ..sort((a, b) => a.x.compareTo(b.x));
}

double getMinX(DateTime baseDate, CalendarViewMode viewMode) {
  if (viewMode == CalendarViewMode.weekly) {
    final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
    return DateTime(start.year, start.month, start.day).millisecondsSinceEpoch.toDouble();
  } else {
    return DateTime(baseDate.year, baseDate.month, 1).millisecondsSinceEpoch.toDouble();
  }
}

double getMaxX(DateTime baseDate, CalendarViewMode viewMode) {
  if (viewMode == CalendarViewMode.weekly) {
    final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
    final end = start.add(const Duration(days: 6));
    return DateTime(end.year, end.month, end.day, 23, 59, 59).millisecondsSinceEpoch.toDouble();
  } else {
    return DateTime(baseDate.year, baseDate.month + 1, 0, 23, 59, 59).millisecondsSinceEpoch.toDouble();
  }
}

String formatDate(double milliseconds) {
  final date = DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt());
  return '${date.day} ${monthAbbreviation(date.month)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

String getDayLabel(int weekday) {
  const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  return days[weekday % 7];
}

String monthAbbreviation(int month) {
  return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
}

void handleMoodSelection(BuildContext context, WidgetRef ref, DateTime selectedDay) {
    final moods = ref.read(moodProvider);
    final isToday = isSameDay(selectedDay, DateTime.now());
    final existingMood = moods[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)];

    if (!isToday && existingMood != null) {
      showOverwriteDialog(context, ref, selectedDay);
    } else {
      MoodPicker.show(context, selectedDay, ref.read(moodProvider.notifier));
    }
  }

  void showOverwriteDialog(BuildContext context, WidgetRef ref, DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Overwrite Mood?'),
        content: const Text('A mood is already logged for this day. Are you sure you want to overwrite it?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              MoodPicker.show(context, selectedDay, ref.read(moodProvider.notifier));
              Navigator.pop(ctx);
            },
            child: const Text('Overwrite'),
          ),
        ],
      ),
    );
  }