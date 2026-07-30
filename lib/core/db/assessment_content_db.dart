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

  Future<List<Question>> questionsForTestType(int testTypeId) =>
      (select(questions)..where((t) => t.testTypeId.equals(testTypeId))).get();

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
