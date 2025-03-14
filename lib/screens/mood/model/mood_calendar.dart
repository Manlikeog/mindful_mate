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
                  : null;
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

  Color _moodColor(int index) {
    return [
      Colors.red, // 😢
      Colors.orange, // 😐
      Colors.lime, // 😊
      Colors.green, // 😄
      injector.palette.accentColor, // 🌟 (gold)
    ][index];
  }

  void _showMoodPicker(BuildContext context, WidgetRef ref, DateTime day) {
    final moods = ref.read(moodProvider);
    final isToday = isSameDay(day, DateTime.now());
    final existingMood = moods[day];

    if (!isToday && existingMood != null) {
      // Show confirmation dialog for previous day with existing mood
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
      // Proceed directly to mood selection for today or days without existing moods
      _showMoodSelectionDialog(context, ref, day, isToday);
    }
  }

  void _showMoodSelectionDialog(
      BuildContext context, WidgetRef ref, DateTime day, bool isToday) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            5,
            (index) => GestureDetector(
              onTap: () {
                final newMood = MoodEntry(date: day, moodRating: index);
                ref.read(moodProvider.notifier).logMood(newMood);
                if (isToday) {
                  ref
                      .read(gamificationProvider.notifier)
                      .logActivity(activityType: 'mood_log');
                  if (context.mounted) {
                    (context.findAncestorStateOfType<MoodTrackerScreenState>())
                        ?.showRewardAnimation();
                  }
                }
                Navigator.pop(ctx);
              },
              child: Text(['😢', '😐', '😊', '😄', '🌟'][index],
                  style: const TextStyle(fontSize: 32)),
            ),
          ),
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
  // lib/screens/mood/model/mood_calendar.dart (partial)
  
// void _showEnhancedMoodPicker(BuildContext context, WidgetRef ref, DateTime day) {
//   int rating = 3; // Default
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Log Your Mood'),
//       content: StatefulBuilder(
//         builder: (context, setState) => Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Slider(
//               value: rating.toDouble(),
//               min: 1,
//               max: 5,
//               divisions: 4,
//               label: rating.toString(),
//               onChanged: (value) => setState(() => rating = value.round()),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             ref.read(moodProvider.notifier).logMood(MoodEntry(date: day, moodRating: rating));
//             ref.read(gamificationProvider.notifier).logActivity(activityType: 'mood_log');
//             Navigator.pop(context);
//                         if (context.mounted) {
//               (context.findAncestorStateOfType<MoodTrackerScreenState>())?.showRewardAnimation();
//             }
//           },
//           child: Text('Save'),
//         ),
//       ],
//     ),
//   );
// }

// void _showMoodPicker(BuildContext context, WidgetRef ref, DateTime day) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: List.generate(5, (index) {
//           return GestureDetector(
//             onTap: () {
//               ref.read(moodProvider.notifier).logMood(index, day);
//               ref.read(gamificationProvider.notifier).logActivity(activityType: 'mood_log');
//               Navigator.pop(context);
//             },
//             child: Text(['😢', '😐', '😊', '😄', '🌟'][index], style: const TextStyle(fontSize: 32)),
//           );
//         }),
//       ),
//     ),
//   );
// }

//  void _showMoodPicker(BuildContext context, WidgetRef ref, DateTime day) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (ctx) => Container(
//         height: 200,
//         decoration: BoxDecoration(
//           color: injector.palette.pureWhite,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: GridView.count(
//           crossAxisCount: 5,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           children: List.generate(
//             5,
//             (index) => GestureDetector(
//               onTap: () {
//                 ref.read(moodProvider.notifier).logMood(index, day);
//                 ref.read(selectedDateProvider.notifier).state = day;
//                 Navigator.pop(context);
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 decoration: BoxDecoration(
//                   color: ref.watch(moodProvider)[day] == index
//                       ? injector.palette.primaryColor.withOpacity(0.2)
//                       : Colors.transparent,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     ['😢', '😐', '😊', '😄', '🌟'][index],
//                     style: const TextStyle(fontSize: 32),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }