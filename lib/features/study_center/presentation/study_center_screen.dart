import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/study_center_providers.dart';
import 'widgets/book_cover_card.dart';

/// Book shelf — Study Center's entry point (spec Section 7), scoped to
/// whatever's actually installed: a "Recently Read" shelf (most recently
/// opened books first) above the full "All Books" grid, matching the
/// mockups' bookshelf layout. Empty state if the student skipped the
/// Study domain in Setup.
class StudyCenterScreen extends ConsumerWidget {
  const StudyCenterScreen({super.key});

  static const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 130,
    mainAxisSpacing: AppSpacing.lg,
    crossAxisSpacing: AppSpacing.lg,
    childAspectRatio: 0.66,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(installedBooksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Study Center')),
      body: booksAsync.when(
        loading: () => GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.xl),
          gridDelegate: _gridDelegate,
          itemCount: 6,
          itemBuilder: (context, i) => ShimmerBlock(
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
        error: (e, st) => EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Something went wrong',
          message: '$e',
        ),
        data: (books) {
          if (books.isEmpty) {
            return EmptyState(
              icon: Icons.menu_book_outlined,
              title: "You haven't downloaded any Study content yet",
              message: 'Add a class and its books in Setup to start reading offline.',
              actionLabel: 'Add Study content',
              onAction: () => context.push(AppRoutes.setup),
            );
          }

          final recentAsync = ref.watch(recentlyReadBooksProvider);
          final recentBooks = recentAsync.valueOrNull ?? const [];

          return CustomScrollView(
            slivers: [
              if (recentBooks.isNotEmpty) ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
                  sliver: SliverToBoxAdapter(child: SectionHeader(title: 'Recently Read')),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 190,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, 0),
                      scrollDirection: Axis.horizontal,
                      itemCount: recentBooks.length,
                      separatorBuilder: (context, i) => const SizedBox(width: AppSpacing.lg),
                      itemBuilder: (context, i) {
                        final book = recentBooks[i];
                        return SizedBox(
                          width: 120,
                          child: BookCoverCard(
                            name: book.name,
                            colorHex: book.color,
                            imagePath: book.imagePath,
                            onTap: () => context.push(AppRoutes.studyBook(book.id)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
                sliver: SliverToBoxAdapter(child: SectionHeader(title: 'All Books')),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                sliver: SliverGrid(
                  gridDelegate: _gridDelegate,
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final book = books[i];
                      return BookCoverCard(
                        name: book.name,
                        colorHex: book.color,
                        imagePath: book.imagePath,
                        onTap: () => context.push(AppRoutes.studyBook(book.id)),
                      );
                    },
                    childCount: books.length,
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
