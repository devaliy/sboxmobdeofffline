import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:success_offline/core/db/study_content_db.dart';

void main() {
  late StudyContentDb db;

  setUp(() => db = StudyContentDb.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('inserts a full class -> book -> subject -> content/question chain and reads it back',
      () async {
    await db.upsertClass(const ClassesCompanion(
      id: Value(3),
      name: Value('JSS2'),
      code: Value('JSS2'),
      sortOrder: Value(2),
      category: Value('juniorsecondary'),
    ));
    await db.upsertTerm(const TermsCompanion(
      id: Value(1),
      name: Value('First Term'),
      startDate: Value('2026-09-01'),
      endDate: Value('2026-12-10'),
    ));
    await db.into(db.libraryBooks).insert(const LibraryBooksCompanion(
          id: Value(12),
          classId: Value(3),
          name: Value('Mathematics'),
          color: Value('#3b82f6'),
        ));
    await db.into(db.librarySubjects).insert(const LibrarySubjectsCompanion(
          id: Value(101),
          libraryBookId: Value(12),
          termId: Value(1),
          title: Value('Week 1: Algebra Basics'),
          author: Value('Chronicles Revolution'),
          week: Value(1),
          numOfTestQuestions: Value(10),
        ));
    await db.into(db.libraryContents).insert(const LibraryContentsCompanion(
          id: Value(501),
          librarySubjectId: Value(101),
          contentHtml: Value('<p>Algebra intro</p>'),
        ));
    await db.into(db.libraryQuestions).insert(const LibraryQuestionsCompanion(
          id: Value(9001),
          librarySubjectId: Value(101),
          questionText: Value('What is x in 2x=4?'),
          optionA: Value('1'),
          optionB: Value('2'),
          optionC: Value('3'),
          optionD: Value('4'),
          correctOption: Value('B'),
        ));
    await db.into(db.installedStudyPacks).insert(InstalledStudyPacksCompanion.insert(
          scopeType: 'book',
          scopeId: 12,
          version: '20260720-1000',
          checksum: 'sha256:abc',
          sizeBytes: 18234112,
          installedAt: DateTime(2026, 7, 29).toIso8601String(),
        ));

    final books = await db.watchBooksForClass(3).first;
    expect(books, hasLength(1));
    expect(books.single.name, 'Mathematics');

    final subjects = await db.watchSubjectsForBook(12).first;
    expect(subjects, hasLength(1));
    expect(subjects.single.title, 'Week 1: Algebra Basics');

    final contents = await db.contentsForSubject(101);
    expect(contents.single.contentHtml, '<p>Algebra intro</p>');

    final questions = await db.questionsForSubject(101);
    expect(questions.single.correctOption, 'B');

    expect(await db.isBookInstalled(12), isTrue);
    expect(await db.isBookInstalled(999), isFalse);

    final packs = await db.watchInstalledPacks().first;
    expect(packs.single.scopeId, 12);
  });

  test('upserting the same class/term twice updates rather than conflicts (spec 4.7)', () async {
    await db.upsertClass(const ClassesCompanion(
      id: Value(3),
      name: Value('JSS2'),
      sortOrder: Value(2),
      category: Value('juniorsecondary'),
    ));
    await db.upsertClass(const ClassesCompanion(
      id: Value(3),
      name: Value('JSS2 (renamed)'),
      sortOrder: Value(2),
      category: Value('juniorsecondary'),
    ));

    final allClasses = await db.watchClasses().first;
    expect(allClasses, hasLength(1));
    expect(allClasses.single.name, 'JSS2 (renamed)');
  });
}
