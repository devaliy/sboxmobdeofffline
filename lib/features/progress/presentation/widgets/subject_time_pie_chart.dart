import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/subject_time_slice.dart';

/// Fixed 8-color rotation shared by the pie chart and its legend, and by
/// the score-over-time line chart, so a subject always reads as the same
/// color across both charts.
final List<Color> kSubjectChartColors = [
  AppColors.signalOrange,
  AppColors.brandBlue,
  AppColors.coral.foreground,
  AppColors.sky.foreground,
  AppColors.lavender.foreground,
  AppColors.sunflower.foreground,
  AppColors.mint.foreground,
  AppColors.rose.foreground,
];

Color subjectColor(int index) => kSubjectChartColors[index % kSubjectChartColors.length];

/// "Pie chart of time spent on all subjects" — each subject's share of
/// total recorded `time_spent_seconds`, with a colored legend beside it.
class SubjectTimePieChart extends StatelessWidget {
  const SubjectTimePieChart({super.key, required this.slices});

  final List<SubjectTimeSlice> slices;

  @override
  Widget build(BuildContext context) {
    final total = slices.fold<int>(0, (sum, s) => sum + s.seconds);
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 34,
              sections: [
                for (var i = 0; i < slices.length; i++)
                  PieChartSectionData(
                    value: slices[i].seconds.toDouble(),
                    color: subjectColor(i),
                    title: '',
                    radius: 30,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < slices.length; i++)
                _LegendEntry(
                  color: subjectColor(i),
                  label: slices[i].label,
                  percent: total == 0 ? 0 : slices[i].seconds / total * 100,
                  theme: theme,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({required this.color, required this.label, required this.percent, required this.theme});

  final Color color;
  final String label;
  final double percent;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: AppSpacing.xs),
        Text('$label · ${percent.round()}%', style: theme.textTheme.bodySmall),
      ],
    );
  }
}
