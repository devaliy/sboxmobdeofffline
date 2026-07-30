import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/db/study_content_db.dart';
import '../../application/study_center_providers.dart';

/// One subject/week row in a book's subject list — title, author, and a
/// live progress bar sourced from the signed-in account's `progress.sqlite`
/// (spec Section 7: "grouped by term, progress bar per row").
class SubjectRow extends ConsumerWidget {
  const SubjectRow({super.key, required this.subject, required this.onTap});

  final LibrarySubject subject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(readingProgressForSubjectProvider(subject.id)).valueOrNull;
    final percent = progress?.percentComplete ?? 0;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlowCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week ${subject.week}',
                  style: textTheme.labelSmall?.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subject.title, style: textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 6,
                    backgroundColor: isDark ? AppColors.outlineDark : AppColors.outlineLight,
                    valueColor: AlwaysStoppedAnimation(
                      percent >= 100 ? AppColors.success : AppColors.signalOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text('$percent%', style: textTheme.labelMedium),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
