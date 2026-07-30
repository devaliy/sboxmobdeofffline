import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/assessment_content_db.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/practice_providers.dart';

/// Subject -> test type setup (spec Section 1.5): every installed
/// Assessment subject with its downloaded test types, tap one to start a
/// timed session straight away. Scoped to installed content only, same
/// "every row here is already installed" reasoning as Study Center's book
/// grid (M6).
class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(installedSubjectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: subjectsAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: const [ShimmerCard(), SizedBox(height: AppSpacing.md), ShimmerCard()],
        ),
        error: (e, st) => EmptyState(icon: Icons.error_outline_rounded, title: 'Something went wrong', message: '$e'),
        data: (subjects) {
          if (subjects.isEmpty) {
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
              for (final subject in subjects) ...[
                SectionHeader(title: subject.name),
                const SizedBox(height: AppSpacing.md),
                _TestTypeList(subjectId: subject.id),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _TestTypeList extends ConsumerWidget {
  const _TestTypeList({required this.subjectId});

  final int subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testTypesAsync = ref.watch(testTypesForSubjectProvider(subjectId));

    return testTypesAsync.when(
      loading: () => const ShimmerCard(),
      error: (e, st) => Text('$e'),
      data: (testTypes) {
        if (testTypes.isEmpty) {
          return const Text('No practice tests in this subject\'s downloaded pack yet.');
        }
        return Column(
          children: [
            for (final testType in testTypes)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _TestTypeCard(testType: testType),
              ),
          ],
        );
      },
    );
  }
}

class _TestTypeCard extends StatelessWidget {
  const _TestTypeCard({required this.testType});

  final TestType testType;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlowCard(
      onTap: () => context.push(AppRoutes.practiceExam(testType.id)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.signalOrange, AppColors.signalOrangeLight]),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.timer_outlined, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(testType.testTypeName, style: textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${testType.numOfQuestions} questions · ${testType.durationMinutes} min',
                  style: textTheme.bodySmall
                      ?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
