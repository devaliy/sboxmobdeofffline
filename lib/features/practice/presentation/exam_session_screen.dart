import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/assessment_content_db.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/practice_exam_controller.dart';
import '../application/practice_providers.dart';
import 'widgets/question_palette_sheet.dart';

/// The active exam session — spec Section 1.5's "exam mode feels like an
/// exam": a top-level route (see app_routes.dart) so the shell's bottom/top
/// nav never wraps it, near-monochrome, no sync/connectivity indicators, no
/// gamified motion. Just a timer, a question, options, and a palette.
class ExamSessionScreen extends ConsumerStatefulWidget {
  const ExamSessionScreen({super.key, required this.testTypeId});

  final int testTypeId;

  @override
  ConsumerState<ExamSessionScreen> createState() => _ExamSessionScreenState();
}

class _ExamSessionScreenState extends ConsumerState<ExamSessionScreen> {
  int _currentIndex = 0;
  final Map<int, String?> _selected = {};
  final Set<int> _flagged = {};
  Timer? _ticker;
  int _remainingSeconds = 0;
  bool _timerStarted = false;
  bool _submitting = false;
  late final DateTime _startedAt = DateTime.now();

  void _startTimer(int durationMinutes) {
    _timerStarted = true;
    _remainingSeconds = durationMinutes * 60;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        _ticker?.cancel();
        setState(() => _remainingSeconds = 0);
        _submit(
          auto: true,
          questions: _questionsCache!,
          subject: _subjectCache,
          testType: _testTypeCache!,
        );
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  // Cached the moment they first load, purely so the auto-submit timer
  // callback (which can't re-watch providers itself) always has the same
  // data the student was actually looking at.
  List<Question>? _questionsCache;
  TestType? _testTypeCache;
  Subject? _subjectCache;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _submit({
    required bool auto,
    required List<Question> questions,
    required Subject? subject,
    required TestType testType,
  }) async {
    if (_submitting) return;
    if (!auto) {
      final unanswered =
          questions.length - _selected.values.where((v) => v != null).length;
      if (unanswered > 0) {
        final proceed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Submit test?'),
            content: Text(
              '$unanswered question${unanswered == 1 ? '' : 's'} still unanswered. '
              'You can\'t change answers after submitting.',
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text('Keep going'),
              ),
              TextButton(
                onPressed: () => context.pop(true),
                child: const Text('Submit anyway'),
              ),
            ],
          ),
        );
        if (proceed != true) return;
      }
    }

    setState(() => _submitting = true);
    _ticker?.cancel();

    final result = await ref
        .read(practiceExamControllerProvider)
        .submit(
          subjectId: subject?.id ?? testType.subjectId ?? 0,
          testTypeId: testType.id,
          subjectName: subject?.name ?? 'Practice',
          testTypeName: testType.testTypeName,
          questions: questions,
          selectedOptions: _selected,
          flagged: _flagged,
          startedAt: _startedAt,
        );
    if (!mounted) return;
    context.pushReplacement(
      AppRoutes.practiceExamResults(widget.testTypeId),
      extra: result,
    );
  }

  Future<bool> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave test?'),
        content: const Text('Your progress on this attempt won\'t be saved.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  void _openPalette(List<Question> questions) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuestionPaletteSheet(
        questions: questions,
        currentIndex: _currentIndex,
        answered: _selected.keys.where((id) => _selected[id] != null).toSet(),
        flagged: _flagged,
        onSelect: (index) {
          setState(() => _currentIndex = index);
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final testTypeAsync = ref.watch(testTypeByIdProvider(widget.testTypeId));
    final questionsAsync = ref.watch(
      questionsForTestTypeProvider(widget.testTypeId),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmLeave() && context.mounted) context.pop();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: testTypeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => EmptyState(
              icon: Icons.error_outline_rounded,
              title: 'Couldn\'t load',
              message: '$e',
            ),
            data: (testType) {
              if (testType == null) {
                return const EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Test not found',
                  message: '',
                );
              }
              return questionsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Couldn\'t load',
                  message: '$e',
                ),
                data: (questions) {
                  if (questions.isEmpty) {
                    return const EmptyState(
                      icon: Icons.quiz_outlined,
                      title: 'No questions in this test',
                      message:
                          'This test type has no questions in the downloaded pack.',
                    );
                  }
                  _testTypeCache = testType;
                  _questionsCache = questions;
                  final subjectAsync = testType.subjectId != null
                      ? ref.watch(subjectByIdProvider(testType.subjectId!))
                      : const AsyncValue<Subject?>.data(null);
                  _subjectCache = subjectAsync.valueOrNull;

                  if (!_timerStarted) _startTimer(testType.durationMinutes);

                  return _ExamBody(
                    testType: testType,
                    questions: questions,
                    currentIndex: _currentIndex,
                    selected: _selected,
                    flagged: _flagged,
                    remainingSeconds: _remainingSeconds,
                    submitting: _submitting,
                    onSelectOption: (value) => setState(
                      () => _selected[questions[_currentIndex].id] = value,
                    ),
                    onToggleFlag: () => setState(() {
                      final id = questions[_currentIndex].id;
                      if (_flagged.contains(id)) {
                        _flagged.remove(id);
                      } else {
                        _flagged.add(id);
                      }
                    }),
                    onPrevious: _currentIndex > 0
                        ? () => setState(() => _currentIndex--)
                        : null,
                    onNext: _currentIndex < questions.length - 1
                        ? () => setState(() => _currentIndex++)
                        : null,
                    onOpenPalette: () => _openPalette(questions),
                    onSubmit: () => _submit(
                      auto: false,
                      questions: questions,
                      subject: _subjectCache,
                      testType: testType,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ExamBody extends ConsumerWidget {
  const _ExamBody({
    required this.testType,
    required this.questions,
    required this.currentIndex,
    required this.selected,
    required this.flagged,
    required this.remainingSeconds,
    required this.submitting,
    required this.onSelectOption,
    required this.onToggleFlag,
    required this.onPrevious,
    required this.onNext,
    required this.onOpenPalette,
    required this.onSubmit,
  });

  final TestType testType;
  final List<Question> questions;
  final int currentIndex;
  final Map<int, String?> selected;
  final Set<int> flagged;
  final int remainingSeconds;
  final bool submitting;
  final ValueChanged<String?> onSelectOption;
  final VoidCallback onToggleFlag;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onOpenPalette;
  final VoidCallback onSubmit;

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static const _optionKeys = ['A', 'B', 'C', 'D', 'E'];

  /// Desktop keyboard navigation (spec Section 8/Phase 8): Left/Right move
  /// between questions, A-E or 1-5 pick an option, Enter advances (or
  /// submits on the last question) — the same actions the on-screen
  /// controls already expose, just reachable without a mouse.
  KeyEventResult _handleKey(KeyEvent event, Question question) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      if (onPrevious == null) return KeyEventResult.ignored;
      onPrevious!();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      if (onNext == null) return KeyEventResult.ignored;
      onNext!();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      if (onNext != null) {
        onNext!();
      } else {
        onSubmit();
      }
      return KeyEventResult.handled;
    }

    final optionIndex = _optionIndexForKey(key);
    if (optionIndex != null) {
      final options = _optionsFor(question);
      if (optionIndex < options.length) {
        onSelectOption(_optionKeys[optionIndex]);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  int? _optionIndexForKey(LogicalKeyboardKey key) {
    const letterKeys = [
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.keyB,
      LogicalKeyboardKey.keyC,
      LogicalKeyboardKey.keyD,
      LogicalKeyboardKey.keyE,
    ];
    const digitKeys = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
    ];
    final letterIndex = letterKeys.indexOf(key);
    if (letterIndex != -1) return letterIndex;
    final digitIndex = digitKeys.indexOf(key);
    if (digitIndex != -1) return digitIndex;
    return null;
  }

  List<String> _optionsFor(Question question) => [
    question.optionA,
    question.optionB,
    question.optionC,
    question.optionD,
    if (question.optionE != null) question.optionE!,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = questions[currentIndex];
    final isFlagged = flagged.contains(question.id);
    final totalSeconds = testType.durationMinutes * 60;
    final lowTime = remainingSeconds <= 60;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) => _handleKey(event, question),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    testType.testTypeName,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AnimatedProgressRing(
                  progress: totalSeconds == 0
                      ? 0
                      : remainingSeconds / totalSeconds,
                  size: 44,
                  strokeWidth: 4,
                  gradientColors: lowTime
                      ? const [AppColors.danger, AppColors.danger]
                      : null,
                  child: Text(
                    _formatTime(remainingSeconds),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: lowTime ? AppColors.danger : null,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  tooltip: 'Question list',
                  icon: const Icon(Icons.grid_view_rounded),
                  onPressed: onOpenPalette,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              minHeight: 3,
              backgroundColor: isDark
                  ? AppColors.outlineDark
                  : AppColors.outlineLight,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Question ${currentIndex + 1} of ${questions.length}',
                        style: Theme.of(context).textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      tooltip: isFlagged ? 'Unflag' : 'Flag for review',
                      icon: Icon(
                        isFlagged ? Icons.flag_rounded : Icons.flag_outlined,
                        color: isFlagged ? AppColors.warning : null,
                      ),
                      onPressed: onToggleFlag,
                    ),
                  ],
                ),
                if (question.passageId != null)
                  _PassageCard(passageId: question.passageId!),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  question.questionText,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                _OptionsList(
                  question: question,
                  selected: selected[question.id],
                  onChanged: onSelectOption,
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onPrevious,
                      child: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: onNext != null
                        ? FilledButton(
                            onPressed: onNext,
                            child: const Text('Next'),
                          )
                        : GradientButton(
                            label: 'Submit',
                            dense: true,
                            loading: submitting,
                            onPressed: onSubmit,
                          ),
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

class _PassageCard extends ConsumerWidget {
  const _PassageCard({required this.passageId});

  final int passageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passageAsync = ref.watch(passageByIdProvider(passageId));
    return passageAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (passage) {
        if (passage == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: GlowCard(
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                passage.title ?? 'Reading passage',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    passage.passageText,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OptionsList extends StatelessWidget {
  const _OptionsList({
    required this.question,
    required this.selected,
    required this.onChanged,
  });

  final Question question;
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

    return RadioGroup<String>(
      groupValue: selected,
      onChanged: onChanged,
      child: Column(
        children:
            [
                  for (final entry in options.entries)
                    GlowCard(
                      padding: EdgeInsets.zero,
                      child: RadioListTile<String>(
                        value: entry.key,
                        title: Text('${entry.key}. ${entry.value}'),
                      ),
                    ),
                ]
                .expand((card) => [card, const SizedBox(height: AppSpacing.sm)])
                .toList()
              ..removeLast(),
      ),
    );
  }
}
