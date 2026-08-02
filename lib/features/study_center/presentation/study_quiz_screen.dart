import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/study_content_db.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/study_center_providers.dart';
import '../application/study_quiz_controller.dart';

/// "Test yourself" — the Study Center's untimed, calm self-check (spec
/// Section 7), deliberately distinct from the M7 Practice/CBT exam
/// experience: no timer, no palette, every question visible on one page.
class StudyQuizScreen extends ConsumerStatefulWidget {
  const StudyQuizScreen({super.key, required this.bookId, required this.subjectId});

  final int bookId;
  final int subjectId;

  @override
  ConsumerState<StudyQuizScreen> createState() => _StudyQuizScreenState();
}

class _StudyQuizScreenState extends ConsumerState<StudyQuizScreen> {
  final Map<int, String?> _selected = {};
  final DateTime _startedAt = DateTime.now();
  bool _submitting = false;

  Future<void> _submit(List<LibraryQuestion> questions) async {
    setState(() => _submitting = true);
    try {
      final subject = ref.read(subjectByIdProvider(widget.subjectId)).valueOrNull;
      final result = await ref.read(studyQuizControllerProvider).submit(
            librarySubjectId: widget.subjectId,
            librarySubjectName: subject?.title,
            questions: questions,
            selectedOptions: _selected,
            startedAt: _startedAt,
          );
      if (!mounted) return;
      context.pushReplacement(
        AppRoutes.studyQuizResults(widget.bookId, widget.subjectId),
        extra: result,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsForSubjectProvider(widget.subjectId));
    final subject = ref.watch(subjectByIdProvider(widget.subjectId)).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text('Test yourself${subject != null ? ': ${subject.title}' : ''}')),
      body: questionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
        data: (questions) {
          if (questions.isEmpty) {
            return const EmptyState(
              icon: Icons.quiz_outlined,
              title: 'No questions yet',
              message: 'This week doesn\'t have a self-test in the downloaded pack.',
            );
          }

          final answeredCount = _selected.values.where((v) => v != null).length;

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  itemCount: questions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
                  itemBuilder: (context, i) => _QuestionCard(
                    index: i,
                    question: questions[i],
                    selected: _selected[questions[i].id],
                    onChanged: (value) => setState(() => _selected[questions[i].id] = value),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.lg),
                  child: GradientButton(
                    label: answeredCount == questions.length
                        ? 'Submit'
                        : 'Submit ($answeredCount/${questions.length} answered)',
                    icon: Icons.check_circle_outline_rounded,
                    loading: _submitting,
                    onPressed: () => _submit(questions),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.selected,
    required this.onChanged,
  });

  final int index;
  final LibraryQuestion question;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = {
      'A': question.optionA,
      'B': question.optionB,
      'C': question.optionC,
      'D': question.optionD,
      if (question.optionE != null) 'E': question.optionE!,
    };

    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${index + 1}. ${question.questionText}', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          RadioGroup<String>(
            groupValue: selected,
            onChanged: onChanged,
            child: Column(
              children: [
                for (final entry in options.entries)
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: entry.key,
                    title: Text('${entry.key}. ${entry.value}'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
