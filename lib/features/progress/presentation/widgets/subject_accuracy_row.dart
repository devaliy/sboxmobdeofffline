import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/subject_accuracy.dart';

class SubjectAccuracyRow extends StatelessWidget {
  const SubjectAccuracyRow({super.key, required this.data});

  final SubjectAccuracy data;

  @override
  Widget build(BuildContext context) {
    final percent = (data.accuracy * 100).round();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final tone = data.accuracy >= 0.7
        ? AppColors.success
        : data.accuracy >= 0.4
            ? AppColors.warning
            : AppColors.danger;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(data.label, style: textTheme.titleSmall)),
              Text('$percent%', style: textTheme.labelMedium?.copyWith(color: tone, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: data.accuracy,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.outlineDark : AppColors.outlineLight,
              valueColor: AlwaysStoppedAnimation(tone),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${data.correct}/${data.total} correct',
            style: textTheme.bodySmall
                ?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        ],
      ),
    );
  }
}
