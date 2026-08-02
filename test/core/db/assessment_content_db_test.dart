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

  test(
      'watchTestTypesForSubject emits again when a test type is added after the '
      'stream is already being observed (a re-imported pack adding test types to an '
      'already-viewed subject must not require an app restart to show up)', () async {
    await db.into(db.subjects).insert(SubjectsCompanion.insert(id: const Value(7), name: 'Physics'));

    final emissions = <int>[];
    final sub = db.watchTestTypesForSubject(7).listen((rows) => emissions.add(rows.length));
    addTearDown(sub.cancel);

    await pumpEventQueue();
    expect(emissions, [0]);

    await db.upsertTestType(const TestTypesCompanion(
      id: Value(3),
      testTypeName: Value('JAMB Practice'),
      durationMinutes: Value(40),
      numOfQuestions: Value(40),
      subjectId: Value(7),
    ));

    await pumpEventQueue();
    expect(emissions, [0, 1]);
  });

  test(
      'watchSubjectsForCategory returns only subjects with a question in that category, '
      'and stays a global cross-subject list, not scoped per pack', () async {
    await db.into(db.subjects).insert(SubjectsCompanion.insert(id: const Value(7), name: 'Physics'));
    await db.into(db.subjects).insert(SubjectsCompanion.insert(id: const Value(8), name: 'Chemistry'));
    await db.into(db.subjects).insert(SubjectsCompanion.insert(id: const Value(9), name: 'Biology'));
    await db.upsertCategory(const CategoriesCompanion(id: Value(1), catName: Value('UTME Simulator')));
    await db.upsertCategory(const CategoriesCompanion(id: Value(2), catName: Value('SSCE Test Engine')));
    await db.into(db.years).insert(YearsCompanion.insert(id: const Value(1), subjectId: 7, yearName: '2020'));

    Future<void> insertQuestion(int id, int subjectId, int categoryId) => db.into(db.questions).insert(
          QuestionsCompanion.insert(
            id: Value(id),
            subjectId: subjectId,
            categoryId: categoryId,
            yearId: 1,
            questionText: 'Q$id',
            optionA: 'a',
            optionB: 'b',
            optionC: 'c',
            optionD: 'd',
            correctOption: 'A',
          ),
        );

    await insertQuestion(1, 7, 1); // Physics has a UTME Simulator question
    await insertQuestion(2, 8, 1); // Chemistry has one too
    await insertQuestion(3, 9, 2); // Biology only has an SSCE Test Engine question

    final utmeSubjects = await db.watchSubjectsForCategory(1).first;
    expect(utmeSubjects.map((s) => s.name).toSet(), {'Physics', 'Chemistry'});

    final ssceSubjects = await db.watchSubjectsForCategory(2).first;
    expect(ssceSubjects.map((s) => s.name).toSet(), {'Biology'});
  });

  test('questionsForSubjectAndCategory caps at the requested limit without erroring when the '
      'pool is smaller than asked for', () async {
    await db.into(db.subjects).insert(SubjectsCompanion.insert(id: const Value(7), name: 'Physics'));
    await db.upsertCategory(const CategoriesCompanion(id: Value(1), catName: Value('UTME Simulator')));
    await db.into(db.years).insert(YearsCompanion.insert(id: const Value(1), subjectId: 7, yearName: '2020'));

    for (var i = 1; i <= 3; i++) {
      await db.into(db.questions).insert(QuestionsCompanion.insert(
            id: Value(i),
            subjectId: 7,
            categoryId: 1,
            yearId: 1,
            questionText: 'Q$i',
            optionA: 'a',
            optionB: 'b',
            optionC: 'c',
            optionD: 'd',
            correctOption: 'A',
          ));
    }

    // Only 3 questions exist — asking for 10 (a "Speed Test") returns all 3,
    // not an error and not padding/duplicating to reach 10.
    final capped = await db.questionsForSubjectAndCategory(7, 1, yearId: 1, limit: 10);
    expect(capped, hasLength(3));

    final limited = await db.questionsForSubjectAndCategory(7, 1, yearId: 1, limit: 2);
    expect(limited, hasLength(2));
  });

  test('watchYearsForSubjectAndCategory only returns years with a question in that '
      'subject+category, not every year the subject has ever mentioned', () async {
    await db.into(db.subjects).insert(SubjectsCompanion.insert(id: const Value(7), name: 'Physics'));
    await db.upsertCategory(const CategoriesCompanion(id: Value(1), catName: Value('UTME Simulator')));
    await db.upsertCategory(const CategoriesCompanion(id: Value(2), catName: Value('NAPPS')));
    await db.into(db.years).insert(YearsCompanion.insert(id: const Value(1), subjectId: 7, yearName: '2020'));
    await db.into(db.years).insert(YearsCompanion.insert(id: const Value(2), subjectId: 7, yearName: '2021'));

    // A 2020 question in category 1, a 2021 question in category 2 only.
    await db.into(db.questions).insert(QuestionsCompanion.insert(
          id: const Value(1),
          subjectId: 7,
          categoryId: 1,
          yearId: 1,
          questionText: 'Q1',
          optionA: 'a',
          optionB: 'b',
          optionC: 'c',
          optionD: 'd',
          correctOption: 'A',
        ));
    await db.into(db.questions).insert(QuestionsCompanion.insert(
          id: const Value(2),
          subjectId: 7,
          categoryId: 2,
          yearId: 2,
          questionText: 'Q2',
          optionA: 'a',
          optionB: 'b',
          optionC: 'c',
          optionD: 'd',
          correctOption: 'A',
        ));

    final category1Years = await db.watchYearsForSubjectAndCategory(7, 1).first;
    expect(category1Years.map((y) => y.yearName).toSet(), {'2020'});

    final category2Years = await db.watchYearsForSubjectAndCategory(7, 2).first;
    expect(category2Years.map((y) => y.yearName).toSet(), {'2021'});
  });
}
