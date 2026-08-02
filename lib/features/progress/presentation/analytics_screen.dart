import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/progress_providers.dart';
import '../domain/analytics_stats.dart';
import 'widgets/attempts_table.dart';
import 'widgets/mini_stat_tile.dart';
import 'widgets/stat_sparkline_card.dart';
import 'widgets/subject_score_line_chart.dart';
import 'widgets/subject_time_pie_chart.dart';

/// Analytics report (formerly "Progress") — headline trend cards, a
/// per-subject time-spent breakdown, a per-subject score-over-time graph,
/// and a paginated test history, matching `desktopscreens/Report.png`.
/// Everything here is read from the signed-in account's real
/// `progress.sqlite`; a fresh account legitimately sees zeros and empty
/// states until it actually completes something.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(analyticsStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) =>
            EmptyState(icon: Icons.error_outline_rounded, title: 'Couldn\'t load', message: '$e'),
        data: (stats) {
          if (stats.totalTests == 0) {
            return const EmptyState(
              icon: Icons.insights_rounded,
              title: 'Nothing to report yet',
              message: 'Finish a "Test yourself" or a Practice test to see your analytics here.',
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isDesktop ? _DesktopTop(stats: stats) : const _MobileTop(),
                    const SizedBox(height: AppSpacing.xxl),
                    _MiniStatsRow(stats: stats, isDesktop: isDesktop),
                    const SizedBox(height: AppSpacing.xxl),
                    const GlowCard(child: AttemptsTable()),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _DesktopTop extends StatelessWidget {
  const _DesktopTop({required this.stats});
  final AnalyticsStats stats;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 3, child: GlowCard(child: _StatSparklineColumn(stats: stats))),
          const SizedBox(width: AppSpacing.lg),
          const Expanded(flex: 7, child: GlowCard(glow: true, child: _ReportSummary())),
        ],
      ),
    );
  }
}

class _MobileTop extends StatelessWidget {
  const _MobileTop();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final statsAsync = ref.watch(analyticsStatsProvider);
      return Column(
        children: [
          statsAsync.when(
            loading: () => const ShimmerCard(),
            error: (e, st) => const SizedBox.shrink(),
            data: (stats) => GlowCard(child: _StatSparklineColumn(stats: stats)),
          ),
          const SizedBox(height: AppSpacing.lg),
          const GlowCard(glow: true, child: _ReportSummary()),
        ],
      );
    });
  }
}

class _StatSparklineColumn extends StatelessWidget {
  const _StatSparklineColumn({required this.stats});
  final AnalyticsStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overview', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        StatSparklineCard(
          label: 'Overall Growth',
          value: '${stats.growthPercent.round()}%',
          trendPercent: stats.growthPercent,
          sparkline: stats.growthSparkline,
        ),
        const Divider(),
        StatSparklineCard(
          label: 'Average Performance',
          value: '${stats.averagePerformancePercent.round()}%',
          trendPercent: stats.performanceTrendPercent,
          sparkline: stats.performanceSparkline,
        ),
        const Divider(),
        StatSparklineCard(
          label: 'Average Time Spent',
          value: _formatDuration(stats.averageTimeSpentSeconds),
          trendPercent: stats.timeSpentTrendPercent,
          sparkline: stats.timeSpentSparkline,
        ),
      ],
    );
  }
}

class _ReportSummary extends ConsumerWidget {
  const _ReportSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieAsync = ref.watch(subjectTimeSpentProvider);
    final lineAsync = ref.watch(subjectScoreSeriesProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Report Summary', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.lg),
        Text('Time spent per subject', style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        pieAsync.when(
          loading: () => const SizedBox(height: 140, child: Center(child: CircularProgressIndicator())),
          error: (e, st) => const SizedBox.shrink(),
          data: (slices) => slices.isEmpty
              ? const SizedBox.shrink()
              : SizedBox(height: 160, child: SubjectTimePieChart(slices: slices)),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text('Scores over time, per subject', style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        lineAsync.when(
          loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
          error: (e, st) => const SizedBox.shrink(),
          data: (series) => series.isEmpty
              ? const SizedBox.shrink()
              : SizedBox(height: 220, child: SubjectScoreLineChart(series: series)),
        ),
      ],
    );
  }
}

class _MiniStatsRow extends StatelessWidget {
  const _MiniStatsRow({required this.stats, required this.isDesktop});
  final AnalyticsStats stats;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      MiniStatTile(
        icon: Icons.checklist_rounded,
        hue: AppColors.sky,
        label: 'Total tests taken',
        value: '${stats.totalTests}',
      ),
      MiniStatTile(
        icon: Icons.emoji_events_rounded,
        hue: AppColors.sunflower,
        label: 'Highest score',
        value: '${stats.highestScorePercent.round()}%',
      ),
      MiniStatTile(
        icon: Icons.check_circle_rounded,
        hue: AppColors.mint,
        label: 'Total passed',
        value: '${stats.totalPassed}',
      ),
      MiniStatTile(
        icon: Icons.cancel_rounded,
        hue: AppColors.coral,
        label: 'Total failed',
        value: '${stats.totalFailed}',
      ),
    ];

    if (isDesktop) {
      return Row(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.lg),
            Expanded(child: tiles[i]),
          ],
        ],
      );
    }
    // Two rows of Expanded tiles rather than a fixed-aspect-ratio grid: the
    // tile's own content (icon + two lines of text) determines its height,
    // so it never overflows at larger system text scales the way a locked
    // aspect ratio would.
    return Column(
      children: [
        Row(children: [
          Expanded(child: tiles[0]),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: tiles[1]),
        ]),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          Expanded(child: tiles[2]),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: tiles[3]),
        ]),
      ],
    );
  }
}

String _formatDuration(double seconds) {
  final minutes = (seconds / 60).round();
  if (minutes < 60) return '${minutes}m';
  final hours = minutes ~/ 60;
  final rem = minutes % 60;
  return '${hours}h ${rem}m';
}
