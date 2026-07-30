import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/db_providers.dart';
import '../../../core/db/progress_db.dart';
import '../../auth/application/auth_controller.dart';
import '../domain/continue_studying_info.dart';

/// Home's stat header (streak, points) — reactive, and safe before the
/// user is fully loaded (emits null rather than erroring).
final localStatsProvider = StreamProvider<LocalStat?>((ref) {
  final db = ref.watch(currentProgressDbProvider);
  if (db == null) return Stream.value(null);
  return db.watchLocalStats();
});

/// Ambient sync-status line (spec Section 1.6: "felt, not seen") — pending
/// outbox row count for the signed-in account.
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(currentProgressDbProvider);
  if (db == null) return Stream.value(0);
  return db.watchPendingOutbox().map((rows) => rows.length);
});

/// Home's "Continue studying" card: the account's most recently opened
/// subject (`progress.sqlite`) joined against its title/book (device-shared
/// `study_content.sqlite`). Null the moment either side is missing — no
/// reading yet, or the pack was since removed — which the UI reads as
/// "show the empty state".
final continueStudyingProvider = StreamProvider<ContinueStudyingInfo?>((ref) {
  final progressDb = ref.watch(currentProgressDbProvider);
  if (progressDb == null) return Stream.value(null);
  final studyDb = ref.watch(studyContentDbProvider);

  return progressDb.watchMostRecentReading().asyncMap((recent) async {
    if (recent == null) return null;
    final subject = await (studyDb.select(studyDb.librarySubjects)
          ..where((t) => t.id.equals(recent.librarySubjectId)))
        .getSingleOrNull();
    if (subject == null) return null;
    final book = await (studyDb.select(studyDb.libraryBooks)..where((t) => t.id.equals(subject.libraryBookId)))
        .getSingleOrNull();
    if (book == null) return null;

    return ContinueStudyingInfo(
      librarySubjectId: subject.id,
      subjectTitle: subject.title,
      bookName: book.name,
      bookColor: book.color,
      percentComplete: recent.percentComplete,
    );
  });
});
