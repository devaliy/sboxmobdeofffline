import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/db_providers.dart';
import '../../../core/db/progress_db.dart';
import '../../auth/application/auth_controller.dart';
import '../domain/subject_accuracy.dart';

/// Full attempt history, oldest first — feeds the score-over-time chart
/// directly and is the source [subjectAccuracyProvider] aggregates from.
final allAttemptsProvider = StreamProvider<List<PracticeAttempt>>((ref) {
  final db = ref.watch(currentProgressDbProvider);
  if (db == null) return Stream.value(const []);
  return db.watchAllAttempts();
});

/// Per-subject/book accuracy (spec Section 7's "per-subject accuracy"):
/// groups every attempt by its resolved label — the assessment subject's
/// name for `source_type: assessment`, the Study Center book's name for
/// `source_type: library` (grouped at book level, not per-week, since a
/// single week's sample size is rarely meaningful on its own) — and sums
/// correct/total across all attempts against that label.
final subjectAccuracyProvider = FutureProvider<List<SubjectAccuracy>>((ref) async {
  final attempts = await ref.watch(allAttemptsProvider.future);
  if (attempts.isEmpty) return const [];

  final studyDb = ref.watch(studyContentDbProvider);
  final assessmentDb = ref.watch(assessmentContentDbProvider);

  final totals = <String, ({int correct, int total})>{};

  for (final attempt in attempts) {
    String? label;
    if (attempt.sourceType == 'assessment' && attempt.subjectId != null) {
      final subject = await (assessmentDb.select(assessmentDb.subjects)
            ..where((t) => t.id.equals(attempt.subjectId!)))
          .getSingleOrNull();
      label = subject?.name;
    } else if (attempt.sourceType == 'library' && attempt.librarySubjectId != null) {
      final subject = await (studyDb.select(studyDb.librarySubjects)
            ..where((t) => t.id.equals(attempt.librarySubjectId!)))
          .getSingleOrNull();
      if (subject != null) {
        final book = await (studyDb.select(studyDb.libraryBooks)
              ..where((t) => t.id.equals(subject.libraryBookId)))
            .getSingleOrNull();
        label = book?.name;
      }
    }
    label ??= 'Other';

    final existing = totals[label] ?? (correct: 0, total: 0);
    totals[label] = (correct: existing.correct + attempt.score, total: existing.total + attempt.totalQuestions);
  }

  final result = [
    for (final entry in totals.entries)
      SubjectAccuracy(label: entry.key, correct: entry.value.correct, total: entry.value.total),
  ]..sort((a, b) => b.accuracy.compareTo(a.accuracy));
  return result;
});
