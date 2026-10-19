import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/assessment_content_db.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/practice_exam_controller.dart';
import '../application/practice_providers.dart';
import '../domain/practice_test_type.dart';

/// The active exam session — spec Section 1.5's "exam mode feels like an
/// exam": a top-level route (see app_routes.dart) so the shell's bottom/top
/// nav never wraps it, near-monochrome, no sync/connectivity indicators, no
/// gamified motion. Just a timer, a question, options, and an always-visible
/// numbered question strip (no separate palette popup — see `_ExamBody`).
class ExamSessionScreen extends ConsumerStatefulWidget {
  const ExamSessionScreen({
    super.key,
    required this.subjectId,
    required this.categoryId,
    required this.yearId,
    required this.testType,
  });

  final int subjectId;
  final int categoryId;
  final int yearId;
  final PracticeTestType testType;

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
        );
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  // Cached the moment they first load, purely so the auto-submit timer
  // callback (which can't re-watch providers itself) always has the same
  // data the student was actually looking at. The test format itself
  // (widget.testType) needs no caching — it's a constructor value, not
  // derived from an async provider.
  List<Question>? _questionsCache;
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
          subjectId: widget.subjectId,
          subjectName: subject?.name ?? 'Practice',
          testTypeName: widget.testType.label,
          questions: questions,
          selectedOptions: _selected,
          flagged: _flagged,
          startedAt: _startedAt,
        );
    if (!mounted) return;
    context.pushReplacement(
      AppRoutes.practiceExamResults(
        subjectId: widget.subjectId,
        categoryId: widget.categoryId,
        yearId: widget.yearId,
        testType: widget.testType.name,
      ),
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

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(
      examQuestionsProvider((
        subjectId: widget.subjectId,
        categoryId: widget.categoryId,
        yearId: widget.yearId,
        limit: widget.testType.numQuestions,
      )),
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
          child: questionsAsync.when(
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
                  title: 'No questions here yet',
                  message:
                      'This subject has no questions in the selected category\'s downloaded pack.',
                );
              }
              _questionsCache = questions;
              final subjectAsync = ref.watch(
                subjectByIdProvider(widget.subjectId),
              );
              _subjectCache = subjectAsync.valueOrNull;

              if (!_timerStarted) _startTimer(widget.testType.durationMinutes);

              return _ExamBody(
                testType: widget.testType,
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
                onSelectIndex: (index) => setState(() => _currentIndex = index),
                onSubmit: () => _submit(
                  auto: false,
                  questions: questions,
                  subject: _subjectCache,
                ),
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
    required this.onSelectIndex,
    required this.onSubmit,
  });

  final PracticeTestType testType;
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
  final ValueChanged<int> onSelectIndex;
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
    final lowTime = remainingSeconds <= 60;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    // On mobile the question-number strip moves below the Previous/Next
    // controls instead of sitting up here under the timer (still built
    // inline further down, once isDesktop is known from layout
    // constraints) — desktop keeps it up here, unchanged.
    final isDesktopScreen =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop;

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
              0,
            ),
            child: Text(
              testType.label,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Text(
                  'Time Left',
                  style: textTheme.bodySmall?.copyWith(color: muted),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _formatTime(remainingSeconds),
                  style: textTheme.headlineSmall?.copyWith(
                    color: lowTime ? AppColors.danger : AppColors.signalOrange,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  '${currentIndex + 1}/${questions.length}',
                  style: textTheme.titleSmall?.copyWith(
                    color: muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: isFlagged ? 'Unflag' : 'Flag for review',
                  icon: Icon(
                    isFlagged ? Icons.flag_rounded : Icons.flag_outlined,
                    size: 20,
                    color: isFlagged ? AppColors.warning : null,
                  ),
                  onPressed: onToggleFlag,
                ),
              ],
            ),
          ),
          if (isDesktopScreen) ...[
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _QuestionNumberStrip(
                questions: questions,
                currentIndex: currentIndex,
                answered: selected.keys
                    .where((id) => selected[id] != null)
                    .toSet(),
                flagged: flagged,
                onSelectIndex: onSelectIndex,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop =
                        constraints.maxWidth >= AppBreakpoints.desktop;
                    final passage = question.passageId != null
                        ? _PassageCard(passageId: question.passageId!)
                        : null;
                    final questionAndOptions = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (passage != null) passage,
                        _QuestionCard(text: question.questionText),
                        if (!isDesktop && question.imagePath != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          _ImagePanel(
                            imagePath: question.imagePath,
                            height: 200,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        _OptionsList(
                          question: question,
                          selected: selected[question.id],
                          onChanged: onSelectOption,
                        ),
                      ],
                    );

                    // Desktop: question+options share the row with a
                    // permanently-reserved image panel on the right —
                    // showing the real image when the question has one,
                    // otherwise the same neutral placeholder, so the layout
                    // doesn't jump between wide/narrow depending on whether
                    // an image exists.
                    final body = isDesktop
                        ? IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(flex: 6, child: questionAndOptions),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  flex: 4,
                                  child: _ImagePanel(
                                    imagePath: question.imagePath,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : questionAndOptions;

                    final prev = OutlinedButton(
                      onPressed: onPrevious,
                      child: const Text('Previous'),
                    );
                    final nextOrSubmit = onNext != null
                        ? FilledButton(
                            onPressed: onNext,
                            child: const Text('Next'),
                          )
                        : GradientButton(
                            label: 'Submit',
                            dense: true,
                            loading: submitting,
                            onPressed: onSubmit,
                          );
                    // Buttons flow directly under the content (not pinned
                    // to the screen's bottom edge) — on a short question or
                    // a tall desktop window there'd otherwise be a large
                    // empty gap between the options and the controls.
                    final buttons = isDesktop
                        ? Row(
                            children: [
                              SizedBox(width: 140, child: prev),
                              const SizedBox(width: AppSpacing.md),
                              SizedBox(width: 140, child: nextOrSubmit),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: prev),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(child: nextOrSubmit),
                            ],
                          );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        body,
                        const SizedBox(height: AppSpacing.lg),
                        buttons,
                        // Mobile only: the question-number strip lives here,
                        // below Previous/Next, instead of up under the
                        // timer (desktop keeps it up there — see the
                        // isDesktopScreen block above `_ExamBody.build`).
                        if (!isDesktop) ...[
                          const SizedBox(height: AppSpacing.lg),
                          _QuestionNumberStrip(
                            questions: questions,
                            currentIndex: currentIndex,
                            answered: selected.keys
                                .where((id) => selected[id] != null)
                                .toSet(),
                            flagged: flagged,
                            onSelectIndex: onSelectIndex,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.text});

  // Question text is not guaranteed to be plain text — some questions
  // author it as HTML (bold/italic emphasis, embedded formulas, line
  // breaks) — so it's rendered through Html rather than a plain Text,
  // same reasoning as the Reader screen's library content.
  final String text;

  @override
  Widget build(BuildContext context) {
    final baseStyle = Style(
      margin: Margins.zero,
      color: Colors.white,
      fontSize: FontSize(
        Theme.of(context).textTheme.titleMedium?.fontSize ?? 18,
      ),
      fontWeight: FontWeight.w600,
      lineHeight: const LineHeight(1.4),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.inkNavy,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Html(
        data: text,
        style: {
          'body': baseStyle,
          'p': baseStyle,
          'span': baseStyle,
          'li': baseStyle,
          'strong': baseStyle.copyWith(fontWeight: FontWeight.w800),
          'a': baseStyle.copyWith(color: AppColors.signalOrangeLight),
        },
      ),
    );
  }
}

/// The image slot from the desktop mockup's empty right-hand panel: a
/// neutral rounded box that shows the question's real image when it has
/// one, and stays the same neutral box (not an error state) otherwise.
class _ImagePanel extends StatelessWidget {
  const _ImagePanel({required this.imagePath, this.height});

  final String? imagePath;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = isDark ? AppColors.surfaceDark : AppColors.backgroundLight;
    final placeholder = Container(color: fill);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: imagePath == null
            ? placeholder
            : LocalContentImage(
                relativePath: imagePath,
                placeholder: placeholder,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

/// The always-visible, numbered, color-coded question strip (replaces the
/// old tap-to-open palette sheet): a horizontally scrollable row of
/// numbered boxes, colored by state, so a student sees exactly what's
/// answered/current/flagged at a glance without leaving the question —
/// and can tap any number to jump straight there.
class _QuestionNumberStrip extends StatelessWidget {
  const _QuestionNumberStrip({
    required this.questions,
    required this.currentIndex,
    required this.answered,
    required this.flagged,
    required this.onSelectIndex,
  });

  final List<Question> questions;
  final int currentIndex;
  final Set<int> answered;
  final Set<int> flagged;
  final ValueChanged<int> onSelectIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outline = isDark ? AppColors.outlineDark : AppColors.outlineLight;

    // Wrap, not a horizontally-scrolling row: a long Standard Test (45
    // questions) would otherwise scroll off-screen with no visual hint
    // there's more — wrapping to further lines keeps every number
    // reachable and visible without needing to discover a scroll gesture.
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (var i = 0; i < questions.length; i++)
          _NumberChip(
            index: i,
            isCurrent: i == currentIndex,
            isAnswered: answered.contains(questions[i].id),
            isFlagged: flagged.contains(questions[i].id),
            outline: outline,
            onTap: () => onSelectIndex(i),
          ),
      ],
    );
  }
}

class _NumberChip extends StatelessWidget {
  const _NumberChip({
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
    final fill = isAnswered ? AppColors.signalOrange : Colors.transparent;
    final borderColor = isCurrent ? AppColors.signalOrange : outline;
    final textColor = isAnswered ? Colors.white : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      // 44x44 minimum touch target (spec Section 9), matching the visible
      // box exactly here since the strip's own height already reserves it.
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
            Center(
              child: Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: textColor,
                  fontWeight: isCurrent ? FontWeight.w700 : null,
                ),
              ),
            ),
            if (isFlagged)
              const Positioned(
                top: -6,
                right: -6,
                child: Icon(
                  Icons.flag_rounded,
                  size: 14,
                  color: AppColors.warning,
                ),
              ),
          ],
        ),
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
                  child: Builder(
                    builder: (context) {
                      final style = Style(
                        margin: Margins.zero,
                        fontSize: FontSize(
                          Theme.of(context).textTheme.bodyMedium?.fontSize ??
                              14,
                        ),
                        lineHeight: const LineHeight(1.5),
                      );
                      return Html(
                        data: passage.passageText,
                        style: {'body': style, 'p': style, 'span': style},
                      );
                    },
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
    final entries = options.entries.toList();

    return Column(
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          _OptionRow(
            optionKey: entries[i].key,
            text: entries[i].value,
            isSelected: selected == entries[i].key,
            onTap: () => onChanged(entries[i].key),
          ),
          if (i != entries.length - 1) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.optionKey,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String optionKey;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Surface, not background: the scaffold itself is `background{Light,
    // Dark}` (see app_theme.dart), so filling a row with that same color
    // made it blend straight into the page in light mode instead of
    // standing out — `surface{Light,Dark}` is the token that's actually
    // distinct from the scaffold in both themes.
    final fill = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final outline = isDark ? AppColors.outlineDark : AppColors.outlineLight;
    final textColor = isDark ? Colors.white : AppColors.inkNavy;

    final optionStyle = Style(
      margin: Margins.zero,
      color: textColor,
      fontSize: FontSize(
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14,
      ),
      lineHeight: const LineHeight(1.4),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.signalOrange.withValues(alpha: 0.14)
              : fill,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.signalOrange : outline,
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.signalOrange : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.signalOrange : outline,
                  width: 1.6,
                ),
              ),
              child: Text(
                optionKey,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isSelected ? Colors.white : textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Html(
                data: text,
                style: {
                  'body': optionStyle,
                  'p': optionStyle,
                  'span': optionStyle,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
