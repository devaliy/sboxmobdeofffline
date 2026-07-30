import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'db_paths.dart';

part 'study_content_db.g.dart';

/// Exact schema from spec Section 4.1. Primary keys reuse the server's
/// integer ids (content is server-authoritative and read-only on device),
/// per Section 4's binding ground rule.
@DataClassName('LibraryClass')
class Classes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  IntColumn get sortOrder => integer().named('sort_order')();
  // 'primary' | 'juniorsecondary' | 'seniorsecondary' | 'higherinstitution'
  TextColumn get category => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Terms extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get startDate => text().named('start_date')(); // ISO 8601 date
  TextColumn get endDate => text().named('end_date')();

  @override
  Set<Column> get primaryKey => {id};
}

class LibraryBooks extends Table {
  IntColumn get id => integer()();
  IntColumn get classId => integer().named('class_id').references(Classes, #id)();
  TextColumn get name => text()();
  TextColumn get imagePath => text().named('image_path').nullable()();
  TextColumn get color => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class LibrarySubjects extends Table {
  IntColumn get id => integer()();
  IntColumn get libraryBookId => integer().named('library_book_id').references(LibraryBooks, #id)();
  IntColumn get termId => integer().named('term_id').references(Terms, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get coverImagePath => text().named('cover_image_path').nullable()();
  TextColumn get author => text()();
  IntColumn get week => integer()();
  IntColumn get numOfTestQuestions => integer().named('num_of_test_questions')();

  @override
  Set<Column> get primaryKey => {id};
}

class LibraryContents extends Table {
  IntColumn get id => integer()();
  IntColumn get librarySubjectId =>
      integer().named('library_subject_id').references(LibrarySubjects, #id)();
  TextColumn get contentHtml => text().named('content_html')(); // raw CKEditor HTML

  @override
  Set<Column> get primaryKey => {id};
}

class LibraryQuestions extends Table {
  IntColumn get id => integer()();
  IntColumn get librarySubjectId =>
      integer().named('library_subject_id').references(LibrarySubjects, #id)();
  TextColumn get questionText => text().named('question_text')();
  TextColumn get imagePath => text().named('image_path').nullable()();
  TextColumn get optionA => text().named('option_a')();
  TextColumn get optionB => text().named('option_b')();
  TextColumn get optionC => text().named('option_c')();
  TextColumn get optionD => text().named('option_d')();
  TextColumn get optionE => text().named('option_e').nullable()();
  TextColumn get correctOption => text().named('correct_option')();
  TextColumn get explanation => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local-only bookkeeping — not from the server. Records exactly what's
/// been downloaded so far (spec Section 3.1).
class InstalledStudyPacks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get scopeType => text().named('scope_type')(); // 'class' | 'book'
  IntColumn get scopeId => integer().named('scope_id')();
  TextColumn get version => text()();
  TextColumn get checksum => text()();
  IntColumn get sizeBytes => integer().named('size_bytes')();
  TextColumn get installedAt => text().named('installed_at')();
}

@DriftDatabase(tables: [
  Classes,
  Terms,
  LibraryBooks,
  LibrarySubjects,
  LibraryContents,
  LibraryQuestions,
  InstalledStudyPacks,
])
class StudyContentDb extends _$StudyContentDb {
  StudyContentDb() : super(_openConnection());

  /// For unit tests: pass an in-memory or otherwise pre-built executor.
  StudyContentDb.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'study_content',
      native: DriftNativeOptions(
        databasePath: DbPaths.studyContentDbPath,
      ),
      // Only reachable on Flutter Web, which isn't a shipped target for this
      // app (spec targets Android/iOS/Windows/macOS) — this exists purely so
      // Chrome remains usable as a local dev/visual-verification surface.
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  // --- Read paths (Study Center, M6) -------------------------------------

  Stream<List<LibraryClass>> watchClasses() => select(classes).watch();

  Stream<List<LibraryBook>> watchBooksForClass(int classId) =>
      (select(libraryBooks)..where((t) => t.classId.equals(classId))).watch();

  Stream<List<LibrarySubject>> watchSubjectsForBook(int libraryBookId) => (select(librarySubjects)
        ..where((t) => t.libraryBookId.equals(libraryBookId))
        ..orderBy([(t) => OrderingTerm.asc(t.week)]))
      .watch();

  Future<List<LibraryContent>> contentsForSubject(int librarySubjectId) =>
      (select(libraryContents)..where((t) => t.librarySubjectId.equals(librarySubjectId))).get();

  Future<List<LibraryQuestion>> questionsForSubject(int librarySubjectId) =>
      (select(libraryQuestions)..where((t) => t.librarySubjectId.equals(librarySubjectId))).get();

  Stream<List<InstalledStudyPack>> watchInstalledPacks() => select(installedStudyPacks).watch();

  Future<bool> isBookInstalled(int libraryBookId) async {
    final row = await (select(installedStudyPacks)
          ..where((t) => t.scopeType.equals('book') & t.scopeId.equals(libraryBookId)))
        .getSingleOrNull();
    return row != null;
  }

  // --- Write paths (pack importer, M4) ------------------------------------
  //
  // Shared lookup rows (classes, terms) use upsert-by-id since the same row
  // can legitimately reappear across independently-downloaded packs (spec
  // Section 4.7). Table-owned rows are inserted fresh per pack; removal
  // (Settings -> Manage downloaded content, M9) deletes by scope.

  Future<void> upsertClass(ClassesCompanion row) => into(classes).insertOnConflictUpdate(row);

  Future<void> upsertTerm(TermsCompanion row) => into(terms).insertOnConflictUpdate(row);
}
