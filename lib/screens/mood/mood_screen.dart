import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/providers/mood_tracker_provider.dart';
import 'package:mindful_mate/screens/mood/model/mood_calendar.dart';
import 'package:mindful_mate/screens/mood/model/trend_chart.dart';

class MoodTrackerScreen extends ConsumerWidget {
  static const String path = 'moodTracker';
  static const String fullPath = '/moodTracker';
  static const String pathName = '/moodTracker';

  const MoodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood History'),
        actions: const [
          _ViewModeToggle(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MoodCalendar(),
            const TrendChart(),
            _InsightsCard(ref),
          ],
        ),
      ),
    );
  }
}

class _ViewModeToggle extends ConsumerWidget {
  const _ViewModeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(calendarViewProvider);
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: ToggleButtons(
        isSelected: [
          viewMode == CalendarViewMode.weekly,
          viewMode == CalendarViewMode.monthly,
        ],
        onPressed: (index) => ref.read(calendarViewProvider.notifier).state =
            index == 0 ? CalendarViewMode.weekly : CalendarViewMode.monthly,
        children: const [Text('Week'), Text('Month')],
      ),
    );
  }
}

// class TrendChart extends ConsumerWidget {
//   const TrendChart({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final moodData = ref.watch(moodProvider);
//     final viewMode = ref.watch(calendarViewProvider);
//     final currentWeekStart = ref.watch(currentDisplayedWeekProvider);

//     final filteredData = _filterData(moodData, currentWeekStart, viewMode);
//     final dateRangeText = _getDateRangeText(currentWeekStart, viewMode);

//     return Column(
//       children: [
//         Card(
//             margin: const EdgeInsets.all(16),
//             child: Container(
//               height: 200,
//               padding: const EdgeInsets.symmetric(horizontal: 17),
//               child: LineChart(
//                 LineChartData(
//                   lineBarsData: [_createChartData(filteredData)],
//                   titlesData: FlTitlesData(
//                     topTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                         axisNameWidget: Text('mood trend'),
//                         axisNameSize: 35),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           final index = value.toInt();
//                           return Text(
//                             ['😢', '😐', '😊', '😄', '🌟'][index],
//                             style: const TextStyle(fontSize: 16),
//                           );
//                         },
//                         interval: 1,
//                         reservedSize: 40,
//                       ),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           final date = DateTime.fromMillisecondsSinceEpoch(
//                               value.toInt());
//                           return Transform.rotate(
//                             angle: -45 *
//                                 (3.1416 / 180), // Rotate labels 45 degrees
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 8),
//                               child: Text(
//                                 viewMode == CalendarViewMode.weekly
//                                     ? _getDayLabel(date.weekday)
//                                     : date.day.toString(),
//                                 style: const TextStyle(
//                                   fontSize: 10, // Reduced font size
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         reservedSize: 48, // Increased reserved space
//                         interval: viewMode == CalendarViewMode.weekly
//                             ? 86400000
//                             : null,
//                       ),
//                     ),
//                   ),
//                   minX: _getMinX(currentWeekStart, viewMode),
//                   maxX: _getMaxX(currentWeekStart, viewMode),
//                   minY: 0,
//                   maxY: 4,
//                   borderData: FlBorderData(show: false),
//                 ),
//               ),
//             )),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 16),
//           child: Text(
//             dateRangeText,
//             style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500),
//           ),
//         ),
//       ],
//     );
//   }

// }

class _InsightsCard extends ConsumerWidget {
  final WidgetRef ref;

  const _InsightsCard(this.ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          ref.getMoodInsight(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
