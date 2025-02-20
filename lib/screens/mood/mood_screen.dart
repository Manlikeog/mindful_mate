// mood_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart'; // Replace charts_flutter import
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
        title: Text('Mood History'),
        actions: [
          _ViewModeToggle(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MoodCalendar(),
            _TrendChart(),
            _InsightsCard(ref),
          ],
        ),
      ),
    );
  }
}

class _ViewModeToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(calendarViewProvider);
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: ToggleButtons(
        isSelected: [
          viewMode == CalendarViewMode.weekly,
          viewMode == CalendarViewMode.monthly,
        ],
        onPressed: (index) => ref.read(calendarViewProvider.notifier).state =
            index == 0 ? CalendarViewMode.weekly : CalendarViewMode.monthly,
        children: [Text('Week'), Text('Month')],
      ),
    );
  }
}

class _TrendChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodData = ref.watch(moodProvider);
    final viewMode = ref.watch(calendarViewProvider);

    return Card(
      margin: EdgeInsets.all(16),
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            lineBarsData: [_createChartData(moodData, viewMode)],
            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
                axisNameWidget: Text('Mood Trend'),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      viewMode == CalendarViewMode.weekly
                          ? _getDayLabel(value)
                          : value.toInt().toString(),
                      style: TextStyle(fontSize: 12),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  LineChartBarData _createChartData(
      Map<DateTime, int> moods, CalendarViewMode viewMode) {
    final List<FlSpot> spots = moods.entries
        .map((e) => FlSpot(
              viewMode == CalendarViewMode.weekly
                  ? (e.key.weekday - 1).toDouble() // 0-6 for Mon-Sun
                  : e.key.day.toDouble(), // 1-31 for monthly view
              e.value.toDouble(),
            ))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: Colors.blue,
      barWidth: 2,
      dotData: FlDotData(show: false),
    );
  }

  String _getDayLabel(double value) {
    // Convert 0-6 to day abbreviations
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final index = value.toInt();
    return index >= 0 && index < 7 ? days[index] : '';
  }
}

class _InsightsCard extends ConsumerWidget {
  final WidgetRef ref;

  _InsightsCard(this.ref);

  @override
  Widget build(BuildContext context, _) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          ref.getMoodInsight(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class MoodEntry {
  final DateTime date;
  final double value;

  MoodEntry(this.date, this.value);
}
