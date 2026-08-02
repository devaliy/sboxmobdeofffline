import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/db/study_content_db.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/study_center_providers.dart';
import 'widgets/desktop_book_reader.dart';
import 'widgets/subject_row.dart';

/// Subject/week list for one book, grouped by term (spec Section 7) on
/// mobile. On desktop, opening a book lands directly in the combined
/// topics-sidebar + reader view instead (`DesktopBookReader`) — matching
/// the desktop mockup's "open a book, you're already reading it" flow
/// rather than requiring a second tap through an intermediate list.
class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key, required this.bookId});

  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(bookId)).valueOrNull;
    final subjectsAsync = ref.watch(subjectsForBookProvider(bookId));
    final terms = ref.watch(termsProvider).valueOrNull ?? const [];
    final termNameById = {for (final t in terms) t.id: t.name};

    return Scaffold(
      appBar: AppBar(title: Text(book?.name ?? 'Study')),
      body: subjectsAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: const [ShimmerCard(), SizedBox(height: AppSpacing.md), ShimmerCard()],
        ),
        error: (e, st) => EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
        data: (subjects) {
          if (subjects.isEmpty) {
            return const EmptyState(
              icon: Icons.menu_book_outlined,
              title: 'Nothing here yet',
              message: 'This book has no weeks in the downloaded pack.',
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= AppBreakpoints.desktop) {
                return DesktopBookReader(bookId: bookId, subjects: subjects);
              }

              final grouped = <int, List<LibrarySubject>>{};
              for (final subject in subjects) {
                grouped.putIfAbsent(subject.termId, () => []).add(subject);
              }

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  for (final entry in grouped.entries) ...[
                    SectionHeader(title: termNameById[entry.key] ?? 'Term'),
                    const SizedBox(height: AppSpacing.md),
                    for (final subject in entry.value)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: SubjectRow(
                          subject: subject,
                          onTap: () => context.push(AppRoutes.studySubject(bookId, subject.id)),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}
