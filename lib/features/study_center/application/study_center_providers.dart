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
