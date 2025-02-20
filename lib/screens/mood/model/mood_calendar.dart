import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/providers/mood_tracker_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodCalendar extends ConsumerWidget {
  const MoodCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodProvider);
    final currentDisplayedDate = ref.watch(currentDisplayedWeekProvider);
    final viewMode = ref.watch(calendarViewProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now(),
        focusedDay: currentDisplayedDate,
        calendarFormat: viewMode == CalendarViewMode.weekly
            ? CalendarFormat.week
            : CalendarFormat.month,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, _) {
            final mood = moods[date] ?? -1;
            return mood != -1
                ? Container(
                    margin: const EdgeInsets.all(4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _moodColor(mood),
                      shape: BoxShape.circle,
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
        onDaySelected: (day, _) => _showMoodPicker(context, ref, day),
        onFormatChanged: (format) {
          // Update view mode and adjust displayed period
          final newViewMode = format == CalendarFormat.week
              ? CalendarViewMode.weekly
              : CalendarViewMode.monthly;
          ref.read(calendarViewProvider.notifier).state = newViewMode;

          // Reset displayed period to start of week/month
          final newDate = newViewMode == CalendarViewMode.weekly
              ? currentDisplayedDate
                  .subtract(Duration(days: currentDisplayedDate.weekday % 7))
              : DateTime(
                  currentDisplayedDate.year, currentDisplayedDate.month, 1);

          ref.read(currentDisplayedWeekProvider.notifier).state = newDate;
        },
        onPageChanged: (focusedDay) {
          // Update displayed period when user navigates
          ref.read(currentDisplayedWeekProvider.notifier).state = focusedDay;
        },
      ),
    );
  }

  Color _moodColor(int index) {
    return const [
      Colors.red, // 😢
      Colors.orange, // 😐
      Colors.lime, // 😊
      Colors.green, // 😄
      Colors.yellow // 🌟
    ][index];
  }

  void _showMoodPicker(BuildContext context, WidgetRef ref, DateTime day) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 5,
          children: List.generate(
            5,
            (index) => GestureDetector(
              onTap: () {
                ref.read(moodProvider.notifier).logMood(index, day);
                ref.read(selectedDateProvider.notifier).state = day;
                Navigator.pop(context);
              },
              child: Text(
                ['😢', '😐', '😊', '😄', '🌟'][index],
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
