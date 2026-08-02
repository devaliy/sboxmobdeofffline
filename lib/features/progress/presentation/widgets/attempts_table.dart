import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../application/analytics_controller.dart';
import '../../application/progress_providers.dart';

const _pageSizeOptions = [5, 10, 20, 50];

String _shortId(String id) => id.length <= 8 ? id : id.substring(0, 8);

/// The report's paginated attempt history — Subject / Test Type / ID /
/// Grade / Improvement / Actions, matching Report.png's data table.
class AttemptsTable extends ConsumerStatefulWidget {
  const AttemptsTable({super.key});

  @override
  ConsumerState<AttemptsTable> createState() => _AttemptsTableState();
}

class _AttemptsTableState extends ConsumerState<AttemptsTable> {
  int _page = 0;
  int _pageSize = 10;

  @override
  Widget build(BuildContext context) {
    final totalAsync = ref.watch(attemptsTotalCountProvider);
    final rowsAsync = ref.watch(attemptsTableProvider((page: _page, pageSize: _pageSize)));
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Test history', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.md),
        rowsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Text('Couldn\'t load test history: $e'),
          ),
          data: (rows) {
            if (rows.isEmpty && _page == 0) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Text('No tests completed yet.'),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('Test Type')),
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Grade')),
                  DataColumn(label: Text('Improvement')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [
                  for (final entry in rows)
                    DataRow(cells: [
                      DataCell(Text(entry.row.subjectLabel)),
                      DataCell(Text(entry.row.testTypeLabel)),
                      DataCell(Text(_shortId(entry.row.attempt.id))),
                      DataCell(_GradeCell(percent: entry.row.scorePercent)),
                      DataCell(_ImprovementCell(percent: entry.improvementPercent)),
                      DataCell(_ActionsCell(attemptId: entry.row.attempt.id)),
                    ]),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        totalAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, st) => const SizedBox.shrink(),
          data: (total) => _PaginationBar(
            page: _page,
            pageSize: _pageSize,
            total: total,
            onPageChanged: (p) => setState(() => _page = p),
            onPageSizeChanged: (s) => setState(() {
              _pageSize = s;
              _page = 0;
            }),
          ),
        ),
      ],
    );
  }
}

class _GradeCell extends StatelessWidget {
  const _GradeCell({required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context) {
    final tone = percent >= 50 ? AppColors.success : AppColors.danger;
    return Text('${percent.round()}%', style: TextStyle(color: tone, fontWeight: FontWeight.w600));
  }
}

class _ImprovementCell extends StatelessWidget {
  const _ImprovementCell({required this.percent});
  final double? percent;

  @override
  Widget build(BuildContext context) {
    if (percent == null) return const Text('—');
    final up = percent! >= 0;
    final tone = up ? AppColors.success : AppColors.danger;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, color: tone, size: 14),
        Text('${percent!.abs().round()}%', style: TextStyle(color: tone, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ActionsCell extends ConsumerWidget {
  const _ActionsCell({required this.attemptId});
  final String attemptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility_outlined, size: 20),
          tooltip: 'View',
          onPressed: () => context.push(AppRoutes.attemptDetail(attemptId)),
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined, size: 20),
          tooltip: 'Copy summary',
          onPressed: () => _copySummary(context, ref),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.danger),
          tooltip: 'Delete',
          onPressed: () => _confirmDelete(context, ref),
        ),
      ],
    );
  }

  Future<void> _copySummary(BuildContext context, WidgetRef ref) async {
    final detail = await ref.read(attemptDetailProvider(attemptId).future);
    if (detail == null) return;
    await Clipboard.setData(ClipboardData(text: ref.read(analyticsControllerProvider).buildSummary(detail)));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Summary copied to clipboard')));
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this test result?'),
        content: const Text('This removes it from your history permanently.'),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(analyticsControllerProvider).deleteAttempt(attemptId);
    }
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.onPageChanged,
    required this.onPageSizeChanged,
  });

  final int page;
  final int pageSize;
  final int total;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  @override
  Widget build(BuildContext context) {
    final start = total == 0 ? 0 : page * pageSize + 1;
    final end = ((page + 1) * pageSize).clamp(0, total);
    final hasNext = end < total;
    final hasPrev = page > 0;
    final theme = Theme.of(context);
    final formatter = NumberFormat.decimalPattern();

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rows per page', style: theme.textTheme.bodySmall),
            const SizedBox(width: AppSpacing.sm),
            DropdownButton<int>(
              value: pageSize,
              underline: const SizedBox.shrink(),
              items: [
                for (final size in _pageSizeOptions) DropdownMenuItem(value: size, child: Text('$size')),
              ],
              onChanged: (value) {
                if (value != null) onPageSizeChanged(value);
              },
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${formatter.format(start)}-${formatter.format(end)} of ${formatter.format(total)}',
              style: theme.textTheme.bodySmall,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: hasPrev ? () => onPageChanged(page - 1) : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: hasNext ? () => onPageChanged(page + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}
