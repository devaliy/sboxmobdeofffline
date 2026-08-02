import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/reader_bookmarks.dart';
import '../application/reader_prefs.dart';
import '../application/reading_progress_controller.dart';
import '../application/study_center_providers.dart';
import 'widgets/reader_controls.dart';

/// Renders `library_contents`' CKEditor-authored HTML faithfully (spec
/// Section 1.9), with a font-size control and a floating "Take test"
/// button once the subject's questions are available. Scroll position
/// drives `reading_progress` writes, debounced and monotonic.
class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key, required this.bookId, required this.subjectId});

  final int bookId;
  final int subjectId;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    loadReaderFontSize().then((value) {
      if (mounted) ref.read(readerFontSizeProvider.notifier).state = value;
    });
    loadBookmarkedSubjectIds().then((value) {
      if (mounted) ref.read(bookmarkedSubjectsProvider.notifier).state = value;
    });
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
    final subject = ref.watch(subjectByIdProvider(widget.subjectId)).valueOrNull;
    final contentsAsync = ref.watch(contentsForSubjectProvider(widget.subjectId));
    final questionsAsync = ref.watch(questionsForSubjectProvider(widget.subjectId));
    final fontSize = ref.watch(readerFontSizeProvider);
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final hasQuestions = questionsAsync.valueOrNull?.isNotEmpty ?? false;
    final contents = contentsAsync.valueOrNull ?? const [];
    final combinedHtml = contents.map((c) => c.contentHtml).join('\n');

    return Scaffold(
      appBar: AppBar(
        title: Text(subject?.title ?? 'Reading', maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          ReadAloudButton(html: combinedHtml),
          BookmarkButton(subjectId: widget.subjectId),
          const FontSizeButton(),
        ],
      ),
      body: contentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
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
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 100),
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
      bottomNavigationBar: hasQuestions
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: GradientButton(
                  label: 'Take test',
                  icon: Icons.quiz_rounded,
                  onPressed: () => context.push(AppRoutes.studyQuiz(widget.bookId, widget.subjectId)),
                ),
              ),
            )
          : null,
    );
  }
}
