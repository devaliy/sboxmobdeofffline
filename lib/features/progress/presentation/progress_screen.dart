import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/application/home_providers.dart';
import '../application/progress_providers.dart';
import 'widgets/count_up_stat.dart';
import 'widgets/score_trend_chart.dart';
import 'widgets/streak_calendar.dart';
import 'widgets/subject_accuracy_row.dart';

/// Streak, points, score-over-time and per-subject accuracy (spec Section
/// 7) — everything here is read from the signed-in account's real
/// `progress.sqlite`; there is no bundled/sample data, so a fresh account
/// legitimately sees zeros and empty states until it actually does
/// something.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(localStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
        data: (stats) {
          final points = stats?.totalPoints ?? 0;
          final streak = stats?.currentStreakDays ?? 0;
          final longest = stats?.longestStreakDays ?? 0;
          final lastActive = stats?.lastActiveDate == null ? null : DateTime.parse(stats!.lastActiveDate!);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              Row(
                children: [
                  Expanded(
                    child: CountUpStat(
                      value: points,
                      label: 'points',
                      icon: Icons.stars_rounded,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: CountUpStat(
                      value: streak,
                      label: 'day streak',
                      icon: Icons.local_fire_department_rounded,
                      hue: AppColors.danger,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Streak calendar',
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Best: $longest days',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              GlowCard(
                child: StreakCalendar(currentStreakDays: streak, lastActiveDate: lastActive),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(title: 'Score over time'),
              const SizedBox(height: AppSpacing.md),
              Consumer(
                builder: (context, ref, _) {
                  final attemptsAsync = ref.watch(allAttemptsProvider);
                  return attemptsAsync.when(
                    loading: () => const ShimmerCard(height: 220),
                    error: (e, st) =>
                        EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
                    data: (attempts) {
                      if (attempts.isEmpty) {
                        return const EmptyState(
                          icon: Icons.show_chart_rounded,
                          title: 'No quizzes or tests yet',
                          message: 'Finish a "Test yourself" or a Practice test to see your score trend here.',
                        );
                      }
                      return GlowCard(
                        child: SizedBox(height: 200, child: ScoreTrendChart(attempts: attempts)),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(title: 'Accuracy by subject'),
              const SizedBox(height: AppSpacing.md),
              Consumer(
                builder: (context, ref, _) {
                  final accuracyAsync = ref.watch(subjectAccuracyProvider);
                  return accuracyAsync.when(
                    loading: () => const ShimmerCard(),
                    error: (e, st) =>
                        EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
                    data: (rows) {
                      if (rows.isEmpty) {
                        return const EmptyState(
                          icon: Icons.pie_chart_outline_rounded,
                          title: 'Nothing to break down yet',
                          message: 'Accuracy per subject shows up once you\'ve completed a few attempts.',
                        );
                      }
                      return GlowCard(
                        child: Column(
                          children: [
                            for (var i = 0; i < rows.length; i++) ...[
                              if (i > 0) const Divider(),
                              SubjectAccuracyRow(data: rows[i]),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
