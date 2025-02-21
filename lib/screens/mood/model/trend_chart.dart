import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/providers/mood_tracker_provider.dart';
import 'package:mindful_mate/utils/constants.dart';

class TrendChart extends ConsumerWidget {
  const TrendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodData = ref.watch(moodProvider);
    final viewMode = ref.watch(calendarViewProvider);
    final currentWeekStart = ref.watch(currentDisplayedWeekProvider);
    final filteredData = _filterData(moodData, currentWeekStart, viewMode);
    final dateRangeText = _getDateRangeText(currentWeekStart, viewMode);

    final gradientColors = [
      Colors.blue.shade400,
      Colors.purple.shade300,
      Colors.pink.shade300,
    ];

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 300,
            padding:
                const EdgeInsets.only(top: 24, bottom: 12, left: 12, right: 15),
            child: AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => Colors.pink,
                      getTooltipItems: (spots) => spots.map((spot) {
                        final emoji =
                            ['😢', '😐', '😊', '😄', '🌟'][spot.y.toInt()];
                        return LineTooltipItem(
                          '$emoji\n${_formatDate(spot.x)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            ['😢', '😐', '😊', '😄', '🌟'][value.toInt()],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text(
                        "Mood Trend",
                        style: kTextStyleFont600(context: context),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                              value.toInt());
                          return Transform.rotate(
                            angle: -45 * (pi / 180),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                viewMode == CalendarViewMode.weekly
                                    ? _getDayLabel(date.weekday)
                                    : '${date.day} ${_monthAbbreviation(date.month)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          );
                        },
                        reservedSize: 48,
                        interval: viewMode == CalendarViewMode.weekly
                            ? 86400000
                            : null,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  minX: _getMinX(currentWeekStart, viewMode),
                  maxX: _getMaxX(currentWeekStart, viewMode),
                  minY: 0,
                  maxY: 4,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _createSpots(filteredData),
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColors
                              .map((c) => c.withOpacity(0.3))
                              .toList(),
                        ),
                      ),
                      dotData: const FlDotData(show: false),
                      shadow:
                          const Shadow(color: Colors.black12, blurRadius: 8),
                      gradient: LinearGradient(
                        colors: gradientColors,
                        stops: const [0.2, 0.5, 0.8],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 8),
          child: Text(
            dateRangeText,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(double milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt());
    return '${date.day} ${_monthAbbreviation(date.month)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  List<FlSpot> _createSpots(Map<DateTime, int> moods) {
    return moods.entries
        .map((e) => FlSpot(
              e.key.millisecondsSinceEpoch.toDouble(),
              e.value.toDouble(),
            ))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
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
    if (viewMode == CalendarViewMode.weekly) {
      final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
      return DateTime(start.year, start.month, start.day)
          .millisecondsSinceEpoch
          .toDouble();
    } else {
      return DateTime(baseDate.year, baseDate.month, 1)
          .millisecondsSinceEpoch
          .toDouble();
    }
  }

  double _getMaxX(DateTime baseDate, CalendarViewMode viewMode) {
    if (viewMode == CalendarViewMode.weekly) {
      final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
      final end = start.add(Duration(days: 6));
      return DateTime(end.year, end.month, end.day, 23, 59, 59)
          .millisecondsSinceEpoch
          .toDouble();
    } else {
      return DateTime(baseDate.year, baseDate.month + 1, 0, 23, 59, 59)
          .millisecondsSinceEpoch
          .toDouble();
    }
  }

  String _getDayLabel(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday % 7];
  }

  String _getDateRangeText(DateTime baseDate, CalendarViewMode viewMode) {
    if (viewMode == CalendarViewMode.weekly) {
      final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
      final end = start.add(const Duration(days: 6));
      return '${_monthAbbreviation(start.month)} ${start.day} - '
          '${_monthAbbreviation(end.month)} ${end.day} ${end.year}';
    } else {
      return '${_monthAbbreviation(baseDate.month)} ${baseDate.year}';
    }
  }

  String _monthAbbreviation(int month) {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][month - 1];
  }
}
