import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/db_providers.dart';
import '../../../core/db/study_content_db.dart';
import '../../auth/application/auth_controller.dart';

/// Every row in `library_books` was, by construction, imported together
/// with its `installed_study_packs` bookkeeping row in one transaction
/// (spec Section 4.7) — so "every book in this table" already means
/// "every installed book". No separate installed-check needed.
final installedBooksProvider = StreamProvider<List<LibraryBook>>((ref) {
  final db = ref.watch(studyContentDbProvider);
  return db.select(db.libraryBooks).watch();
});

final bookByIdProvider = StreamProvider.family<LibraryBook?, int>((ref, bookId) {
  final db = ref.watch(studyContentDbProvider);
  return (db.select(db.libraryBooks)..where((t) => t.id.equals(bookId))).watchSingleOrNull();
});

/// Small shared-lookup table — cheap to watch in full and index client-side
/// wherever a term *name* is needed for grouping.
final termsProvider = StreamProvider<List<Term>>((ref) {
  final db = ref.watch(studyContentDbProvider);
  return db.select(db.terms).watch();
});

final subjectsForBookProvider = StreamProvider.family<List<LibrarySubject>, int>((ref, bookId) {
  return ref.watch(studyContentDbProvider).watchSubjectsForBook(bookId);
});

final subjectByIdProvider = StreamProvider.family<LibrarySubject?, int>((ref, subjectId) {
  final db = ref.watch(studyContentDbProvider);
  return (db.select(db.librarySubjects)..where((t) => t.id.equals(subjectId))).watchSingleOrNull();
});

final contentsForSubjectProvider = FutureProvider.family<List<LibraryContent>, int>((ref, subjectId) {
  return ref.watch(studyContentDbProvider).contentsForSubject(subjectId);
});

final questionsForSubjectProvider = FutureProvider.family<List<LibraryQuestion>, int>((ref, subjectId) {
  return ref.watch(studyContentDbProvider).questionsForSubject(subjectId);
});

/// Null when nothing's been read yet, or once the signed-in account isn't
/// resolved (splash still bootstrapping).
final readingProgressForSubjectProvider = StreamProvider.family((ref, int subjectId) {
  final db = ref.watch(currentProgressDbProvider);
  if (db == null) return Stream.value(null);
  return db.watchReadingProgress(subjectId);
});

/// A book's overall completion — every subject counts (unread ones count
/// as 0%), not just the ones with a progress row, so a book with 10 weeks
/// where only 5 have been opened reads as 50% (half-read), not 100%
/// (average of only the touched weeks).
final bookProgressProvider = StreamProvider.family<int, int>((ref, bookId) {
  final progressDb = ref.watch(currentProgressDbProvider);
  final studyDb = ref.watch(studyContentDbProvider);
  if (progressDb == null) return Stream.value(0);

  return studyDb.watchSubjectsForBook(bookId).asyncExpand((subjects) {
    if (subjects.isEmpty) return Stream.value(0);
    final ids = subjects.map((s) => s.id).toSet();
    return progressDb.watchReadingProgressForSubjects(ids).map((rows) {
      final percentBySubject = {for (final r in rows) r.librarySubjectId: r.percentComplete};
      final total = subjects.fold<int>(0, (sum, s) => sum + (percentBySubject[s.id] ?? 0));
      return (total / subjects.length).round();
    });
  });
});

/// Distinct books behind the account's most recently opened subjects, most
/// recent first — Study Center's "Recently Read" shelf. Reading two weeks
/// of the same book only surfaces that book once, at its most recent
/// position.
final recentlyReadBooksProvider = StreamProvider<List<LibraryBook>>((ref) {
  final progressDb = ref.watch(currentProgressDbProvider);
  final studyDb = ref.watch(studyContentDbProvider);
  if (progressDb == null) return Stream.value(const []);

  return progressDb.watchRecentReadingProgress().asyncMap((rows) async {
    final seenBookIds = <int>{};
    final books = <LibraryBook>[];
    for (final row in rows) {
      final subject = await (studyDb.select(studyDb.librarySubjects)
            ..where((t) => t.id.equals(row.librarySubjectId)))
          .getSingleOrNull();
      if (subject == null) continue;
      if (!seenBookIds.add(subject.libraryBookId)) continue;
      final book = await (studyDb.select(studyDb.libraryBooks)
            ..where((t) => t.id.equals(subject.libraryBookId)))
          .getSingleOrNull();
      if (book != null) books.add(book);
      if (books.length >= 10) break;
    }
    return books;
  });
});
