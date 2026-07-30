import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/study_center_providers.dart';
import 'widgets/book_cover_card.dart';

/// Book grid — Study Center's entry point (spec Section 7), scoped to
/// whatever's actually installed. Empty state if the student skipped the
/// Study domain in Setup.
class StudyCenterScreen extends ConsumerWidget {
  const StudyCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(installedBooksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Study Center')),
      body: booksAsync.when(
        loading: () => GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(AppSpacing.xl),
          mainAxisSpacing: AppSpacing.lg,
          crossAxisSpacing: AppSpacing.lg,
          childAspectRatio: 0.72,
          children: List.generate(
            4,
            (_) => ShimmerBlock(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
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

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.xl),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.lg,
              crossAxisSpacing: AppSpacing.lg,
              childAspectRatio: 0.72,
            ),
            itemCount: books.length,
            itemBuilder: (context, i) {
              final book = books[i];
              return BookCoverCard(
                name: book.name,
                colorHex: book.color,
                onTap: () => context.push(AppRoutes.studyBook(book.id)),
              );
            },
          );
        },
      ),
    );
  }
}
