import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/assessment_content_db.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/practice_providers.dart';
import '../domain/practice_test_type.dart';

/// Category -> test format -> subject setup: the server's `test_types`
/// table has never been populated in production (confirmed by pulling real
/// pack.json across every installed subject — always `[]`), so the picker
/// is built around what's actually real instead: installed `categories`
/// (e.g. "UTME Simulator", "SSCE Test Engine"), a fixed pair of client-side
/// formats (Speed/Standard), then whichever installed subjects actually
/// have questions in the chosen category. Tapping a subject starts a timed
/// session straight away.
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  Category? _category;
  PracticeTestType? _testType;
  Subject? _subject;

  void _reset() => setState(() {
        _category = null;
        _testType = null;
        _subject = null;
      });

  void _back() => setState(() {
        if (_subject != null) {
          _subject = null;
        } else if (_testType != null) {
          _testType = null;
        } else {
          _category = null;
        }
      });

  @override
  Widget build(BuildContext context) {
    final category = _category;
    final testType = _testType;
    final subject = _subject;

    final String title;
    if (category == null) {
      title = 'Practice / CBT';
    } else if (testType == null) {
      title = category.catName;
    } else if (subject == null) {
      title = '${category.catName} · ${testType.label}';
    } else {
      title = subject.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: category == null ? null : BackButton(onPressed: _back),
      ),
      body: category == null
          ? _CategoryPicker(onSelect: (c) => setState(() => _category = c))
          : testType == null
              ? _TestTypePicker(onSelect: (t) => setState(() => _testType = t))
              : subject == null
                  ? _SubjectPicker(category: category, onSelect: (s) => setState(() => _subject = s))
                  : _YearPicker(category: category, testType: testType, subject: subject, onDone: _reset),
    );
  }
}

class _CategoryPicker extends ConsumerWidget {
  const _CategoryPicker({required this.onSelect});

  final ValueChanged<Category> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(installedCategoriesProvider);

    return categoriesAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: const [ShimmerCard(), SizedBox(height: AppSpacing.md), ShimmerCard()],
      ),
      error: (e, st) =>
          EmptyState(icon: Icons.error_outline_rounded, title: 'Something went wrong', message: '$e'),
      data: (categories) {
        if (categories.isEmpty) {
          return EmptyState(
            icon: Icons.fact_check_outlined,
            title: "You haven't downloaded any Assessment content yet",
            message: 'Add a subject in Setup to start practicing offline.',
            actionLabel: 'Add Assessment content',
            onAction: () => context.push(AppRoutes.setup),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            SectionHeader(title: 'Choose a category'),
            const SizedBox(height: AppSpacing.md),
            for (final category in categories)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _PickerTile(
                  icon: Icons.category_rounded,
                  title: category.catName,
                  onTap: () => onSelect(category),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TestTypePicker extends StatelessWidget {
  const _TestTypePicker({required this.onSelect});

  final ValueChanged<PracticeTestType> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        SectionHeader(title: 'Choose a test format'),
        const SizedBox(height: AppSpacing.md),
        for (final testType in PracticeTestType.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _PickerTile(
              icon: Icons.timer_outlined,
              title: testType.label,
              subtitle: '${testType.numQuestions} questions · ${testType.durationMinutes} min',
              onTap: () => onSelect(testType),
            ),
          ),
      ],
    );
  }
}

class _SubjectPicker extends ConsumerWidget {
  const _SubjectPicker({required this.category, required this.onSelect});

  final Category category;
  final ValueChanged<Subject> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsForCategoryProvider(category.id));

    return subjectsAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: const [ShimmerCard(), SizedBox(height: AppSpacing.md), ShimmerCard()],
      ),
      error: (e, st) =>
          EmptyState(icon: Icons.error_outline_rounded, title: 'Something went wrong', message: '$e'),
      data: (subjects) {
        if (subjects.isEmpty) {
          return EmptyState(
            icon: Icons.fact_check_outlined,
            title: 'No subjects for ${category.catName} yet',
            message: 'Check back later — new content is added regularly.',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            SectionHeader(title: 'Choose a subject'),
            const SizedBox(height: AppSpacing.md),
            for (final subject in subjects)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _PickerTile(
                  icon: Icons.menu_book_rounded,
                  title: subject.name,
                  onTap: () => onSelect(subject),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _YearPicker extends ConsumerWidget {
  const _YearPicker({
    required this.category,
    required this.testType,
    required this.subject,
    required this.onDone,
  });

  final Category category;
  final PracticeTestType testType;
  final Subject subject;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearsAsync = ref.watch(
      yearsForSubjectAndCategoryProvider((subjectId: subject.id, categoryId: category.id)),
    );

    return yearsAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: const [ShimmerCard(), SizedBox(height: AppSpacing.md), ShimmerCard()],
      ),
      error: (e, st) =>
          EmptyState(icon: Icons.error_outline_rounded, title: 'Something went wrong', message: '$e'),
      data: (years) {
        if (years.isEmpty) {
          return EmptyState(
            icon: Icons.event_busy_outlined,
            title: 'No years for ${subject.name} yet',
            message: 'Check back later — new content is added regularly.',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            SectionHeader(title: 'Choose a year'),
            const SizedBox(height: AppSpacing.md),
            for (final year in years)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _PickerTile(
                  icon: Icons.event_outlined,
                  title: year.yearName,
                  onTap: () {
                    // Reset before pushing, not via `.then()` on the
                    // pushed route's future: "Done" on the results screen
                    // returns here via `context.go`, which replaces the
                    // route stack rather than popping it — that doesn't
                    // reliably complete a pending `push()` future. Resetting
                    // eagerly is harmless (this screen is fully covered by
                    // the exam session, a top-level route, until the
                    // student is back anyway) and is guaranteed to happen.
                    onDone();
                    context.push(
                      AppRoutes.practiceExam(
                        subjectId: subject.id,
                        categoryId: category.id,
                        yearId: year.id,
                        testType: testType.name,
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({required this.icon, required this.title, this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlowCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.signalOrange, AppColors.signalOrangeLight]),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall
                        ?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
