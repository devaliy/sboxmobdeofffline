import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// One headline stat with a trend arrow/percent and a small sparkline —
/// the report's left-hand panel (Overall Growth / Average Performance /
/// Average Time Spent).
class StatSparklineCard extends StatelessWidget {
  const StatSparklineCard({
    super.key,
    required this.label,
    required this.value,
    required this.trendPercent,
    required this.sparkline,
  });

  final String label;
  final String value;
  final double trendPercent;
  final List<double> sparkline;

  @override
  Widget build(BuildContext context) {
    final up = trendPercent >= 0;
    final tone = up ? AppColors.success : AppColors.danger;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, color: tone, size: 16),
                    Text(
                      '${trendPercent.abs().round()}%',
                      style: theme.textTheme.labelMedium?.copyWith(color: tone, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 72,
            height: 36,
            child: sparkline.length < 2
                ? const SizedBox.shrink()
                : LineChart(
                    LineChartData(
                      minY: sparkline.reduce((a, b) => a < b ? a : b) * 0.9,
                      maxY: sparkline.reduce((a, b) => a > b ? a : b) * 1.1 + 1,
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      lineTouchData: const LineTouchData(enabled: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            for (var i = 0; i < sparkline.length; i++) FlSpot(i.toDouble(), sparkline[i]),
                          ],
                          isCurved: true,
                          color: tone,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: true, color: tone.withValues(alpha: 0.12)),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
