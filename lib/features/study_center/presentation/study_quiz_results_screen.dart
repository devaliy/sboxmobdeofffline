import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/study_content_db.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/study_quiz_result.dart';

/// Score summary + per-question review with explanations (spec Section 7).
class StudyQuizResultsScreen extends StatelessWidget {
  const StudyQuizResultsScreen({super.key, required this.bookId, required this.result});

  final int bookId;
  final StudyQuizResult result;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scorePercent = result.total == 0 ? 0 : ((result.score / result.total) * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => context.go(AppRoutes.studyBook(bookId)),
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
                AnimatedProgressRing(
                  progress: result.total == 0 ? 0 : result.score / result.total,
                  size: 84,
                  strokeWidth: 8,
                  child: Text('$scorePercent%', style: textTheme.titleMedium),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('${result.score} / ${result.total} correct', style: textTheme.titleSmall),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: 'Review'),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < result.questions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _ReviewCard(index: i, question: result.questions[i], selected: result.selectedOptions[result.questions[i].id]),
            ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.index, required this.question, required this.selected});

  final int index;
  final LibraryQuestion question;
  final String? selected;

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
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
