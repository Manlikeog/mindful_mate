import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/calendar_provider.dart';
import 'package:mindful_mate/providers/mood_provider.dart';
import 'package:mindful_mate/screens/mood/utils/mood_util.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class TrendChart extends ConsumerWidget {
  const TrendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredData = ref.watch(filteredMoodProvider);
    final viewMode = ref.watch(calendarViewProvider);
    final currentWeekStart = ref.watch(currentDisplayedWeekProvider);

    return Card(
      margin: EdgeInsets.all(4.pw(context)), // Scaled margin
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 40.ph(context), // 40% of screen height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              injector.palette.primaryColor.withOpacity(0.1),
              injector.palette.secondaryColor.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(2.pw(context)), // Scaled padding
        child: Column(
          children: [
            Text(
              'Mood Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: injector.palette.textColor,
                    fontSize: 16.ww(context), // Scaled text
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.ph(context)), // Scaled spacing
            Expanded(
              child: MoodLineChart(
                filteredData: filteredData,
                viewMode: viewMode,
                currentWeekStart: currentWeekStart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodLineChart extends StatelessWidget {
  final Map<DateTime, int> filteredData;
  final CalendarViewMode viewMode;
  final DateTime currentWeekStart;

  const MoodLineChart({
    super.key,
    required this.filteredData,
    required this.viewMode,
    required this.currentWeekStart,
  });

  @override
  Widget build(BuildContext context) {
    final spots = createMoodSpots(filteredData);
    final minX = getMinX(currentWeekStart, viewMode);
    final maxX = getMaxX(currentWeekStart, viewMode);
    final gradientColors = [
      injector.palette.primaryColor,
      injector.palette.secondaryColor,
      injector.palette.accentColor,
    ];

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => injector.palette.secondaryColor,
            getTooltipItems: (spots) => spots.map((spot) {
              final emoji = ['😢', '😐', '😊', '😄', '🌟'][spot.y.toInt()];
              return LineTooltipItem(
                '$emoji\n${formatDate(spot.x)}',
                Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: injector.palette.pureWhite,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.ww(context), // Scaled tooltip text
                    ),
              );
            }).toList(),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (_) => FlLine(
            color: injector.palette.dividerColor.withOpacity(0.5),
            strokeWidth: 1.ww(context), // Scaled line width
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) => Padding(
                padding: EdgeInsets.only(right: 2.pw(context)),
                child: Text(
                  ['😢', '😐', '😊', '😄', '🌟'][value.toInt()],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: injector.palette.textColor.withOpacity(0.7),
                        fontSize: 12.ww(context), // Scaled text
                      ),
                ),
              ),
              reservedSize: 10.pw(context), // Dynamic reserved space
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                final label = viewMode == CalendarViewMode.weekly
                    ? getDayLabel(date.weekday)
                    : '${date.day} ${monthAbbreviation(date.month)}';
                return Transform.rotate(
                  angle: -45 * (pi / 180),
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.ph(context)),
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: injector.palette.textColor.withOpacity(0.7),
                            fontSize: 10.ww(context), // Scaled text
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
              reservedSize: 12.pw(context), // Dynamic reserved space
              interval: viewMode == CalendarViewMode.weekly ? 86400000 : null,
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: injector.palette.dividerColor),
        ),
        minX: minX,
        maxX: maxX,
        minY: 0,
        maxY: 4,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            barWidth: 2.ww(context), // Scaled bar width
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
              ),
            ),
            dotData: const FlDotData(show: false),
            gradient: LinearGradient(
                colors: gradientColors, stops: const [0.2, 0.5, 0.8]),
          ),
        ],
      ),
    );
  }
}
