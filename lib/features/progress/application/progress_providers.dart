import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/assessment_content_db.dart' show AssessmentContentDb;
import '../../../core/db/db_providers.dart';
import '../../../core/db/progress_db.dart';
import '../../../core/db/study_content_db.dart' show StudyContentDb;
import '../../auth/application/auth_controller.dart';
import '../domain/analytics_stats.dart';
import '../domain/attempt_row.dart';
import '../domain/subject_score_series.dart';
import '../domain/subject_time_slice.dart';

/// Full attempt history, oldest first — feeds the score-over-time chart
/// directly and is the source [resolvedAttemptsProvider] resolves from.
final allAttemptsProvider = StreamProvider<List<PracticeAttempt>>((ref) {
  final db = ref.watch(currentProgressDbProvider);
  if (db == null) return Stream.value(const []);
  return db.watchAllAttempts();
});

/// Resolves an attempt's subject/book display name: attempts written after
/// the `subject_name` column was added (see `progress_db.dart`'s schema v2
/// migration) already carry it; older rows fall back to a live lookup
/// against the relevant content DB, same as this provider always did before
/// that column existed.
Future<String> resolveSubjectLabel(
  PracticeAttempt attempt,
  StudyContentDb studyDb,
  AssessmentContentDb assessmentDb,
) async {
  if (attempt.subjectName != null && attempt.subjectName!.isNotEmpty) {
    return attempt.subjectName!;
  }
  if (attempt.sourceType == 'assessment' && attempt.subjectId != null) {
    final subject = await (assessmentDb.select(assessmentDb.subjects)
          ..where((t) => t.id.equals(attempt.subjectId!)))
        .getSingleOrNull();
    if (subject != null) return subject.name;
  } else if (attempt.sourceType == 'library' && attempt.librarySubjectId != null) {
    final subject = await (studyDb.select(studyDb.librarySubjects)
          ..where((t) => t.id.equals(attempt.librarySubjectId!)))
        .getSingleOrNull();
    if (subject != null) {
      final book = await (studyDb.select(studyDb.libraryBooks)
            ..where((t) => t.id.equals(subject.libraryBookId)))
          .getSingleOrNull();
      if (book != null) return book.name;
    }
  }
  return 'Other';
}

String _resolveTestTypeLabel(PracticeAttempt attempt) {
  if (attempt.testTypeLabel != null && attempt.testTypeLabel!.isNotEmpty) {
    return attempt.testTypeLabel!;
  }
  return attempt.sourceType == 'library' ? 'Self Test' : 'Practice';
}

/// Every attempt with its labels resolved, oldest first — the single source
/// every other Analytics provider derives from, so a subject's label/order
/// is never computed two different ways in two different places.
final resolvedAttemptsProvider = FutureProvider<List<AttemptRow>>((ref) async {
  final attempts = await ref.watch(allAttemptsProvider.future);
  if (attempts.isEmpty) return const [];

  final studyDb = ref.watch(studyContentDbProvider);
  final assessmentDb = ref.watch(assessmentContentDbProvider);

  final rows = <AttemptRow>[];
  for (final attempt in attempts) {
    final label = await resolveSubjectLabel(attempt, studyDb, assessmentDb);
    rows.add(AttemptRow(
      attempt: attempt,
      subjectLabel: label,
      testTypeLabel: _resolveTestTypeLabel(attempt),
    ));
  }
  return rows;
});

/// Time spent per subject/book, for the report's pie chart — sums
/// `time_spent_seconds` across every attempt against that label.
final subjectTimeSpentProvider = FutureProvider<List<SubjectTimeSlice>>((ref) async {
  final rows = await ref.watch(resolvedAttemptsProvider.future);
  if (rows.isEmpty) return const [];

  final totals = <String, int>{};
  for (final row in rows) {
    totals[row.subjectLabel] = (totals[row.subjectLabel] ?? 0) + row.attempt.timeSpentSeconds;
  }

  final result = [
    for (final entry in totals.entries) SubjectTimeSlice(label: entry.key, seconds: entry.value),
  ]..sort((a, b) => b.seconds.compareTo(a.seconds));
  return result;
});

/// Score-over-time per subject/book, for the report's multi-line chart.
/// Capped to the 6 subjects with the most attempts, so the chart stays
/// readable instead of drawing a line per subject regardless of volume.
final subjectScoreSeriesProvider = FutureProvider<List<SubjectScoreSeries>>((ref) async {
  final rows = await ref.watch(resolvedAttemptsProvider.future);
  if (rows.isEmpty) return const [];

  final byLabel = <String, List<AttemptRow>>{};
  for (final row in rows) {
    (byLabel[row.subjectLabel] ??= []).add(row);
  }

  final labels = byLabel.keys.toList()
    ..sort((a, b) => byLabel[b]!.length.compareTo(byLabel[a]!.length));

  return [
    for (final label in labels.take(6))
      SubjectScoreSeries(
        label: label,
        points: [
          for (final row in byLabel[label]!)
            ScorePoint(
              date: DateTime.parse(row.attempt.completedAt),
              scorePercent: row.scorePercent,
            ),
        ],
      ),
  ];
});

/// Headline stat cards: totals, pass/fail, and period-over-period trends
/// with a small sparkline history behind each one.
final analyticsStatsProvider = FutureProvider<AnalyticsStats>((ref) async {
  final rows = await ref.watch(resolvedAttemptsProvider.future);
  if (rows.isEmpty) return AnalyticsStats.empty;

  final scores = [for (final r in rows) r.scorePercent];
  final times = [for (final r in rows) r.attempt.timeSpentSeconds.toDouble()];

  final totalPassed = scores.where((s) => s >= 50).length;
  final highest = scores.reduce((a, b) => a > b ? a : b);
  final avgPerformance = scores.reduce((a, b) => a + b) / scores.length;
  final avgTime = times.reduce((a, b) => a + b) / times.length;

  double periodChange(List<double> values) {
    if (values.length < 2) return 0;
    final mid = values.length ~/ 2;
    final first = values.sublist(0, mid);
    final second = values.sublist(mid);
    final firstAvg = first.reduce((a, b) => a + b) / first.length;
    final secondAvg = second.reduce((a, b) => a + b) / second.length;
    if (firstAvg == 0) return secondAvg == 0 ? 0 : 100;
    return (secondAvg - firstAvg) / firstAvg * 100;
  }

  List<double> lastN(List<double> values, int n) =>
      values.length <= n ? values : values.sublist(values.length - n);

  return AnalyticsStats(
    totalTests: rows.length,
    highestScorePercent: highest,
    totalPassed: totalPassed,
    totalFailed: rows.length - totalPassed,
    averagePerformancePercent: avgPerformance,
    averageTimeSpentSeconds: avgTime,
    growthPercent: periodChange(scores),
    performanceTrendPercent: periodChange(scores),
    timeSpentTrendPercent: periodChange(times),
    growthSparkline: lastN(scores, 10),
    performanceSparkline: lastN(scores, 10),
    timeSpentSparkline: lastN(times, 10),
  );
});

/// One page of the report's data table, newest attempt first, with each
/// row's score-over-time "Improvement" vs that same subject's previous
/// attempt (null for a subject's first-ever recorded attempt).
final attemptsTableProvider =
    FutureProvider.family<List<AttemptTableRow>, ({int page, int pageSize})>((ref, args) async {
  final rows = await ref.watch(resolvedAttemptsProvider.future); // oldest first
  if (rows.isEmpty) return const [];

  final lastScoreBySubject = <String, double>{};
  final withImprovement = <AttemptTableRow>[];
  for (final row in rows) {
    final previous = lastScoreBySubject[row.subjectLabel];
    withImprovement.add(AttemptTableRow(
      row: row,
      improvementPercent: previous == null ? null : row.scorePercent - previous,
    ));
    lastScoreBySubject[row.subjectLabel] = row.scorePercent;
  }

  final newestFirst = withImprovement.reversed.toList();
  final start = args.page * args.pageSize;
  if (start >= newestFirst.length) return const [];
  final end = (start + args.pageSize).clamp(0, newestFirst.length);
  return newestFirst.sublist(start, end);
});

final attemptsTotalCountProvider = FutureProvider<int>((ref) async {
  final rows = await ref.watch(resolvedAttemptsProvider.future);
  return rows.length;
});

class AttemptTableRow {
  const AttemptTableRow({required this.row, required this.improvementPercent});
  final AttemptRow row;
  final double? improvementPercent;
}
