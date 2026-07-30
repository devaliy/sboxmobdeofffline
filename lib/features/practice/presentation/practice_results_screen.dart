import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/assessment_content_db.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/practice_providers.dart';
import '../domain/practice_result.dart';

/// Score summary + per-question review with explanations (spec Section
/// 1.5/9's "results/review" step) — motivation belongs here, not inside
/// the test itself, so this is the one Practice/CBT screen allowed to
/// feel celebratory.
class PracticeResultsScreen extends StatelessWidget {
  const PracticeResultsScreen({super.key, required this.result});

  final PracticeResult result;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scorePercent = result.total == 0 ? 0 : ((result.score / result.total) * 100).round();
    final minutes = result.timeSpentSeconds ~/ 60;
    final seconds = result.timeSpentSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => context.go(AppRoutes.practice),
            child: const Text('Done'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          GlowCard(
            glow: true,
            child: Column(
              children: [
                Text(result.testTypeName, style: textTheme.titleSmall),
                Text(
                  result.subjectName,
                  style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.md),
                AnimatedProgressRing(
                  progress: result.total == 0 ? 0 : result.score / result.total,
                  size: 84,
                  strokeWidth: 8,
                  child: Text('$scorePercent%', style: textTheme.titleMedium),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('${result.score} / ${result.total} correct', style: textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Time spent: ${minutes}m ${seconds}s',
                  style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: 'Review'),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < result.questions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _ReviewCard(
                index: i,
                question: result.questions[i],
                selected: result.selectedOptions[result.questions[i].id],
                wasFlagged: result.flagged.contains(result.questions[i].id),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({
    required this.index,
    required this.question,
    required this.selected,
    required this.wasFlagged,
  });

  final int index;
  final Question question;
  final String? selected;
  final bool wasFlagged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCorrect = selected != null && selected == question.correctOption;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tone = isCorrect ? AppColors.success : AppColors.danger;

    final options = {
      'A': question.optionA,
      'B': question.optionB,
      'C': question.optionC,
      'D': question.optionD,
      if (question.optionE != null) 'E': question.optionE!,
    };
    String describe(String key) => '$key. ${options[key]}';

    return GlowCard(
      border: BorderSide(color: tone.withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: tone,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('${index + 1}. ${question.questionText}', style: textTheme.titleSmall),
              ),
              if (wasFlagged)
                const Padding(
                  padding: EdgeInsets.only(left: AppSpacing.xs),
                  child: Icon(Icons.flag_rounded, size: 16, color: AppColors.warning),
                ),
            ],
          ),
          if (question.passageId != null) _PassageReference(passageId: question.passageId!),
          const SizedBox(height: AppSpacing.sm),
          Text(
            selected == null
                ? 'You left this unanswered. Correct answer: ${describe(question.correctOption)}'
                : isCorrect
                    ? 'Your answer: ${describe(selected!)}'
                    : 'Your answer: ${describe(selected!)} · Correct answer: ${describe(question.correctOption)}',
            style: textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          if (question.explanation != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(question.explanation!, style: textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _PassageReference extends ConsumerWidget {
  const _PassageReference({required this.passageId});

  final int passageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passageAsync = ref.watch(passageByIdProvider(passageId));
    final title = passageAsync.valueOrNull?.title;
    if (title == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Text(
        'From: $title',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontStyle: FontStyle.italic, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
