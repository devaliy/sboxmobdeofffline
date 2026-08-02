import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/subject_score_series.dart';
import 'subject_time_pie_chart.dart' show subjectColor;

/// "Graph of scores for test practice of all subject over time" — one line
/// per subject, x-axis is attempt order (not raw dates, since attempts are
/// often clustered on the same day for a real local user) rather than a
/// continuous calendar axis.
class SubjectScoreLineChart extends StatelessWidget {
  const SubjectScoreLineChart({super.key, required this.series});

  final List<SubjectScoreSeries> series;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDark ? AppColors.outlineDark : AppColors.outlineLight;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (_) => FlLine(color: gridColor, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              reservedSize: 36,
              getTitlesWidget: (value, meta) =>
                  Text('${value.toInt()}%', style: const TextStyle(fontSize: 10)),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => [
              for (final spot in touchedSpots)
                LineTooltipItem(
                  '${series[spot.barIndex].label} ${spot.y.round()}%',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
        lineBarsData: [
          for (var i = 0; i < series.length; i++)
            LineChartBarData(
              spots: [
                for (var j = 0; j < series[i].points.length; j++)
                  FlSpot(j.toDouble(), series[i].points[j].scorePercent),
              ],
              isCurved: true,
              color: subjectColor(i),
              barWidth: 2.5,
              dotData: const FlDotData(show: true),
            ),
        ],
      ),
    );
  }
}
