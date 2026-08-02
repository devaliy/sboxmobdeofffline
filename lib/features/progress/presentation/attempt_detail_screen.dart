import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/analytics_controller.dart';
import '../domain/attempt_detail.dart';

/// Read-only review of one past attempt — the report table's "view"
/// action. Reconstructed from `practice_answers` joined back to the
/// original question content, same underlying data Practice/CBT's own
/// results screen shows immediately after a test, just reachable later
/// from history instead.
class AttemptDetailScreen extends ConsumerWidget {
  const AttemptDetailScreen({super.key, required this.attemptId});

  final String attemptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(attemptDetailProvider(attemptId));

    return Scaffold(
      appBar: AppBar(title: const Text('Test result')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) =>
            EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
        data: (detail) {
          if (detail == null) {
            return const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'Not found',
              message: 'This test result may have been deleted.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              GlowCard(
                glow: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.subjectLabel, style: Theme.of(context).textTheme.titleLarge),
                    Text(detail.testTypeLabel, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '${detail.attempt.score}/${detail.attempt.totalQuestions} · ${detail.scorePercent.round()}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: detail.scorePercent >= 50 ? AppColors.success : AppColors.danger,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              for (var i = 0; i < detail.answers.length; i++) ...[
                _AnswerCard(index: i, answer: detail.answers[i]),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({required this.index, required this.answer});

  final int index;
  final AttemptAnswerDetail answer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                answer.isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: answer.isCorrect ? AppColors.success : AppColors.danger,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('Question ${index + 1}', style: theme.textTheme.labelLarge),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Html(data: answer.questionText),
          if (answer.imagePath != null) ...[
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: LocalContentImage(
                  relativePath: answer.imagePath,
                  placeholder: const SizedBox.shrink(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          for (final entry in answer.options.entries) _OptionLine(letter: entry.key, text: entry.value, answer: answer),
          if (answer.explanation != null && answer.explanation!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Explanation', style: theme.textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            Html(data: answer.explanation!),
          ],
        ],
      ),
    );
  }
}

class _OptionLine extends StatelessWidget {
  const _OptionLine({required this.letter, required this.text, required this.answer});

  final String letter;
  final String text;
  final AttemptAnswerDetail answer;

  @override
  Widget build(BuildContext context) {
    final isCorrect = letter == answer.correctOption;
    final isSelected = letter == answer.selectedOption;
    Color? tone;
    if (isCorrect) {
      tone = AppColors.success;
    } else if (isSelected && !isCorrect) {
      tone = AppColors.danger;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: tone?.withValues(alpha: 0.15) ?? Colors.transparent,
            foregroundColor: tone,
            child: Text(letter, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Html(data: text)),
          if (isSelected) Icon(Icons.turn_left_rounded, size: 16, color: tone),
        ],
      ),
    );
  }
}
