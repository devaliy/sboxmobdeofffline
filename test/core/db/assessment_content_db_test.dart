import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:success_offline/core/db/assessment_content_db.dart';

void main() {
  late AssessmentContentDb db;

  setUp(() => db = AssessmentContentDb.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('inserts a full subject -> category/year/test_type -> question chain and reads it back',
      () async {
    await db.into(db.subjects).insert(SubjectsCompanion.insert(id: const Value(7), name: 'Physics'));
    await db.upsertCategory(const CategoriesCompanion(id: Value(2), catName: Value('Objective')));
    await db.upsertYear(const YearsCompanion(id: Value(55), subjectId: Value(7), yearName: Value('2019')));
    await db.upsertTestType(const TestTypesCompanion(
      id: Value(3),
      testTypeName: Value('JAMB Practice'),
      durationMinutes: Value(40),
      numOfQuestions: Value(40),
      subjectId: Value(7),
      assocCategoryId: Value(2),
    ));
    await db.into(db.questions).insert(QuestionsCompanion.insert(
          id: Value(30021),
          subjectId: 7,
          categoryId: 2,
          yearId: 55,
          questionText: 'What is acceleration due to gravity?',
          optionA: '9.8 m/s²',
          optionB: '10 m/s²',
          optionC: '8.9 m/s²',
          optionD: '11 m/s²',
          correctOption: 'A',
          testTypeId: Value(3),
        ));
    await db.into(db.installedAssessmentPacks).insert(InstalledAssessmentPacksCompanion.insert(
          scopeType: 'subject',
          scopeId: 7,
          version: '20260718-0930',
          checksum: 'sha256:1a2b',
          sizeBytes: 42011904,
          installedAt: DateTime(2026, 7, 29).toIso8601String(),
        ));

    final subjects = await db.watchSubjects().first;
    expect(subjects.single.name, 'Physics');

    final testTypes = await db.testTypesForSubject(7);
    expect(testTypes.single.testTypeName, 'JAMB Practice');

    final questions = await db.questionsForTestType(3);
    expect(questions.single.correctOption, 'A');

    expect(await db.isSubjectInstalled(7), isTrue);
    expect(await db.isSubjectInstalled(999), isFalse);
  });
}
