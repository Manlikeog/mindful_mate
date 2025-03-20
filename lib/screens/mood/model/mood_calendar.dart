import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/gamification_provider.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/providers/mood_tracker_provider.dart';
import 'package:mindful_mate/screens/mood/model/mood_entry.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              injector.palette.primaryColor.withOpacity(0.1),
              injector.palette.secondaryColor.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TableCalendar(
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now(),
          focusedDay: currentDisplayedDate,
          calendarFormat: viewMode == CalendarViewMode.weekly
              ? CalendarFormat.week
              : CalendarFormat.month,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: injector.palette.textColor,
                ),
            leftChevronIcon:
                Icon(Icons.chevron_left, color: injector.palette.primaryColor),
            rightChevronIcon:
                Icon(Icons.chevron_right, color: injector.palette.primaryColor),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: injector.palette.accentColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: injector.palette.primaryColor,
              shape: BoxShape.circle,
            ),
            defaultTextStyle: Theme.of(context).textTheme.bodyMedium!,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, _) {
              // Normalize the date to only year, month, day
              final normalizedDate = DateTime(date.year, date.month, date.day);
              final moodEntry = moods[normalizedDate];
              if (moodEntry != null) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _moodColor(moodEntry.moodRating),
                    shape: BoxShape.circle,
                  ),
                );
              }
              return null;
            },
          ),
          onDaySelected: (day, _) => _showMoodPicker(context, ref, day),
          onFormatChanged: (format) {
            final newViewMode = format == CalendarFormat.week
                ? CalendarViewMode.weekly
                : CalendarViewMode.monthly;
            ref.read(calendarViewProvider.notifier).state = newViewMode;
            final newDate = newViewMode == CalendarViewMode.weekly
                ? currentDisplayedDate
                    .subtract(Duration(days: currentDisplayedDate.weekday % 7))
                : DateTime(
                    currentDisplayedDate.year, currentDisplayedDate.month, 1);
            ref.read(currentDisplayedWeekProvider.notifier).state = newDate;
          },
          onPageChanged: (focusedDay) {
            ref.read(currentDisplayedWeekProvider.notifier).state = focusedDay;
          },
        ),
      ),
    );
  }

  Color _moodColor(int rating) {
    return [
      Colors.red, // 😢
      Colors.orange, // 😐
      Colors.lime, // 😊
      Colors.green, // 😄
      injector.palette.accentColor, // 🌟 (gold)
    ][rating];
  }

  void _showMoodPicker(BuildContext context, WidgetRef ref, DateTime day) {
    final moods = ref.read(moodProvider);
    final isToday = isSameDay(day, DateTime.now());
    final existingMood =
        moods[DateTime(day.year, day.month, day.day)]; // Normalize here too

    if (!isToday && existingMood != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Overwrite Mood?'),
          content: const Text(
              'A mood is already logged for this day. Are you sure you want to overwrite it?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _showMoodSelectionDialog(context, ref, day, isToday);
              },
              child: const Text('Overwrite'),
            ),
          ],
        ),
      );
    } else {
      _showMoodSelectionDialog(context, ref, day, isToday);
    }
  }

  void _showMoodSelectionDialog(
      BuildContext context, WidgetRef ref, DateTime day, bool isToday) {
    String? note;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx2) => AlertDialog(
                        title: const Text('Add a Note (Optional)'),
                        content: TextField(
                          onChanged: (value) => note = value,
                          decoration: const InputDecoration(
                              hintText: 'How are you feeling?'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              final newMood = MoodEntry(
                                  date: DateTime(day.year, day.month, day.day),
                                  moodRating: index,
                                  note: note);
                              ref.read(moodProvider.notifier).logMood(newMood);
                              if (isToday) {
                                ref
                                    .read(gamificationProvider.notifier)
                                    .logActivity(activityType: 'mood_log');
                                if (context.mounted) {
                                  (context.findAncestorStateOfType<
                                          MoodTrackerScreenState>())
                                      ?.showRewardAnimation();
                                }
                              }
                              Navigator.pop(ctx2);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Save'),
                          ),
                          TextButton(
                            onPressed: () {
                              final newMood = MoodEntry(
                                  date: DateTime(day.year, day.month, day.day),
                                  moodRating: index,
                                  note: "");
                              ref.read(moodProvider.notifier).logMood(newMood);
                              if (isToday) {
                                ref
                                    .read(gamificationProvider.notifier)
                                    .logActivity(activityType: 'mood_log');
                                if (context.mounted) {
                                  (context.findAncestorStateOfType<
                                          MoodTrackerScreenState>())
                                      ?.showRewardAnimation();
                                }
                              }
                              Navigator.pop(ctx2);
                              Navigator.pop(ctx);
                            },
                            child: const Text('No Notes'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(['😢', '😐', '😊', '😄', '🌟'][index],
                      style: const TextStyle(fontSize: 32)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
