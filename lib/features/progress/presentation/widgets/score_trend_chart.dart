import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/db/progress_db.dart';
import '../../../../core/theme/theme.dart';

/// Score-over-time (spec Section 7), one point per completed attempt —
/// glowing gradient fill under the line, matching the design system's
/// "glow reserved for the one or two hero elements" rule (this chart *is*
/// the hero element on Progress).
class ScoreTrendChart extends StatelessWidget {
  const ScoreTrendChart({super.key, required this.attempts});

  final List<PracticeAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDark ? AppColors.outlineDark : AppColors.outlineLight;

    final spots = [
      for (var i = 0; i < attempts.length; i++)
        FlSpot(i.toDouble(), attempts[i].totalQuestions == 0
            ? 0
            : (attempts[i].score / attempts[i].totalQuestions) * 100),
    ];

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
              getTitlesWidget: (value, meta) => Text('${value.toInt()}%', style: const TextStyle(fontSize: 10)),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => [
              for (final spot in touchedSpots)
                LineTooltipItem('${spot.y.round()}%', const TextStyle(color: Colors.white)),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.signalOrange,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.signalOrange.withValues(alpha: 0.35),
                  AppColors.signalOrange.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
