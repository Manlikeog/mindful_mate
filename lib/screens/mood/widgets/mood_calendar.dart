import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/providers/calendar_provider.dart';

import 'package:mindful_mate/providers/mood_provider.dart';
import 'package:mindful_mate/screens/mood/utils/mood_util.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodCalendar extends ConsumerStatefulWidget {
  const MoodCalendar({super.key});

  @override
  _MoodCalendarState createState() => _MoodCalendarState();
}

class _MoodCalendarState extends ConsumerState<MoodCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
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
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: viewMode == CalendarViewMode.weekly
              ? CalendarFormat.week
              : CalendarFormat.month,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) => buildMoodMarker(date, moods),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            handleMoodSelection(context, ref, selectedDay);
          },
        ),
      ),
    );
  }

  Widget? buildMoodMarker(DateTime date, Map<DateTime, MoodEntry> moods) {
    if (moods.containsKey(date)) {
      final rating = moods[date]!.moodRating;
      return Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: [
            Colors.red,
            Colors.orange,
            Colors.lime,
            Colors.green,
            Colors.yellow
          ][rating],
        ),
        width: 8.0,
        height: 8.0,
      );
    }
    return null;
  }

  
}