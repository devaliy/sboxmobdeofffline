import 'package:flutter/material.dart';
import '../../../../core/db/assessment_content_db.dart';
import '../../../../core/theme/theme.dart';

/// Jump-to-question drawer (spec Section 1.5/9): a grid of question
/// numbers color-coded by state, so a student can see at a glance what's
/// left without leaving the calm, chrome-free exam surface for anything
/// more than a bottom sheet.
class QuestionPaletteSheet extends StatelessWidget {
  const QuestionPaletteSheet({
    super.key,
    required this.questions,
    required this.currentIndex,
    required this.answered,
    required this.flagged,
    required this.onSelect,
  });

  final List<Question> questions;
  final int currentIndex;
  final Set<int> answered;
  final Set<int> flagged;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outline = isDark ? AppColors.outlineDark : AppColors.outlineLight;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Questions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (var i = 0; i < questions.length; i++)
                  _PaletteChip(
                    index: i,
                    isCurrent: i == currentIndex,
                    isAnswered: answered.contains(questions[i].id),
                    isFlagged: flagged.contains(questions[i].id),
                    outline: outline,
                    onTap: () => onSelect(i),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.xs,
              children: [
                _Legend(color: AppColors.signalOrange, label: 'Answered'),
                _Legend(color: AppColors.warning, label: 'Flagged'),
                _Legend(color: outline, label: 'Unanswered'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteChip extends StatelessWidget {
  const _PaletteChip({
    required this.index,
    required this.isCurrent,
    required this.isAnswered,
    required this.isFlagged,
    required this.outline,
    required this.onTap,
  });

  final int index;
  final bool isCurrent;
  final bool isAnswered;
  final bool isFlagged;
  final Color outline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fill = isAnswered ? AppColors.signalOrange.withValues(alpha: 0.15) : Colors.transparent;
    final borderColor = isCurrent ? AppColors.signalOrange : outline;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      // 44x44 minimum touch target (spec Section 9) — the visible chip can
      // stay compact, but the tappable area can't.
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: borderColor, width: isCurrent ? 2 : 1),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(child: Text('${index + 1}')),
            if (isFlagged)
              const Positioned(
                top: -6,
                right: -6,
                child: Icon(Icons.flag_rounded, size: 14, color: AppColors.warning),
              ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
