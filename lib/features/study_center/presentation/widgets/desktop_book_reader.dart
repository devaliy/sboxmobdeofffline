import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/db/study_content_db.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/utils/parse_hex_color.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/reader_prefs.dart';
import '../../application/reading_progress_controller.dart';
import '../../application/study_center_providers.dart';
import 'reader_controls.dart';

/// Desktop's "open a book -> land straight in it" experience (per the
/// desktop mockup): a fixed topics sidebar next to the reader pane, both
/// on the one `studyBook` route — not a second navigation step the way
/// mobile's book -> subject list -> reader flow is. Selecting a topic just
/// updates local state; there's no per-topic URL on desktop.
class DesktopBookReader extends StatefulWidget {
  const DesktopBookReader({super.key, required this.bookId, required this.subjects});

  final int bookId;
  final List<LibrarySubject> subjects;

  @override
  State<DesktopBookReader> createState() => _DesktopBookReaderState();
}

class _DesktopBookReaderState extends State<DesktopBookReader> {
  late int _selectedSubjectId = _sorted(widget.subjects).first.id;

  static List<LibrarySubject> _sorted(List<LibrarySubject> subjects) =>
      [...subjects]..sort((a, b) => a.week.compareTo(b.week));

  @override
  void didUpdateWidget(covariant DesktopBookReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the previously-selected topic disappears (pack re-imported/
    // trimmed), fall back to the first one rather than pointing at
    // nothing.
    if (widget.subjects.every((s) => s.id != _selectedSubjectId)) {
      setState(() => _selectedSubjectId = _sorted(widget.subjects).first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted(widget.subjects);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 240,
          child: _TopicSidebar(
            subjects: sorted,
            selectedId: _selectedSubjectId,
            onSelect: (id) => setState(() => _selectedSubjectId = id),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          // Keyed so switching topics gets a fresh scroll position/state
          // instead of reusing the previous topic's scroll offset.
          child: _DesktopReaderPane(
            key: ValueKey(_selectedSubjectId),
            bookId: widget.bookId,
            subjectId: _selectedSubjectId,
          ),
        ),
      ],
    );
  }
}

class _TopicSidebar extends StatelessWidget {
  const _TopicSidebar({required this.subjects, required this.selectedId, required this.onSelect});

  final List<LibrarySubject> subjects;
  final int selectedId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
          child: Text('Topics', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            itemCount: subjects.length,
            itemBuilder: (context, i) {
              final subject = subjects[i];
              final isSelected = subject.id == selectedId;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Material(
                  color: isSelected ? AppColors.inkNavy : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    onTap: () => onSelect(subject.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Week ${subject.week}',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: isSelected ? Colors.white70 : AppColors.textMutedLight,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subject.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isSelected ? Colors.white : null,
                                  fontWeight: isSelected ? FontWeight.w600 : null,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DesktopReaderPane extends ConsumerStatefulWidget {
  const _DesktopReaderPane({super.key, required this.bookId, required this.subjectId});

  final int bookId;
  final int subjectId;

  @override
  ConsumerState<_DesktopReaderPane> createState() => _DesktopReaderPaneState();
}

class _DesktopReaderPaneState extends ConsumerState<_DesktopReaderPane> {
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), _persistProgress);
  }

  void _persistProgress() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final percent = position.maxScrollExtent <= 0
        ? 100
        : ((position.pixels / position.maxScrollExtent) * 100).clamp(0, 100).round();
    ref
        .read(readingProgressControllerProvider)
        .recordProgress(librarySubjectId: widget.subjectId, percentComplete: percent);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _persistProgress();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(bookByIdProvider(widget.bookId)).valueOrNull;
    final bookProgress = ref.watch(bookProgressProvider(widget.bookId)).valueOrNull ?? 0;
    final subject = ref.watch(subjectByIdProvider(widget.subjectId)).valueOrNull;
    final contentsAsync = ref.watch(contentsForSubjectProvider(widget.subjectId));
    final questionsAsync = ref.watch(questionsForSubjectProvider(widget.subjectId));
    final fontSize = ref.watch(readerFontSizeProvider);
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final hasQuestions = questionsAsync.valueOrNull?.isNotEmpty ?? false;
    final contents = contentsAsync.valueOrNull ?? const [];
    final combinedHtml = contents.map((c) => c.contentHtml).join('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (book != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
            child: _BookProgressHeader(book: book, percentComplete: bookProgress),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  subject?.title ?? '',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ReadAloudButton(html: combinedHtml),
              BookmarkButton(subjectId: widget.subjectId),
              const FontSizeButton(),
              if (hasQuestions) ...[
                const SizedBox(width: AppSpacing.sm),
                GradientButton(
                  label: 'Take test',
                  icon: Icons.quiz_rounded,
                  dense: true,
                  // Not full-width: this sits inline among the icon
                  // buttons, not stretched across the row — `expand: true`
                  // (the default) also crashes here regardless, since a
                  // non-flex sibling of the title's Expanded gets
                  // unbounded width during layout, and GradientButton's
                  // own internal Row can't be MainAxisSize.max under that.
                  expand: false,
                  onPressed: () => context.push(AppRoutes.studyQuiz(widget.bookId, widget.subjectId)),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: contentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) =>
                EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
            data: (contents) {
              if (contents.isEmpty) {
                return const EmptyState(
                  icon: Icons.article_outlined,
                  title: 'No reading content',
                  message: 'This week has no article content in the downloaded pack.',
                );
              }

              final textStyle = Style(
                fontSize: FontSize(fontSize),
                color: onSurface,
                lineHeight: const LineHeight(1.6),
              );

              return ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxxl),
                children: [
                  for (final content in contents)
                    Html(
                      data: content.contentHtml,
                      style: {
                        'body': textStyle.copyWith(margin: Margins.zero),
                        'p': textStyle,
                        'li': textStyle,
                        'span': textStyle,
                        'h1': textStyle.copyWith(fontSize: FontSize(fontSize + 8), fontWeight: FontWeight.w700),
                        'h2': textStyle.copyWith(fontSize: FontSize(fontSize + 5), fontWeight: FontWeight.w700),
                        'h3': textStyle.copyWith(fontSize: FontSize(fontSize + 2), fontWeight: FontWeight.w600),
                        'a': textStyle.copyWith(color: AppColors.signalOrange),
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BookProgressHeader extends StatelessWidget {
  const _BookProgressHeader({required this.book, required this.percentComplete});

  final LibraryBook book;
  final int percentComplete;

  @override
  Widget build(BuildContext context) {
    final base = parseHexColor(book.color, fallback: AppColors.brandBlue);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlowCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: book.imagePath == null
                  ? Container(color: base)
                  : LocalContentImage(
                      relativePath: book.imagePath,
                      placeholder: Container(color: base),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.name,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: percentComplete / 100,
                    minHeight: 6,
                    backgroundColor: isDark ? AppColors.outlineDark : AppColors.outlineLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.success),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text('$percentComplete% Completed', style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
