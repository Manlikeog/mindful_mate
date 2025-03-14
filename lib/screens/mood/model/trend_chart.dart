import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/providers/mood_tracker_provider.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class TrendChart extends ConsumerWidget {
  const TrendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodData = ref.watch(moodProvider);
    final viewMode = ref.watch(calendarViewProvider);
    final currentWeekStart = ref.watch(currentDisplayedWeekProvider);
    final filteredData = _filterData(moodData, currentWeekStart, viewMode);

    final gradientColors = [
      injector.palette.primaryColor,
      injector.palette.secondaryColor,
      injector.palette.accentColor,
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 300,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Mood Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: injector.palette.textColor,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => injector.palette.secondaryColor,
                      getTooltipItems: (spots) => spots.map((spot) {
                        final emoji = ['😢', '😐', '😊', '😄', '🌟'][spot.y.toInt()];
                        return LineTooltipItem(
                          '$emoji\n${_formatDate(spot.x)}',
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: injector.palette.pureWhite,
                                fontWeight: FontWeight.w500,
                              ),
                        );
                      }).toList(),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: injector.palette.dividerColor.withOpacity(0.5),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            ['😢', '😐', '😊', '😄', '🌟'][value.toInt()],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: injector.palette.textColor.withOpacity(0.7),
                                ),
                          ),
                        ),
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          return Transform.rotate(
                            angle: -45 * (pi / 180),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                viewMode == CalendarViewMode.weekly
                                    ? _getDayLabel(date.weekday)
                                    : '${date.day} ${_monthAbbreviation(date.month)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: injector.palette.textColor.withOpacity(0.7),
                                    ),
                              ),
                            ),
                          );
                        },
                        reservedSize: 48,
                        interval: viewMode == CalendarViewMode.weekly ? 86400000 : null,
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: injector.palette.dividerColor),
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
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
                        ),
                      ),
                      dotData: const FlDotData(show: false),
                      gradient: LinearGradient(
                        colors: gradientColors,
                        stops: const [0.2, 0.5, 0.8],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(double milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt());
    return '${date.day} ${_monthAbbreviation(date.month)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  List<FlSpot> _createSpots(Map<DateTime, int> moods) {
    return moods.entries
        .map((e) => FlSpot(e.key.millisecondsSinceEpoch.toDouble(), e.value.toDouble()))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  Map<DateTime, int> _filterData(Map<DateTime, int> moods, DateTime baseDate, CalendarViewMode viewMode) {
    if (viewMode == CalendarViewMode.weekly) {
      final startOfWeek = baseDate.subtract(Duration(days: baseDate.weekday % 7));
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

  double _getMinX(DateTime baseDate, CalendarViewMode viewMode) {
    if (viewMode == CalendarViewMode.weekly) {
      final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
      return DateTime(start.year, start.month, start.day).millisecondsSinceEpoch.toDouble();
    } else {
      return DateTime(baseDate.year, baseDate.month, 1).millisecondsSinceEpoch.toDouble();
    }
  }

  double _getMaxX(DateTime baseDate, CalendarViewMode viewMode) {
    if (viewMode == CalendarViewMode.weekly) {
      final start = baseDate.subtract(Duration(days: baseDate.weekday % 7));
      final end = start.add(Duration(days: 6));
      return DateTime(end.year, end.month, end.day, 23, 59, 59).millisecondsSinceEpoch.toDouble();
    } else {
      return DateTime(baseDate.year, baseDate.month + 1, 0, 23, 59, 59).millisecondsSinceEpoch.toDouble();
    }
  }

  String _getDayLabel(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday % 7];
  }

  String _monthAbbreviation(int month) {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
  }
}