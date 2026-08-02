import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'db_paths.dart';

part 'assessment_content_db.g.dart';

/// Exact schema from spec Section 4.2.
class Subjects extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  IntColumn get id => integer()();
  TextColumn get catName => text().named('cat_name')();

  @override
  Set<Column> get primaryKey => {id};
}

class Years extends Table {
  IntColumn get id => integer()();
  IntColumn get subjectId => integer().named('subject_id').references(Subjects, #id)();
  TextColumn get yearName => text().named('year_name')();

  @override
  Set<Column> get primaryKey => {id};
}

class TestTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get testTypeName => text().named('test_type_name')();
  IntColumn get durationMinutes => integer().named('duration_minutes')();
  IntColumn get numOfQuestions => integer().named('num_of_questions')();
  IntColumn get subjectId => integer().named('subject_id').nullable().references(Subjects, #id)();
  IntColumn get assocCategoryId =>
      integer().named('assoc_category_id').nullable().references(Categories, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

class Passages extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text().nullable()();
  IntColumn get yearId => integer().named('year_id').nullable()();
  TextColumn get passageText => text().named('passage_text')();

  @override
  Set<Column> get primaryKey => {id};
}

class Questions extends Table {
  IntColumn get id => integer()();
  IntColumn get subjectId => integer().named('subject_id').references(Subjects, #id)();
  IntColumn get categoryId => integer().named('category_id').references(Categories, #id)();
  IntColumn get yearId => integer().named('year_id').references(Years, #id)();
  IntColumn get passageId => integer().named('passage_id').nullable().references(Passages, #id)();
  IntColumn get testTypeId => integer().named('test_type_id').nullable().references(TestTypes, #id)();
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

/// Local-only bookkeeping (spec Section 3.1 / 4.4) — 'subject' is the only
/// scope granularity for this domain.
class InstalledAssessmentPacks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get scopeType => text().named('scope_type')();
  IntColumn get scopeId => integer().named('scope_id')();
  TextColumn get version => text()();
  TextColumn get checksum => text()();
  IntColumn get sizeBytes => integer().named('size_bytes')();
  TextColumn get installedAt => text().named('installed_at')();
}

@DriftDatabase(tables: [
  Subjects,
  Categories,
  Years,
  TestTypes,
  Passages,
  Questions,
  InstalledAssessmentPacks,
])
class AssessmentContentDb extends _$AssessmentContentDb {
  AssessmentContentDb() : super(_openConnection());

  AssessmentContentDb.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'assessment_content',
      native: DriftNativeOptions(
        databasePath: DbPaths.assessmentContentDbPath,
      ),
      // See the matching comment in study_content_db.dart: web support here
      // exists only so Chrome stays usable for local dev verification.
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  // --- Read paths (Practice/CBT, M7) --------------------------------------

  Stream<List<Subject>> watchSubjects() => select(subjects).watch();

  Future<List<TestType>> testTypesForSubject(int subjectId) =>
      (select(testTypes)..where((t) => t.subjectId.equals(subjectId))).get();

  Stream<List<TestType>> watchTestTypesForSubject(int subjectId) =>
      (select(testTypes)..where((t) => t.subjectId.equals(subjectId))).watch();

  Future<List<Question>> questionsForTestType(int testTypeId) =>
      (select(questions)..where((t) => t.testTypeId.equals(testTypeId))).get();

  Future<Question?> questionById(int id) =>
      (select(questions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Subject?> subjectById(int id) =>
      (select(subjects)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Every installed category, across every installed subject — `categories`
  /// is a flat, global table (no `subject_id` column), so a category
  /// imported while processing one subject's pack is immediately usable to
  /// filter questions/subjects from any other installed subject too.
  Stream<List<Category>> watchCategories() => select(categories).watch();

  /// Subjects that actually have at least one question in [categoryId] —
  /// the practice picker's "subject" step is scoped to whatever's real for
  /// the category just chosen, not every installed subject regardless of
  /// relevance.
  Stream<List<Subject>> watchSubjectsForCategory(int categoryId) {
    final query = select(subjects).join([
      innerJoin(questions, questions.subjectId.equalsExp(subjects.id)),
    ])
      ..where(questions.categoryId.equals(categoryId))
      ..groupBy([subjects.id]);
    return query.watch().map((rows) => rows.map((row) => row.readTable(subjects)).toList());
  }

  /// Years that actually have at least one question in [subjectId]+
  /// [categoryId] — a subject's `years` aren't all necessarily represented
  /// within any one category, since each question picks one category and
  /// one year independently.
  Stream<List<Year>> watchYearsForSubjectAndCategory(int subjectId, int categoryId) {
    final query = select(years).join([
      innerJoin(questions, questions.yearId.equalsExp(years.id)),
    ])
      ..where(questions.subjectId.equals(subjectId) & questions.categoryId.equals(categoryId))
      ..groupBy([years.id]);
    return query.watch().map((rows) => rows.map((row) => row.readTable(years)).toList());
  }

  /// Up to [limit] questions for a subject+category+year, in a stable
  /// order (not randomized — deterministic id order, same as every other
  /// read path in this file) capped at whatever's actually available,
  /// since a subject+category+year combination can have fewer questions
  /// than a test format asks for.
  Future<List<Question>> questionsForSubjectAndCategory(
    int subjectId,
    int categoryId, {
    required int yearId,
    required int limit,
  }) {
    final query = select(questions)
      ..where((q) =>
          q.subjectId.equals(subjectId) & q.categoryId.equals(categoryId) & q.yearId.equals(yearId))
      ..orderBy([(q) => OrderingTerm.asc(q.id)])
      ..limit(limit);
    return query.get();
  }

  Future<Passage?> passageById(int passageId) =>
      (select(passages)..where((t) => t.id.equals(passageId))).getSingleOrNull();

  Stream<List<InstalledAssessmentPack>> watchInstalledPacks() =>
      select(installedAssessmentPacks).watch();

  Future<bool> isSubjectInstalled(int subjectId) async {
    final row = await (select(installedAssessmentPacks)
          ..where((t) => t.scopeType.equals('subject') & t.scopeId.equals(subjectId)))
        .getSingleOrNull();
    return row != null;
  }

  // --- Write paths (pack importer, M4) ------------------------------------

  Future<void> upsertCategory(CategoriesCompanion row) =>
      into(categories).insertOnConflictUpdate(row);

  Future<void> upsertYear(YearsCompanion row) => into(years).insertOnConflictUpdate(row);

  Future<void> upsertTestType(TestTypesCompanion row) =>
      into(testTypes).insertOnConflictUpdate(row);
}
