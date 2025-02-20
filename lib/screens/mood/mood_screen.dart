import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/providers/mood_tracker_provider.dart';
import 'package:mindful_mate/screens/mood/model/mood_calendar.dart';

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

class TrendChart extends ConsumerWidget {
  const TrendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodData = ref.watch(moodProvider);
    final viewMode = ref.watch(calendarViewProvider);
    final currentWeekStart = ref.watch(currentDisplayedWeekProvider);

    final filteredData = _filterData(moodData, currentWeekStart, viewMode);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            lineBarsData: [_createChartData(filteredData)],
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
                axisNameWidget: Text('Mood Trend'),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return Text(
                      viewMode == CalendarViewMode.weekly
                          ? _getDayLabel(date.weekday)
                          : date.day.toString(),
                      style: const TextStyle(fontSize: 12),
                    );
                  },
                  reservedSize: 30,
                  interval: viewMode == CalendarViewMode.weekly
                      ? 86400000
                      : null, // Force daily labels
                ),
              ),
            ),
            minX: _getMinX(currentWeekStart, viewMode),
            maxX: _getMaxX(currentWeekStart, viewMode),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  Map<DateTime, int> _filterData(
    Map<DateTime, int> moods,
    DateTime baseDate,
    CalendarViewMode viewMode,
  ) {
    if (viewMode == CalendarViewMode.weekly) {
      final startOfWeek =
          baseDate.subtract(Duration(days: baseDate.weekday % 7));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      return Map.fromEntries(
        moods.entries.where((e) =>
            e.key.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            e.key.isBefore(endOfWeek.add(const Duration(days: 1)))),
      );
    } else {
      final startOfMonth = DateTime(baseDate.year, baseDate.month, 1);
      final endOfMonth = DateTime(baseDate.year, baseDate.month + 1, 0);
      return Map.fromEntries(
        moods.entries.where((e) =>
            e.key.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
            e.key.isBefore(endOfMonth.add(const Duration(days: 1)))),
      );
    }
  }

  LineChartBarData _createChartData(Map<DateTime, int> moods) {
    final spots = moods.entries
        .map((e) => FlSpot(
              e.key.millisecondsSinceEpoch.toDouble(),
              e.value.toDouble(),
            ))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: Colors.blue,
      barWidth: 2,
      dotData: const FlDotData(show: false),
    );
  }

  double _getMinX(DateTime baseDate, CalendarViewMode viewMode) {
    return viewMode == CalendarViewMode.weekly
        ? baseDate
            .subtract(Duration(days: baseDate.weekday % 7))
            .millisecondsSinceEpoch
            .toDouble()
        : DateTime(baseDate.year, baseDate.month, 1)
            .millisecondsSinceEpoch
            .toDouble();
  }

  double _getMaxX(DateTime baseDate, CalendarViewMode viewMode) {
    return viewMode == CalendarViewMode.weekly
        ? baseDate
            .subtract(Duration(days: baseDate.weekday % 7))
            .add(const Duration(days: 6))
            .millisecondsSinceEpoch
            .toDouble()
        : DateTime(baseDate.year, baseDate.month + 1, 0)
            .millisecondsSinceEpoch
            .toDouble();
  }

  String _getDayLabel(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday % 7];
  }
}

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
